extends ItemList

var items = []
var buttons = []

func cust_add_item(item: BaseItem) -> void:
	var index = find_item_index(item.item_properties.string_name)
	
	if index != -1:
		items[index][1] += 1
		set_item_text(index, combine_name_and_count(item))
	else:
		items.append([item.item_properties.string_name, 1])
		add_item(combine_name_and_count(item), item.get_node("%ItemSprite").texture)
		add_button(find_item_index(item.item_properties.string_name))

func add_button(item_index: int) -> void:
	var drop_button = Button.new()
	var pickup_all_button = Button.new()
	drop_button.text = "Drop all"
	pickup_all_button.text = "Pick-up all"
	drop_button.pressed.connect(drop_all.bind(item_index))
	pickup_all_button.pressed.connect(pickup_all.bind(item_index))
	buttons.append(drop_button)
	buttons.append(pickup_all_button)
	get_parent().get_node("%ButtonList").add_child(drop_button)
	get_parent().get_node("%ButtonList").add_child(pickup_all_button)

func drop_all(item_index: int) -> void:
	if item_index != -1:
		get_parent().get_parent().on_drop_all_pressed(item_index)
		items[item_index][1] = 1
		_cust_remove_item(item_index)

func pickup_all(item_index: int) -> void:
	if item_index != -1:
		get_parent().get_parent().on_pickup_all_pressed(item_index)

func _cust_remove_item(item_index: int) -> void:
	if item_index == -1: return
	items[item_index][1] -= 1
	if items[item_index][1] == 0:
		items.remove_at(item_index)
		remove_item(item_index)
		remove_button(item_index)
	else:
		cust_remove_item(BaseItem.new())

func cust_remove_item(item: BaseItem) -> void:
	var index = find_item_index(item.item_properties.string_name)
	
	if index == -1: return
	items[index][1] -= 1
	if items[index][1] == 0:
		items.remove_at(index)
		remove_item(index)
		remove_button(index)
	else:
		set_item_text(index, combine_name_and_count(item))

func combine_name_and_count(item: BaseItem) -> String:
	return str(item.item_properties.string_name, "|", items[find_item_index(item.item_properties.string_name)][1])

func specify_count(item: BaseItem, count) -> String:
	return str(item.item_properties.string_name, "|", count)
	
func find_item_index(name_to_find):
	for i in range(items.size()):
		if items[i][0] == name_to_find:
			return i
	return -1
	
func remove_button(item_index: int) -> void:
	if item_index == -1: return
	buttons[item_index * 2].queue_free()
	buttons[item_index * 2 + 1].queue_free()
	buttons.remove_at(item_index * 2)
	buttons.remove_at(item_index * 2)
