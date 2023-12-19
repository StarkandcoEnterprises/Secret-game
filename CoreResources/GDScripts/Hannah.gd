extends CharacterBody2D

class_name Hannah
## Player character, our lovely [Hannah]
##
## Has [method Hannah.equip_item], [method Hannah.unhandled_input] to interact and move, [method Hannah.unequip_held], and [method Hannah.face_direction]

## [Hannah]'s base speed
var speed = 300.0

## [Hannah]'s inventory, really now represents player UI
var inventory: PlayerUI

## Current [BaseEquipment] in hands
var equipped: BaseEquipment

## Progress bar representing stamina on player UI
var stamina_bar 

## Progress bar representing health on player UI
var health_bar

var in_building = false

## Tilemap
var map: TileMap

## The direction being faced and moved
var direction: Vector2 = Vector2.ZERO

## EaseInOut value 
var c4 = (2 * PI) / 3

## Used to determine the current interpolation, updated by delta, for the swing animation while ongoing
var anim_state: float = 0

## Used to represent the state of animation is ongoing
var playing_anim: bool = false

## Whether the animation should ease out or in
var easing_out: bool = true

## Starting rotation for animation
var start_rotation = 0

## Ending rotation for animation
var end_rotation = 90

## The maximum health of the character
const MAX_HEALTH = 100

## The maximum stamina of the character
const MAX_STAMINA = 100

## The maximum morale of the character
const MAX_MORALE = 100

## The health of the character, when it reaches 0, the character dies
var health = MAX_HEALTH

## The stamina of the character, used for actions that require physical effort
var stamina = MAX_STAMINA

## The morale of the character, can affect the character's performance and actions
var morale = MAX_MORALE

## The weight the character is currently carrying
var weight = 0

## The maximum weight the character can carry without penalty
const MAX_WEIGHT = 50

## The rate at which stamina regenerates
const STAMINA_REGEN_RATE = 1

## The rate at which stamina decreases when running
const RUNNING_STAMINA_DECREASE = 2

## The rate at which stamina decreases when using items
const ITEM_USE_STAMINA_DECREASE = 5

## Update the values of the health and stamina bars
func update_progress_bars():
	stamina_bar.value = stamina
	health_bar.value = health
	
## Decreases the health by a specified amount
func decrease_health(amount):
	health -= amount
	if health < 0:
		health = 0
		die()

## Increases the health by a specified amount
func increase_health(amount):
	health += amount
	if health > MAX_HEALTH:
		health = MAX_HEALTH

## Decreases the stamina by a specified amount
func decrease_stamina(amount):
	stamina -= amount
	if stamina < 0:
		stamina = 0

## Increases the stamina by a specified amount
func increase_stamina(amount):
	stamina += amount
	if stamina > MAX_STAMINA:
		stamina = MAX_STAMINA

## Decreases the morale by a specified amount
func decrease_morale(amount):
	morale -= amount
	if morale < 0:
		morale = 0

## Increases the morale by a specified amount
func increase_morale(amount):
	morale += amount
	if morale > MAX_MORALE:
		morale = MAX_MORALE

## Handles the death of the character
func die():
	print("Hannah has died")

## Decreases the stamina based on the current weight
func decrease_stamina_based_on_weight(delta):
	if weight > MAX_WEIGHT:
		decrease_stamina((weight - MAX_WEIGHT) * delta)

## Regenerates stamina over time
func regenerate_stamina(delta):
	increase_stamina(STAMINA_REGEN_RATE * delta)

## Decreases stamina when running
func decrease_stamina_when_running(delta):
	if Input.is_action_pressed("run"):
		decrease_stamina(RUNNING_STAMINA_DECREASE * ((weight - MAX_WEIGHT) if (weight - MAX_WEIGHT) > 1 else 1 * delta))

## Decreases stamina when using an item
func decrease_stamina_when_using_item():
	decrease_stamina(ITEM_USE_STAMINA_DECREASE)

## Updates the weight
func update_weight(item_weight):
	weight += item_weight

## _ready initialises [Hannah]'s [member Hannah.inventory] by using [method Node.get_first_node_in_group]
func _ready():
	inventory = get_tree().get_first_node_in_group("PlayerUI")
	map = get_tree().get_first_node_in_group("Map")
	stamina_bar = inventory.get_node("%StaminaBar")
	health_bar = inventory.get_node("%HealthBar")

## Toggles [Hannah]'s [member Hannah.is_physics_processing] and [method Hannah.is_processing_unhandled_input] 
func toggle_processing():
	set_physics_process(!is_physics_processing())
	set_process_unhandled_input(!is_processing_unhandled_input())
	set_process(!is_processing())

## Move based on [member Hannah.direction] * [member Hannah.speed], and handle any collisions by checking they are items and if so adding to inventory
func _physics_process(delta):
	
	%ArmBase.look_at(get_global_mouse_position())
	
	#Prepare
	var current_speed = speed
	if Input.is_action_pressed("run") and stamina > 5:
		current_speed = current_speed * 2
	elif stamina <= 5:
		current_speed = current_speed / 2
	velocity = direction * current_speed
	
	#Move and check for collision 
	var collision = move_and_collide(velocity * delta)
	
	if current_speed == speed * 2:
		decrease_stamina_when_running(delta)
	elif velocity != Vector2.ZERO:
		decrease_stamina_based_on_weight(delta)
	regenerate_stamina(delta)
	
	update_progress_bars()
	
	if !collision: return
	
	if !collision.get_collider() is BaseItem: return
	if collision.get_collider().interact_state not in [BaseItem.Interact_State.IN_WORLD]: return
	
	#If it's an item, add it to the inventory
	inventory.first_add_item(collision.get_collider())

##Handles capturing [member Hannah.direction], interacting with [WorldObject]s, and the starting point for [method BaseEquipment.use]
func _unhandled_input(_event):
	direction = Input.get_vector("left","right","up","down")
	%AnimatedSprite2D.flip_h = direction.x < 0 if direction.x != 0 else %AnimatedSprite2D.flip_h
	#Here is inventory handling and interacting with world objects
	if !Input.is_action_just_pressed("interact"): return
	var overlapping_objects = %UseArea.get_overlapping_bodies() + %UseArea.get_overlapping_areas()
	for object in overlapping_objects:
		if !object is WorldObject: continue
		toggle_processing()
		object.interact()
		direction = Vector2.ZERO
		break

func _ease_in_out_elastic(x: float) -> float:
	if x == 0.0:
		return 0.0
	if x == 1.0:
		return 1.0
	x = x * 2
	if x < 1:
		return -0.5 * pow(2.0, 10.0 * (x - 1)) * sin((x - 1.1) * c4)
	return 0.5 * pow(2.0, -10.0 * (x - 1)) * sin((x - 1.1) * c4) + 1

## Manages input/swinging animation for equipment and the highlight tile if required
func _process(delta):
	if equipped != null:
		if equipped.equipment_properties.highlight_area:
			var tile_pos = map.local_to_map(%UseArea.global_position)
			%HighlightSprite.global_position = map.map_to_local(tile_pos)
			%HighlightSprite.visible = true
		else:
			%HighlightSprite.visible = false
	else:
		%HighlightSprite.visible = false
	if equipped and Input.is_action_just_pressed("left_click") and !playing_anim and stamina > ITEM_USE_STAMINA_DECREASE:
		%SlashSprite.visible = true
		start_animation()
		equipped.use()
		decrease_stamina_when_using_item()
	if playing_anim:
		update_animation_state(delta)
		update_rotation()
		if anim_state >= 1:
			end_animation()
			%SlashSprite.visible = false

## Starts the animation i.e. updates members to reflect the new animation states
func start_animation():
	playing_anim = true
	easing_out = !easing_out
	%SlashSprite.flip_h = !%SlashSprite.flip_h
	start_rotation = %Equipped.rotation
	end_rotation = start_rotation + (PI/8 if easing_out else -PI/8) 

## Progresses the animation state float by delta (*2) 
func update_animation_state(delta):
	anim_state += delta * 2

## Updates the rotation based on an ease in out elastic function if the animation is being played
func update_rotation():
	if !playing_anim:
		%Equipped.rotation = 0
	else:
		%Equipped.rotation = start_rotation + _ease_in_out_elastic(anim_state) * (end_rotation - start_rotation)

## Disabled and reset vars for the animation
func end_animation():
	playing_anim = false
	anim_state = 0 
	var temp = start_rotation
	start_rotation = end_rotation
	end_rotation = temp
	%Equipped.position.y *= -1  
	update_rotation()

## Equips a [BaseEquipment]
func equip_item(equipment: BaseEquipment):
	var sprite = equipment.get_node("InWorldSprite")
	equipment.interact_state = BaseItem.Interact_State.EQUIPPED
	sprite.reparent(%Equipped)
	sprite.position = Vector2.ZERO
	sprite.visible = true
	equipped = equipment

## Unequips any held [BaseEquipment]
func unequip_held():
	if %Equipped.get_child_count() == 0: return
	%Equipped.get_child(0).visible = false
	%Equipped.get_child(0).reparent(equipped)
	equipped.interact_state = BaseItem.Interact_State.SLOTTED
	equipped = null
	if %HighlightSprite.visible:
		%HighlightSprite.visible = false

func sleep():
	increase_stamina(100)
