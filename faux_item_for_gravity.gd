extends RigidBody2D

var selectable = false
var selected = false

func _input(event):
	if selectable:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and get_global_mouse_position:
				global.is_dragging = true
				selected = true
				scale = Vector2(1.2, 1.2)
			else:
				selected = false
				global.is_dragging = false
				scale = Vector2(1.0, 1.0)

func _process(delta):
	var debug = position
	if selected:
		global_position = get_global_mouse_position()
	if position.y >= 648:
		position.y = 0
		position.x = 0

func _on_mouse_entered():
	if not global.is_dragging:
		selectable = true
		scale = Vector2(1.1, 1.1)

func _on_mouse_exited():
	if not global.is_dragging:
		selectable = false
		scale = Vector2(1, 1)
