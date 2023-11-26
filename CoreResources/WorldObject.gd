extends StaticBody2D

class_name WorldObject

@onready var dialogueUI = UI.get_node("/root/UI/DialogueUI")
@onready var label = UI.get_node("/root/UI/DialogueUI/DialoguePanel/Text")
@onready var options = UI.get_node("/root/UI/DialogueUI/DialoguePanel/Options")
@onready var main = get_tree().root.get_child(get_tree().root.get_child_count() - 1)
@onready var hannah = get_tree().get_first_node_in_group("Hannah")

func _ready():
	UI.get_node("/root/UI/DialogueUI/DialoguePanel/Options/Yes").pressed.connect(_on_yes_pressed)
	UI.get_node("/root/UI/DialogueUI/DialoguePanel/Options/No").pressed.connect(_on_no_pressed)

func interact():
	if name == "Bed":
		sleep_prompt()
	if name == "Crate":
		crate_interaction()

func crate_interaction():
	pass

func end_interaction():
	hannah.interacting = false

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
	dialogueUI.visible = !dialogueUI.visible

func toggle_option_visibility():
	options.visible = !options.visible
