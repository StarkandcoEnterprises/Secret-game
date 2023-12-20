# GdUnit generated TestSuite
class_name TentTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://Buildings/Scenes/Tent.gd'

var main_scene: PackedScene = preload("res://CoreResources/Scenes/Main.tscn")
var tent_scene: PackedScene = preload("res://Buildings/Scenes/Tent.tscn")
var main: Main
var tent: Tent

func before():
	#Set up inventory, map
	main = auto_free(main_scene.instantiate())
	add_child(main)
	await get_tree().process_frame
	tent = tent_scene.instantiate()
	main.add_child(tent)
	await get_tree().process_frame

@warning_ignore("unused_parameter")
func test_interact():
	# Call the interact method
	tent.interact()

	# Assert that Hannah is inside the tent
	assert_bool(tent.hannah_inside).is_true()
	assert_bool(tent.hannah.in_building).is_true()

@warning_ignore("unused_parameter")
func test_process():
	# Set Hannah's position to a value greater than 210
	tent.hannah.position.y = 211

	# Call the _process method
	tent._process(0.1)

	# Assert that Hannah is not inside the tent
	assert_bool(tent.hannah_inside).is_false()
	assert_bool(tent.hannah.in_building).is_false()
