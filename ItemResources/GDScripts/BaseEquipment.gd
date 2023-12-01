extends BaseItem

class_name BaseEquipment

@export var equipment_properties:EquipmentPropertiesResource
@onready var hannah: Hannah = get_tree().get_first_node_in_group("Hannah")

var equipped_bar
var bar_sprite
var in_use = false

#This stuff could happen when added to inventory but I added it here so it's definitely already available
func _ready():
	await get_tree().process_frame
	equipped_bar = get_tree().get_first_node_in_group("EquippedBar")
	bar_sprite = %EquipmentBarSprite
	

func use():
	var debug = equipment_properties.durability
	if in_use or equipment_properties.durability <= 0: return
	equipment_properties.use()
	
	var tween_rotation
	tween_rotation = 90 if get_parent().name == "RightHand" else -90 if get_parent().name == "LeftHand" else 0
	in_use = true
	var tween = get_tree().create_tween()
	tween.tween_property(get_parent().get_parent(), "rotation_degrees", tween_rotation, 0.3)
	tween.tween_property(get_parent().get_parent(), "rotation_degrees", 0, 0)
	tween.tween_property(self, "in_use", false, 0)
	tween.play()

func _unhandled_input(event):
	if interact_state == Interact_State.IN_WORLD: return
	super(event)
	
	if !event is InputEventMouseButton: return
	if event.button_index != MOUSE_BUTTON_LEFT: return
	
	if event.pressed:
		#Try and unslot ourselves, nasty business
		for equip_slot in equipped_bar.get_children():
			
			if equip_slot.get_child_count() == 0: continue
			if equip_slot.get_child(0) != bar_sprite: continue
			
			#Get our bar sprite back
			bar_sprite.reparent(self)
			bar_sprite.visible = false
			
			#Tell the inventory? That the current slot is 0 lol
			equip_slot.get_parent().get_parent().get_parent().get_parent().current_slot = 0
			if hannah: hannah.unequip_held()
			#Need to also possiblyf remove the reference rect....
			if equip_slot.get_child_count() > 0:
				equip_slot.get_child(0).queue_free()
			return
	
	elif are_all_slots_free():
		#Slot ourselves
		#It would be nice if the equipment didn't have to care about this equipped bar stuff.
		for equip_slot in equipped_bar.get_children():
			
			if equip_slot.get_child_count() != 0: continue
			
			bar_sprite.visible = true
			bar_sprite.reparent(equip_slot)
			equip_slot.get_child(equip_slot.get_child_count() - 1).position =  Vector2(32, 28)
			return
