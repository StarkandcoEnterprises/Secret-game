extends ItemList

var items = []

func cust_add_item(item: BaseItem) -> void:
	var index = find_item_index(item.item_properties.string_name)
	
	if index != -1:
		items[index][1] += 1
		set_item_text(index, combine_name_and_count(item))
	else:
		items.append([item.item_properties.string_name, 1])
		add_item(combine_name_and_count(item), item.get_node("%ItemSprite").texture)

func cust_remove_item(item: BaseItem) -> void:
	var index = find_item_index(item.item_properties.string_name)
	
	if index == -1: return
	items[index][1] -= 1
	if items[index][1] == 0:
		items.remove_at(index)
		remove_item(index)
	else:
		set_item_text(index, combine_name_and_count(item))

func combine_name_and_count(item: BaseItem) -> String:
	for i in range(items.size()):
		if items[i][0] == item.item_properties.string_name:
			return str(item.item_properties.string_name, "|", items[i][1])
	return ""  # Handle the case where the item is not found

func find_item_index(name_to_find):
	for i in range(items.size()):
		if items[i][0] == name_to_find:
			return i
	return -1
