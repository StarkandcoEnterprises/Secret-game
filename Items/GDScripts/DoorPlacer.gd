extends BaseEquipment

class_name DoorPlacer

@export var door_scene: PackedScene

var door_size = Vector2(1, 0.15625) 
const TILE_SIZE = Vector2(64, 64)
var sprite_altered = false

var highlight_sprite

func _ready():
	super()
	highlight_sprite = hannah.get_node("%HighlightSprite")

func use():
	if hannah.in_building: return

	var areas = hannah.get_node("%UseArea").get_overlapping_areas()
	if areas.size() == 0: return

	var wall_found = false
	var use_area_pos = hannah.get_node("%UseArea").global_position
	var tile_pos = hannah.map.local_to_map(use_area_pos)
	var wall

	for area in areas:
		for child in area.get_children():
			if !child is HorizontalWall: continue
			if child.global_position != hannah.map.map_to_local(tile_pos) + Vector2(0, TILE_SIZE.y / 2 - 5): continue
			wall_found = true
			wall = child
			break
		if wall_found: break
	if !wall_found: return

	var door = door_scene.instantiate()

	for child in wall.get_children():
		if child is Door and child.position == door.position: return 

	super()
	wall.add_child(door)
	door.force_update_transform()

func _process(delta):
	super(delta)

	if sprite_altered and interact_state != Interact_State.EQUIPPED: 
		highlight_sprite.scale = Vector2(1, 1)
		sprite_altered = false
		return

	if interact_state != Interact_State.EQUIPPED: return

	highlight_sprite.scale = door_size
	sprite_altered = true

	var use_area_pos = hannah.get_node("%UseArea").global_position

	var tile_pos = hannah.map.local_to_map(use_area_pos)

	highlight_sprite.global_position = hannah.map.map_to_local(tile_pos) + Vector2(0, TILE_SIZE.y / 2 - 5)
