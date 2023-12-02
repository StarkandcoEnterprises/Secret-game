extends Control

class_name InventoryUI

var current_slot = 0

@onready var hannah: Hannah = get_tree().get_first_node_in_group("Hannah")


func add_item(item: BaseItem):
	item.reparent(%ItemCollection)
	item.position = %PickupSpawn.position
	item.added_to_inventory()

func _unhandled_input(event):
	
	if !event is InputEventKey: return
	
	if !event.pressed: return
	
	if event.is_action_pressed("unequip"):
		select_on_bar(0)
	elif event.is_action_pressed("inventory"):
		invert_inventory_and_bar()
		
	elif event.as_text() in ["1","2","3","4","5","6","7","8","9","0"]:
		select_on_bar(int(event.as_text()))

func invert_inventory_and_bar():
	%EquippedBar.visible = !%EquippedBar.visible
	%InvSprite.visible = !%InvSprite.visible
	mouse_filter = MOUSE_FILTER_PASS if mouse_filter == MOUSE_FILTER_STOP else MOUSE_FILTER_STOP
	if hannah: hannah.toggle_processing()


##This is not working
func select_on_bar(new_slot: int):
	#If we're passing 0, the same slot, or an empty slot - just unequip things.
	if new_slot == 0 or new_slot == current_slot or %EquippedContainer.get_node(str("Equipped", new_slot)).get_child_count() == 0:
		if hannah:
			hannah.unequip_held()
			
		#Clear our old ref rect
		if current_slot != 0:
			%EquippedContainer.get_node(str("Equipped", current_slot)).get_child(1).queue_free()
			current_slot = 0
		return
	
	if current_slot != 0: 
		%EquippedContainer.get_node(str("Equipped", current_slot)).get_child(1).queue_free()
		hannah.unequip_held()
	
	#Unequip current if the passed slot is empty
	
	#Highlight the selected box
	var reference_rect = ReferenceRect.new() 
	reference_rect.editor_only = false
	reference_rect.size = Vector2(64, 55)
	reference_rect.position = Vector2(5,0)
	%EquippedContainer.get_node(str("Equipped", new_slot)).add_child(reference_rect)
	
	current_slot = new_slot
	
	#Equip
	if hannah: 
		hannah.equip_item(%EquippedContainer.get_node(str("Equipped", new_slot)).get_child(0).parent.duplicate())
		hannah.equipped.rotation_degrees = 0
		hannah.equipped.interact_state = hannah.equipped.Interact_State.IN_WORLD 

