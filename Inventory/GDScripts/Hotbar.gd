extends HBoxContainer

class_name Hotbar

@export var equipped_bar_slot: PackedScene

func _ready():
	for i in range(1, 10):
		var new_slot = equipped_bar_slot.instantiate()
		new_slot.name = new_slot.name + str(i)
		add_child(new_slot) 
