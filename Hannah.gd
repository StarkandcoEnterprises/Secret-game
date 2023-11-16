extends CharacterBody2D


var speed = 300.0
var direction = "right"

@onready var inventory = get_tree().get_nodes_in_group("Inventory")[0]

func _input(event):
	if !inventory.visible and event.is_action_pressed("interact") and $RayCast2D.is_colliding():
		pass #some interact call on item here
	elif inventory.visible and event.is_action_pressed("interact"):
		inventory.get_context_menu_for_selected()
	elif event.is_action_pressed("inventory"):
		if inventory.visible:
			inventory.hide() 
		else:
			inventory.show()
	elif inventory.visible and event.is_action_pressed("right"):
		inventory.move_cursor("right")
	elif inventory.visible and event.is_action_pressed("left"):
		inventory.move_cursor("left")
	elif inventory.visible and event.is_action_pressed("up"):
		inventory.move_cursor("up")
	elif inventory.visible and event.is_action_pressed("down"):
		inventory.move_cursor("down")

func _physics_process(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("right") and !inventory.visible:
		velocity.x += speed
		face_right()
	if Input.is_action_pressed("left") and !inventory.visible:
		velocity.x -= speed
		face_left()
	if Input.is_action_pressed("down") and !inventory.visible:
		velocity.y += speed
		face_down()
	if Input.is_action_pressed("up") and !inventory.visible:
		velocity.y -= speed
		face_up()
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().is_in_group("Item"):
			inventory.add_item(collision.get_collider())
			collision.get_collider().get_child(1).queue_free()

func face_right():
	rotation_degrees = 0
	$Sprite2D.flip_v = false
	direction = "right"

func face_down():
	rotation_degrees = 90
	$Sprite2D.flip_v = false
	direction = "down"

func face_left():
	rotation_degrees = 180
	$Sprite2D.flip_v = true
	direction = "left"

func face_up():
	rotation_degrees = 270
	$Sprite2D.flip_v = false
	direction = "up"

func _on_equip_pressed():
	var item = inventory.get_child(inventory.grid_pos).get_child(inventory.cursor_pos).get_child(0)
	inventory.get_context_menu_for_selected()
	inventory.remove_item(item, self)
	inventory.get_child(1).show()
	
