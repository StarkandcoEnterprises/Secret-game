extends BaseEquipment

class_name CornSeed

@onready var map: TileMap  = get_tree().get_first_node_in_group("Map")
@onready var plants_node: Node2D = get_tree().get_first_node_in_group("PlantsNode")
@export var seed_scene: PackedScene

func use():
	var tile_pos = map.local_to_map(hannah.get_node("%UseArea").global_position)
	if map.get_cell_atlas_coords(0,tile_pos) not in [Vector2i(1, 0), Vector2i(2, 0)]: return
	for plant in plants_node.get_children():
		if map.local_to_map(plant.global_position) == tile_pos: return
	super()
	var new_seed = seed_scene.instantiate()
	new_seed.position = map.map_to_local(tile_pos)
	plants_node.add_child(new_seed)
