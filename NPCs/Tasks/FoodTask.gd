extends BaseTask

class_name FoodTask

func perform(npc: BaseNPC):
	position = find_food(npc)
	if npc.global_position.distance_to(position) > INTERACT_DISTANCE: return
	await super(npc)
	npc.needs.hunger = 0

func find_food(npc: BaseNPC):
	for building in npc.knowledge["buildings"]:
		pass
	for noted_object in npc.knowledge["nature"].keys():
		if npc.knowledge["nature"][noted_object]["type"] == "Tree":
			return npc.knowledge["nature"][noted_object]["position"]
	return null
