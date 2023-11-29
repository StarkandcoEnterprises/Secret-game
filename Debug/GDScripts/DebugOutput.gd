extends Window

class_name DebugOutput

@export var corn_seed: PackedScene

func _process(_delta):
	%FPSCount.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))
	%ObjectCount.text = "#Objects: " + str(Performance.get_monitor(Performance.OBJECT_COUNT))

func stack_and_text(string):
	stack_trace()
	update_text(str(string))

func stack_trace():
	%StackTraceAt.text = ""
	var stack = get_stack()
	for frame in range(2,stack.size()):
		if frame == 2:
			%StackTraceAt.text += str("Level ",frame - 1, 
				" --- Source: ",stack[frame]["source"],
				"\nFunction: ",stack[frame]["function"],
				" --- @Line: ",stack[frame]["line"],"\n")
		else:
			%StackTraceAt.text += str("Level ",frame - 1, 
				" --- Source: ",stack[frame]["source"],
				" --- Function: ",stack[frame]["function"],
				" --- Line: ",stack[frame]["line"],"\n")

func update_text(string):
	%DebugText.text = %DebugText.text + "\n" + string
	if %DebugText.get_line_count() >= 10:
		var new_text_array = %DebugText.text.split("\n")
		new_text_array.remove_at(0)
		%DebugText.text = "\n".join(new_text_array)

func _on_spawn_seed_pressed():
	var new_seed = corn_seed.instantiate()
	get_tree().get_first_node_in_group("ObjectHolder").add_child(new_seed)
	new_seed.position = Vector2(400, 150)
