extends WorldObjectStatic

class_name Building

var hannah_inside = false

@onready var subviewport = get_node("%SubViewport")
@onready var entrypoint = get_node("%EntryPoint")
@onready var subviewport_container = get_node("%SubViewportContainer")
@onready var camera = get_node("%Camera2D")

func interact():
	hannah_inside = true
	hannah.in_building = true
	camera.make_current()
	hannah.reparent(subviewport)
	hannah.get_node("Camera2D").make_current()
	hannah.global_position = entrypoint.global_position
	subviewport_container.visible = true
	call_dialogue_callback("")
