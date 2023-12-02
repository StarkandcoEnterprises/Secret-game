extends WorldObject

class_name BasePlant 

var planted_days = 0
const MAX_PLANTED_DAYS = 125
var sprouted = 0

enum Life_Cycle {
	PLANTED,
	SPROUTED,
	FIRST_GROWTH,
	SECOND_GROWTH,
	THIRD_GROWTH,
	GROWN
}

var pos_in_cycle = Life_Cycle.PLANTED 

@export var produce_scene: PackedScene

func _ready():
	$CollisionShape2D.set_deferred("disabled", true)

func _input(event):
	if event.is_action_pressed("debug"):
		planted_days += 20

func interact():
	if pos_in_cycle != Life_Cycle.GROWN: 
		super()
		return
	var produce = produce_scene.instantiate()
	produce.position = position
	get_parent().add_child(produce)
	queue_free()
	super()

func grow():
	planted_days += 1
	var try_sprout = randi_range(8, 21)
	match pos_in_cycle:
		Life_Cycle.PLANTED:
			if planted_days < try_sprout: return
			%SeedSprite.visible = false
			%SproutSprite.visible = true
			pos_in_cycle = Life_Cycle.SPROUTED
		Life_Cycle.SPROUTED:
			if planted_days < try_sprout + 10: return
			%SproutSprite.visible = false
			%Growth1Sprite.visible = true
			pos_in_cycle = Life_Cycle.FIRST_GROWTH
		Life_Cycle.FIRST_GROWTH:
			if planted_days < try_sprout + 25: return
			%Growth1Sprite.visible = false
			%Growth2Sprite.visible = true
			pos_in_cycle = Life_Cycle.SECOND_GROWTH
		Life_Cycle.SECOND_GROWTH:
			if planted_days < try_sprout + 65: return
			%Growth2Sprite.visible = false
			%Growth3Sprite.visible = true
			pos_in_cycle = Life_Cycle.THIRD_GROWTH
		Life_Cycle.THIRD_GROWTH:
			if float(MAX_PLANTED_DAYS) / float(planted_days) < 1: return
			%Growth3Sprite.visible = false
			%GrownSprite.visible = true
			pos_in_cycle = Life_Cycle.GROWN
			$CollisionShape2D.set_deferred("disabled", false)
