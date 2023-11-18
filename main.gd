extends Node2D

var seed_dict = {}

@onready var hannah = $Map/Objects/Hannah

func _on_daytime_timeout():
	$Daytime.paused = true
	
	$UI/DayOverUI.visible = true
	
	hannah.inventory.visible = false
	
	if hannah.inventory.check_menu_visibility_for_selected():
		hannah.inventory.toggle_context_menu_for_selected()
	
	hannah.process_mode = 4
	
	var tween = get_tree().create_tween()
	tween.tween_property($UI/DayOverUI/ColorRect, "modulate", Color(0,0,0,1), 1)
	tween.play()
	
	var timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.start()
	
	await timer.timeout
	$UI/DayOverUI/NextDay.visible = true

func reset_watering():
	for c in $Map/TileMap.get_used_cells(0):
		if check_is_seed_tile(Vector2i(c.x, c.y)):
			$Map/TileMap.set_cell(0, Vector2i(c.x, c.y), 0, Vector2i(16,8))
		elif check_is_tilled_tile(Vector2i(c.x, c.y)):
			$Map/TileMap.set_cell(0, Vector2i(c.x, c.y), 0, Vector2i(0,0))

func _on_next_day_pressed():
	next_day()
	$UI/DayOverUI/NextDay.visible = false

func next_day():
	reset_watering()
	
	var tween = get_tree().create_tween()
	tween.tween_property($UI/DayOverUI/ColorRect, "modulate", Color(0,0,0,0), 1)
	tween.play()
	
	var timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.start()
	
	await timer.timeout
	
	hannah.process_mode = 0
	$UI/DayOverUI.visible = false
	$Daytime.wait_time = 20
	$Daytime.paused = false
	$Daytime.start()
	
	remove_child(timer)

###hide it awayyyyyy

func check_is_seed_tile(cell) -> bool:
	return $Map/TileMap.get_cell_atlas_coords(0, Vector2i(cell.x, cell.y)) == Vector2i(16,8) and $Map/TileMap.get_cell_alternative_tile(0, Vector2i(cell.x, cell.y)) == 1

func check_is_tilled_tile(cell) -> bool:
	return $Map/TileMap.get_cell_atlas_coords(0,Vector2i(cell.x, cell.y)) == Vector2i(0,0) and $Map/TileMap.get_cell_alternative_tile(0, Vector2i(cell.x, cell.y)) == 1
