extends BaseItem

class_name BaseEquipment

@export var equipment_properties:EquipmentPropertiesResource
@export var slot_shape:PackedScene
@onready var hannah: Hannah = get_tree().get_first_node_in_group("Hannah")

var equipped_bar
var equipped = false
var bar_sprite


#This stuff could happen when added to inventory but I added it here so it's definitely already available
func _ready():
	var new_shape = slot_shape.instantiate()
	%Slots.add_child(new_shape)
	await get_tree().process_frame
	equipped_bar = get_tree().get_first_node_in_group("EquippedBar")
	bar_sprite = %EquipmentBarSprite


func _process(delta):
	if in_inventory:
		if selected:
			global_position = get_global_mouse_position()
		elif global_position.y >= 648:
			position.y = 0
			position.x = 0
		elif !slotted:
			velocity += Vector2.DOWN * SPEED * delta
			move_and_slide()

func added_to_inventory():
	update_collision()
	super()

func use():
	if equipment_properties.durability > 0:
		pass #rotation, also effect complexity for tools....
		equipment_properties.use()
		position.x += 90

func _input(event):
	if selectable:
		super(event)
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if !event.pressed and are_all_slots_free():
				#It would be nice if the equipment didn't have to care about this equipped bar stuff.
				for slot in equipped_bar.get_children():
					if slot.get_child_count() == 0:
						bar_sprite.visible = true
						bar_sprite.reparent(slot)
						slot.get_child(slot.get_child_count() - 1).position =  Vector2(32, 28)
						return
			elif event.pressed:
				for slot in equipped_bar.get_children():
					if slot.get_child(0) == bar_sprite:
						bar_sprite.reparent(self)
						bar_sprite.visible = false
						if slot.get_child_count() > 0:
							slot.get_child(0).queue_free()
							slot.get_parent().get_parent().get_parent().get_parent().current_slot = 0
							hannah.unequip_item(self)
						return

func update_collision():
	var new_shape = slot_shape.instantiate()
	if "shape" in new_shape:
		%CharShape.shape = new_shape.shape.duplicate()
	else:
		%CharShape.queue_free()
		add_child(new_shape)
