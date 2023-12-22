# GdUnit generated TestSuite
class_name SleepingBagPackagedTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://SleepingBagPackaged.gd'

var main_scene: PackedScene = preload("res://CoreResources/Scenes/Main.tscn")
var sleeping_bag_scene: PackedScene = preload("res://Items/Scenes/Instanced/SleepingBagPackaged.tscn")
var main: Main
var sleeping_bag: SleepingBagPackaged

func before():
	#Set up inventory, map
	main = auto_free(main_scene.instantiate())
	add_child(main)
	await get_tree().process_frame
	sleeping_bag = sleeping_bag_scene.instantiate()
	main.add_child(sleeping_bag)

@warning_ignore("unused_parameter")
func test_process(timeout=10) -> void:
	sleeping_bag.hannah.equipped = sleeping_bag
	sleeping_bag.interact_state = BaseItem.Interact_State.EQUIPPED
	# Call the _process method
	sleeping_bag._process(0.1)
	# Assert that the highlight sprite was scaled correctly
	assert_vector(sleeping_bag.hannah.get_node("%HighlightSprite").scale).is_equal(sleeping_bag.bag_size)

@warning_ignore("unused_parameter")
func test_use(timeout=20) -> void:
	# Call the use method
	sleeping_bag.use()
	# Assert that the sleeping bag was instantiated and added to the world
	assert_object(get_tree().get_first_node_in_group("WorldPlacements").get_child(3)).is_instanceof(AreaBed)
