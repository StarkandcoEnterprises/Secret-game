extends StaticBody2D

class_name WorldObject

func interact():
	if name == "Bed":
		sleep_prompt()
	if name == "Crate":
		crate_interaction()

func crate_interaction():
	pass

func sleep_prompt():
	$"../../../UI/DialogueUI".visible = true
	$"../../../UI/DialogueUI/DialoguePanel/Text".text = "Would you like to go to sleep?"
	$"../../../UI/DialogueUI/DialoguePanel/Yes".visible = true
	$"../../../UI/DialogueUI/DialoguePanel/No".visible = true

func _on_no_pressed():
	if name == "Bed":
		$"../../../UI/DialogueUI".visible = false
		$"../../../UI/DialogueUI/DialoguePanel/Yes".visible = false
		$"../../../UI/DialogueUI/DialoguePanel/No".visible = false

func _on_yes_pressed():
	if name == "Bed":
		$"../../.."._on_daytime_timeout()
		$"../../../UI/DialogueUI".visible = false
		$"../../../UI/DialogueUI/DialoguePanel/Yes".visible = false
		$"../../../UI/DialogueUI/DialoguePanel/No".visible = false
