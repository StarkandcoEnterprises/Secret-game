extends Camera2D

func _ready():
	if get_tree().get_first_node_in_group("MainWorld"):
		get_parent().world_2d = get_tree().get_first_node_in_group("MainWorld").world_2d
	
func _physics_process(_delta):
	if get_tree().get_first_node_in_group("Hannah"):
		global_position = get_tree().get_first_node_in_group("Hannah").global_position
