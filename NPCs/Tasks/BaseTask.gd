extends Node

class_name BaseTask

var task_name: String
var duration: float = 1
var completion: float = 0
var position: Vector2
var is_completed: bool = false
const INTERACT_DISTANCE = 100

func perform(npc: BaseNPC):
	await npc.get_tree().create_timer(duration).timeout
	is_completed = true
	completion = 0
	npc.needs.warmth = 0
