extends Window

@onready var text_out = get_tree().get_first_node_in_group("TextOut")
@onready var stack_out = get_tree().get_first_node_in_group("StackOut")
@onready var fps_out = get_tree().get_first_node_in_group("FPSOut")
@onready var object_count_out = get_tree().get_first_node_in_group("ObjectCountOut")

@export var corn_seed: PackedScene

func _process(_delta):
	fps_out.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))
	object_count_out.text = "#Objects: " + str(Performance.get_monitor(Performance.OBJECT_COUNT))

func stack_and_text(string):
	stack_trace()
	update_text(str(string))

func stack_trace():
	stack_out.text = ""
	var stack = get_stack()
	for frame in range(2,stack.size()):
		if frame == 2:
			stack_out.text += str("Level ",frame - 1, 
				" --- Source: ",stack[frame]["source"],
				"\nFunction: ",stack[frame]["function"],
				" --- @Line: ",stack[frame]["line"],"\n")
		else:
			stack_out.text += str("Level ",frame - 1, 
				" --- Source: ",stack[frame]["source"],
				" --- Function: ",stack[frame]["function"],
				" --- Line: ",stack[frame]["line"],"\n")

func update_text(string):
	text_out.text = text_out.text + "\n" + string
	if text_out.get_line_count() >= 10:
		var new_text_array = text_out.text.split("\n")
		new_text_array.remove_at(0)
		text_out.text = "\n".join(new_text_array)

func _on_spawn_seed_pressed():
	var new_seed = corn_seed.instantiate()
	var debug = get_tree().get_first_node_in_group("ObjectHolder")
	get_tree().get_first_node_in_group("ObjectHolder").add_child(new_seed)
	new_seed.position = Vector2(400, 150)
