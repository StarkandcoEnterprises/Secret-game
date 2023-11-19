extends CharacterBody2D


var speed = 300.0

#Get the inventory object - probably this should just be a child of the player? TODO refactor
@onready var inventory = get_tree().get_nodes_in_group("Inventory")[0]
var equipped
var interacting = false

func _input(event):
	if !interacting:
		#Here is inventory handling and interacting with world objects
		if !inventory.visible and event.is_action_pressed("interact") and $RayCast2D.is_colliding() and $RayCast2D.get_collider().has_method("interact"):
			interacting = true
			$RayCast2D.get_collider().interact()
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
		if get_child_count() == 4:
			get_child(3).get_child(0).flip_h = true
			get_child(3).position = Vector2(90, 18)
	else:
		$AnimatedSprite2D.flip_h = false
		if get_child_count() == 4:
			get_child(3).get_child(0).flip_h = false
			get_child(3).position = Vector2(90, -90)
	
	$RayCast2D.rotation_degrees = 90*["down","left","up","right"].find(direction)

#Equip equipment - same notes as above refactor on inventory / equipment
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
