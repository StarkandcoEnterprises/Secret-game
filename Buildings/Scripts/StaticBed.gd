extends WorldObjectStatic

class_name StaticBed
## Static body beds for sleeping :)
##
## A [Bed] object inheriting [WorldObject] which has a dialogue tree allowing a player to choose or not to sleep after interacting 

## Assigns the dialogue tree value. Retrieves [Main] so that it can use [method Main._on_daytime_timeout]
func _ready():
	super()
	type = "Bed"
	main = get_tree().get_first_node_in_group("Main")
	dialogue_tree = {
	"text": "Do you want to sleep?",
	"options": [
		{
			"text": "Yes",
			"callback": "on_day_over"
		},
		{
			"text": "No",
			"callback": "end_dialogue"
		}
	]
}

## Calls [method Main._on_daytime_timeout] if user selectes "Yes" option after [method Hannah.interact] with [Bed]
func call_dialogue_callback(callback_name):
	match callback_name:
		"on_day_over":
			main._on_daytime_timeout()
		var _default:
			super(callback_name)
