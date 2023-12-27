extends BaseTask

class_name SocialTask

func _ready():
	duration = 5

func perform(npc: BaseNPC):
	position = get_social_target(npc)
	if position == Vector2.ZERO: return
	if !npc.near_NPC: return
	position = npc.global_position
	await super(npc)
	npc.needs.social = 0

func get_social_target(npc: BaseNPC):
	var closest_villager = null
	var min_distance = INF

	for villager_name in npc.knowledge["villagers"].keys():
		if npc.knowledge["villagers"][villager_name]["state"] != BaseNPC.State.DOING_TASK:
			var distance = npc.global_position.distance_to(npc.knowledge["villagers"][villager_name]["position"])
			if distance < min_distance:
				min_distance = distance
				closest_villager = npc.knowledge["villagers"][villager_name]

	if closest_villager != null:
		return closest_villager["position"]
	else:
		return Vector2.ZERO

func get_villager_at_position(at_position: Vector2, npc: BaseNPC):
	for villager_name in npc.knowledge["villagers"].keys():
		if npc.knowledge["villagers"][villager_name]["position"].distance_to(at_position) < INTERACT_DISTANCE:
			return npc.knowledge["villagers"][villager_name]
	return null
