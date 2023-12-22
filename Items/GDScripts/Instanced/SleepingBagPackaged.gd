extends BaseEquipment

class_name SleepingBagPackaged

# The sleeping bag scene
@export var sleeping_bag_scene: PackedScene

# The size of the sleeping bag in tiles
var bag_size = Vector2(1, 2)
var sprite_altered = false

func use():
	super()

	# Use the position of the use area
	var use_area_pos = hannah.get_node("%UseArea").global_position

	# Get the direction from the player to the use area
	var direction = (use_area_pos - hannah.global_position).normalized()

	var highlight_sprite = hannah.get_node("%HighlightSprite")
	# Calculate the offset from the use area to the center of the sleeping bag
	# The offset is in the direction from Hannah to the use area
	var offset = direction * (highlight_sprite.texture.get_width() * highlight_sprite.scale.x / 2)

	# Convert the position of the use area to map coordinates
	var tile_pos = hannah.map.local_to_map(use_area_pos + offset)

	# Instantiate the sleeping bag
	var sleeping_bag = sleeping_bag_scene.instantiate()
	if !hannah.in_building:
		get_tree().get_first_node_in_group("WorldPlacements").add_child(sleeping_bag)
	else:
		hannah.get_parent().add_child(sleeping_bag)
	sleeping_bag.global_position = hannah.map.map_to_local(tile_pos) + Vector2(32, 32)

func _process(delta):
	super(delta)
	
	var highlight_sprite = hannah.get_node("%HighlightSprite")
		
	if sprite_altered and interact_state != Interact_State.EQUIPPED: 
		highlight_sprite.scale = Vector2(1, 1)
		sprite_altered = false
		return

	if interact_state != Interact_State.EQUIPPED: return
	
	# Update the highlight sprite
	highlight_sprite.scale = bag_size
	sprite_altered = true
	
	# Use the position of the use area
	var use_area_pos = hannah.get_node("%UseArea").global_position

	# Get the direction from the player to the use area
	var direction = (use_area_pos - hannah.global_position).normalized()

	# Calculate the offset from the use area to the center of the sleeping bag
	# The offset is in the direction from Hannah to the use area
	var offset = direction * (highlight_sprite.texture.get_width() * highlight_sprite.scale.x / 2)

	# Convert the position of the use area to map coordinates
	var tile_pos = hannah.map.local_to_map(use_area_pos + offset)

	# Adjust the position of the highlight sprite to face outwards from the use area
	# Convert the position back from map coordinates to local coordinates
	highlight_sprite.global_position = hannah.map.map_to_local(tile_pos) + Vector2(32, 32)
