extends Hannah

class_name HannahTest

func test_get_global_mouse_position() -> Vector2:
	return Vector2(100, 100) 

func _physics_process(delta):
	
	%ArmBase.look_at(test_get_global_mouse_position())
	#Prepare
	velocity = direction * speed
	
	#Move and check for collision 
	var collision = move_and_collide(velocity * delta)
	
	if !collision: return
	
	if !collision.get_collider() is BaseItem: return
	if collision.get_collider().interact_state not in [BaseItem.Interact_State.IN_WORLD]: return
	
	#If it's an item, add it to the inventory
	inventory.first_add_item(collision.get_collider())
