extends Area2D

var full = false
var contains_ref

func accept_item(item):
	full = true
	contains_ref = item

func remove_item():
	full = false
	contains_ref = false

func is_full():
	return full
