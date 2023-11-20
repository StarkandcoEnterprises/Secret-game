extends Node2D

var seed_dict = {}

@onready var hannah = $SubViewportContainer/SubViewport/Hannah
@onready var tileMap = $SubViewportContainer/SubViewport/World/TileMap
@onready var seeds = $SubViewportContainer/SubViewport/World/Objects/Seeds


func _on_daytime_timeout():
	$Daytime.paused = true
	
	$UI/DayOverUI.visible = true
	
	hannah.inventory.visible = false
	
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
	remove_child(timer)

func reset_watering_and_grow():
	for c in tileMap.get_used_cells(0):
		if check_is_wet_tile(Vector2i(c.x, c.y)):
			if get_seed_on_tile(Vector2i(c.x, c.y)):
				get_seed_on_tile(Vector2i(c.x, c.y)).grow()
			tileMap.set_cell(0, c, 0, Vector2(0, 0), 0)

func _on_next_day_pressed():
	next_day()
	$UI/DayOverUI/NextDay.visible = false

func next_day():
	reset_watering_and_grow()
	
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

func get_seed_on_tile(cell) -> Object:
	if seeds.get_child_count() > 0:
		for s in seeds.get_children():
			if s.position == Vector2(cell * 64) + Vector2(32,32):
				return s
	return null

func check_is_wet_tile(cell) -> bool:
	return tileMap.get_cell_atlas_coords(0,Vector2i(cell.x, cell.y)) == Vector2i(0,0) and tileMap.get_cell_alternative_tile(0, Vector2i(cell.x, cell.y)) == 1

