extends BaseWeapon

func added_to_inventory():
	super()
	rotation_degrees = 90
	%ItemUsedSlots.rotation_degrees = 0
	%WorldAndInventory.rotation_degrees = -90
