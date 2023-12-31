extends BaseItem

class_name BaseEquipment

@export var equipment_properties:EquipmentPropertiesResource
@onready var hannah: Hannah = get_tree().get_first_node_in_group("Hannah")

var equipped_bar
var equipped_slot
var bar_sprite
var durability_bar

var in_use = false

#This stuff could happen when added to inventory but I added it here so it's definitely already available
func _ready():
	super()
	equipped_bar = get_tree().get_first_node_in_group("EquippedBar")
	bar_sprite = %EquipmentBarSprite
	durability_bar = %DurabilityBar

func _process(delta):
	super(delta)
	durability_bar.value = equipment_properties.durability
	if interact_state != Interact_State.EQUIPPED: return
		
	if equipment_properties.durability <= 0 and equipment_properties.discarded_on_use:
		hannah.unequip_held()
		deslot()
		if hannah.inventory.current_slot != 0:
			hannah.weight -= item_properties.weight
			equipped_bar.get_child(hannah.inventory.current_slot - 1).get_child(1).queue_free()
		
		hannah.inventory.current_slot = 0
		
		bar_sprite.call_deferred("queue_free")
		call_deferred("queue_free")

func use():
	if in_use or equipment_properties.durability <= 0: return
	equipment_properties.use()

func _unhandled_input(event):
	
	if !event is InputEventMouseButton: return
	
	super(event)
	if interact_state != Interact_State.SLOTTED_SELECTABLE and interact_state != Interact_State.SELECTED: return
	
	
	if event.button_index != MOUSE_BUTTON_LEFT: return
	
	if event.pressed:
		#Try and unslot ourselves, nasty business
		#Get our bar sprite back
		if !equipped_slot: return
		
		bar_sprite.reparent(self)
		bar_sprite.visible = false
		
		durability_bar.reparent(self)
		durability_bar.visible = false
		
		#Tell the inventory? That the current slot is 0 lol
		hannah.inventory.current_slot = 0
	
		#Need to also possibly remove the reference rect....
		if equipped_slot.get_child_count() > 0:
			equipped_slot.get_child(0).call_deferred("queue_free")
			
		equipped_slot = null
		
		if hannah: hannah.unequip_held()

	else:
		#Slot ourselves
		#It would be nice if the equipment didn't have to care about this equipped bar stuff.
		for equip_slot in equipped_bar.get_children():
			
			if equip_slot.get_child_count() != 0: continue
			
			equipped_slot = equip_slot
			
			durability_bar.visible = true
			bar_sprite.visible = true
			
			durability_bar.reparent(bar_sprite)
			bar_sprite.reparent(equip_slot)
			
			bar_sprite.rotation_degrees = 0
			
			equip_slot.get_child(equip_slot.get_child_count() - 1).position =  Vector2(32, 28)
			return
