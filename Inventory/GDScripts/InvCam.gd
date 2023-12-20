extends Camera2D

class_name InventoryCamera
##Used to show the player in the [inventoryUI]
##
##Just overrides the world for the viewport and gets Hannah's position

##checks if there is a node in the "MainWorld" group, and if so, it sets the inventory viewport's world_2d property to the world_2d property of the "MainWorld" node. 
func _ready():
	if get_tree().get_first_node_in_group("MainWorld"):
		get_parent().world_2d = get_tree().get_first_node_in_group("MainWorld").world_2d

##If [Hannah] exists, it sets the global_position of the [InventoryCamera] to the global_position of [Hannah]. This makes the camera follow [Hannah], keeping her in view.
func _physics_process(_delta):
	if get_tree().get_first_node_in_group("Hannah"):
		global_position = get_tree().get_first_node_in_group("Hannah").global_position
