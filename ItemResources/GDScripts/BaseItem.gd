extends CharacterBody2D

class_name BaseItem

@export var item_properties:ItemPropertiesResource


enum Interact_State {
	IN_WORLD,
	IN_INVENTORY,
	SELECTABLE,
	SELECTED,
	SLOTTED_SELECTABLE,
	SLOTTED
}

var interact_state = Interact_State.IN_WORLD

const SPEED = 300
const SINGLE_BLOCK_SIZE = 40

var center = Vector2.ZERO

var overlapping_areas = []


func _process(delta):
	
	if interact_state == Interact_State.SLOTTED or \
	interact_state == Interact_State.SLOTTED_SELECTABLE or\
	interact_state == Interact_State.IN_WORLD: return
	
	if interact_state == Interact_State.SELECTED:
		global_position = get_global_mouse_position()
		
	elif global_position.y >= 648 or global_position.y <= -200:
		position.y = 0
		position.x = 0
		
	else:
		velocity += Vector2.DOWN * SPEED * delta
		move_and_slide()



func are_all_slots_free():
	return overlapping_areas.size() == item_properties.slots_needed


func added_to_inventory():
	interact_state = Interact_State.IN_INVENTORY
	position = Vector2.ZERO

func _on_mouse_entered():
	if interact_state == Interact_State.IN_WORLD: return
	if interact_state == Interact_State.SLOTTED: interact_state = Interact_State.SLOTTED_SELECTABLE
	elif interact_state != Interact_State.SELECTED: interact_state = Interact_State.SELECTABLE

func _on_mouse_exited():
	if interact_state == Interact_State.IN_WORLD: return
	if interact_state == Interact_State.SLOTTED_SELECTABLE: interact_state = Interact_State.SLOTTED
	elif interact_state != Interact_State.SELECTED: interact_state = Interact_State.IN_INVENTORY


#We are in an area... is it a grid block? Is it full?
func _on_slots_area_entered(area):
	if interact_state == Interact_State.IN_WORLD: return
	if !area.is_in_group("GridBlock"): return
	if area.full: return
	
	#No, we could slot here.
	overlapping_areas.append(area)
	find_slotted_center()

#We are leaving an area. If we were slotted or considering being here, we don't want to be anymore
func _on_slots_area_exited(area):
	if interact_state == Interact_State.IN_WORLD: return
	if !area.is_in_group("GridBlock"): return
	
	#If it's not full, then we were considering entering it
	if !area.full:
		overlapping_areas.erase(area)
	
	#Even though it was not full, it might have been the slot we just left
	elif area.contains_ref == self:
		area.remove_item()
		overlapping_areas.erase(area)

	#Always forget the topleft value?
	center = Vector2.ZERO
	find_slotted_center()



func _unhandled_input(event):
	
	#Not necessary when in world
	if interact_state == Interact_State.IN_WORLD: return
	
	#We only care about mouse inputs
	if !event is InputEventMouseButton: return 
	
	#If we're not selectable or selected
	if interact_state != Interact_State.SELECTABLE and interact_state != Interact_State.SELECTED \
	and interact_state != Interact_State.SLOTTED_SELECTABLE: return
	
	if event.button_index == MOUSE_BUTTON_LEFT:
		
		#If it's a press of the click
		if event.pressed: start_drag()
		
		#Else, if it's a release and there are not enough free slots underneath
		elif !are_all_slots_free(): interact_state = Interact_State.SELECTABLE
		
		#Otherwise if it's a release and the slots are free
		else: slot()

	#If we get a right click and item selected, rotate
	elif interact_state == Interact_State.SELECTED and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		rotation_degrees += 90

func slot():
	
	#Give all the areas a reference to this object and mark them as full
	for area in overlapping_areas:
		area.accept_item(self)
		
	#It's not selected, or being dragged. 
	#Scale is reset, gravity/collision is removed as it has been slotted
	interact_state = Interact_State.SLOTTED_SELECTABLE
	global_position = center



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
		
		#If we're not yet holding a x value (we were over no slots) or our position is more to the left, store our x
		if center == Vector2.ZERO or a.global_position.x +  (temp_width / 2) <= center.x:
			center.x = a.global_position.x +  (temp_width / 2) + (3 * temp_width / SINGLE_BLOCK_SIZE)
		
		#If we're not yet holding a y value (we were in over slots) or our position is more upwards, store our y
			if center.y != 0 and a.global_position.y + (temp_height / 2) > center.y: continue
			center.y = a.global_position.y + (temp_height / 2) + (3 * temp_height / SINGLE_BLOCK_SIZE)
		
		#If we weren't holding 0 and we're not more left, we might need to be more upwards
		elif a.global_position.y > center.y: continue
		center.y = a.global_position.y + (temp_height / 2) + (3 * temp_height / SINGLE_BLOCK_SIZE)
