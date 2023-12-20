extends WorldObject

class_name SleepingBag2

func _ready():
	super()
	dialogue_tree = {
	"text": "Hello, traveler! Welcome to our village.",
	"options": [
		{
			"text": "Continue",
			"callback": "show_dialogue_tree_2"
		}
	]
}

var dialogue_tree_2 = {
	"text": "Our village is known for its beautiful scenery and friendly people.",
	"options": [
		{
			"text": "Continue",
			"callback": "show_dialogue_tree_3"
		}
	]
}

var dialogue_tree_3 = {
	"text": "Feel free to explore and enjoy your stay!",
	"options": [
		{
			"text": "Continue",
			"callback": "end_dialogue"
		}
	]
}

## Calls [method Main._on_daytime_timeout] if user selectes "Yes" option after [method Hannah.interact] with [Bed]
func call_dialogue_callback(callback_name):
	match callback_name:
		"show_dialogue_tree_2":
			show_dialogue_tree_2()
		"show_dialogue_tree_3":
			show_dialogue_tree_3()
		var _default:
			super(callback_name)

func show_dialogue_tree_2():
	dialogue_UI.show_dialogue(self, dialogue_tree_2)

func show_dialogue_tree_3():
	dialogue_UI.show_dialogue(self, dialogue_tree_3)
