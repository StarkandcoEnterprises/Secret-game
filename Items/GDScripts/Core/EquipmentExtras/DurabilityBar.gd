extends ProgressBar

class_name DurabilityBar

var parent

func _ready():
	parent = get_parent()
	max_value = parent.equipment_properties.durability
	value = parent.equipment_properties.durability

func _process(_delta):
	if parent.interact_state != parent.Interact_State.SLOTTED: return
	value = parent.equipment_properties.durability
