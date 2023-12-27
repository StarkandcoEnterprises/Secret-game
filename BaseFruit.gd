extends BaseItem

class_name BaseFruit

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_loose = false

func _physics_process(delta):
	if !is_loose: return
	if position.y <= 64:
		velocity.y += gravity * delta
	else:
		velocity = Vector2.ZERO
		is_loose = false
	move_and_slide()
