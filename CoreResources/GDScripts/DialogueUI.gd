extends Control

class_name DialogueUI

func update_text(newText: String):
	%Label.text = newText

func toggle_option_visibility():
	%Options.visible = !%Options.visible

func toggle_UI_visibility():
	visible = !visible
