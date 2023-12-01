extends Sprite2D

class_name EquipmentBarSprite

var parent

func _ready():
	parent = get_parent()
	$ProgressBar.max_value = parent.equipment_properties.durability
	$ProgressBar.value = parent.equipment_properties.durability

func _process(_delta):
	$ProgressBar.value = parent.equipment_properties.durability
