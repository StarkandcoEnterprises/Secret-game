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

## The direction being faced and moved
var direction: Vector2 = Vector2.ZERO

## _ready initialises [Hannah]'s [member Hannah.inventory] by using [method Node.get_first_node_in_group]
func _ready():
	inventory = get_tree().get_first_node_in_group("Inventory")
 
## Equips a [BaseEquipment]
func equip_item(equipment: BaseEquipment):
	var new_version = equipment.duplicate()
	new_version.position = Vector2.ZERO
	new_version.interact_state = new_version.Interact_State.EQUIPPED
	if !%AnimatedSprite2D.flip_h:
		%RightHand.add_child(new_version)
	else:
		new_version.get_node("%ItemSprite").flip_h = true
		%LeftHand.add_child(new_version)
	equipped = new_version

## Unequips any held [BaseEquipment]
func unequip_held():
	
	%RightHand.get_child(0).queue_free() if %RightHand.get_child_count() > 0 else null
	%LeftHand.get_child(0).queue_free() if %LeftHand.get_child_count() > 0 else null
	
	equipped = null

## Flips sprite or equipped based on [member Hannah.direction]
func face_direction():
	%RayCast2D.rotation_degrees = 90*[Vector2.DOWN,Vector2.LEFT,Vector2.UP,Vector2.RIGHT].find(direction)
	if direction == Vector2.LEFT:
		flip_and_adjust_hand(%RightHand, %LeftHand, true)
	else:
		flip_and_adjust_hand(%LeftHand, %RightHand, false)

func flip_and_adjust_hand(source_hand, target_hand, flip_sprite):
	%AnimatedSprite2D.flip_h = flip_sprite
	if source_hand.get_child_count() > 0:
		equipped = source_hand.get_child(0)
		equipped.reparent(target_hand)
		equipped.position = Vector2.ZERO
		equipped.rotation = 0
		equipped.get_child(0).flip_h = flip_sprite

## Move based on [member Hannah.direction] * [member Hannah.speed], and handle any collisions by checking they are items and if so adding to inventory
func _physics_process(delta):
	
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
	if direction != Vector2.ZERO: face_direction()
	
	#Here is inventory handling and interacting with world objects
	if Input.is_action_just_pressed("interact") and %RayCast2D.is_colliding() and \
	%RayCast2D.get_collider().has_method("interact"):
		
		toggle_processing()
		%RayCast2D.get_collider().interact()

	#use any equipment
	if is_instance_valid(equipped) and Input.is_action_just_pressed("interact"):
		equipped.use()

## Toggles [Hannah]'s [member Hannah.is_physics_processing] and [method Hannah.is_processing_unhandled_input] 
func toggle_processing():
	set_physics_process(!is_physics_processing())
	set_process_unhandled_input(!is_processing_unhandled_input())
