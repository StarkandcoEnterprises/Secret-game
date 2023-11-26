extends CharacterBody2D


var speed = 300.0

var subviewport

#Get the inventory object - probably this should just be a child of the player? TODO refactor
@onready var inventory = get_tree().get_first_node_in_group("Inventory")
@onready var debug = get_tree().get_first_node_in_group("DebugOutput")
@onready var start_inv_visible = inventory.visible

var equipped
var interacting = false

func _ready():
	await get_tree().process_frame
	subviewport = get_node("/root/Main/UI/PlayerInventoryUI/InvSprite/SubViewportContainer/SubViewport")
	subviewport.world_2d = get_viewport().world_2d



func _input(event):
	if !interacting:
		
		#Here is inventory handling and interacting with world objects
		if !inventory.visible and event.is_action_pressed("interact") and %RayCast2D.is_colliding() and %RayCast2D.get_collider().has_method("interact"):
			interacting = true
			%RayCast2D.get_collider().interact()
		elif event.is_action_pressed("inventory"):
			
			#Just in case I have the inventory visible at game runtime
			if inventory.visible and !start_inv_visible:
				inventory.hide()
				var inv_cam = get_tree().get_nodes_in_group("InvCam")[0]
				remove_child(inv_cam)
				
			#Normal inventory handling
			elif inventory.visible:
				inventory.hide()
			else:
				inventory.show()
			
				#Instantiate the inventory camera
				var inv_cam = Camera2D.new()
				inv_cam.custom_viewport = subviewport
				inv_cam.position = $Marker2D.position
				inv_cam.add_to_group("InvCam")
				add_child(inv_cam)



func _physics_process(delta):
	if !interacting and !inventory.visible:
		
		#use any equipment
		if is_instance_valid(equipped) and Input.is_action_pressed("interact"):
			var kept = equipped.use($AnimatedSprite2D.flip_h, delta)
			if !kept:
				equipped = null
		elif is_instance_valid(equipped) and Input.is_action_pressed("unequip"):
			inventory.add_item(equipped)
			equipped = null
		
		#Check for movement
		velocity = Vector2.ZERO
		velocity = Input.get_vector("left","right","up","down") * speed
		face_direction(Input.get_vector("left","right","up","down"))
		
		#Move and check for collision 
		var collision = move_and_collide(velocity * delta)
		if collision:
			
			#If it's an item, add it to the inventory
			if collision.get_collider().is_in_group("Item"):
				inventory.add_item(collision.get_collider())
				
				#We also need to get rid of its collision shape TODO this doesn't work for interactions after this point....
				collision.get_collider().get_child(1).queue_free()

func face_direction(direction):
	if direction == Vector2.LEFT:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	debug.stack_and_text(str(90*[Vector2.DOWN,Vector2.LEFT,Vector2.UP,Vector2.RIGHT].find(direction)))
	%RayCast2D.rotation_degrees = 90*[Vector2.DOWN,Vector2.LEFT,Vector2.UP,Vector2.RIGHT].find(direction)

#Equip equipment - TODO FIX TO USE THE BAR WHEN WE HAVE INVENTORY WORKING
func _on_equip_pressed():
	if equipped: 
		inventory.add_item(equipped)
	equipped = inventory.get_child(inventory.grid_pos).get_child(inventory.cursor_pos).get_child(0)
	inventory.toggle_context_menu_for_selected()
	inventory.remove_item(equipped, self)
	inventory.get_child(1).show()
	if $AnimatedSprite2D.flip_h == true:
		equipped.position = Vector2(90,18)
	else:
		equipped.position = Vector2(-45,36)
	equipped.rotation_degrees = 0

