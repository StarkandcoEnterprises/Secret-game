extends Button

func _ready():
	material.set_shader_parameter("top_left", PanelColourManager.menu_colours["top_left"])
	material.set_shader_parameter("top_right", PanelColourManager.menu_colours["top_right"])
	material.set_shader_parameter("bottom_left", PanelColourManager.menu_colours["bottom_left"])
	material.set_shader_parameter("bottom_right", PanelColourManager.menu_colours["bottom_right"])
	material.set_shader_parameter("border_hori_threshold", 0.1)
	material.set_shader_parameter("border_vert_threshold", 0.1)
