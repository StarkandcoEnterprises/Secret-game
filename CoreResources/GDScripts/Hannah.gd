extends CharacterBody2D

class_name Hannah

var speed = 300.0

@onready var inventory = get_tree().get_first_node_in_group("Inventory")
@onready var debug = get_tree().get_first_node_in_group("DebugOutput")

var equipped: BaseEquipment
var interacting = false

func equip_item(item: BaseItem):
	var new_version = item.duplicate()
	%HandsRight.add_child(new_version)
	new_version.position = Vector2.ZERO
	equipped = new_version


func unequip_held():
	if %HandsRight.get_child_count() > 0:
		%HandsRight.get_child(0).queue_free()
	elif %HandsLeft.get_child_count() > 0:
		%HandsLeft.get_child(0).queue_free()
	equipped = null
	
func unequip_item(item: BaseItem):
	if %HandsRight.get_child_count() > 0:
		if %HandsRight.get_child(0).name == item.name:
			%HandsRight.get_child(0).queue_free()
	elif %HandsLeft.get_child_count() > 0:
		if %HandsLeft.get_child(0).name == item.name:
			%HandsLeft.get_child(0).queue_free()
	equipped = null

func face_direction(direction):
	if direction == Vector2.LEFT:
		%AnimatedSprite2D.flip_h = true
		if %HandsRight.get_child_count() > 0:
			%HandsRight.get_child(0).reparent(%HandsLeft)
	else:
		%AnimatedSprite2D.flip_h = false
		if %HandsLeft.get_child_count() > 0:
			%HandsLeft.get_child(0).reparent(%HandsRight)
	%RayCast2D.rotation_degrees = 90*[Vector2.DOWN,Vector2.LEFT,Vector2.UP,Vector2.RIGHT].find(direction)


func _physics_process(delta):
	if !interacting:
		
		#use any equipment
		if is_instance_valid(equipped) and Input.is_action_just_pressed("interact"):
			equipped.use()
		elif is_instance_valid(equipped) and Input.is_action_pressed("unequip"):
			unequip_held()
		
		#Check for movement
		velocity = Vector2.ZERO
		velocity = Input.get_vector("left","right","up","down") * speed
		face_direction(Input.get_vector("left","right","up","down"))
		
		#Move and check for collision 
		var collision = move_and_collide(velocity * delta)
		if collision:
			
			#If it's an item, add it to the inventory
			if collision.get_collider() is BaseItem:
				inventory.add_item(collision.get_collider())


func _input(event):
	if !interacting:
		#Here is inventory handling and interacting with world objects
		if event.is_action_pressed("interact") and %RayCast2D.is_colliding() and %RayCast2D.get_collider().has_method("interact"):
			interacting = true
			%RayCast2D.get_collider().interact()
