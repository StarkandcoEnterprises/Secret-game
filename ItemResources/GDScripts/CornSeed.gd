extends BaseEquipment

class_name CornSeed

@onready var map: TileMap  = get_tree().get_nodes_in_group("Map")[0]
@onready var seed_manager: Node2D = get_tree().get_nodes_in_group("SeedsParent")[0]
@export var seed_scene: PackedScene

func use():
	var tile_pos = map.local_to_map(global_position)
	for seed in seed_manager.get_children():
		if seed.position == map.map_to_local(tile_pos): return
	for layer in map.get_layers_count():
		if map.get_layer_name(layer) != "Ground": continue
		if map.get_cell_atlas_coords(layer,tile_pos) != Vector2i(0, 0): continue
		
		var new_seed = seed_scene.instantiate()
		new_seed.position = map.map_to_local(tile_pos)
		get_tree().get_nodes_in_group("SeedsParent")[0].add_child(new_seed)
