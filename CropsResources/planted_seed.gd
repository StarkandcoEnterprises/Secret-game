extends WorldObject

class_name PlantedSeed 


@onready var sprite1 = get_tree().get_first_node_in_group("sprite1")
@onready var sprite2 = get_tree().get_first_node_in_group("sprite2")
@onready var sprite3 = get_tree().get_first_node_in_group("sprite3")
@onready var sprite4 = get_tree().get_first_node_in_group("sprite4")
@onready var sprite5 = get_tree().get_first_node_in_group("sprite5")
@onready var sprite6 = get_tree().get_first_node_in_group("sprite6")

var planted_days = 0
var max_planted_days = 125
var sprouted = 0
var grow1 = false
var grow2 = false
var grow3 = false
var grown = false

@export var corn_scene: PackedScene

func _input(event):
	if event.is_action_pressed("debug"):
		planted_days += 20

func interact():
	if grown:
		var corn = corn_scene.instantiate()
		corn.position = position
		get_parent().add_child(corn)
		queue_free()

func grow():
	planted_days += 1
	var try_sprout = randi_range(8, 21)
	if sprouted == 0 and planted_days >= try_sprout:
		sprite1.visible = false
		sprite2.visible = true
		sprouted = try_sprout
	elif planted_days >= try_sprout + 10 and !grow1:
		sprite2.visible = false
		sprite3.visible = true
		grow1 = true
	elif planted_days >= try_sprout + 25 and !grow2:
		sprite3.visible = false
		sprite4.visible = true
		grow2 = true
	elif planted_days >= try_sprout + 65 and !grow3:
		sprite4.visible = false
		sprite5.visible = true
		grow3 = true
	elif max_planted_days / planted_days == 1 and !grown:
		sprite5.visible = false
		sprite6.visible = true
		grown = true
