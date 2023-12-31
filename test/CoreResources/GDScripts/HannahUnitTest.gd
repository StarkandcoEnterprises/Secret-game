# GdUnit generated TestSuite
class_name HannahUnitTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://CoreResources/GDScripts/Hannah.gd'

var hannah_scene: PackedScene = preload("res://CoreResources/Scenes/HannahTest.tscn")
var main_scene: PackedScene = preload("res://CoreResources/Scenes/Main.tscn")
var sample_item_scene: PackedScene = preload("res://Items/Scenes/Instanced/Stone.tscn")
var sample_interactable_scene: PackedScene = preload("res://CoreResources/Scenes/Bed.tscn")
var sample_equipment_scene: PackedScene = preload("res://Items/Scenes/Instanced/Hoe.tscn")
var hannah: HannahTest
var main: Main

func before():
	#Set up inventory, map
	main = auto_free(main_scene.instantiate())
	add_child(main)
	await get_tree().process_frame
	hannah = auto_free(hannah_scene.instantiate())
	main.add_child(hannah)

@warning_ignore("unused_parameter")
func test_ready(timeout=20) -> void:
	#Verify it's a Hannah base.
	assert_object(hannah).is_instanceof(HannahTest)
	
	#It hasn't had any renamed or removed methods that are below
	assert_object(hannah).has_method("toggle_processing")
	assert_object(hannah).has_method("_physics_process")
	assert_object(hannah).has_method("_unhandled_input")
	assert_object(hannah).has_method("_easeInOutElastic")
	assert_object(hannah).has_method("_process")
	assert_object(hannah).has_method("start_animation")
	assert_object(hannah).has_method("update_animation_state")
	assert_object(hannah).has_method("update_rotation")
	assert_object(hannah).has_method("end_animation")
	assert_object(hannah).has_method("equip_item")
	assert_object(hannah).has_method("unequip_held")
	
	for layer in hannah.collision_layer:
		if layer == 0: continue
		if layer == 1:
			assert_bool(hannah.get_collision_layer_value(layer)).is_true()
			continue
		assert_bool(hannah.get_collision_layer_value(layer)).is_false()
	
	for mask in hannah.collision_mask:
		if mask == 0: continue
		if mask == 1:
			assert_bool(hannah.get_collision_mask_value(mask)).is_true()
			continue
		assert_bool(hannah.get_collision_mask_value(mask)).is_false()
		
	assert_object(hannah.inventory).is_not_null().is_instanceof(PlayerUI)
	assert_object(hannah.map).is_not_null().is_instanceof(TileMap)

@warning_ignore("unused_parameter")
func test_toggle_processing(timeout=20) -> void:
	#Run toggle processing
	hannah.toggle_processing()
	#Verify processing is false
	assert_bool(hannah.is_processing()).is_false()
	assert_bool(hannah.is_physics_processing()).is_false()
	assert_bool(hannah.is_processing_unhandled_input()).is_false()
	#Repeat for true
	hannah.toggle_processing()
	assert_bool(hannah.is_processing()).is_true()
	assert_bool(hannah.is_physics_processing()).is_true()
	assert_bool(hannah.is_processing_unhandled_input()).is_true()

@warning_ignore("unused_parameter")
func test__physics_process(timeout=30) -> void:
	var sample_item: BaseItem = auto_free(sample_item_scene.instantiate())
	main.add_child(sample_item)
	await get_tree().process_frame
	
	#Set a direction to be used for physics processing
	hannah.direction = Vector2.LEFT
	
	#Reenable physics processing
	hannah.set_physics_process(true)
	hannah._physics_process(0.1)
	
	#Make sure we've picked up the item
	assert_int(main.get_node("%UI").get_node("%PlayerUI").get_node("%InvSprite").get_node("%LooseItems").get_child_count()).is_equal(1)
	
	#Make sure the velocity has been updated
	assert_vector(hannah.velocity).is_equal_approx(Vector2.LEFT * hannah.speed, Vector2(0.0001,0.0001))
		
	#Make sure we've tried rotate to the mouse position
	assert_float(hannah.get_node("%ArmBase").rotation).is_equal_approx(1.018838, 0.2)
	
	#Create a new item to *not* be picked up 
	var not_pickedup_item: BaseItem = auto_free(sample_item_scene.instantiate())
	not_pickedup_item.interact_state = BaseItem.Interact_State.EQUIPPED
	main.add_child(not_pickedup_item)
	
	hannah._physics_process(0.1)
	
	#Ensure it isn't picked up
	assert_int(main.get_node("%UI").get_node("%PlayerUI").get_node("%InvSprite").get_node("%LooseItems").get_child_count()).is_equal(1)
	
	# Test withe excess weight
	hannah.weight = 60
	var initial_stamina = hannah.stamina
	hannah.direction = Vector2.LEFT
	
	hannah._physics_process(5)

	# Check that stamina has decreased after moving with excess weight
	assert_int(hannah.stamina).is_less(Hannah.MAX_STAMINA)

	initial_stamina = hannah.stamina
	
	# Stop moving
	hannah.direction = Vector2.ZERO

	hannah._physics_process(5)

	# Check that stamina has increased after stopping
	assert_int(hannah.stamina).is_greater(initial_stamina)

	# Test running effect
	hannah.stamina = Hannah.MAX_STAMINA  # Ensure we have enough stamina to run
	hannah.direction = Vector2.RIGHT
	hannah._physics_process(0.1)
	var initial_velocity = hannah.velocity

	# Simulate pressing the run action
	Input.action_press("run")
	hannah._physics_process(5)

	# Check that velocity has increased/stamina has decreased
	assert_float(hannah.velocity.length()).is_greater(initial_velocity.length())
	assert_float(hannah.stamina).is_less(Hannah.MAX_STAMINA)

	# Simulate releasing the run action
	Input.action_release("run")
	hannah._physics_process(5)

	# Check that velocity has returned to normal
	assert_float(hannah.velocity.length()).is_equal(initial_velocity.length())

	# Deplete stamina
	hannah.stamina = 0
	Input.action_press("run")
	hannah._physics_process(0.1)

	# Check that velocity has dropped due to no stamina even though the run action is pressed
	assert_float(hannah.velocity.length()).is_less(initial_velocity.length())

@warning_ignore("unassigned_variable")
func test__unhandled_input(timeout=100) -> void:
	hannah.set_physics_process(false)
	hannah.get_node("%UseArea").global_position = Vector2(100, 0)
	#Simulate left and press action
	Input.action_press("left")
	Input.action_press("interact")
	
	#Run unhandled input 
	var _event
	hannah._unhandled_input(_event)
	
	#Reset button presses
	Input.action_release("interact")
	Input.action_release("left")
	
	#Verify we're facing left
	assert_bool(hannah.get_node("%AnimatedSprite2D").flip_h).is_true()
	assert_vector(hannah.direction).is_equal(Vector2.LEFT)
	
	#Simulate right 
	Input.action_press("right")
	
	#Run unhandled input
	hannah._unhandled_input(_event)
	
	#Reset button press
	Input.action_release("right")
	
	#Verify we're facing right
	assert_bool(hannah.get_node("%AnimatedSprite2D").flip_h).is_false()
	assert_vector(hannah.direction).is_equal(Vector2.RIGHT)
	
	#So the use area doesn't move for other testing later
	
	#Create an interactable object and supporting scenes
	var sample_interactable = auto_free(sample_interactable_scene.instantiate())
	
	#Add the child
	main.add_child(sample_interactable)
	sample_interactable.global_position = hannah.get_node("%UseArea").global_position
	await get_tree().create_timer(0.06).timeout
	#Prepare for interaction
	Input.action_press("interact")
	
	#Run unhandled input 
	hannah._unhandled_input(_event)
	
	#Reset button press
	Input.action_release("interact")
	
	#This was just toggled by the toggle from interacting, which means it's incorrectly true
	hannah.set_physics_process(false)
	
	#Verify the interaction is taking place
	assert_bool(hannah.is_processing()).is_false()
	assert_bool(hannah.is_physics_processing()).is_false()
	assert_bool(hannah.is_processing_unhandled_input()).is_false()
	assert_vector(hannah.direction).is_equal(Vector2.ZERO)
	hannah.toggle_processing()
	

@warning_ignore("unused_parameter")
func test__easeInOutElastic(timeout=10) -> void:
	# Test with x = 0.0
	var result = hannah._ease_in_out_elastic(0.0)
	assert_float(result).is_equal(0)

	# Test with x = 1.0
	result = hannah._ease_in_out_elastic(1.0)
	assert_float(result).is_equal(1.0)

	# Test with x = 0.5
	result = hannah._ease_in_out_elastic(0.5)
	
	# Expected result calculated manually or using a trusted source
	var expected_result = 0.896044
	assert_float(result).is_equal_approx(expected_result, 0.0001)
	

@warning_ignore("unused_parameter")
func test__process(timeout=20) -> void:
	# Test with equipped and playing_anim both false
	hannah.playing_anim = false
	hannah._process(0.1)
	
	assert_bool(hannah.get_node("%HighlightSprite").visible).is_false()

	# Test with equipped true and equipped.equipment_properties.highlight_area true
	hannah.equipped = auto_free(sample_equipment_scene.instantiate())
	hannah.playing_anim = false
	hannah._process(0.1)
	
	assert_bool(hannah.get_node("%HighlightSprite").visible).is_true()

	# Test with equipped true and equipped.equipment_properties.highlight_area false
	hannah.equipped.equipment_properties.highlight_area = false
	hannah.playing_anim = false
	hannah._process(0.1)
	assert_bool(hannah.get_node("%HighlightSprite").visible).is_false()

	# Test with Input.is_action_just_pressed("left_click") true and playing_anim true
	Input.action_press("left_click")
	hannah.playing_anim = true
	hannah._process(0.1)
	
	assert_bool(hannah.get_node("%SlashSprite").visible).is_false()
	
	# Test with equipped true and Input.is_action_just_pressed("left_click") true
	hannah.equipped.equipment_properties.highlight_area = true
	Input.action_press("left_click")
	hannah.playing_anim = false
	hannah.stamina = Hannah.MAX_STAMINA
	hannah._process(0.1)
	
	assert_bool(hannah.get_node("%SlashSprite").visible).is_true()

	# Test with playing_anim true and anim_state < 1
	hannah.playing_anim = true
	hannah.anim_state = 0.5
	hannah._process(0.1)
	assert_bool(hannah.get_node("%SlashSprite").visible).is_true()

	# Test with playing_anim true and anim_state >= 1
	hannah.playing_anim = true
	hannah.anim_state = 1
	hannah._process(0.1)
	
	assert_bool(hannah.get_node("%SlashSprite").visible).is_false()
	
@warning_ignore("unused_parameter")
# Test start_animation function
func test_start_animation(timeout=10):
	hannah.start_animation()
	assert_bool(hannah.playing_anim).is_true()
	assert_bool(hannah.get_node("%SlashSprite").flip_h).is_true() # replace with actual node name
	assert_float(hannah.start_rotation).is_equal(hannah.get_node("%Equipped").rotation) # replace with actual node name

@warning_ignore("unused_parameter")
# Test update_animation_state function
func test_update_animation_state(timeout=30):

	var initial_anim_state = hannah.anim_state
	hannah.update_animation_state(0.1)
	assert_float(hannah.anim_state).is_equal(initial_anim_state + 0.2)

@warning_ignore("unused_parameter")
# Test update_rotation function
func test_update_rotation(timeout=20):
	hannah.playing_anim = false
	hannah.update_rotation()
	assert_float(hannah.get_node("%Equipped").rotation).is_equal(0) # replace with actual node namea

@warning_ignore("unused_parameter")
# Test end_animation function
func test_end_animation(timeout=20):
	hannah.playing_anim = true
	hannah.start_rotation = 1
	hannah.end_rotation = 2
	var test_pos = hannah.get_node("%Equipped").position.y
	
	hannah.end_animation()
	
	assert_bool(hannah.playing_anim).is_false()
	assert_float(hannah.anim_state).is_equal(0)
	assert_int(hannah.start_rotation).is_equal(2)
	assert_int(hannah.end_rotation).is_equal(1)
	assert_float(hannah.get_node("%Equipped").position.y).is_equal(-test_pos)

@warning_ignore("unused_parameter")
# Test equip_item function
func test_equip_item(timeout=30):
	var equipment: BaseEquipment = auto_free(sample_equipment_scene.instantiate())
	hannah.equip_item(equipment)

	assert_object(hannah.equipped).is_instanceof(BaseEquipment)
	assert_int(hannah.equipped.interact_state).is_equal(BaseItem.Interact_State.EQUIPPED)
	assert_vector(hannah.equipped.position).is_equal(Vector2.ZERO)

@warning_ignore("unused_parameter")
# Test unequip_held function
func test_unequip_held(timeout=20):
	var equipment: BaseEquipment = auto_free(sample_equipment_scene.instantiate())
	hannah.equip_item(equipment)
	hannah.unequip_held()

	assert_object(hannah.equipped).is_null()
	assert_bool(hannah.get_node("%HighlightSprite").visible).is_false()

@warning_ignore("unused_parameter")
func test_health(timeout=20):
	hannah.decrease_health(10)
	assert_int(hannah.health).is_equal(90)

	hannah.increase_health(110)
	assert_int(hannah.health).is_equal(100)
	
	hannah.decrease_health(110)
	assert_int(hannah.health).is_equal(0)
	#TODO: Return to implement die effect

@warning_ignore("unused_parameter")
func test_stamina(timeout=10):
	hannah.decrease_stamina(110)
	assert_int(hannah.stamina).is_equal(0)

	hannah.increase_stamina(110)
	assert_int(hannah.stamina).is_equal(100)

@warning_ignore("unused_parameter")
func test_morale(timeout=10):
	hannah.decrease_morale(110)
	assert_int(hannah.morale).is_equal(0)

	hannah.increase_morale(110)
	assert_int(hannah.morale).is_equal(100)
