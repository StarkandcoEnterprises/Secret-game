extends BaseWeapon

class_name BreakpointHammer

func added_to_inventory():
	super()
	rotation_degrees = 90
	%ItemUsedSlots.rotation_degrees = 0
	%ItemSprite.rotation_degrees = -90
