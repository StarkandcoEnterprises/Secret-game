extends WorldObjectStatic

@export var fruit_scene: PackedScene

func grow_overnight():
	if randf() > 0.3:
		grow_fruit()

func grow_fruit():
	var fruit = fruit_scene.instantiate()
	fruit.get_node("%ItemCharShape").disabled = true
	%FruitMarker.add_child(fruit)

func interact():
	super()
	for child in %FruitMarker.get_children():
		child.is_loose = true
		child.get_node("%ItemCharShape").disabled = false
