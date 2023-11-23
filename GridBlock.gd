extends Control

@onready var debugOutput = get_tree().get_first_node_in_group("DebugOutput")

var full = false
var contains_ref

func accept_item(item):
	full = true
	contains_ref = item
	debugOutput.update_text(str("Accept: ", self, full, contains_ref))

func remove_item():
	full = false
	contains_ref = false
	debugOutput.update_text(str("Remove: ", self, full, contains_ref))

func is_full():
	return full
	debugOutput.update_text(str("Check Full: ", self, full, contains_ref))
