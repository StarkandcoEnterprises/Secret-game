extends Node2D

var seed_dict = {}

func _on_daytime_timeout():
	var tween = get_tree().create_tween()
	$DayOver.visible = true
	tween.tween_property($DayOver/ColorRect, "modulate", Color(0,0,0,1), 1)
	#TODO day over menu
	var timer = Timer.new()
	timer.timeout.connect(next_day)
	add_child(timer)
	timer.start()

func reset_watering():
	for c in $Map/TileMap.get_used_cells(0):
		if $Map/TileMap.get_cell_atlas_coords(0,Vector2i(c.x, c.y)) == Vector2i(16,8) and $Map/TileMap.get_cell_alternative_tile(0, Vector2i(c.x, c.y)) == 1:
			$Map/TileMap.set_cell(0, Vector2i(c.x, c.y), 0, Vector2i(16,8))

func next_day():
	reset_watering()
	$DayOver.visible = false
	var tween = get_tree().create_tween()
	tween.tween_property($DayOver/ColorRect, "modulate", Color(0,0,0,0), 1)
	$Daytime.start()
