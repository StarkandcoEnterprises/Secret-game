extends Label

#@onready var debugOutput = get_tree().get_first_node_in_group("DebugOutput")

func update_text(string):
	text = text + "\n" + string
	if get_line_count() >= 10:
		var new_text_array = text.split("\n")
		new_text_array.remove_at(0)
		text = "\n".join(new_text_array)
