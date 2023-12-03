extends Area2D

var full = false
var contains_ref: BaseItem

func accept_item(item):
	full = true
	contains_ref = item

func remove_item():
	full = false
	contains_ref = null

func is_full():
	return full
