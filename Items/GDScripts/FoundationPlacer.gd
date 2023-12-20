extends BaseEquipment

class_name FoundationPlacer

@onready var map: TileMap  = get_tree().get_first_node_in_group("Map")
@export var foundation_scene: PackedScene

func use():
	var tile_pos = map.local_to_map(hannah.get_node("%UseArea").global_position)
	super()
	var new_foundation = foundation_scene.instantiate()
	new_foundation.position = map.map_to_local(tile_pos) + Vector2(-32, -32)
	get_tree().get_first_node_in_group("WorldPlacements").add_child(new_foundation)
