extends Area2D

var full = false
var contains_ref: BaseItem

func accept_item(item):
	full = true
	contains_ref = item
	get_parent().modulate = Color.ANTIQUE_WHITE

func remove_item():
	full = false
	contains_ref = null
	get_parent().modulate = Color.WHITE

func is_full():
	return full
