extends CharacterBody2D

class_name Hannah
## Player character, our lovely [Hannah]
##
## Has [method Hannah.equip_item], [method Hannah.unhandled_input] to interact and move, [method Hannah.unequip_held], and [method Hannah.face_direction]

## [Hannah]'s base speed
var speed = 300.0

## [Hannah]'s inventory
var inventory: Control

## Current [BaseEquipment] in hands
var equipped: BaseEquipment

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

## _ready initialises [Hannah]'s [member Hannah.inventory] by using [method Node.get_first_node_in_group]
func _ready():
	inventory = get_tree().get_first_node_in_group("Inventory")
	map = get_tree().get_first_node_in_group("Map")

## Toggles [Hannah]'s [member Hannah.is_physics_processing] and [method Hannah.is_processing_unhandled_input] 
func toggle_processing():
	set_physics_process(!is_physics_processing())
	set_process_unhandled_input(!is_processing_unhandled_input())
	set_process(!is_processing())

## Move based on [member Hannah.direction] * [member Hannah.speed], and handle any collisions by checking they are items and if so adding to inventory
func _physics_process(delta):
	
	%ArmBase.look_at(get_global_mouse_position())
	#Prepare
	velocity = direction * speed
	
	#Move and check for collision 
	var collision = move_and_collide(velocity * delta)
	
	if !collision: return
	
	if !collision.get_collider() is BaseItem: return
	if collision.get_collider().interact_state not in [collision.get_collider().Interact_State.IN_WORLD]: return
	
	#If it's an item, add it to the inventory
	inventory.first_add_item(collision.get_collider())

##Handles capturing [member Hannah.direction], interacting with [WorldObject]s, and the starting point for [method BaseEquipment.use]
func _unhandled_input(_event):
	direction = Input.get_vector("left","right","up","down")
	%AnimatedSprite2D.flip_h = direction.x < 0 if direction.x != 0 else %AnimatedSprite2D.flip_h
	#Here is inventory handling and interacting with world objects
	if !Input.is_action_just_pressed("interact"): return
	var overlapping_bodies = %UseArea.get_overlapping_bodies()
	for body in overlapping_bodies:
		if !body is WorldObject: continue
		toggle_processing()
		body.interact()
		break

func _easeInOutElastic(x: float) -> float:
	if x == 0.0:
		return 0.0
	if x == 1.0:
		return 1.0
	x = x * 2
	if x < 1:
		return -0.5 * pow(2.0, 10.0 * (x - 1)) * sin((x - 1.1) * c4)
	return 0.5 * pow(2.0, -10.0 * (x - 1)) * sin((x - 1.1) * c4) + 1

## Manages swinging animation for equipment
func _process(delta):
	if !equipped: return
	if equipped.equipment_properties.highlight_area:
		var tile_pos = map.local_to_map(%UseArea.global_position)
		%HighlightSprite.global_position = map.map_to_local(tile_pos)
		%HighlightSprite.visible = true
	else:
		%HighlightSprite.visible = false
	if Input.is_action_just_pressed("left_click") and !playing_anim:
		%SlashSprite.visible = true
		start_animation()
		equipped.use()
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
		%Equipped.rotation = start_rotation + _easeInOutElastic(anim_state) * (end_rotation - start_rotation)

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
	var new_version = equipment.duplicate()
	new_version.interact_state = new_version.Interact_State.EQUIPPED
	%Equipped.add_child(new_version)
	new_version.position = Vector2.ZERO
	equipped = new_version

## Unequips any held [BaseEquipment]
func unequip_held():
	%Equipped.get_child(0).queue_free() if %Equipped.get_child_count() > 0 else null
	equipped = null
	if %HighlightSprite.visible:
		%HighlightSprite.visible = false
