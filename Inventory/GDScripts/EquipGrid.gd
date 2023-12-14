extends GridContainer

var grid_start_size = 16
var grid_curr_size = 16

@export var grid_slot: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in grid_start_size:
		var new_block = grid_slot.instantiate()
		add_child(new_block)

func get_max():
	for i in range(grid_curr_size, 64):
		var new_block = grid_slot.instantiate()
		add_child(new_block)
	grid_curr_size = 64
