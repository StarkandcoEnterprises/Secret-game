extends Sprite2D

enum State {
	CLOSED,
	SELECTABLE,
	OPEN,
	ITEM_HOVER
}

var drop_ref

var current_state = State.CLOSED

func _on_interact_area_entered(area):
	drop_ref = area.get_parent()

func _on_interact_area_exited(_area):
	if drop_ref: drop_ref = null

func take(_item: BaseItem):
	#reparent
	pass

func _unhandled_input(event):
	
	if !event is InputEventMouseButton: return
	
	if event.button_index == MOUSE_BUTTON_LEFT and current_state == State.SELECTABLE:
		current_state = State.OPEN
		toggle_UI()

func _on_close_pressed():
	current_state = State.CLOSED
	toggle_UI()

func toggle_UI():
	%BackpackUI.visible = !%BackpackUI.visible
	%BackpackUI.mouse_filter = Control.MOUSE_FILTER_PASS if %BackpackUI.mouse_filter == Control.MOUSE_FILTER_STOP \
								else Control.MOUSE_FILTER_STOP

func _on_interact_mouse_entered():
	if current_state == State.CLOSED: current_state = State.SELECTABLE

func _on_interact_mouse_exited():
	if current_state != State.OPEN: current_state = State.CLOSED


