extends WorldObject

@export var plant_resource: BasePlant

var sprout_needed_days = randi_range(8, 21)

var planted_days = 0

var pos_in_cycle = plant_resource.Life_Cycle.PLANTED 

func _ready():
	super()
	$CollisionShape2D.set_deferred("disabled", true)

func _unhandled_input(event):
	if event.is_action_pressed("debug"):
		planted_days += 20
		grow()

func interact():
	if pos_in_cycle != plant_resource.Life_Cycle.GROWN: 
		super()
		return
	var produce = plant_resource.produce_scene.instantiate()
	produce.position = position
	get_parent().add_child(produce)
	queue_free()
	super()

func grow():
	planted_days += 1
	match pos_in_cycle:
		plant_resource.Life_Cycle.PLANTED:
			try_sprout()
		plant_resource.Life_Cycle.SPROUTED:
			
			if planted_days < sprout_needed_days + plant_resource.first_growth: return
			
			%PlantSprite.next_sprite()
			pos_in_cycle = plant_resource.Life_Cycle.FIRST_GROWTH
			
		plant_resource.Life_Cycle.FIRST_GROWTH:
			
			if planted_days < sprout_needed_days + plant_resource.second_growth: return
			
			%PlantSprite.next_sprite()
			pos_in_cycle = plant_resource.Life_Cycle.SECOND_GROWTH
			
		plant_resource.Life_Cycle.SECOND_GROWTH:
			
			if planted_days < sprout_needed_days + plant_resource.third_growth: return
			
			%PlantSprite.next_sprite()
			pos_in_cycle = plant_resource.Life_Cycle.THIRD_GROWTH
			
		plant_resource.Life_Cycle.THIRD_GROWTH:
			
			if float(plant_resource.max_planted_days) / float(planted_days) < 1: return
			
			%PlantSprite.next_sprite()
			pos_in_cycle = plant_resource.Life_Cycle.GROWN
			$CollisionShape2D.set_deferred("disabled", false)

func try_sprout():
	if planted_days < sprout_needed_days: sprout_needed_days = randi_range(plant_resource.min_sprout, plant_resource.max_sprout)
	else:
		%PlantSprite.next_sprite()
		pos_in_cycle = plant_resource.Life_Cycle.SPROUTED
