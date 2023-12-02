extends StaticBody2D

class_name WorldObject

@onready var main = get_tree().root.get_child(0)
@onready var hannah = get_tree().get_first_node_in_group("Hannah")
@onready var dialogue_UI = get_tree().get_first_node_in_group("DialogueUI")

func _ready():
	await get_tree().process_frame
	dialogue_UI.get_node("%Yes").pressed.connect(_on_yes_pressed)
	dialogue_UI.get_node("%No").pressed.connect(_on_no_pressed)

func interact():
	if name == "Bed":
		sleep_prompt()
	elif name == "Crate":
		crate_interaction()
	else:
		end_interaction()

func crate_interaction():
	end_interaction()

func end_interaction():
	hannah.interacting = false

func sleep_prompt():
	dialogue_UI.toggle_UI_visibility()
	dialogue_UI.toggle_option_visibility()
	dialogue_UI.update_text("Would you like to go to sleep?")

func _on_no_pressed():
	if name == "Bed":
		dialogue_UI.toggle_UI_visibility()
		dialogue_UI.toggle_option_visibility()
	end_interaction()

func _on_yes_pressed():
	if name == "Bed":
		main._on_daytime_timeout()
		dialogue_UI.toggle_UI_visibility()
		dialogue_UI.toggle_option_visibility()
	end_interaction()

