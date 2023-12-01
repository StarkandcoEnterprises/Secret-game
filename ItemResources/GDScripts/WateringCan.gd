extends BaseEquipment

class_name WateringCan

@onready var map: TileMap  = get_tree().get_nodes_in_group("Map")[0]

func use():
	super()
	if !map or equipment_properties.durability <= 0: return
	var tile_pos = map.local_to_map(global_position)
	for layer in map.get_layers_count():
		if map.get_layer_name(layer) != "Ground": continue
		if map.get_cell_atlas_coords(layer,tile_pos) != Vector2i(0, 0): continue
		map.set_cell(layer, tile_pos, 0, Vector2(0, 0), 1)
