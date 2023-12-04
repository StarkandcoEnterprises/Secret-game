extends Sprite2D

@export var plant_sprites: Array[Texture2D]

var current_sprite_index = 0

func next_sprite():
	current_sprite_index += 1
	if current_sprite_index >= plant_sprites.size(): return
	texture = plant_sprites[current_sprite_index]


#func _input(event):
	#if event.is_action_pressed("debug"):
		#next_sprite()
