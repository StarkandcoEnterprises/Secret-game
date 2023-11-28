extends BaseItem

func added_to_inventory():
	super()
	rotation_degrees = 90
	%Slots.rotation_degrees = 0
	%Sprite2D.rotation_degrees = -90
