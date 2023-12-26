extends BaseTask

class_name FoodTask

func perform(npc: BaseNPC):
	#find food
	await super(npc)
	npc.needs.hunger = 0
