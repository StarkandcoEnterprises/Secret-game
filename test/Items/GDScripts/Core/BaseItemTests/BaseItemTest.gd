# GdUnit generated TestSuite
class_name BaseItemTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://Items/GDScripts/Core/BaseItems/BaseItem.gd'

var sample_item_scene: PackedScene = preload("res://Items/Resources/Stone.tscn")
var complex_item_scene: PackedScene = preload("res://Items/Resources/Stone.tscn")
var main_scene: PackedScene = preload("res://CoreResources/Scenes/Main.tscn")

@warning_ignore("unused_parameter")
func test_ready(timeout=50):
	var main: Main = auto_free(main_scene.instantiate())
	add_child(main)
	
	await get_tree().process_frame
	
	var item: BaseItem = auto_free(sample_item_scene.instantiate())
	main.add_child(item)

	await get_tree().process_frame

	# Assert that inventory_item_holder has been set
	assert_object(item.inventory_item_holder).is_not_null()

   if is_failure():
	  return
	
	# Assert that inventory_item_holder is in the "LooseItems" group
	assert_bool(item.inventory_item_holder.is_in_group("LooseItems")).is_true()

   if is_failure():
	  return

@warning_ignore("unused_parameter")
# Test toggle_collision_layer function
func test_toggle_collision_layer(timeout=20):
	var item: BaseItem = auto_free(sample_item_scene.instantiate())
	add_child(item)

	item.toggle_collision_layer()

	# Assert that the collision layer has been toggled to BACKPACK_COLLISION
	assert_int(item.get_collision_layer()).is_equal(BaseItem.BACKPACK_COLLISION)

	item.toggle_collision_layer()

	# Assert that the collision layer has been toggled back to INV_COLLISION
	assert_int(item.get_collision_layer()).is_equal(BaseItem.INV_COLLISION)


@warning_ignore("unused_parameter")
# Test set_interact_state function
func test_set_interact_state(timeout=20):
	var item: BaseItem = auto_free(sample_item_scene.instantiate())
	add_child(item)

	item.set_interact_state(BaseItem.Interact_State.IN_BACKPACK)

	# Assert that the interact state has been set to IN_BACKPACK
	assert_int(item.interact_state).is_equal(BaseItem.Interact_State.IN_BACKPACK)

@warning_ignore("unused_parameter")
# Test rotate_selected_item function
func test_rotate_selected_item(timeout=20):
	var item: BaseItem = auto_free(sample_item_scene.instantiate())
	add_child(item)

	var initial_rotation: float = item.rotation_degrees

	item.rotate_selected_item()

	# Assert that the item has been rotated by 90 degrees
	assert_float(item.rotation_degrees).is_equal(initial_rotation + 90)
	
@warning_ignore("unused_parameter")
func test_handle_reentry_to_inventory(timeout=40):
	var main: Main = auto_free(main_scene.instantiate())
	add_child(main)
	
	await get_tree().process_frame
	
	var item: BaseItem = auto_free(sample_item_scene.instantiate())
	main.add_child(item)
	
	await get_tree().process_frame
	
	# Add the item to the backpack_item_list
	item.handle_drop()

	# Call the function
	item.handle_reentry_to_inventory()

	# Assert that the item has been removed from the backpack_item_list
	assert_int(item.backpack_item_list.find_item_index(item.item_properties.string_name)).is_equal(-1)

	# Assert that the item's parent is the inventory_item_holder
	assert_object(item.get_parent()).is_equal(item.inventory_item_holder)

	# Assert that the item's collision layer has been toggled to BACKPACK_COLLISION
	assert_int(item.get_collision_layer()).is_equal(BaseItem.INV_COLLISION)

@warning_ignore("unused_parameter")
func test_handle_drop(timeout=40):
	var main: Main = auto_free(main_scene.instantiate())
	add_child(main)
	
	await get_tree().process_frame
	
	var item: BaseItem = auto_free(sample_item_scene.instantiate())
	main.add_child(item)
	
	await get_tree().process_frame

	# Call the function
	item.handle_drop()

	# Assert that the item is in the backpack_item_list
	assert_int(item.backpack_item_list.find_item_index(item.item_properties.string_name)).is_equal(0)

	# Assert that the item's parent is the backpack_item_holder
	assert_object(item.get_parent()).is_equal(item.backpack_item_holder.get_child(item.backpack_item_list.find_item_index(item.item_properties.string_name)))

	# Assert that the item's interact_state is IN_BACKPACK
	assert_int(item.interact_state).is_equal(BaseItem.Interact_State.IN_BACKPACK)

	# Assert that the item's collision layer has been toggled to BACKPACK_COLLISION
	assert_int(item.get_collision_layer()).is_equal(BaseItem.BACKPACK_COLLISION)

@warning_ignore("unused_parameter")
func test_handle_left_click_drag(timeout=40):
	var item: BaseItem = auto_free(sample_item_scene.instantiate())
	add_child(item)
	
	await get_tree().process_frame

	# Set the interact_state to SELECTABLE
	item.set_interact_state(BaseItem.Interact_State.SELECTABLE)
		
	var event = auto_free(InputEventMouseButton.new())
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	# Call the handle_left_click function of the item
	item.handle_left_click(event)

	# Assert that the interact_state is now SELECTED
	assert_int(item.interact_state).is_equal(BaseItem.Interact_State.SELECTED)

@warning_ignore("unused_parameter")
func test_handle_left_click_reentry(timeout=50):
	var main: Main = auto_free(main_scene.instantiate())
	add_child(main)
	
	await get_tree().process_frame
	
	var item: BaseItem = auto_free(sample_item_scene.instantiate())
	main.add_child(item)

	await get_tree().process_frame
	
	item.handle_drop()

	item.set_interact_state(BaseItem.Interact_State.SELECTED_IN_BACKPACK)

	var event = auto_free(InputEventMouseButton.new())
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	
	# Call the handle_left_click function of the item
	item.handle_left_click(event)

	# Assert that the interact_state is now IN_BACKPACK
	assert_int(item.interact_state).is_equal(BaseItem.Interact_State.SELECTED)

@warning_ignore("unused_parameter")
func test_handle_left_click_fall(timeout=20):
	var item: BaseItem = auto_free(sample_item_scene.instantiate())
	add_child(item)
	# Set the interact_state to SELECTED
	item.set_interact_state(BaseItem.Interact_State.SELECTED)

	var event = InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = false

	# Call the handle_left_click function of the item
	item.handle_left_click(event)

	# Assert that the interact_state is now SELECTABLE
	assert_int(item.interact_state).is_equal(BaseItem.Interact_State.SELECTABLE)


@warning_ignore("unused_parameter")
func test_handle_left_click_slot(timeout=20):
	var main: Main = auto_free(main_scene.instantiate())
	add_child(main)
	
	var item: BaseItem = auto_free(sample_item_scene.instantiate())
	main.add_child(item)
	
	item.set_interact_state(BaseItem.Interact_State.SELECTED)
	# Create an InputEventMouseButton instance for a left click release
	var event = InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = false

	# Make sure are_all_slots_free returns true
	item._on_slots_area_entered(get_tree().get_first_node_in_group("GridBlock"))

	# Call the _input function of the item
	item.handle_left_click(event)

	# Assert that the interact_state is now SLOTTED
	assert_int(item.interact_state).is_equal(BaseItem.Interact_State.SLOTTED_SELECTABLE)

@warning_ignore("unused_parameter")
func test_handle_left_click_handle_drop(timeout=40):
	var main: Main = auto_free(main_scene.instantiate())
	add_child(main)
	
	await get_tree().process_frame
	
	var item: BaseItem = auto_free(sample_item_scene.instantiate())
	main.add_child(item)
	
	await get_tree().process_frame

	# Set the interact_state to SELECTED
	item.set_interact_state(BaseItem.Interact_State.DROPPABLE)

	# Create an InputEventMouseButton instance for a left click release
	var event = InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = false

	# Call the _input function of the item
	item.handle_left_click(event)

	# Assert that the interact_state is now IN_BACKPACK
	assert_int(item.interact_state).is_equal(BaseItem.Interact_State.IN_BACKPACK)

@warning_ignore("unused_parameter")
func test_handle_left_click_else(timeout=30):
	var item: BaseItem = auto_free(sample_item_scene.instantiate())
	add_child(item)
	
	await get_tree().process_frame
	# Set the interact_state to DRAGGING
	item.set_interact_state(BaseItem.Interact_State.SELECTED)

	# Set the item to be not droppable
	item.item_properties.backpack_storable = false

	# Create an InputEventMouseButton instance for a left click release
	var event = InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = false

	# Call the handle_left_click function of the item
	item.handle_left_click(event)

	# Assert that the interact_state is now SELECTABLE
	assert_int(item.interact_state).is_equal(BaseItem.Interact_State.SELECTABLE)
	
@warning_ignore("unused_parameter")
func test_find_slotted_center(timeout=40):
	var main: Main = auto_free(main_scene.instantiate())
	add_child(main)
	
	await get_tree().process_frame
	
	var item: BaseItem = auto_free(sample_item_scene.instantiate())
	main.add_child(item)

	item.set_interact_state(BaseItem.Interact_State.SELECTED)
	
	var complex_item: BaseItem = auto_free(complex_item_scene.instantiate())
	main.add_child(complex_item)

	complex_item.set_interact_state(BaseItem.Interact_State.SELECTED)

	await get_tree().process_frame
	
	complex_item._on_slots_area_entered(get_tree().get_first_node_in_group("GridBlock"))
	complex_item._on_slots_area_entered(get_tree().get_nodes_in_group("GridBlock")[10])

	# Call the find_slotted_center function
	complex_item.find_slotted_center()
	
	# Assert that the center has been updated
	assert_vector(complex_item.center).is_equal(Vector2(0, 0))

	
	item._on_slots_area_entered(get_tree().get_nodes_in_group("GridBlock")[1])
	# Call the find_slotted_center function
	item.find_slotted_center()

	# Assert that the center has been updated
	assert_vector(item.center).is_equal(Vector2(44, 41))

@warning_ignore("unused_parameter")
func test_should_skip_processing(timeout=20):
	var item: BaseItem = auto_free(sample_item_scene.instantiate())
	add_child(item)

	# Test when interact_state is IN_WORLD
	item.set_interact_state(BaseItem.Interact_State.IN_WORLD)
	assert_bool(item.should_skip_processing()).is_true()

	# Test when interact_state is IN_INVENTORY
	item.set_interact_state(BaseItem.Interact_State.IN_INVENTORY)
	assert_bool(item.should_skip_processing()).is_false()

	# Test when interact_state is SELECTABLE
	item.set_interact_state(BaseItem.Interact_State.SELECTABLE)
	assert_bool(item.should_skip_processing()).is_false()

	# Test when interact_state is SELECTED
	item.set_interact_state(BaseItem.Interact_State.SELECTED)
	assert_bool(item.should_skip_processing()).is_false()

	# Test when interact_state is SLOTTED_SELECTABLE
	item.set_interact_state(BaseItem.Interact_State.SLOTTED_SELECTABLE)
	assert_bool(item.should_skip_processing()).is_true()

	# Test when interact_state is SLOTTED
	item.set_interact_state(BaseItem.Interact_State.SLOTTED)
	assert_bool(item.should_skip_processing()).is_true()

	# Test when interact_state is EQUIPPED
	item.set_interact_state(BaseItem.Interact_State.EQUIPPED)
	assert_bool(item.should_skip_processing()).is_true()

	# Test when interact_state is DROPPABLE
	item.set_interact_state(BaseItem.Interact_State.DROPPABLE)
	assert_bool(item.should_skip_processing()).is_false()

	# Test when interact_state is IN_BACKPACK
	item.set_interact_state(BaseItem.Interact_State.IN_BACKPACK)
	assert_bool(item.should_skip_processing()).is_true()

	# Test when interact_state is SELECTED_IN_BACKPACK
	item.set_interact_state(BaseItem.Interact_State.SELECTED_IN_BACKPACK)
	assert_bool(item.should_skip_processing()).is_true()

@warning_ignore("unused_parameter")
func test_handle_movement(timeout=50):
	var main: Main = auto_free(main_scene.instantiate())
	add_child(main)
	
	await get_tree().process_frame
	
	var item: BaseItem = auto_free(sample_item_scene.instantiate())
	main.add_child(item)

	# Test when interact_state is SELECTED
	item.set_interact_state(BaseItem.Interact_State.SELECTED)
	var initial_position = item.global_position
	item.handle_movement(0.1)
	
	await get_tree().process_frame
	
	assert_vector(item.global_position).is_equal_approx(item.get_global_mouse_position(), Vector2(2, 2))

	# Test when interact_state is IN_BACKPACK
	item.set_interact_state(BaseItem.Interact_State.IN_BACKPACK)
	initial_position = item.global_position
	item.handle_movement(0.1)
	
	await get_tree().physics_frame
	
	assert_vector(item.global_position).is_not_equal(initial_position)

	# Test when item is out of bounds
	item.global_position = Vector2(0, 700)
	item.set_interact_state(BaseItem.Interact_State.IN_INVENTORY) 
	initial_position = item.position
	item.handle_movement(0.1)
	

	assert_vector(item.position).is_equal_approx(Vector2(0, 0), Vector2(0, 30))  # Expect position to be reset

	# Test when item is not out of bounds and not in SELECTED or DROPPABLE state
	item.global_position = Vector2(0, 0) 
	item.set_interact_state(BaseItem.Interact_State.IN_INVENTORY)
	initial_position = item.position
	var initial_velocity = item.velocity
	item.handle_movement(0.1)
	await get_tree().process_frame
	assert_vector(item.position).is_not_equal(initial_position)  # Expect position to change due to gravity
	assert_vector(item.velocity).is_not_equal(initial_velocity)  # Expect velocity to change due to gravity

@warning_ignore("unused_parameter")
func test_added_to_inventory(timeout=20):
	var item: BaseItem = auto_free(sample_item_scene.instantiate())
	add_child(item)
	item.added_to_inventory()
	assert_int(item.interact_state).is_equal(BaseItem.Interact_State.IN_INVENTORY)

@warning_ignore("unused_parameter")
func test_on_mouse_entered(timeout=20):
	var item: BaseItem = auto_free(sample_item_scene.instantiate())
	add_child(item)
	# Test when interact_state is SLOTTED
	item.interact_state = BaseItem.Interact_State.SLOTTED
	item._on_mouse_entered()
	assert_int(item.interact_state).is_equal(BaseItem.Interact_State.SLOTTED_SELECTABLE)

	# Test when interact_state is not SELECTED
	item.interact_state = BaseItem.Interact_State.IN_INVENTORY
	item._on_mouse_entered()
	assert_int(item.interact_state).is_equal(BaseItem.Interact_State.SELECTABLE)

@warning_ignore("unused_parameter")
func test_on_mouse_exited(timeout=20):
	var item: BaseItem = auto_free(sample_item_scene.instantiate())
	add_child(item)

	# Test when interact_state is SLOTTED_SELECTABLE
	item.interact_state = BaseItem.Interact_State.SLOTTED_SELECTABLE
	item._on_mouse_exited()
	assert_int(item.interact_state).is_equal(BaseItem.Interact_State.SLOTTED)

	# Test when interact_state is not SELECTED
	item.interact_state = BaseItem.Interact_State.SELECTABLE
	item._on_mouse_exited()
	assert_int(item.interact_state).is_equal(BaseItem.Interact_State.IN_INVENTORY)

@warning_ignore("unused_parameter")
func test_should_skip_mouse_events(timeout=20):
	var item: BaseItem = auto_free(sample_item_scene.instantiate())
	add_child(item)

	# Test when interact_state is IN_WORLD
	item.interact_state = BaseItem.Interact_State.IN_WORLD
	assert_bool(item.should_skip_mouse_events()).is_true()

	# Test when interact_state is IN_BACKPACK
	item.interact_state = BaseItem.Interact_State.IN_BACKPACK
	assert_bool(item.should_skip_mouse_events()).is_true()

	# Test when interact_state is SELECTED_IN_BACKPACK
	item.interact_state = BaseItem.Interact_State.SELECTED_IN_BACKPACK
	assert_bool(item.should_skip_mouse_events()).is_true()

	# Test when interact_state is not in [IN_WORLD, IN_BACKPACK, SELECTED_IN_BACKPACK]
	item.interact_state = BaseItem.Interact_State.IN_INVENTORY
	assert_bool(item.should_skip_mouse_events()).is_false()

	item.interact_state = BaseItem.Interact_State.SELECTABLE
	assert_bool(item.should_skip_mouse_events()).is_false()
	
	item.interact_state = BaseItem.Interact_State.SELECTED
	assert_bool(item.should_skip_mouse_events()).is_false()
	
	item.interact_state = BaseItem.Interact_State.SLOTTED_SELECTABLE
	assert_bool(item.should_skip_mouse_events()).is_false()
	
	item.interact_state = BaseItem.Interact_State.SLOTTED
	assert_bool(item.should_skip_mouse_events()).is_false()
	
	item.interact_state = BaseItem.Interact_State.EQUIPPED
	assert_bool(item.should_skip_mouse_events()).is_false()
	
	item.interact_state = BaseItem.Interact_State.DROPPABLE
	assert_bool(item.should_skip_mouse_events()).is_false()

@warning_ignore("unused_parameter")
func test_on_slots_area_entered(timeout=50):
	var main: Main = auto_free(main_scene.instantiate())
	add_child(main)
	
	await get_tree().process_frame
	
	var item: BaseItem = auto_free(sample_item_scene.instantiate())
	main.add_child(item)

	# Test when interact_state is IN_WORLD
	item.interact_state = BaseItem.Interact_State.IN_WORLD
	item._on_slots_area_entered(get_tree().get_nodes_in_group("GridBlock")[0])
	assert_int(item.overlapping_areas.size()).is_equal(0)

	# Test when area is a GridBlock and not full
	item.interact_state = BaseItem.Interact_State.SELECTED
	item._on_slots_area_entered(get_tree().get_nodes_in_group("GridBlock")[0])
	assert_int(item.overlapping_areas.size()).is_equal(1)
	assert_object(item.overlapping_areas[0]).is_same(get_tree().get_nodes_in_group("GridBlock")[0])

	# Test when area is a BackpackArea and interact_state is SELECTED
	item.interact_state = BaseItem.Interact_State.SELECTED
	
	#Backpack area parent is in item hover state?
	get_tree().get_nodes_in_group("BackpackArea")[0].get_parent().current_state = Backpack.State.ITEM_HOVER
	
	await item._on_slots_area_entered(get_tree().get_nodes_in_group("BackpackArea")[0])
	assert_int(item.interact_state).is_equal(BaseItem.Interact_State.DROPPABLE)

@warning_ignore("unused_parameter")
func test_on_slots_area_exited(timeout=30):
	var main: Main = auto_free(main_scene.instantiate())
	add_child(main)
	
	await get_tree().process_frame
	
	var item: BaseItem = auto_free(sample_item_scene.instantiate())
	main.add_child(item)

	# Test when interact_state is IN_WORLD
	item.interact_state = BaseItem.Interact_State.IN_WORLD
	item._on_slots_area_exited(get_tree().get_nodes_in_group("GridBlock")[0])
	assert_int(item.overlapping_areas.size()).is_equal(0)

	# Test when area is a GridBlock and not full
	item.interact_state = BaseItem.Interact_State.SELECTED
	item._on_slots_area_exited(get_tree().get_nodes_in_group("GridBlock")[0])
	assert_int(item.overlapping_areas.size()).is_equal(0)

	# Test when area is a GridBlock, full, and contains the item
	item.interact_state = BaseItem.Interact_State.SELECTED
	item._on_slots_area_exited(get_tree().get_nodes_in_group("GridBlock")[0])
	assert_int(item.overlapping_areas.size()).is_equal(0)

	# Test when area is a BackpackArea and interact_state is DROPPABLE
	item.interact_state = BaseItem.Interact_State.DROPPABLE
	item._on_slots_area_exited(get_tree().get_nodes_in_group("BackpackArea")[0])
	assert_int(item.interact_state).is_equal(BaseItem.Interact_State.SELECTED)
