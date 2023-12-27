extends BaseTask

class_name SocialTask

func _ready():
	duration = 5

func perform(npc: BaseNPC):
	position = get_social_target(npc)
	if position == Vector2.ZERO: return
	var target_villager = get_villager_at_position(position, npc)
	if !npc.near_NPC: return
	await super(npc)
	npc.needs.social = 0

func get_social_target(npc: BaseNPC):
	for villager_name in npc.knowledge["villagers"].keys():
		if npc.knowledge["villagers"][villager_name]["state"] != BaseNPC.State.DOING_TASK:
			return npc.knowledge["villagers"][villager_name]["position"]
	return Vector2.ZERO

func get_villager_at_position(at_position: Vector2, npc: BaseNPC):
	for villager_name in npc.knowledge["villagers"].keys():
		if npc.knowledge["villagers"][villager_name]["position"].distance_to(at_position) < INTERACT_DISTANCE:
			return npc.knowledge["villagers"][villager_name]
	return null
