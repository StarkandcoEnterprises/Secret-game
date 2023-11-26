extends WorldObject

class_name PlantedSeed 

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
		%SeedSprite.visible = false
		%SproutSprite.visible = true
		sprouted = try_sprout
	elif planted_days >= try_sprout + 10 and !grow1:
		%SproutSprite.visible = false
		%Growth1Sprite.visible = true
		grow1 = true
	elif planted_days >= try_sprout + 25 and !grow2:
		%Growth1Sprite.visible = false
		%Growth2Sprite.visible = true
		grow2 = true
	elif planted_days >= try_sprout + 65 and !grow3:
		%Growth2Sprite.visible = false
		%Growth3Sprite.visible = true
		grow3 = true
	elif max_planted_days / planted_days == 1 and !grown:
		%Growth3Sprite.visible = false
		%GrownSprite.visible = true
		grown = true
