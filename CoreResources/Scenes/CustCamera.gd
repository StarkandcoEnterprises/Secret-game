extends Camera2D

func _ready():
	var cell_size = get_tree().get_first_node_in_group("Map").get_used_rect()
	var cell_count = get_tree().get_first_node_in_group("Map").tile_set.tile_size
	limit_left = cell_size.position.x * cell_count.x
	limit_right = cell_size.end.x * cell_count.x
	limit_top =cell_size.position.y * cell_count.y
	limit_bottom = cell_size.end.y * cell_count.y

func _process(delta):
	var viewport_rect = get_viewport_rect()
	if viewport_rect != get_tree().root.get_viewport().get_visible_rect():
		limit_left = 0
		limit_top= 0
		limit_right = viewport_rect.size.x
		limit_bottom= viewport_rect.size.y
	else:
		var cell_size = get_tree().get_first_node_in_group ("Map").get_used_rect()
		var cell_count = get_tree().get_first_node_in_group("Map").tile_set.tile_size
		limit_left = cell_size.position.x * cell_count.x
		limit_right = cell_size.end.x* cell_count.x
		limit_top=cell_size.position.y* cell_count.y
		limit_bottom= cell_size.end.y * cell_count.y
	
