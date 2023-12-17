# GdUnit generated TestSuite
class_name MainTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://CoreResources/GDScripts/Main.gd'

var main_scene: PackedScene = preload("res://CoreResources/Scenes/Main.tscn")
var base_plant_scene: PackedScene = preload("res://Plants/Scenes/Instanced/CornPlant.tscn")

@warning_ignore("unused_parameter")
# Test _ready function
func test__ready(timeout=30):
	var main: Main = auto_free(main_scene.instantiate())
	add_child(main)

	await get_tree().process_frame

	assert_object(main.dialogue_UI).is_instanceof(DialogueManager)
	assert_object(main.dayover_UI).is_instanceof(DayoverUI)
	assert_bool(main.dayover_UI.next_day_UI_finished.is_connected(main.next_day)).is_true()

	assert_bool(main.get_node("%Daytime").is_stopped()).is_false()
	assert_float(main.get_node("%Daytime").wait_time).is_equal(Main.DAYTIME_VALUE)

@warning_ignore("unused_parameter")
# Test _on_daytime_timeout function
func test__on_daytime_timeout(timeout=30):
	var main: Main = auto_free(main_scene.instantiate())
	add_child(main)

	await get_tree().process_frame
	
	assert_object(main.get_node("%Hannah")).is_not_null()
	assert_object(main.get_node("%Hannah").inventory).is_not_null()
	
	main._on_daytime_timeout()

	assert_bool(main.get_node("%Hannah").inventory.visible).is_false()
	assert_bool(main.get_node("%Hannah").inventory.get_node("%HotbarUI").visible).is_true()
	assert_bool(main.get_node("%Hannah").is_processing_unhandled_input()).is_false()

@warning_ignore("unused_parameter")
# Test next_day function
func test_next_day(timeout=30):
	var main: Main = auto_free(main_scene.instantiate())
	add_child(main)

	await get_tree().process_frame

	assert_object(main.get_node("%Hannah")).is_not_null()

	main.next_day()

	assert_bool(main.get_node("%Hannah").inventory.visible).is_true()
	assert_bool(main.get_node("%Hannah").is_processing_unhandled_input()).is_true()

@warning_ignore("unused_parameter")
# Test reset_watering_and_grow function
func test_reset_watering_and_grow(timeout=30):
	var main: Main = auto_free(main_scene.instantiate())
	add_child(main)

	await get_tree().process_frame

	# Set a tile in the TileMap to be wet soil
	main.get_node("%TileMap").set_cell(0, Vector2(0, 0), 0, Vector2(0, 0), 1)

	# Add a BasePlant node to the %Plants node
	var plant: BasePlant = auto_free(base_plant_scene.instantiate())
	main.get_node("%Plants").add_child(plant)
	plant.position = Vector2(0, 0)
	await get_tree().process_frame

	main.reset_watering_and_grow()

	# Assert that the plant has grown
	assert_int(plant.planted_days).is_equal(1)

	# Assert that the tile in the TileMap is no longer wet soil
	assert_bool(main.is_wet_tile(Vector2i(0, 0))).is_false()

@warning_ignore("unused_parameter")
# Test is_wet_tile function
func test_is_wet_tile(timeout=30):
	var main: Main = auto_free(main_scene.instantiate())
	add_child(main)

	await get_tree().process_frame

	# Set a tile in the TileMap to be wet soil
	main.get_node("%TileMap").set_cell(0, Vector2i(0, 0), 0, Vector2(0, 0), 1)

	# Assert that the tile at position (0, 0) is wet
	assert_bool(main.is_wet_tile(Vector2i(0, 0))).is_true()

	# Set a tile in the TileMap to be not wet soil
	main.get_node("%TileMap").set_cell(0, Vector2i(1, 1), 0, Vector2(0, 0), 0)

	# Assert that the tile at position (1, 1) is not wet
	assert_bool(main.is_wet_tile(Vector2i(1, 1))).is_false()
