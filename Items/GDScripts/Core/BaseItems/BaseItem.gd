extends CharacterBody2D

class_name BaseItem

@export var item_properties: ItemPropertiesResource

enum Interact_State {
	IN_WORLD,
	IN_INVENTORY,
	SELECTABLE,
	SELECTED,
	SLOTTED_SELECTABLE,
	SLOTTED,
	EQUIPPED,
	DROPPABLE,
	IN_BACKPACK,
	SELECTED_IN_BACKPACK
}

var interact_state = Interact_State.IN_WORLD

const SPEED = 300
const SINGLE_BLOCK_SIZE = 40

const INV_COLLISION = 1
const BACKPACK_COLLISION = 2


var center = Vector2.ZERO
var overlapping_areas = []

var inventory_item_holder: Node2D
var backpack_item_list
var backpack_item_holder: Node2D
var main_backpack_node: Sprite2D


func _ready():
	await get_tree().process_frame
	inventory_item_holder = get_tree().get_first_node_in_group("LooseItems")
	backpack_item_list = get_tree().get_first_node_in_group("Backpack")
	backpack_item_holder = get_tree().get_first_node_in_group("BackpackItems")
	main_backpack_node = get_tree().get_first_node_in_group("MainBackpackNode")

func _process(delta):
	if should_skip_processing(): return
	handle_movement(delta)

func should_skip_processing() -> bool:
	return !interact_state in \
	[Interact_State.IN_INVENTORY, Interact_State.DROPPABLE, Interact_State.SELECTED, Interact_State.SELECTABLE]

func handle_movement(delta):
	if interact_state in [Interact_State.SELECTED, Interact_State.DROPPABLE]:
		move_with_mouse()
		
	elif is_out_of_bounds():
		reset()
		
	else:
		apply_gravity(delta)
		move_and_slide()

func is_out_of_bounds() -> bool:
	return global_position.y >= 648 or global_position.y <= -700 or global_position.x >= 896

func reset():
	position.y = 0
	position.x = 0
	velocity = Vector2.ZERO

func apply_gravity(delta):
	velocity += Vector2.DOWN * SPEED * delta

func move_with_mouse():
	global_position = get_global_mouse_position()

func are_all_slots_free() -> bool:
	return overlapping_areas.size() == item_properties.slots_needed

func added_to_inventory():
	set_interact_state(Interact_State.IN_INVENTORY)

func _on_mouse_entered():
	if should_skip_mouse_events(): return
	if interact_state == Interact_State.SLOTTED:  set_interact_state(Interact_State.SLOTTED_SELECTABLE)
	elif interact_state != Interact_State.SELECTED:  set_interact_state(Interact_State.SELECTABLE)

func _on_mouse_exited():
	if should_skip_mouse_events(): return
	if interact_state == Interact_State.SLOTTED_SELECTABLE: set_interact_state(Interact_State.SLOTTED)
	elif interact_state != Interact_State.SELECTED:  set_interact_state(Interact_State.IN_INVENTORY)

func should_skip_mouse_events() -> bool:
	return interact_state in \
	[Interact_State.IN_WORLD, Interact_State.IN_BACKPACK, Interact_State.SELECTED_IN_BACKPACK, \
	Interact_State.EQUIPPED]

#We are in an area... is it a grid block? Is it full?
func _on_slots_area_entered(area):
	if interact_state in [Interact_State.IN_WORLD,Interact_State.IN_BACKPACK,Interact_State.SELECTED_IN_BACKPACK]: 
		return
	if area.is_in_group("GridBlock"):
		if area.full: 
			modulate = Color.RED
			return
		
		#No, we could slot here.
		overlapping_areas.append(area)
		find_slotted_center()
		
		if overlapping_areas.size() == item_properties.slots_needed:
			modulate = Color.GREEN

	elif area.is_in_group("BackpackArea") and interact_state == Interact_State.SELECTED:
		await get_tree().process_frame
		if area.get_parent().current_state == area.get_parent().State.ITEM_HOVER:
			set_interact_state(Interact_State.DROPPABLE)

#We are leaving an area. If we were slotted or considering being here, we don't want to be anymore
func _on_slots_area_exited(area):
	if interact_state in [Interact_State.IN_WORLD,Interact_State.IN_BACKPACK,Interact_State.SELECTED_IN_BACKPACK]: 
		return
	if area.is_in_group("GridBlock"):
		
		
		#If it's not full, then we were considering entering it
		if !area.full:
			overlapping_areas.erase(area)
		
		#Even though it was not full, it might have been the slot we just left
		elif area.contains_ref == self:
			area.remove_item()
			overlapping_areas.erase(area)

		find_slotted_center()
		
		for area_b in %ItemUsedSlots.get_overlapping_areas():
			if !area_b.is_in_group("GridBlock"): continue
			if area_b.full: return
			
		modulate = Color.WHITE
		
		#Always forget the topleft value?
		
	elif area.is_in_group("BackpackArea") and interact_state == Interact_State.DROPPABLE:
		set_interact_state(Interact_State.SELECTED)

func _unhandled_input(event):
	# Not necessary when in the world
	if interact_state == Interact_State.IN_WORLD:
		return
	
	# We only care about mouse inputs
	if not event is InputEventMouseButton:
		return 
	
	# If we're not selectable or selected
	if interact_state not in [Interact_State.SELECTABLE, Interact_State.SELECTED, \
							Interact_State.SLOTTED_SELECTABLE, Interact_State.DROPPABLE,\
							 Interact_State.SELECTED_IN_BACKPACK]:
		return
	
	if event.button_index == MOUSE_BUTTON_LEFT:
		handle_left_click(event)
	
	# If we get a right click and item selected, rotate
	elif interact_state == Interact_State.SELECTED and Input.is_action_just_pressed("right_click"):
		rotate_selected_item()

# Separate function to handle left click actions
func handle_left_click(event):
	# If it's a press of the click and we're not in the backpack
	if event.is_pressed() and interact_state != Interact_State.SELECTED_IN_BACKPACK: 
		start_drag()
	
	# We are selected in the backpack
	elif interact_state == Interact_State.SELECTED_IN_BACKPACK: 
		handle_reentry_to_inventory()
	
	# Else, if it's a release and there are not enough free slots underneath / It is not droppable, fall
	elif !are_all_slots_free() and interact_state != Interact_State.DROPPABLE: 
		set_interact_state(Interact_State.SELECTABLE)
	
	# Otherwise, if it's a release and the slots are free
	elif are_all_slots_free(): 
		slot()
		modulate = Color.WHITE
	
	# Otherwise, it is droppable, it's in the backpack now!
	elif item_properties.backpack_storable: 
		handle_drop()
	
	#Otherwise fall
	else:
		set_interact_state(Interact_State.SELECTABLE)

# Separate function to handle actions when selected in the backpack
func handle_reentry_to_inventory():
	var item_index = backpack_item_list.find_item_index(item_properties.string_name)
	reparent(inventory_item_holder)
	if backpack_item_holder.get_child(item_index).get_child_count() == 0:
		backpack_item_holder.get_child(item_index).queue_free()
		main_backpack_node.index_of_selected_item = null
	else:
		backpack_item_list.deselect(item_index)
	backpack_item_list.cust_remove_item(self)
	toggle_collision_layer()
	start_drag()

# Separate function to handle when it is dropped
func handle_drop():
	modulate = Color.WHITE
	var item_index = backpack_item_list.find_item_index(item_properties.string_name)
	if item_index == -1: 
		var new_node = Node2D.new()
		backpack_item_holder.add_child(new_node)
	backpack_item_list.cust_add_item(self)
	reparent(backpack_item_holder.get_child(backpack_item_list.find_item_index(item_properties.string_name)))
	set_interact_state(Interact_State.IN_BACKPACK)
	toggle_collision_layer()

func toggle_collision_layer():
	set_collision_layer(BACKPACK_COLLISION if get_collision_layer() == INV_COLLISION else INV_COLLISION)

func set_interact_state(state):
	interact_state = state

# Separate function to handle rotating the selected item
func rotate_selected_item():
	rotation_degrees += 90

func slot():
	
	#Give all the areas a reference to this object and mark them as full
	for area in overlapping_areas:
		area.accept_item(self)
		
	#It's not selected, or being dragged. 
	#Scale is reset, gravity/collision is removed as it has been slotted
	interact_state = Interact_State.SLOTTED_SELECTABLE
	global_position = center

##Unslot function to allow equipment that are discarded to be deslotted
func deslot():
	for area in overlapping_areas:
		area.remove_item()

func start_drag():
	
	#We are now dragging it, it is selected, and it's a little bigger!
	interact_state = Interact_State.SELECTED
	
	#IF we're still a child of a slot, we shouldn't be
	if overlapping_areas.size() == 0: return

	#Remove any the areas a reference to this object and mark them as full
	for area in overlapping_areas:
		area.remove_item()

func find_slotted_center():
	
	center = Vector2.ZERO
	if !are_all_slots_free(): return
	
	var temp_width
	var temp_height
	
	if %ItemUsedSlots.get_child(0) is CollisionPolygon2D:
		
		temp_width = %ItemUsedSlots.get_child(0).width
		temp_height = %ItemUsedSlots.get_child(0).height
		
	else:
		
		temp_width = %ItemUsedSlots.get_child(0).shape.size.x
		temp_height = %ItemUsedSlots.get_child(0).shape.size.y
	
	if int(rotation_degrees) % 180 != 0:
		var temp_store = temp_width
		temp_width = temp_height
		temp_height = temp_store
		
		
	for a in overlapping_areas:
		
		if center == Vector2.ZERO or a.global_position.x +  (temp_width / 2) <= center.x:
			center.x = a.global_position.x +  (temp_width / 2) + (3 * temp_width / SINGLE_BLOCK_SIZE)
		
			if center.y != 0 and a.global_position.y + (temp_height / 2) > center.y: continue
			center.y = a.global_position.y + (temp_height / 2) + (3 * temp_height / SINGLE_BLOCK_SIZE)
		

		elif a.global_position.y > center.y: continue
		center.y = a.global_position.y + (temp_height / 2) + (3 * temp_height / SINGLE_BLOCK_SIZE)
