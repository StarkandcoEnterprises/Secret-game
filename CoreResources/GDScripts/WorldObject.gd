extends StaticBody2D

class_name WorldObject

## A world object, which is to be extended by all kinds of things like beds, characters, crates for selling things etc.
## 
## This object has an [method WorldObject.interact] function to be called by [Hannah].
## Inheriting children should extend versions of [method WorldObject.interact].
## NB: The object has an [method WorldObject.end_interaction] function to be called for each object when an interaction with it should end.  

## Reference to the main scene
var main: Node

## Reference to [Hannah]
var hannah: Hannah

## Reference to the dialogue UI
var dialogue_UI: DialogueUI 

## Connects the dialogue UI buttons to the script and retrieves [member WorldObject.main],  [member WorldObject.hannah] and  [member WorldObject.dialogue_UI]
func _ready():
	await get_tree().process_frame
	dialogue_UI = get_tree().get_first_node_in_group("DialogueUI")
	hannah = get_tree().get_first_node_in_group("Hannah")
	main = get_tree().root.get_child(0)
	dialogue_UI.get_node("%Yes").pressed.connect(_on_yes_pressed)
	dialogue_UI.get_node("%No").pressed.connect(_on_no_pressed)

##Is called when [Hannah] interacts with the [WorldObject]
func interact():
	if name == "Bed":
		sleep_prompt()
	elif name == "Crate":
		crate_interaction()
	else:
		end_interaction()

## To be moved to a crate object
func crate_interaction():
	end_interaction()

## Resumes [Hannah]'s processing
func end_interaction():
	hannah.toggle_processing()
	pass

## To be moved to a bed object
func sleep_prompt():
	dialogue_UI.toggle_UI_visibility()
	dialogue_UI.toggle_option_visibility()
	dialogue_UI.update_text("Would you like to go to sleep?")

## When [Hannah] presses no on a dialogue prompt, this function handles the result as connected in _ready()
## Current implementation to be moved to a bed object
func _on_no_pressed():
	if name == "Bed":
		dialogue_UI.toggle_UI_visibility()
		dialogue_UI.toggle_option_visibility()
	end_interaction()

## When [Hannah] presses yes on a dialogue prompt, this function handles the result as connected in _ready()
## Current implementation to be moved to a bed object
func _on_yes_pressed():
	if name == "Bed":
		main._on_daytime_timeout()
		dialogue_UI.toggle_UI_visibility()
		dialogue_UI.toggle_option_visibility()

