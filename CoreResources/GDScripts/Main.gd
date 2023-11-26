extends Node2D

var seed_dict = {}

@onready var hannah = get_tree().get_first_node_in_group("Hannah")
@onready var tile_map = get_tree().get_first_node_in_group("Map")
@onready var seeds = get_tree().get_first_node_in_group("SeedsParent")
var dayover_UI 
var dayover_background
var dayover_button

func _ready():
	await get_tree().process_frame
	dayover_UI = get_node("/root/Main/UI/DayOverUI")
	dayover_background = get_node("/root/Main/UI/DayOverUI/ColorRect")
	dayover_button = get_node("/root/Main/UI/DayOverUI/NextDay")
	get_node("/root/Main/UI/DayOverUI/NextDay").pressed.connect(_on_next_day_pressed)


func _on_daytime_timeout():
	%Daytime.paused = true
	
	dayover_UI.visible = true
	
	hannah.inventory.visible = false
	
	hannah.process_mode = 4
	
	var tween = get_tree().create_tween()
	tween.tween_property(dayover_background, "modulate", Color(0,0,0,1), 1)
	tween.play()
	
	var timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.start()
	
	await timer.timeout
	dayover_button.visible = true
	remove_child(timer)

func reset_watering_and_grow():
	for c in tile_map.get_used_cells(0):
		if check_is_wet_tile(Vector2i(c.x, c.y)):
			if get_seed_on_tile(Vector2i(c.x, c.y)):
				get_seed_on_tile(Vector2i(c.x, c.y)).grow()
			tile_map.set_cell(0, c, 0, Vector2(0, 0), 0)

func _on_next_day_pressed():
	next_day()
	dayover_button.visible = false

func next_day():
	reset_watering_and_grow()
	
	var tween = get_tree().create_tween()
	tween.tween_property(dayover_background, "modulate", Color(0,0,0,0), 1)
	tween.play()
	
	var timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.start()
	
	await timer.timeout
	
	hannah.process_mode = 0
	dayover_UI.visible = false
	%Daytime.wait_time = 500
	%Daytime.paused = false
	%Daytime.start()
	
	remove_child(timer)


func get_seed_on_tile(cell) -> Object:
	if seeds.get_child_count() > 0:
		for s in seeds.get_children():
			if s.position == Vector2(cell * 64) + Vector2(32,32):
				return s
	return null



###hide it awayyyyyy
func check_is_wet_tile(cell) -> bool:
	return tile_map.get_cell_atlas_coords(0,Vector2i(cell.x, cell.y)) == Vector2i(0,0) and tile_map.get_cell_alternative_tile(0, Vector2i(cell.x, cell.y)) == 1


