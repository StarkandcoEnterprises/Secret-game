extends WorldObjectArea

class_name Foundation 

var neighbours = []
var is_complete = false
@export var building_scene: PackedScene

func _ready():
	await super()
	get_node("RayCast2D").add_exception(hannah.get_node("%UseArea"))
	get_node("RayCast2D").add_exception(hannah)
	await get_tree().physics_frame

func retrieve_neighbours():
	for area in get_overlapping_areas():
		if area is Foundation:
			neighbours.append(area)

func check_building_completion(checked_foundations = {}, door_found = {0: false}, roof_found = {0: false}) -> bool:
	if is_complete:return true
	neighbours = []
	retrieve_neighbours() 

	if self in checked_foundations:
		return checked_foundations[self]
	if !has_element_for_each_edge() or !has_roof(): 
		checked_foundations[self] = false
		return false

	checked_foundations[self] = true
	if door_found[0] or check_doors_for_walls():
		door_found[0] = true
	if roof_found[0] or has_roof():
		roof_found[0] = true
	for area in neighbours:
		if area in checked_foundations:
			if checked_foundations[area] == false:
				checked_foundations[self] = false
				return false
			continue
		if !area.check_building_completion(checked_foundations, door_found, roof_found): 
			checked_foundations[self] = false
			return false
	if !door_found[0] or !roof_found[0]:
		checked_foundations[self] = false
		return false
	return true

func has_element_for_each_edge() -> bool:
	var raycast = get_node("RayCast2D")

	var edge_covered = [false, false, false, false]  

	for i in range(4):
		raycast.rotation_degrees = i * 90
		raycast.force_raycast_update()
		if !raycast.is_colliding(): continue
		var collider = raycast.get_collider()
		if !(collider is Foundation or collider is HorizontalWall or collider is VerticalWall): continue
		edge_covered[i] = true
	return edge_covered.find(false) == -1



func _on_child_entered_tree(node):
	if is_complete: return
	if !(node is Roof): return
	await node.ready
	await get_tree().physics_frame
	instance_new_building()

func instance_new_building():
	if !check_building_completion(): return
	var building = building_scene.instantiate()
	var top_left_position = get_top_left_position()
	building.global_position = top_left_position
	get_tree().get_first_node_in_group("Village").add_child(building)
	await get_tree().process_frame
	reparent_connected_components(building)
	building.prepare_inside()

func get_top_left_position(visited = {}) -> Vector2:
	if self in visited:
		return Vector2(INF, INF)
	visited[self] = true
	var min_x = self.global_position.x
	var min_y = self.global_position.y
	for neighbour in neighbours:
		var neighbour_pos = neighbour.get_top_left_position(visited)
		min_x = min(min_x, neighbour_pos.x)
		min_y = min(min_y, neighbour_pos.y)
	return Vector2(min_x, min_y)

func reparent_connected_components(building):
	if self.get_parent() == building:
		return
	reparent(building)
	for neighbour in neighbours:
		if neighbour.get_parent() != building:
			neighbour.reparent_connected_components(building)

func has_roof() -> bool:
	for child in get_children():
		if child is Roof:
			return true
	return false

func check_doors_for_walls() -> bool:
	for child in get_children():
		if child is HorizontalWall:
			if has_door(child):
				return true
	return false

func has_door(wall) -> bool:
	for child in wall.get_children():
		if child is Door:
			return true
	return false
