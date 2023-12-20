extends WorldObjectArea

class_name Foundation 

var neighbours = []

func _ready():
	await get_tree().process_frame
	retrieve_neighbours()
	await get_tree().process_frame
	if check_building_completion():
		#Create new BaseBuilding
		pass

func retrieve_neighbours():
	for area in get_overlapping_areas():
		if area is Foundation:
			neighbours.append(area)

func check_building_completion(checked_foundations = {}) -> bool:
	if self in checked_foundations:
		return true
	if !has_wall_for_each_edge(): 
		return false
	checked_foundations[self] = true
	for area in neighbours:
		if area in checked_foundations:
			continue
		checked_foundations[area] = true
		if !area.check_building_completion(checked_foundations): 
			return false
	return true

func has_wall_for_each_edge() -> bool:
	var raycast = get_node("RayCast2D")

	var edge_covered = [false, false, false, false]  

	for i in range(4):
		raycast.rotation = i * 90
		raycast.force_raycast_update()
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if !(collider is Foundation or collider is HorizontalWall or collider is VerticalWall): continue
			edge_covered[i] = true
	return edge_covered.find(false) == -1

