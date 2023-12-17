extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	material.set_shader_parameter("viewport_size", get_viewport_rect().size)
