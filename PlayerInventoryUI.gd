extends Control

var item_count = 0

func add_item(item):
	item.reparent(get_child(0).get_child(item_count))
	item.position = Vector2(26,40) 
	item_count += 1
