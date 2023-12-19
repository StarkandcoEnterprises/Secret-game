extends BaseItem

class_name BaseItemTest

var mouse_pos:Vector2 = Vector2(100,100)

func move_with_mouse():
	global_position = mouse_pos
