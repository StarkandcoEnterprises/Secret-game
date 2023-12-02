extends Node2D

var dayover_UI 

const DAYTIME_VALUE = 50

func _ready():
	await get_tree().process_frame
	dayover_UI = get_node("/root/Main/UI/DayOverUI")
	dayover_UI.next_day_UI_finished.connect(next_day)
	%Daytime.stop()
	%Daytime.wait_time = DAYTIME_VALUE
	%Daytime.start()
	
#Pauses day time, makes inventory visible, hides inventory/bar, disables hannah, tween on background
func _on_daytime_timeout():
	
	dayover_UI.day_timeout()
	
	%Hannah.inventory.visible = false
	
	%Hannah.process_mode = Node.PROCESS_MODE_DISABLED
	
	var timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.start()
	
	await timer.timeout
	remove_child(timer)
	
	reset_watering_and_grow()


func next_day():
	
	%Hannah.process_mode = Node.PROCESS_MODE_INHERIT
	%Hannah.inventory.visible = true
	%Daytime.wait_time = DAYTIME_VALUE
	%Daytime.start()

func reset_watering_and_grow():
	if %Plants.get_child_count() == 0: return
	for plant: BasePlant in %Plants.get_children():
		if !is_wet_tile(plant.global_position): continue
		plant.grow()
	for cell_pos in %TileMap.get_used_cells(0):
		if !is_wet_tile(%TileMap.map_to_local(cell_pos)): continue
		%TileMap.set_cell(0, cell_pos, 0, Vector2(0, 0), 0)

###hide it awayyyyyy
func is_wet_tile(local_position) -> bool:
	return %TileMap.get_cell_atlas_coords(0, %TileMap.local_to_map(local_position)) == Vector2i(0,0) \
	and %TileMap.get_cell_alternative_tile(0, %TileMap.local_to_map(local_position)) == 1
