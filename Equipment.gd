extends StaticBody2D

class_name equipment

func use(direction, delta):
	if direction == "left":
		rotation_degrees = lerp(rotation_degrees + 60, rotation_degrees, 5 * delta)
		if rotation_degrees >= 150:
			rotation_degrees = 0
	else:
		rotation_degrees = lerp(rotation_degrees + 90, rotation_degrees, 5 * delta)
		#TODO FIGURE OUT ROTATION FOR THIS NONSENSE
		if rotation_degrees <= 150:
			rotation_degrees = 0
