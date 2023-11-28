extends AbsWeaponArmour

func added_to_inventory():
	super()
	rotation_degrees = 90
	%Slots.rotation_degrees = 0
	%WorldAndInventory.rotation_degrees = -90
