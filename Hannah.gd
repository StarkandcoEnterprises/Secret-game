extends CharacterBody2D


var speed = 300.0
var direction = "right"

@onready var inventory = get_tree().get_nodes_in_group("Inventory")[0]

func _input(event):
	if event.is_action_pressed("interact") and $RayCast2D.is_colliding():
		pass
	elif event.is_action_pressed("inventory"):
		if inventory.visible:
			inventory.hide() 
		else:
			inventory.show()

func _physics_process(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("right"):
		velocity.x += speed
		face_right()
	if Input.is_action_pressed("left"):
		velocity.x -= speed
		face_left()
	if Input.is_action_pressed("down"):
		velocity.y += speed
		face_down()
	if Input.is_action_pressed("up"):
		velocity.y -= speed
		face_up()
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().is_in_group("Item"):
			collision.get_collider().get_child(1).disabled = true
			inventory.add_item(collision.get_collider())

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
