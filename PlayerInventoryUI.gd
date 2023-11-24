extends Control

@onready var faux_item_collection = get_tree().get_first_node_in_group("FauxColl")
@onready var item_collection = get_tree().get_first_node_in_group("ItemColl")
@export var grav_affected_item_scene: PackedScene



func add_item(item):
	item.reparent(item_collection)
	var new_slot_filler = grav_affected_item_scene.instantiate()
	faux_item_collection.add_child(new_slot_filler)
	var match_item = RemoteTransform2D.new()
	match_item.set_remote_node(item.get_path())
	match_item.add_to_group("Remote")
	new_slot_filler.add_child(match_item)

#func delete_item(pos):
#	get_child(grid_pos).get_child(pos).get_child(0).queue_free()
#	item_count -= 1
#	sort()

#func remove_item(item, new_parent):
#	item.reparent(new_parent)
#	item_count -= 1
#	sort()

#func sort():
#	var earliest_empty_spot
#	#Loop through all spots in inv
#	for i in range(0,160,1):
#		#when we get to the first empty spot, mark this as our starting empty spot
#		if get_child(grid_pos).get_child(i).get_child_count() == 0:
#			if earliest_empty_spot == null:
#				earliest_empty_spot = i
#		#when we find a child and there's an empty space, move it, and mark the next space as empty
#		elif earliest_empty_spot != null:
#			get_child(grid_pos).get_child(i).get_child(0).reparent(get_child(grid_pos).get_child(earliest_empty_spot))
#			get_child(grid_pos).get_child(earliest_empty_spot).get_child(0).position = Vector2(26,39) 
#			get_child(grid_pos).get_child(earliest_empty_spot).get_child(0).get_child(0).position = Vector2.ZERO 
#			earliest_empty_spot += 1

#func move_cursor(direction):
#	if direction == "right" and cursor_pos % 20 <= 18:
#		$ReferenceRect.position.x += 57.9
#		cursor_pos += 1
#	if direction == "left" and cursor_pos % 20 >= 1:
#		$ReferenceRect.position.x -= 57.9
#		cursor_pos -= 1
#	if direction == "up" and cursor_pos >=20:
#		$ReferenceRect.position.y -= 81.5
#		cursor_pos -= 20
#	if direction == "down" and cursor_pos <= 139:
#		$ReferenceRect.position.y += 81.5
#		cursor_pos += 20
#
#func toggle_context_menu_for_selected():
#	#some checking to see that cursor position is not empty so no null pointers
#	if get_child(grid_pos).get_child(cursor_pos).get_child_count() > 0:
#		#It has a sprite. But not only does it need to have a sprite, it also needs a context menu...
#		if get_child(grid_pos).get_child(cursor_pos).get_child(0).get_child_count() > 1:
#			#Don't want our cursor getting in the way of the mouse (Bad scene layout I presume)
#			var selected = get_child(grid_pos).get_child(cursor_pos).get_child(0).get_child(1)
#			if selected.visible:
#				$ReferenceRect.show()
#				selected.hide()
#			else:
#				selected.show()
#				$ReferenceRect.hide()
#
#func check_menu_visibility_for_selected():
#	#some checking to see that it's a valid instance so no null pointers
#	if get_child(grid_pos).get_child(cursor_pos).get_child_count() > 0:
#		#Not only does it need to have a sprite but also a context menu...
#		if get_child(grid_pos).get_child(cursor_pos).get_child(0).get_child_count() > 1:
#			var selected = get_child(grid_pos).get_child(cursor_pos).get_child(0).get_child(1)
#			if selected.visible:
#				return true
#			else:
#				return false
#
#func _on_throw_away_pressed():
#	delete_item(cursor_pos)
#	$ReferenceRect.show()
