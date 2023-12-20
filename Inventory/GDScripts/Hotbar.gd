extends HBoxContainer

class_name Hotbar
##Hotbar to hold equipped items for selection by the player
##
##Just initialises itself dynamically

##[EquippedBarSlot] for dynamic initialisation
@export var equipped_bar_slot: PackedScene

##Creates slots with names of 1-9
func _ready():
	for i in range(1, 10):
		var new_slot = equipped_bar_slot.instantiate()
		new_slot.name = new_slot.name + str(i)
		add_child(new_slot) 
