extends Resource

class_name EquipmentPropertiesResource

@export var durability: int = 10
@export var max_durability: int = 10
@export var discarded_on_use: bool
@export var highlight_area: bool

func use():
	durability -= 1
	pass

func repair():
	durability = max_durability
