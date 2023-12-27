extends BaseTask

class_name FirewoodTask

func perform(npc: BaseNPC):
	position = find_wood(npc)
	if npc.global_position.distance_to(position) > INTERACT_DISTANCE: return
	await super(npc)
	npc.needs.hunger = 0

func find_fire(npc: BaseNPC):
	#for building in npc.knowledge["buildings"]:
	for building in npc.knowledge["buildings"]:
		if npc.knowledge["buildings"][building]["placements"]["type"] == "Fire":
			return npc.knowledge["buildings"][[building]]["position"]
	for noted_object in npc.knowledge["placements"].keys():
		if npc.knowledge["placements"][noted_object]["type"] == "Fire":
			return npc.knowledge["placements"][noted_object]["position"]

func find_wood(npc: BaseNPC):
	for building in npc.knowledge["buildings"]:
		pass
	for noted_object in npc.knowledge["nature"].keys():
		if npc.knowledge["nature"][noted_object]["type"] == "Tree":
			return npc.knowledge["nature"][noted_object]["position"]
	return Vector2.ZERO
