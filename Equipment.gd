extends StaticBody2D

class_name equipment

@onready var hannah = get_tree().get_nodes_in_group("Hannah")[0]
@onready var map  = get_tree().get_nodes_in_group("Map")[0]

func use(direction, delta):
	var tile_pos = Vector2.ZERO
	tile_pos.x = hannah.global_position.x - (int(hannah.global_position.x) % 64)
	tile_pos.y = hannah.global_position.y - (int(hannah.global_position.y) % 64)
	tile_pos = Vector2(int(tile_pos.x)/64,int(tile_pos.y)/64)
	for layer in map.get_layers_count():
		if map.get_layer_name(layer) == "Ground":
			for c in map.get_used_cells(layer):
				var debug = c
				pass
			map.erase_cell(layer, tile_pos)
	map.erase_cell(2,hannah.global_position)
	if direction == "left":
		rotation_degrees = lerp(rotation_degrees + 60, rotation_degrees, 5 * delta)
		if rotation_degrees >= 150:
			rotation_degrees = 0
	else:
		rotation_degrees = lerp(rotation_degrees + 90, rotation_degrees, 5 * delta)
		#TODO FIGURE OUT ROTATION FOR THIS NONSENSE
		if rotation_degrees <= 150:
			rotation_degrees = 0
