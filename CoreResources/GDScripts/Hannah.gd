extends CharacterBody2D

class_name Hannah

var speed = 300.0

@onready var inventory = get_tree().get_first_node_in_group("Inventory")
@onready var debug = get_tree().get_first_node_in_group("DebugOutput")

var equipped: BaseEquipment
var interacting = false

var direction: Vector2 = Vector2.ZERO

func equip_item(item: BaseItem):
	
	var new_version = item.duplicate()
	%RightHand.add_child(new_version)
	if direction == Vector2.LEFT: face_direction()
	
	new_version.position = Vector2.ZERO
	
	equipped = new_version


func unequip_held():
	
	%RightHand.get_child(0).queue_free() if %RightHand.get_child_count() > 0 else null
	%LeftHand.get_child(0).queue_free() if %LeftHand.get_child_count() > 0 else null
	
	equipped = null

func face_direction():
	
	if direction == Vector2.LEFT:
		%AnimatedSprite2D.flip_h = true
		if %RightHand.get_child_count() > 0: 
			%RightHand.get_child(0).reparent(%LeftHand)
			%LeftHand.get_child(0).position = Vector2.ZERO
			%LeftHand.get_child(0).rotation = 0
			%LeftHand.get_child(0).get_child(0).flip_h = true
	else:
		%AnimatedSprite2D.flip_h = false
		if %LeftHand.get_child_count() > 0: 
			%LeftHand.get_child(0).reparent(%RightHand)
			%RightHand.get_child(0).position = Vector2.ZERO
			%RightHand.get_child(0).rotation = 0
			%RightHand.get_child(0).get_child(0).flip_h = false
	
	%RayCast2D.rotation_degrees = 90*[Vector2.DOWN,Vector2.LEFT,Vector2.UP,Vector2.RIGHT].find(direction)


func _physics_process(delta):
	if interacting: return
	
	#Prepare
	velocity = direction * speed
	
	#Move and check for collision 
	var collision = move_and_collide(velocity * delta)
	
	velocity = Vector2.ZERO
	
	if !collision: return
	
	if !collision.get_collider() is BaseItem: return
	
	if collision.get_collider().interact_state != collision.get_collider().Interact_State.IN_WORLD: return
	
	#If it's an item, add it to the inventory
	inventory.add_item(collision.get_collider())


func _unhandled_input(_event):
	if interacting: return

	direction = Input.get_vector("left","right","up","down")
	if direction != Vector2.ZERO: face_direction()
	
	#Here is inventory handling and interacting with world objects
	if Input.is_action_just_pressed("interact") and %RayCast2D.is_colliding() and \
	%RayCast2D.get_collider().has_method("interact"):
		
		interacting = true
		%RayCast2D.get_collider().interact()
		
	if Input.is_action_just_pressed("inventory"):
		toggle_processing()

	#use any equipment
	if is_instance_valid(equipped) and Input.is_action_just_pressed("interact"):
		equipped.use()

func toggle_processing():
	set_physics_process(is_physics_processing())
	set_process_input(is_processing_input())
