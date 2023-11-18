extends Node2D

var seed_dict = {}


func _on_daytime_timeout():
	$Hannah.inventory.visible = false
	if $Hannah.inventory.check_menu_visibility_for_selected():
		$Hannah.inventory.get_context_menu_for_selected()
	$Hannah.process_mode = 4
	$DayOver.visible = true
	$DayOver/NextDay.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property($DayOver/ColorRect, "modulate", Color(0,0,0,1), 1)
	tween.play()

func reset_watering():
	for c in $Map/TileMap.get_used_cells(0):
		if check_is_seed_tile(Vector2i(c.x, c.y)):
			$Map/TileMap.set_cell(0, Vector2i(c.x, c.y), 0, Vector2i(16,8))
		elif check_is_tilled_tile(Vector2i(c.x, c.y)):
			$Map/TileMap.set_cell(0, Vector2i(c.x, c.y), 0, Vector2i(0,0))

func _on_next_day_pressed():
	next_day()
	$DayOver/NextDay.visible = false

func next_day():
	reset_watering()
	var tween = get_tree().create_tween()
	tween.tween_property($DayOver/ColorRect, "modulate", Color(0,0,0,0), 1)
	tween.play()
	
	var timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.start()
	
	await timer.timeout
	$Hannah.process_mode = 0
	$DayOver.visible = false
	$Daytime.start()
	
	remove_child(timer)

###hide it awayyyyyy

func check_is_seed_tile(cell) -> bool:
	return $Map/TileMap.get_cell_atlas_coords(0, Vector2i(cell.x, cell.y)) == Vector2i(16,8) and $Map/TileMap.get_cell_alternative_tile(0, Vector2i(cell.x, cell.y)) == 1

func check_is_tilled_tile(cell) -> bool:
	return $Map/TileMap.get_cell_atlas_coords(0,Vector2i(cell.x, cell.y)) == Vector2i(0,0) and $Map/TileMap.get_cell_alternative_tile(0, Vector2i(cell.x, cell.y)) == 1
