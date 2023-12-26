extends CharacterBody2D

class_name BaseNPC

enum State {IDLE, WALKING, DOING_TASK, WANDERING}

var state: State = State.IDLE

var needs: Dictionary = {"hunger": 0, "social": 0, "warmth": 0}

const WALK_SPEED: int = 100

const TASK_SPEED: int = 100

const TILE_SIZE: int = 64

var walk_target: Vector2 = Vector2.ZERO

var knowledge: Dictionary = {"villagers": {}, "tasks": {}, "buildings": {}}

@onready var task_manager: TaskManager = TaskManager.new()

var current_task = null

## Reference to [Main]
var main: Node

## Reference to [Hannah]
var hannah: Hannah

## Reference to the [DialogueManager]
var dialogue_UI: DialogueManager 

## [Dictionary] which contains 
var dialogue_tree: Dictionary = {}

## Connects the [DialogueManager] buttons to the script and retrieves [member WorldObjectArea.main],  [member WorldObjectArea.hannah] and  [member WorldObjectArea.dialogue_UI]
func _ready():
	await get_tree().process_frame
	dialogue_UI = get_tree().get_first_node_in_group("DialogueUI")
	main = get_tree().get_first_node_in_group("Main")
	hannah = get_tree().get_first_node_in_group("Hannah")
	
	var food_task = FoodTask.new()
	food_task.task_name = "food"
	food_task.is_completed = true
	task_manager.add_task(food_task)

	var firewood_task = BaseTask.new()
	firewood_task.task_name = "firewood"
	firewood_task.is_completed = true
	task_manager.add_task(firewood_task)


	var social_task = SocialTask.new()
	social_task.task_name = "social"
	social_task.is_completed = true
	task_manager.add_task(social_task)


## Is called when [Hannah] interacts with the [WorldObjectArea] to send the [member WorldObjectArea.dialogue_tree] to the manager. Also pauses the timer on [Main].
func interact():
	toggle_processing()
	main.get_node("%Daytime").stop()
	dialogue_UI.show_dialogue(self, dialogue_tree)

## Is called when a dialogue option is selected, allowing the [WorldObjectArea] to respond by calling other functions. By default this resumes [Hannah]'s handling and restarts the timer on [Main]
func call_dialogue_callback(_callback_name):
	if !hannah.is_processing_unhandled_input():
		hannah.toggle_processing()
	if main.get_node("%Daytime").is_stopped:
		main.get_node("%Daytime").start()
	if !is_processing():
		toggle_processing()

func toggle_processing():
	set_process(!is_processing())

func _process(delta):
	update_needs(delta)
	update_movement(delta)

func update_needs(delta):
	needs.hunger += delta
	needs.social += delta
	if !near_fire():
		needs.warmth += delta

func update_state():
	if state == State.IDLE:
		if needs.hunger > 50: 
			reset_task("food")
		elif needs.warmth > 50: 
			reset_task("firewood")
		elif needs.social > 50: 
			reset_task("social")
		else:
			state = State.WANDERING
			if walk_target == global_position or walk_target == Vector2.ZERO:
				walk_target = get_random_walk_target()
		current_task = task_manager.get_task()
		if current_task:
			state = State.DOING_TASK
	elif state == State.DOING_TASK:
		if current_task.is_completed:
			state = State.IDLE

func update_movement(delta):
	if state == State.DOING_TASK:
		var direction = (current_task.position - global_position).normalized()
		global_position += direction * WALK_SPEED * delta
		if global_position.distance_to(current_task.position) < 10:
			current_task.perform(self)
			if current_task.is_completed:
				%SpeechBubble.show()
				%Complete.show()
				current_task = null
				state = State.IDLE
				await get_tree().create_timer(1).timeout
				%Complete.hide()
				%SpeechBubble.hide()
	elif state == State.WANDERING:
		var direction = (walk_target - global_position).normalized()
		global_position += direction * WALK_SPEED * delta
		if global_position.distance_to(walk_target) < 10:
			state = State.IDLE
	else:
		update_state()

func reset_task(task_name: String, target_position: Vector2 = Vector2.ZERO):
	var task = task_manager.get_task(task_name)
	if task:
		task.is_completed = false
		if target_position:
			task.position = target_position

func get_social_target():
	for villager_name in knowledge["villagers"].keys():
		if villager_name != self.name and knowledge["villagers"][villager_name]["state"] != State.DOING_TASK:
			return knowledge["villagers"][villager_name]["position"]
	return null

func near_fire(): #TODO
	return false

func can_find_food(): #TODO
	return false  

func get_random_walk_target():
	var min_x = 0
	var max_x = get_tree().get_first_node_in_group("Map").get_used_rect().size.x * TILE_SIZE
	var min_y = 0 
	var max_y = get_tree().get_first_node_in_group("Map").get_used_rect().size.y * TILE_SIZE
	var x = randi_range(min_x, max_x)
	var y = randi_range(min_y, max_y)
	return Vector2(x, y)

func _on_body_entered(body):
	if body is BaseNPC:
		knowledge["villagers"][body.name] = {"position": body.global_position, "state": body.state, "needs": body.needs, "timestamp": Time.get_ticks_msec(), "source": [self.name]}
		%SpeechBubble.show()
		%Hiya.show()
		await get_tree().create_timer(2).timeout
		%Hiya.hide()
		%SpeechBubble.hide()
		if will_gossip():
			gossip(body)
			
func _on_body_exited(body):
	if body is BaseNPC:
		knowledge["villagers"][body.name] = {"position": body.global_position, "state": body.state, "timestamp": Time.get_ticks_msec(), "source": [self.name]}

func will_gossip():
	return true

func gossip(other_villager):
	for villager_name in knowledge["villagers"].keys():
		if villager_name == other_villager.name: continue
		if villager_name not in other_villager.knowledge["villagers"]: 
			other_villager.knowledge["villagers"][villager_name] = knowledge["villagers"][villager_name].duplicate()
			if self.name in other_villager.knowledge["villagers"][villager_name]["source"]: continue
			other_villager.knowledge["villagers"][villager_name]["source"].append(self.name)
		else:
			if knowledge["villagers"][villager_name].timestamp <= other_villager.knowledge["villagers"][villager_name].timestamp: continue
			for key in knowledge["villagers"][villager_name].keys():
				if key == "source": continue
				other_villager.knowledge["villagers"][villager_name][key] = knowledge["villagers"][villager_name][key]
			other_villager.knowledge["villagers"][villager_name]["source"] = other_villager.knowledge["villagers"][villager_name]["source"] + [self.name]
