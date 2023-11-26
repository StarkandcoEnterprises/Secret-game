extends CharacterBody2D

var selectable = false
var selected = false
var slotted = false

var slots_available = 0
var slots_needed = 2

var to_center = 25

var overlapping_areas = []
var SPEED = 10

@onready var debugOutput = get_tree().get_first_node_in_group("DebugOutput")

var top_left_of_slots = Vector2.ZERO

func _process(delta):
	if selected:
		global_position = get_global_mouse_position()
	elif global_position.y >= 648:
		position.y = 0
		position.x = 0
	elif !slotted:
		velocity += Vector2.DOWN * SPEED
		move_and_slide()

func _on_mouse_entered():
	if not global.is_dragging:
		selectable = true

func _on_mouse_exited():
	if not global.is_dragging:
		selectable = false

#We are in an area... is it a grid block? Is it full?
func _on_slots_area_entered(area):
	if area.get_parent().is_in_group("GridBlock"):
		if !area.get_parent().full:
			
			#No, we could slot here.
			slots_available += 1
			overlapping_areas.append(area)
			
			##A whole bunch of nonsense to try and get the left most slot of all areas entered that needs refactoring
			if top_left_of_slots == Vector2.ZERO or area.get_parent().position.x + 45 <= top_left_of_slots.x:
				top_left_of_slots.x = area.get_parent().position.x + 45 + to_center
				if top_left_of_slots.y == 0 or area.get_parent().position.y + 41 <= top_left_of_slots.y:
					top_left_of_slots.y = area.get_parent().position.y + 41

#We are leaving an area. If we were slotted or considering being here, we don't want to be anymore
func _on_slots_area_exited(area):
	if area.get_parent().is_in_group("GridBlock"):
		
		#If it's not full, then we were considering entering it
		if !area.get_parent().full:
			slots_available -= 1
			overlapping_areas.erase(area)
		
		#Even though it was not full, it might have been the slot we just left
		elif area.get_parent().contains_ref == self:
			area.get_parent().remove_item()
			slots_available -= 1
	
	#If we have no more overlapping areas, we can forget the top left slot value
	if overlapping_areas.size() == 0:
		top_left_of_slots = Vector2.ZERO

func are_all_slots_free():
	return slots_available == slots_needed

func toggle_selected(select):
	if !select:
		selected = false
		global.is_dragging = false
		
	else:
		selected = true
		global.is_dragging = true

func _input(event):
	#Make sure we are hovering over it and not already dragging anything.
	if selectable:
		#IF we get a left click
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			
			#If it's a press of the click and the mouse exists (? stole this I'm sure)
			if event.pressed and get_global_mouse_position:
				
				#We are now dragging it, it is selected, and it's a little bigger!
				toggle_selected(true)
				
				#IF we're still a child of a slot, we shouldn't be
				if overlapping_areas.size() > 0:
					
					#Remove any the areas a reference to this object and mark them as full
					for area in overlapping_areas:
						area.get_parent().remove_item()
					slotted = false
			
			#Else, if it's a release and there are not enough free slots underneath
			elif !event.pressed and !are_all_slots_free():
				
				#It's not selected, or being dragged. 
				#Scale is reset, gravity/collision is reapplied as it may have been previously slotted
				toggle_selected(false)
			
			#Otherwise if it's a release and the slots are free
			elif !event.pressed and are_all_slots_free():
				
				#Give all the areas a reference to this object and mark them as full
				for area in overlapping_areas:
					area.get_parent().accept_item(self)
					
				#It's not selected, or being dragged. 
				#Scale is reset, gravity/collision is removed as it has been slotted
				toggle_selected(false)
				slotted = true
				global_position = top_left_of_slots
				global_position = top_left_of_slots
