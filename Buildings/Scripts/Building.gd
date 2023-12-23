extends WorldObjectStatic

class_name Building

var doors = []
var hannah_inside = false
var unique_id_counter = 0

@onready var subviewport = get_node("%SubViewport")
@onready var subviewport_container = get_node("%SubViewportContainer")
@onready var camera = get_node("%Camera2D")

func prepare_inside():
	for child in get_children():
		if !child is Foundation: continue
		assign_building_to_door(child, true)
		await get_tree().process_frame
		var duplicate_child = child.duplicate()
		assign_building_to_door(duplicate_child, false)
		for child_b in duplicate_child.get_children():
			if !child_b is Roof: continue
			child_b.queue_free()
		if duplicate_child.is_connected("child_entered_tree", duplicate_child._on_child_entered_tree):
			duplicate_child.child_entered_tree.disconnect(duplicate_child._on_child_entered_tree)
		subviewport.add_child(duplicate_child)
		for door in doors:
			var debug = door.name
			var duplicate_door = duplicate_child.find_child(door.name, true, false)
			if !duplicate_door: continue
			door.corresponding_door = duplicate_door
			duplicate_door.corresponding_door = door
	await get_tree().process_frame
	call_deferred("adjust_subviewport_size")

func assign_building_to_door(foundation, add_to_doors_list = true):
	for child_b in foundation.get_children():
		if !child_b is HorizontalWall: continue
		for child_c in child_b.get_children():
			if !child_c is Door: continue
			child_c.building = self
			if add_to_doors_list and !doors.has(child_c):
				child_c.name = str(unique_id_counter)
				unique_id_counter += 1
				doors.append(child_c)

func adjust_building_position():
	var min_x = INF
	var min_y = INF
	var max_x = -INF
	var max_y = -INF
	for child in get_children():
		if !child is Foundation: continue
		var child_rect = child.get_node("Sprite2D").get_rect()
		var global_pos = child.get_node("Sprite2D").global_position
		min_x = min(min_x, global_pos.x)
		min_y = min(min_y, global_pos.y)
		max_x = max(max_x, global_pos.x + child_rect.size.x)
		max_y = max(max_y, global_pos.y + child_rect.size.y)
	var width = max_x - min_x
	var height = max_y - min_y
	var center = Vector2(min_x + width / 2, min_y + height / 2)
	self.global_position = Vector2(center - Vector2(width, height) / 2)

func adjust_subviewport_size():
	var min_x = INF
	var min_y = INF
	var max_x = -INF
	var max_y = -INF
	for child in get_node("SubViewportContainer/SubViewport").get_children():
		if !child is Foundation: continue
		var child_rect = child.get_node("Sprite2D").get_rect()
		var global_pos = child.global_position
		min_x = min(min_x, global_pos.x)
		min_y = min(min_y, global_pos.y)
		max_x = max(max_x, global_pos.x + child_rect.size.x)
		max_y = max(max_y, global_pos.y + child_rect.size.y)
	var width = max_x - min_x
	var height = max_y - min_y
	subviewport.size = Vector2(width, height)
	subviewport_container.custom_minimum_size = Vector2(width, height)
	subviewport_container.size = Vector2(width, height)

func enter_building(door: Door):
	hannah_inside = true
	hannah.in_building = true
	camera.make_current()
	hannah.reparent(subviewport)
	hannah.get_node("Camera2D").make_current()
	hannah.global_position = door.corresponding_door.entry_point
	subviewport_container.visible = true

func exit_building(door: Door):
	hannah.reparent(get_tree().get_first_node_in_group("WorldContainer"))
	hannah_inside = false
	hannah.in_building = false
	%SubViewportContainer.visible = false
	hannah.global_position = door.corresponding_door.exit_point
	await get_tree().process_frame
	hannah.get_node("Camera2D").make_current()

func add_door(door):
	doors.append(door)
	door.building = self

func remove_door(door):
	if doors.size() > 1:
		doors.erase(door)
		door.building = null

#func can_place_component(component):
	#var component_rect = component.get_node("Sprite2D").get_rect()
	#var global_pos = component.get_node("Sprite2D").global_position
	#var min_x = global_pos.x
	#var min_y = global_pos.y
	#var max_x = global_pos.x + component_rect.size.x
	#var max_y = global_pos.y + component_rect.size.y
#
	#if min_x < subviewport.global_position.x or min_y < subviewport.global_position.y or \
		#max_x > subviewport.global_position.x + subviewport.size.x or \
		#max_y > subviewport.global_position.y + subviewport.size.y:
		#return false
	#return true
