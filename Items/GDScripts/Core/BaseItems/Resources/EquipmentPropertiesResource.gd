extends Resource

class_name EquipmentPropertiesResource

@export var durability: int = 10
@export var max_durability: int = 10
@export var discarded_on_use: bool

func use():
	durability -= 1

func repair():
	durability = max_durability
