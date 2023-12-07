extends Sprite2D

enum State {
	SELECTABLE,
	OPEN,
	ITEM_HOVER
}

var open: bool = false
var drop_ref

var index_of_selected_item

var current_state = State.SELECTABLE

func _ready():
	%BackpackItems.set_physics_process(false)

func _on_interact_area_entered(area):
	if !is_valid_item(area): return
	drop_ref = area.get_parent()
	current_state = State.ITEM_HOVER

func _on_interact_area_exited(area):
	if !is_valid_item(area): return
	if current_state != State.ITEM_HOVER: return
	clear_drop_ref()
	current_state = State.SELECTABLE if !open else State.OPEN

func clear_drop_ref():
	if drop_ref: drop_ref = null

func is_valid_item(area):
	return area.get_parent() is BaseItem

func _on_open_pressed():
	open = !open
	if !open and !index_of_selected_item == null:
		_on_item_list_empty_clicked(Vector2.ZERO, 0)
	current_state = State.OPEN if open else State.SELECTABLE
	toggle_UI()

func toggle_UI():
	%BackpackUI.visible = !%BackpackUI.visible
	%BackpackUI.mouse_filter = Control.MOUSE_FILTER_PASS if %BackpackUI.mouse_filter == Control.MOUSE_FILTER_STOP \
		else Control.MOUSE_FILTER_STOP

func _on_item_list_item_selected(index):
	if !index_of_selected_item == null:
		%BackpackItems.get_child(index_of_selected_item).get_child(0).interact_state = %BackpackItems.get_child(index_of_selected_item).get_child(0).Interact_State.IN_BACKPACK
	%BackpackItems.get_child(index).get_child(0).interact_state = %BackpackItems.get_child(0).get_child(index).Interact_State.SELECTED_IN_BACKPACK
	index_of_selected_item = index


func _on_item_list_empty_clicked(_at_position, _mouse_button_index):
	if !index_of_selected_item == null:
		%BackpackItems.get_child(index_of_selected_item).get_child(0).interact_state = %BackpackItems.get_child(index_of_selected_item).get_child(0).Interact_State.IN_BACKPACK
		%ItemList.deselect(index_of_selected_item)
		index_of_selected_item = null
