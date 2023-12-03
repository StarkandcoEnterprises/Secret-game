extends Resource

class_name BasePlant 

@export var min_sprout: int = 8
@export var max_sprout: int = 21
@export var first_growth: int = 10
@export var second_growth: int = 25
@export var third_growth: int = 65
@export var max_planted_days: int = 125

@export var produce_scene: PackedScene

enum Life_Cycle {
	PLANTED,
	SPROUTED,
	FIRST_GROWTH,
	SECOND_GROWTH,
	THIRD_GROWTH,
	GROWN
}

