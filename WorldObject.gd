extends StaticBody2D

class_name WorldObject

@onready var UI = $"../../../../../UI/DialogueUI"
@onready var label = $"../../../../../UI/DialogueUI/DialoguePanel/Text"
@onready var options = $"../../../../../UI/DialogueUI/DialoguePanel/Options"
@onready var main = $"../../../../.."

func interact():
	if name == "Bed":
		sleep_prompt()
	if name == "Crate":
		crate_interaction()

func crate_interaction():
	pass

func end_interaction():
	$"../Hannah".interacting = false

func sleep_prompt():
	toggle_UI_visibility()
	toggle_option_visibility()
	update_text("Would you like to go to sleep?")

func _on_no_pressed():
	if name == "Bed":
		toggle_UI_visibility()
		toggle_option_visibility()
	end_interaction()

func _on_yes_pressed():
	if name == "Bed":
		main._on_daytime_timeout()
		toggle_UI_visibility()
		toggle_option_visibility()
	end_interaction()

func update_text(newText: String):
	label.text = newText

func toggle_UI_visibility():
	UI.visible = !UI.visible

func toggle_option_visibility():
	options.visible = !options.visible
