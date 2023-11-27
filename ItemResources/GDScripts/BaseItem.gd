extends CharacterBody2D

class_name BaseItem

@export var properties:BaseResource = BaseResource.new() 
@export var slot_shape:PackedScene

var in_inventory = false
var selectable = false
var selected = false
var slotted = false

var slots_available = 0
var to_center = 26
const SPEED = 300

var center = Vector2.ZERO

var overlapping_areas = []

var equipped_bar
var equipped = false
var new_sprite

##DEBUG
@onready var debug_output:DebugOutput = get_tree().get_first_node_in_group("DebugOutput")

func _ready():
	var new_shape = slot_shape.instantiate()
	%Slots.add_child(new_shape)
	await get_tree().process_frame
	equipped_bar = get_tree().get_first_node_in_group("EquippedBar")
	new_sprite = $Sprite2D.duplicate()

func _process(delta):
	if in_inventory:
		if selected:
			global_position = get_global_mouse_position()
		elif global_position.y >= 648:
			position.y = 0
			position.x = 0
		elif !slotted:
			velocity += Vector2.DOWN * SPEED * delta
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
			
		#Reset top left
		reset_top_left()
	debug_output.stack_and_text(str("Slots Available:", slots_available, "   overlapping areas ", $Slots.get_overlapping_areas()))


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
			overlapping_areas.erase(area)

	#Always forget the topleft value?
	center = Vector2.ZERO
	#we should recalculate our position
	reset_top_left()
	debug_output.stack_and_text(str("Slots Available:", slots_available, "   overlapping areas ", $Slots.get_overlapping_areas()))

func reset_top_left():
	center = Vector2.ZERO
	##A whole bunch of nonsense to try and get the left most slot of all areas entered that needs refactoring
	if overlapping_areas:
		if $Slots.get_child(0) is CollisionPolygon2D:
			
			for a in overlapping_areas:
				#If we're rotated once or thrice, we need to use our width to add to our x instead of height as in our else
				if int(rotation_degrees) % 180 == 0.0:
					#If we're not yet holding a value (we're in no slots) or our position is more to the left, store that x
					if center == Vector2.ZERO or a.global_position.x +  (%Slots.get_child(0).width / 2) <= center.x:
						center.x = a.global_position.x +  (%Slots.get_child(0).width / 2) + (3 * %Slots.get_child(0).width / 45)
						
					#If we're not yet holding a y value (we were in no slots) or our position is upwards of the last, store that y
						if center.y == 0 or a.global_position.y + (%Slots.get_child(0).height / 2) <= center.y:
							center.y = a.global_position.y + (%Slots.get_child(0).height / 2) + (3 * %Slots.get_child(0).height / 45)
							
					#If we weren't holding 0 and we're not more left, we might need to more upwards
					elif a.global_position.y <= center.y:
						center.y = a.global_position.y + (%Slots.get_child(0).height / 2) + (3 * %Slots.get_child(0).height / 45)
				else:
					#If we're not yet holding a value (we're in no slots) or our position is more to the left, store that x
					if center == Vector2.ZERO or a.global_position.x +  (%Slots.get_child(0).height / 2) <= center.x:
						center.x = a.global_position.x +  (%Slots.get_child(0).height / 2) + (3 * %Slots.get_child(0).height / 45)
						
					#If we're not yet holding a y value (we were in no slots) or our position is upwards of the last, store that y
						if center.y == 0 or a.global_position.y + (%Slots.get_child(0).width / 2) <= center.y:
							center.y = a.global_position.y + (%Slots.get_child(0).width / 2) + (3 * %Slots.get_child(0).width / 45)
							
					#If we weren't holding 0 and we're not more left, we might need to more upwards
					elif a.global_position.y <= center.y:
						center.y = a.global_position.y + (%Slots.get_child(0).width / 2) + (3 * %Slots.get_child(0).width / 45)
		
		else:
			for a in overlapping_areas:
				if int(rotation_degrees) % 180 == 0.0:
						
					#If we're not yet holding a value (we're in no slots) or our position is more to the left, store that x
					if center == Vector2.ZERO or a.global_position.x +  (%Slots.get_child(0).shape.size.x / 2) <= center.x:
						center.x = a.global_position.x +  (%Slots.get_child(0).shape.size.x / 2) + (3 * %Slots.get_child(0).shape.size.x / 45)
						
					#If we're not yet holding a y value (we were in no slots) or our position is upwards of the last, store that y
						if center.y == 0 or a.global_position.y + (%Slots.get_child(0).shape.size.y / 2) <= center.y:
							center.y = a.global_position.y + (%Slots.get_child(0).shape.size.y / 2) + (3 * %Slots.get_child(0).shape.size.y / 45)
							
					#If we weren't holding 0 and we're not more left, we might need to more upwards
					elif a.global_position.y <= center.y:
						center.y = a.global_position.y + (%Slots.get_child(0).shape.size.y / 2) + (3 * %Slots.get_child(0).shape.size.y / 45)
				else:
					#If we're not yet holding a value (we're in no slots) or our position is more to the left, store that x
					if center == Vector2.ZERO or a.global_position.x +  (%Slots.get_child(0).shape.size.y / 2) <= center.x:
						center.x = a.global_position.x +  (%Slots.get_child(0).shape.size.y / 2) + (3 * %Slots.get_child(0).shape.size.y / 45)
						
					#If we're not yet holding a y value (we were in no slots) or our position is upwards of the last, store that y
						if center.y == 0 or a.global_position.y + (%Slots.get_child(0).shape.size.x / 2) <= center.y:
							center.y = a.global_position.y + (%Slots.get_child(0).shape.size.x / 2) + (3 * %Slots.get_child(0).shape.size.x / 45)
							
					#If we weren't holding 0 and we're not more left, we might need to more upwards
					elif a.global_position.y <= center.y:
						center.y = a.global_position.y + (%Slots.get_child(0).shape.size.x / 2) + (3 * %Slots.get_child(0).shape.size.x / 45)
	#Reset if we have no areas
	else:
		center = Vector2.ZERO

func are_all_slots_free():
	return slots_available == properties.item_properties.slots_needed

func toggle_selected(select):
	if !select:
		selected = false
		global.is_dragging = false
		
	else:
		selected = true
		global.is_dragging = true

func added_to_inventory():
	in_inventory = true
	if is_instance_valid(get_child(2)):
		get_child(2).scale = Vector2(1, 1)
		get_child(2).position = Vector2(0, 0)
	
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
					if properties.equipment_properties:
						for slot in equipped_bar.get_children():
							if slot.get_child(0) == new_sprite:
								slot.remove_child(new_sprite)
								return
					
			
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
				global_position = center
				if properties.equipment_properties:
					for slot in equipped_bar.get_children():
						if slot.get_child_count() == 0:
							slot.add_child(new_sprite)
							new_sprite.position = Vector2(32, 28)
							return
		
		#If we get a right click and item selected, rotate
		elif selected and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			rotation_degrees += 90
