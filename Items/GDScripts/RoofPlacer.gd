extends BaseEquipment

class_name RoofPlacer

@export var roof_scene: PackedScene

const TILE_SIZE = Vector2(64, 64)

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
	var foundation: Foundation

	for area in areas:
		if !area is Foundation: continue
		if area.global_position != hannah.map.map_to_local(tile_pos) - TILE_SIZE / 2: continue
		foundation_found = true
		foundation = area
		break
	if !foundation_found: return
	
	if !foundation.has_element_for_each_edge(): return
	
	var roof = roof_scene.instantiate()
	roof.position += Vector2(32, 32)
	for child in foundation.get_children():
		if child is Roof and child.position == roof.position: return 

	super()
	foundation.add_child(roof)
	

func _process(delta):
	super(delta)

	if interact_state != Interact_State.EQUIPPED: return

	var use_area_pos = hannah.get_node("%UseArea").global_position

	var tile_pos = hannah.map.local_to_map(use_area_pos)

	highlight_sprite.global_position = hannah.map.map_to_local(tile_pos)
