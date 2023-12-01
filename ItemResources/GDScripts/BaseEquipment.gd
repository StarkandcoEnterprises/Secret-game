extends BaseItem

class_name BaseEquipment

@export var equipment_properties:EquipmentPropertiesResource
@onready var hannah: Hannah = get_tree().get_first_node_in_group("Hannah")

var equipped_bar
var equipped = false
var bar_sprite


#This stuff could happen when added to inventory but I added it here so it's definitely already available
func _ready():
	await get_tree().process_frame
	equipped_bar = get_tree().get_first_node_in_group("EquippedBar")
	bar_sprite = %EquipmentBarSprite
	

func use():
	if equipment_properties.durability > 0:
		equipment_properties.use()
		if get_parent().name == "HandsRight":
			var tween = get_tree().create_tween()
			tween.tween_property(get_parent().get_parent(), "rotation_degrees", 90, 1)
			tween.tween_property(get_parent().get_parent(), "rotation_degrees", 0, 0)
			tween.play()
		elif get_parent().name ==  "HandsLeft":
			var tween = get_tree().create_tween()
			tween.tween_property(get_parent().get_parent(), "rotation_degrees", -90, 1)
			tween.tween_property(get_parent().get_parent(), "rotation_degrees", 0, 0)
			tween.play()

func _unhandled_input(event):
	if interact_state == Interact_State.IN_WORLD: return
	super(event)
	
	if !event is InputEventMouseButton: return
	if event.button_index != MOUSE_BUTTON_LEFT: return
	
	if event.pressed:
		#Try and unslot ourselves, nasty business
		for slot in equipped_bar.get_children():
			
			if slot.get_child_count() == 0: continue
			if slot.get_child(0) != bar_sprite: continue
			
			#Get our bar sprite back
			bar_sprite.reparent(self)
			bar_sprite.visible = false
			
			#Tell the inventory? That the current slot is 0 lol
			slot.get_parent().get_parent().get_parent().get_parent().current_slot = 0
			if hannah: hannah.unequip_held()
			#Need to also possibly remove the reference rect....
			if slot.get_child_count() > 0:
				slot.get_child(0).queue_free()
			return
	
	elif are_all_slots_free():
		#Slot ourselves
		#It would be nice if the equipment didn't have to care about this equipped bar stuff.
		for slot in equipped_bar.get_children():
			
			if slot.get_child_count() != 0: continue
			
			bar_sprite.visible = true
			bar_sprite.reparent(slot)
			slot.get_child(slot.get_child_count() - 1).position =  Vector2(32, 28)
			return
