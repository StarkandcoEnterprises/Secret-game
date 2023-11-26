extends Resource

class_name ItemResource

@export var price: int = 100
@export var size: Vector2 = Vector2i(1,1)

@export var equipment_properties: EquipmentPropertiesResource = null
@export var abstract_properties: AbstractPropertiesResource = null

#Some stuff for crafting might go here
#E.g. Groups of resources could be used for crafting rather than specific items all the time
