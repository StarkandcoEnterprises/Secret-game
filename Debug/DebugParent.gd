extends Node

@export var window_scene: PackedScene


func _process(_delta):
	if Input.is_action_just_pressed("debug"):
		if get_child_count() > 0:
			get_child(0).queue_free()
			await get_tree().process_frame
		get_tree().root.get_viewport().gui_embed_subwindows = !get_tree().root.get_viewport().gui_embed_subwindows
	elif Input.is_action_just_pressed("debug_2"):
		if get_child_count() > 0:
			get_child(0).queue_free()
		var new_window = window_scene.instantiate()
		add_child(new_window)
