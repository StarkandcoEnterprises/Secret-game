extends Control

var full = false

func accept_item():
	full = true

func remove_item():
	full = false

func is_full():
	return full
