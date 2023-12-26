class_name TaskManager

var tasks: Dictionary = {}

func add_task(task: BaseTask):
	tasks[task.task_name] = task

func get_task(task_name: String = ""):
	if task_name != "" and tasks.has(task_name):
		return tasks[task_name]
	else:
		for task in tasks.values():
			if not task.is_completed:
				return task
	return null
