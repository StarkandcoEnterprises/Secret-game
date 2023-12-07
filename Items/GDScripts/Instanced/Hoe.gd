extends BaseEquipment

class_name Hoe

@onready var map: TileMap  = get_tree().get_first_node_in_group("Map") 

func use():
	super()
	if !map or equipment_properties.durability <= 0: return
	var tile_pos = map.local_to_map(global_position)
	if map.get_cell_atlas_coords(0,tile_pos) != Vector2i(16, 5): return
	map.set_cell(0, tile_pos, 0, Vector2(0, 0))
