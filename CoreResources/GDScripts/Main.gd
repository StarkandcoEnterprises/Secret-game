extends Node2D

var dayover_UI 

const DAYTIME_VALUE = 500

func _ready():
	await get_tree().process_frame
	dayover_UI = get_node("/root/Main/UI/DayOverUI")
	dayover_UI.next_day_UI_finished.connect(next_day)
	%Daytime.wait_time = DAYTIME_VALUE

#Pauses day time, makes inventory visible, hides inventory/bar, disables hannah, tween on background
func _on_daytime_timeout():
	
	dayover_UI.day_timeout()
	
	%Hannah.inventory.visible = false
	
	%Hannah.process_mode = Node.PROCESS_MODE_DISABLED


func next_day():
	
	reset_watering_and_grow()
	
	%Hannah.process_mode = Node.PROCESS_MODE_INHERIT
	%Hannah.inventory.visible = true
	%Daytime.wait_time = DAYTIME_VALUE
	%Daytime.start()

func reset_watering_and_grow():
	if %Plants.get_child_count() == 0: return
	for plant: BasePlant in %Plants.get_children():
		if !is_wet_tile(%TileMap.local_to_map(plant)): continue
		plant.grow()

###hide it awayyyyyy
func is_wet_tile(cell) -> bool:
	return %TileMap.get_cell_atlas_coords(0,%TileMap.local_to_map(cell)) == Vector2i(0,0) \
	and %TileMap.get_cell_alternative_tile(0, %TileMap.local_to_map(cell)) == 1
