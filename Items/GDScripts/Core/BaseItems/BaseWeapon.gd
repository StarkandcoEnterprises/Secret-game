extends BaseEquipment

class_name BaseWeapon

@export var abstract_properties:AbstractPropertiesResource

func use():
	super()
	var bodies = hannah.get_node("%UseArea").get_overlapping_bodies()
	for body in bodies:
		if body is BaseEnemy:
			body.take_damage(abstract_properties.damage)
