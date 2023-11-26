extends Control


var full = false
var contains_ref

func accept_item(item):
	full = true
	contains_ref = item
	debug.stack_and_text(str("Accept: ", self, full, contains_ref))

func remove_item():
	full = false
	contains_ref = false
	debug.stack_and_text(str("Remove: ", self, full, contains_ref))

func is_full():
	return full
	debug.stack_and_text(str("Check Full: ", self, full, contains_ref))
