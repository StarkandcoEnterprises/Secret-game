extends BaseEquipment

class_name WallPlacer

@export var v_wall_scene: PackedScene
@export var h_wall_scene: PackedScene

var wall_size = Vector2(0.15625, 1) 
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
	
	var foundation_found = false
	var use_area_pos = hannah.get_node("%UseArea").global_position
	var tile_pos = hannah.map.local_to_map(use_area_pos)
	var foundation
	
	for area in areas:
		if !area is Foundation: continue
		if area.global_position + TILE_SIZE / 2 != Vector2(hannah.map.map_to_local(tile_pos)): continue
		foundation_found = true
		foundation = area
		break
	if !foundation_found: return

	var wall = v_wall_scene.instantiate() if int(highlight_sprite.rotation_degrees) % 180 == 0 else h_wall_scene.instantiate()

	if int(highlight_sprite.rotation_degrees) % 180 == 0: 
		if highlight_sprite.rotation_degrees == 0: 
			wall.position = Vector2(-TILE_SIZE.x / 2 + 5, 0) + TILE_SIZE / 2
			wall.get_node("Sprite2D").flip_v = true
		else: 
			wall.position = Vector2(TILE_SIZE.x / 2 - 5, 0) + TILE_SIZE / 2
	else: 
		if highlight_sprite.rotation_degrees == 90:
			wall.position = Vector2(0, -TILE_SIZE.y / 2 + 5) + TILE_SIZE / 2
		else: 
			wall.position = Vector2(0, TILE_SIZE.y / 2 - 5) + TILE_SIZE / 2

	for child in foundation.get_children():
		if child.position == wall.position: return 

	super()
	foundation.add_child(wall)
	wall.force_update_transform()

func _process(delta):
	super(delta)

	if sprite_altered and interact_state != Interact_State.EQUIPPED: 
		highlight_sprite.scale = Vector2(1, 1)
		highlight_sprite.rotation = 0
		sprite_altered = false
		return

	if interact_state != Interact_State.EQUIPPED: return

	if Input.is_action_just_pressed("right_click"):
		cust_rotate()
		
	highlight_sprite.scale = wall_size
	sprite_altered = true

	var use_area_pos = hannah.get_node("%UseArea").global_position

	var tile_pos = hannah.map.local_to_map(use_area_pos)

	if int(highlight_sprite.rotation_degrees) % 180 == 0:
		if highlight_sprite.rotation_degrees == 0:
			highlight_sprite.global_position = hannah.map.map_to_local(tile_pos) + Vector2(-TILE_SIZE.x / 2 + 5, 0)
		else:
			highlight_sprite.global_position = hannah.map.map_to_local(tile_pos) + Vector2(TILE_SIZE.x / 2 - 5, 0)
	else: 
		if highlight_sprite.rotation_degrees == 90: 
			highlight_sprite.global_position = hannah.map.map_to_local(tile_pos) + Vector2(0, -TILE_SIZE.y / 2 + 5)
		else:
			highlight_sprite.global_position = hannah.map.map_to_local(tile_pos) + Vector2(0, TILE_SIZE.y / 2 - 5)

func cust_rotate():
	highlight_sprite.rotation_degrees = int(highlight_sprite.rotation_degrees + 90) % 360
	highlight_sprite.force_update_transform()
