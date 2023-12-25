extends CharacterBody2D

class_name BaseNPC

enum State {IDLE, WALKING, SEARCHING_FOOD, MAKING_FOOD}

var state = State.IDLE
var needs = {"hunger": 0}

var walk_speed = 100  # Adjust as needed
var walk_target = Vector2.ZERO


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
