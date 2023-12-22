extends WorldObjectArea

class_name Foundation 

var neighbours = []
@export var building_scene: PackedScene

func _ready():
	await super()
	get_node("RayCast2D").add_exception(hannah.get_node("%UseArea"))
	get_node("RayCast2D").add_exception(hannah)
	await get_tree().physics_frame
	retrieve_neighbours()
	await get_tree().physics_frame
	if check_building_completion():
		#Create new BaseBuilding
		pass

#No need for interaction
func interact():
	pass

func retrieve_neighbours():
	for area in get_overlapping_areas():
		if area is Foundation:
			neighbours.append(area)

func check_building_completion(checked_foundations = {}, door_found = {0: false}, roof_found = {0: false}) -> bool:
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
	if !(node is HorizontalWall or node is VerticalWall or node is Roof): return
	await node.ready
	await get_tree().physics_frame
	node.child_entered_tree.connect(on_wall_child_added)
	if check_building_completion():
		var building = building_scene.instantiate()
		get_parent().add_child(building)
		reparent_foundations(building)

func on_wall_child_added(node):
	if (!node is Door or !node is Roof): return
	await node.ready
	await get_tree().physics_frame
	if check_building_completion():
		var building = building_scene.instantiate()
		get_parent().add_child(building)
		reparent_foundations(building)

func reparent_foundations(building):
	if self.get_parent() == building:
		return
	for child in get_children():
		if child is Roof:
			child.reparent(building)
	self.reparent(building)
	for neighbour in neighbours:
		if neighbour.get_parent() != building:
			neighbour.reparent_foundations(building)


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
