extends BaseEquipment

class_name TentBag

# The tent, peg, and mallet scenes
@export var tent_scene: PackedScene
@export var peg_scene: PackedScene
@export var mallet_scene: PackedScene

# The size of the tent in tiles
var tent_size = Vector2(4, 4)
var sprite_altered = false

func use():
	super()

	# Use the position of the use area
	var use_area_pos = hannah.get_node("%UseArea").global_position

	# Get the direction from the player to the use area
	var direction = (use_area_pos - hannah.global_position).normalized()

	var highlight_sprite = hannah.get_node("%HighlightSprite")
	# Calculate the offset from the use area to the center of the tent
	# The offset is in the direction from Hannah to the use area
	var offset = direction * (highlight_sprite.texture.get_width() * highlight_sprite.scale.x / 2)

	# Convert the position of the use area to map coordinates
	var tile_pos = hannah.map.local_to_map(use_area_pos + offset)

	# Instantiate the tent
	var tent: Tent = tent_scene.instantiate()
	get_tree().get_first_node_in_group("WorldPlacements").add_child(tent)
	tent.global_position = hannah.map.map_to_local(tile_pos) + Vector2(32, 32)

	## Instantiate the pegs
	#for i in range(4):
		#var peg = peg_scene.instantiate()
		#get_tree().get_first_node_in_group("ObjectHolder").add_child(peg)
		#hannah.inventory.first_add_item(peg)
#
	## Instantiate the mallet
	#var mallet = mallet_scene.instantiate()
	#get_tree().get_first_node_in_group("ObjectHolder").add_child(mallet)
	#hannah.inventory.first_add_item(mallet)

func _process(delta):
	super(delta)
	
	var highlight_sprite = hannah.get_node("%HighlightSprite")
		
	if sprite_altered and interact_state != Interact_State.EQUIPPED: 
		highlight_sprite.scale = Vector2(1, 1)
		sprite_altered = false
		return

	if interact_state != Interact_State.EQUIPPED: return
	
	# Update the highlight sprite
	highlight_sprite.scale = tent_size
	sprite_altered = true
	
	# Use the position of the use area
	var use_area_pos = hannah.get_node("%UseArea").global_position

	# Get the direction from the player to the use area
	var direction = (use_area_pos - hannah.global_position).normalized()

	# Calculate the offset from the use area to the center of the tent
	# The offset is in the direction from Hannah to the use area
	var offset = direction * (highlight_sprite.texture.get_width() * highlight_sprite.scale.x / 2)

	# Convert the position of the use area to map coordinates
	var tile_pos = hannah.map.local_to_map(use_area_pos + offset)

	# Adjust the position of the highlight sprite to face outwards from the use area
	# Convert the position back from map coordinates to local coordinates
	highlight_sprite.global_position = hannah.map.map_to_local(tile_pos) + Vector2(32, 32)
