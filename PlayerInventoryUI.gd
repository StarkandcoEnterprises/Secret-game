extends Control

var item_count = 0
var grid_pos = 0
var cursor_pos = 0

func add_item(item):
	item.reparent(get_child(grid_pos).get_child(item_count))
	item.position = Vector2(26,39) 
	item_count += 1

func delete_item(pos):
	get_child(grid_pos).get_child(pos).get_child(0).queue_free()
	item_count -= 1
	sort()

func remove_item(item, new_parent):
	item.reparent(new_parent)
	item_count -= 1
	sort()

func sort():
	var earliest_empty_spot
	#Loop through all spots in inv
	for i in range(0,160,1):
		#when we get to the first empty spot, mark this as our starting empty spot
		if get_child(grid_pos).get_child(i).get_child_count() == 0:
			if earliest_empty_spot == null:
				earliest_empty_spot = i
		#when we find a child and there's an empty space, move it, and mark the next space as empty
		elif earliest_empty_spot != null:
			get_child(grid_pos).get_child(i).get_child(0).reparent(get_child(grid_pos).get_child(earliest_empty_spot))
			get_child(grid_pos).get_child(earliest_empty_spot).get_child(0).position = Vector2(26,39) 
			earliest_empty_spot += 1

func move_cursor(direction):
	if direction == "right":
		$ReferenceRect.position.x += 57.9
		cursor_pos += 1
	if direction == "left":
		$ReferenceRect.position.x -= 57.9
		cursor_pos -= 1
	if direction == "up":
		$ReferenceRect.position.y -= 81.5
		cursor_pos -= 20
	if direction == "down":
		$ReferenceRect.position.y += 81.5
		cursor_pos += 20

func get_context_menu_for_selected():
	#some checking to see that it's a valid instance so no null pointers
	if get_child(grid_pos).get_child(cursor_pos).get_child_count() > 0:
		#Not only does it need to have a sprite but also a context menu...
		if get_child(grid_pos).get_child(cursor_pos).get_child(0).get_child_count() > 1:
			#Don't want our cursor getting in the way of the mouse (Bad scene layout I presume)
			$ReferenceRect.hide()
			var selected = get_child(grid_pos).get_child(cursor_pos).get_child(0).get_child(1)
			if selected.visible:
				selected.hide()
			else:
				selected.show()

