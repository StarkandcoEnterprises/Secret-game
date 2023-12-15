extends Node

@export var window_scene: PackedScene


func _process(_delta):
	if Input.is_action_just_pressed("debug"):
		get_tree().root.get_viewport().gui_embed_subwindows = !get_tree().root.get_viewport().gui_embed_subwindows
	elif Input.is_action_just_pressed("debug_2"):
		if get_child_count() > 0:
			get_child(0).hide()
		var new_window = window_scene.instantiate()
		add_child(new_window)
