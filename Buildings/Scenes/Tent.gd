extends WorldObject

class_name Tent

var hannah_inside = false

func _ready():
	super()
	dialogue_tree = {}

# Override the interact function to allow the player to enter the tent
func interact():
	main.get_node("%Daytime").stop()
	hannah_inside = true
	hannah.in_building = true
	%Camera2D.make_current()
	hannah.reparent(%SubViewport)
	hannah.get_node("Camera2D").make_current()
	hannah.global_position = %EntryPoint.global_position
	%SubViewportContainer.visible = true
	call_dialogue_callback("")

func _process(_delta):
	if !hannah_inside: return
	if hannah.position.y > 210:
		hannah.reparent(get_tree().get_first_node_in_group("WorldContainer"))
		hannah_inside = false
		hannah.in_building = false
		%SubViewportContainer.visible = false
		hannah.global_position = %ExitPoint.global_position
		await get_tree().process_frame
		hannah.get_node("Camera2D").make_current()
