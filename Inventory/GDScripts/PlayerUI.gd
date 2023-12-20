extends Control

class_name PlayerUI

##Class for managing the inventory UI for [Hannah]
##
##Has functions for receiving items, handling inputs etc.

##This member variable keeps track of the currently selected slot in the inventory.
var current_slot = 0

##[Hannah] is referenced to ensure that her processing is updated for inventory interactions
@onready var hannah: Hannah = get_tree().get_first_node_in_group("Hannah")

##This function is used to add an item to the inventory for the first time. It takes an item as a parameter, reparents it to the inventory, sets its position, and calls its [method BaseItem.added_to_inventory] method.
func first_add_item(item: BaseItem):
	item.reparent(%InvSprite.get_node("%LooseItems"))
	item.position = %InvSprite.get_node("%PickupSpawn").position
	item.added_to_inventory()
	hannah.update_weight(item.item_properties.weight)

##Update weight for the inventory text
func _process(_delta):
	if !visible: return
	%InvSprite.get_node("%CarriedWeight").text = "Weight: " + str(hannah.weight) + " (Max:" + str(Hannah.MAX_WEIGHT) + ")"

##Checks if the event is a key press, and if so, it handles the "inventory" and "unequip" actions and the number keys.
func _unhandled_input(event):
	if hannah:
		if !hannah.is_processing() and %HotbarUI.visible: return
	
	if !event is InputEventKey: return
	
	if !event.pressed: return
	
	if event.is_action_pressed("inventory"):
		invert_inventory_and_bar()
	if hannah:
		if !hannah.is_processing(): return
	
	if event.is_action_pressed("unequip"):
		select_on_bar(0)
	
	elif event.as_text() in ["1","2","3","4","5","6","7","8","9","0"]:
		select_on_bar(int(event.as_text()))

##This function toggles the visibility of the inventory and the hotbar, and toggles the mouse filter between "Pass" and "Stop". It also toggles the processing of [Hannah].
func invert_inventory_and_bar():
	%HotbarUI.visible = !%HotbarUI.visible
	%InvSprite.visible = !%InvSprite.visible
	%StatPanel.visible = !%StatPanel.visible
	mouse_filter = MOUSE_FILTER_PASS if mouse_filter == MOUSE_FILTER_STOP else MOUSE_FILTER_STOP
	if hannah: hannah.toggle_processing()

##This function is used to select a slot on the hotbar. It takes a new slot number as a parameter. Needs refactoring :)
func select_on_bar(new_slot: int):
	#If we're passing 0, the same slot, or an empty slot - just unequip things.
	if new_slot == 0 or new_slot == current_slot or %HotbarUI.get_node(str("%Hotbar/Equipped", new_slot)).get_child_count() == 0:

		if hannah:
			hannah.unequip_held()
			
		#Clear our old ref rect
		if current_slot != 0:
			%HotbarUI.get_node(str("%Hotbar/Equipped", current_slot)).get_child(1).queue_free()
			current_slot = 0
		return
	
	#If we're not unequipping, but we were holding something, unequip it before moving on
	if current_slot != 0: 
		%HotbarUI.get_node(str("%Hotbar/Equipped", current_slot)).get_child(1).queue_free()
		hannah.unequip_held()
		
	#Highlight the selected box
	var highlight = Sprite2D.new()
	highlight.texture = preload("res://Art/Images/Inventory/Highlight.png") 
	highlight.position = Vector2(32, 32) 
	%HotbarUI.get_node(str("%Hotbar/Equipped", new_slot)).add_child(highlight)
	
	current_slot = new_slot
	
	#Equip
	if hannah: 
		hannah.equip_item(%HotbarUI.get_node(str("%Hotbar/Equipped", new_slot)).get_child(0).parent)

