extends StaticBody2D

class_name equipment

@onready var hannah = get_tree().get_nodes_in_group("Hannah")[0]
@onready var map  = get_tree().get_nodes_in_group("Map")[0]

@export var seed_scene: PackedScene

var uses_multi_slots = false

func use(direction, delta):
	var item_kept = true
	#TODO put in group "affects ground"? - Hoe, watering can, seeds.. Then pass an atlas pos for new tile
	if name == "Hoe":
		use_hoe(direction, delta)
	if name == "WateringCan":
		use_watering_can()
	if name == "CornSeed":
		item_kept = plant_seed()
		if !item_kept: queue_free()
	return item_kept

func use_hoe(facingLeft, delta):
	var tile_pos = get_tile_pos()
	for layer in map.get_layers_count():
		if map.get_layer_name(layer) == "Ground":
			#Grass to tilled ground
			if map.get_cell_atlas_coords(layer,tile_pos) == Vector2i(16, 5):
				map.set_cell(layer, tile_pos, 0, Vector2(0, 0))
	rotate_tool(facingLeft, delta)

func use_watering_can():
	var tile_pos = get_tile_pos()
	for layer in map.get_layers_count():
		if map.get_layer_name(layer) == "Ground":
			#Ground to wet ground
			if map.get_cell_atlas_coords(layer,tile_pos) == Vector2i(0,0):
				map.set_cell(layer, tile_pos, 0, Vector2(0, 0), 1)

func plant_seed() -> bool:
	var seed_kept = true
	var tile_pos = get_tile_pos()
	for layer in map.get_layers_count():
		if map.get_cell_atlas_coords(layer,tile_pos) == Vector2i(0,0):
			var new_seed = seed_scene.instantiate()
			new_seed.position = (tile_pos * 64) + Vector2(32,32)
			get_tree().get_nodes_in_group("SeedsParent")[0].add_child(new_seed)
			seed_kept = false
	return seed_kept

func rotate_tool(facingLeft, delta):
	if facingLeft:
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


