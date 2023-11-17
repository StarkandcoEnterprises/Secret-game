extends StaticBody2D

class_name equipment

@onready var hannah = get_tree().get_nodes_in_group("Hannah")[0]
@onready var map  = get_tree().get_nodes_in_group("Map")[0]

###Debugging cells###
	#for c in map.get_used_cells(layer):
	#	var debug = c
	#	pass

func use(direction, delta):
	
	#TODO put in group "affects ground"? - Hoe, watering can, seeds.. Then pass an atlas pos for new tile
	if name == "Hoe":
		use_hoe(direction, delta)
	if name == "WateringCan":
		use_watering_can()
	if name == "Seed":
		plant_seed()
		queue_free()
		return false
	return true

func use_hoe(direction, delta):
	var tile_pos = get_tile_pos()
	for layer in map.get_layers_count():
		if map.get_layer_name(layer) == "Ground":
			#Grass to tilled ground
			if map.get_cell_atlas_coords(layer,tile_pos) == Vector2i(16, 5):
				map.set_cell(layer, tile_pos, 0, Vector2(-1, -1))
	rotate_tool(direction, delta)

func use_watering_can():
	var tile_pos = get_tile_pos()
	for layer in map.get_layers_count():
		if map.get_layer_name(layer) == "Ground":
			#Ground to wet ground
			if map.get_cell_atlas_coords(layer,tile_pos) == Vector2i(-1,-1):
				map.set_cell(layer, tile_pos, 0, Vector2(0, 0), 1)
			#Dry seed to wet seed
			elif map.get_cell_atlas_coords(layer,tile_pos) == Vector2i(16, 8):
				map.set_cell(layer, tile_pos, 0, Vector2(16, 8), 1)

func plant_seed():
	var tile_pos = get_tile_pos()
	for layer in map.get_layers_count():
		if map.get_layer_name(layer) == "Ground":
			#Ground to dry seed
			if map.get_cell_atlas_coords(layer,tile_pos) == Vector2i(-1,-1):
				map.set_cell(layer, tile_pos, 0, Vector2(16, 8))
			#Wet ground to wet seed
			elif map.get_cell_atlas_coords(layer,tile_pos) == Vector2i(0,0) and map.get_cell_alternative_tile(layer,tile_pos) == 1:
				map.set_cell(layer, tile_pos, 0, Vector2(16, 8), 1)

func rotate_tool(direction, delta):
	if direction == "left":
		rotation_degrees = lerp(rotation_degrees + 60, rotation_degrees, 5 * delta)
		if rotation_degrees >= 150:
			rotation_degrees = 0
	else:
		rotation_degrees = lerp(rotation_degrees + 90, rotation_degrees, 5 * delta)
		#TODO FIGURE OUT ROTATION FOR THIS NONSENSE
		if rotation_degrees <= 150:
			rotation_degrees = 0

func get_tile_pos() -> Vector2:
	var tile_pos = Vector2.ZERO
	tile_pos.x = hannah.global_position.x - (int(hannah.global_position.x) % 64)
	tile_pos.y = hannah.global_position.y - (int(hannah.global_position.y) % 64)
	tile_pos = Vector2(int(tile_pos.x) / 64, int(tile_pos.y) / 64)
	return tile_pos
