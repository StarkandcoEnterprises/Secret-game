extends Node2D

class_name Main

## Main class from which all objects are loaded
##
## Manages some day time elements but is the container for all non-UI game objects

## [DayOverUI] - Holds the UI for the end of the day
var dayover_UI: DayoverUI

## [DialogueManager] - Holds the UI for the end of the day
var dialogue_UI: DialogueManager

## Holds the length of the day in seconds
const DAYTIME_VALUE = 50

## Sets up a Daytime timer and gets / connects the Dialogue UI,  Dayover UI / button
func _ready():
	await get_tree().process_frame
	dialogue_UI = get_tree().get_first_node_in_group("DialogueUI")
	dayover_UI = get_tree().get_first_node_in_group("DayOverUI")
	dayover_UI.next_day_UI_finished.connect(next_day)
	
	%Daytime.stop()
	%Daytime.wait_time = DAYTIME_VALUE
	%Daytime.start()
	
## Hides [InventoryUI], disables [Hannah], calls [method DayoverUI.day_timeout] and [method Main.reset_watering_and_grow]
func _on_daytime_timeout():
	if dialogue_UI.calling_object:
		await dialogue_UI._on_option_selected("end_dialogue")
		
	dayover_UI.day_timeout()

	%Hannah.inventory.visible = false
	if !%Hannah.inventory.get_node("%HotbarUI").visible:
		%Hannah.inventory.invert_inventory_and_bar()
	if %Hannah.is_processing_unhandled_input():
		%Hannah.toggle_processing()
	
	var timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.start()
	
	await timer.timeout
	remove_child(timer)
	
	reset_watering_and_grow()
	%Hannah.sleep()

## Re-enables [Hannah]'s processing. Restarts Daytime Timer
func next_day():
	
	%Hannah.inventory.visible = true
	if !%Hannah.is_processing_unhandled_input():
		%Hannah.toggle_processing() 
	
	%Daytime.wait_time = DAYTIME_VALUE
	%Daytime.start()

## Loops through all Plants in the scene and makes them grow if necessary. Also makes wet ground dry.
func reset_watering_and_grow():
	
	if %Plants.get_child_count() == 0: return
	
	for plant in %Plants.get_children():
		if !is_wet_tile(plant.global_position): continue
		plant.grow()
	
	for cell_pos in %TileMap.get_used_cells(0):
		if !is_wet_tile(cell_pos): continue
		%TileMap.set_cell(0, cell_pos, 0, Vector2(0, 0), 0)

##Checks if a tile is wet based on it's position in the gameworld
func is_wet_tile(local_position) -> bool:
	
	return %TileMap.get_cell_atlas_coords(0, local_position) == Vector2i(0,0) \
	and %TileMap.get_cell_alternative_tile(0, local_position) == 1
