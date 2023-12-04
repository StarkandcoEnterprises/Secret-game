extends GridContainer

var grid_size = 24

@export var grid_slot: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in grid_size:
		var new_block = grid_slot.instantiate()
		add_child(new_block)
	for j in range(grid_size, 132):
		var new_block = grid_slot.instantiate()
		new_block.get_child(0).get_child(0).disabled = true
		add_child(new_block)
