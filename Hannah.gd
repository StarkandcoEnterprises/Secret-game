extends CharacterBody2D


var speed = 300.0
var direction = "right"

#Get the inventory object - probably this should just be a child of the player? TODO refactor
@onready var inventory = get_tree().get_nodes_in_group("Inventory")[0]
var equipped

func _input(event):
	#Here is inventory handling and not yet implemented raycast check 
	if !inventory.visible and event.is_action_pressed("interact") and $RayCast2D.is_colliding():
		pass #TODO some interact call on world objects here
	elif inventory.visible and event.is_action_pressed("interact"):
		inventory.toggle_context_menu_for_selected()
	elif event.is_action_pressed("inventory"):
		if inventory.visible:
			inventory.hide()
			if inventory.check_menu_visibility_for_selected():
				inventory.toggle_context_menu_for_selected()
		else:
			inventory.show()
	elif inventory.visible and event.is_action_pressed("right") and !inventory.check_menu_visibility_for_selected():
		inventory.move_cursor("right")
	elif inventory.visible and event.is_action_pressed("left") and !inventory.check_menu_visibility_for_selected():
		inventory.move_cursor("left")
	elif inventory.visible and event.is_action_pressed("up") and !inventory.check_menu_visibility_for_selected():
		inventory.move_cursor("up")
	elif inventory.visible and event.is_action_pressed("down") and !inventory.check_menu_visibility_for_selected():
		inventory.move_cursor("down")

func _physics_process(delta):
	
	#use any equipment
	if !inventory.visible and is_instance_valid(equipped) and Input.is_action_pressed("interact"):
		var kept = equipped.use(direction, delta)
		if !kept:
			equipped = null
	#Check for movement
	velocity = Vector2.ZERO
	if Input.is_action_pressed("right") and !inventory.visible:
		velocity.x += speed
		direction = "right"
	if Input.is_action_pressed("left") and !inventory.visible:
		velocity.x -= speed
		direction = "left"
	if Input.is_action_pressed("down") and !inventory.visible:
		velocity.y += speed
		direction = "down"
	if Input.is_action_pressed("up") and !inventory.visible:
		velocity.y -= speed
		direction = "up"
	face_direction()
	
	#Move and check for collision 
	var collision = move_and_collide(velocity * delta)
	if collision:
		#If it's an item, add it to the inventory
		if collision.get_collider().is_in_group("Item"):
			inventory.add_item(collision.get_collider())
			#We also need to get rid of its collision shape TODO this doesn't work for interactions after this point....
			collision.get_collider().get_child(1).queue_free()


func face_direction():
	if direction == "left":
		$Sprite2D.flip_v = true
		if get_child_count() == 4:
			get_child(3).get_child(0).flip_v = true
			get_child(3).position = Vector2(90, 18)
	else:
		$Sprite2D.flip_v = false
		if get_child_count() == 4:
			get_child(3).get_child(0).flip_v = false
			get_child(3).position = Vector2(90, -90)
	var debug = 90*["right","down","left","up"].find(direction)
	rotation_degrees = 90*["right","down","left","up"].find(direction)

#Equip equipment - same notes as above refactor on inventory / equipment
func _on_equip_pressed():
	if equipped: 
		inventory.add_item(equipped)
	equipped = inventory.get_child(inventory.grid_pos).get_child(inventory.cursor_pos).get_child(0)
	inventory.toggle_context_menu_for_selected()
	inventory.remove_item(equipped, self)
	inventory.get_child(1).show()
	if direction == "left":
		equipped.position = Vector2(90,18)
	else:
		equipped.position = Vector2(-45,36)
	equipped.rotation_degrees = 0
