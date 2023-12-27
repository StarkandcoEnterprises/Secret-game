extends Node2D

class_name WorldObjectStatic

## A world object, which is to be extended by all kinds of things like beds, characters, crates for selling things etc.
## 
## Representing world objects such as crates and beds, these objects have an [method WorldObjectStatic.interact] function to be called by [Hannah].
## Inheriting children should extend versions of [method WorldObjectStatic.interact] if any specific functionality is required.
## [br][br]An empty [member WorldObjectStatic.dialogue_tree] exists, and more can be added to build out character interactions. [method WorldObjectStatic.interact] then passes these trees to [DialogueManager] as appropriate.
## [br]This can be achieved using [method WorldObjectStatic.call_dialogue_callback]

## Reference to [Main]
var main: Node

## Reference to [Hannah]
var hannah: Hannah

## Reference to the [DialogueManager]
var dialogue_UI: DialogueManager 

## [Dictionary] which contains 
var dialogue_tree: Dictionary = {}

@export var type = ""

## Connects the [DialogueManager] buttons to the script and retrieves [member WorldObjectStatic.main],  [member WorldObjectStatic.hannah] and  [member WorldObjectStatic.dialogue_UI]
func _ready():
	await get_tree().process_frame
	dialogue_UI = get_tree().get_first_node_in_group("DialogueUI")
	main = get_tree().get_first_node_in_group("Main")
	hannah = get_tree().get_first_node_in_group("Hannah")

## Is called when [Hannah] interacts with the [WorldObjectStatic] to send the [member WorldObjectStatic.dialogue_tree] to the manager. Also pauses the timer on [Main].
func interact():
	main.get_node("%Daytime").stop()
	dialogue_UI.show_dialogue(self, dialogue_tree)

## Is called when a dialogue option is selected, allowing the [WorldObjectStatic] to respond by calling other functions. By default this resumes [Hannah]'s handling and restarts the timer on [Main]
func call_dialogue_callback(_callback_name):
	if !hannah.is_processing_unhandled_input():
		hannah.toggle_processing()
	if main.get_node("%Daytime").is_stopped():
		main.get_node("%Daytime").start()
