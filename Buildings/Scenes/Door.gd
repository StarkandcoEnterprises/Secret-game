extends WorldObjectArea

class_name Door

var building = null
var entry_point: Vector2
var exit_point: Vector2
var corresponding_door = null
var unique_id = null

func _ready():
	super()
	entry_point = global_position + Vector2(32, -64)
	exit_point = global_position + Vector2(32, 64)

func interact():
	super()
	if building:
		if building.hannah_inside:
			building.exit_building(self)
		else:
			building.enter_building(self)
