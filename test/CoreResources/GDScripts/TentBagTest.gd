# GdUnit generated TestSuite
class_name TentBagTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://Items/GDScripts/Instanced/TentBag.gd'
var bag_scene: PackedScene = preload("res://Items/Scenes/Instanced/TentBag.tscn")
var main_scene: PackedScene = preload("res://CoreResources/Scenes/Main.tscn")
var tent_bag
var main

func before():
	main = auto_free(main_scene.instantiate())
	add_child(main)
	await get_tree().process_frame
	tent_bag = auto_free(bag_scene.instantiate())
	main.add_child(tent_bag)

@warning_ignore("unused_parameter")
func test_use(timeout=10):
	# Test the use function
	tent_bag.use()
	var world_placements = get_tree().get_first_node_in_group("WorldPlacements")
	assert_object(world_placements.get_child(2)).is_instanceof(Tent)

@warning_ignore("unused_parameter")
func test_process(timeout=10):
	# Test the _process function
	tent_bag.interact_state = BaseItem.Interact_State.EQUIPPED
	tent_bag._process(0.1)
	assert_vector(tent_bag.hannah.get_node("%HighlightSprite").scale).is_equal(tent_bag.tent_size)
