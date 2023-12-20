extends Hannah

class_name HannahTest

func test_get_global_mouse_position() -> Vector2:
	return Vector2(100, 100) 

func _physics_process(delta):
	
	%ArmBase.look_at(test_get_global_mouse_position())
	
	#Prepare
	var current_speed = speed
	if Input.is_action_pressed("run") and stamina > 0:
		current_speed = current_speed * 2
		
	velocity = direction * current_speed
	
	#Move and check for collision 
	var collision = move_and_collide(velocity * delta)
	
	if Input.is_action_pressed("run"):
		decrease_stamina_when_running(delta)
	elif velocity != Vector2.ZERO:
		decrease_stamina_based_on_weight(delta)
	regenerate_stamina(delta)
	
	update_progress_bars()
	
	if !collision: return
	
	if !collision.get_collider() is BaseItem: return
	if collision.get_collider().interact_state not in [BaseItem.Interact_State.IN_WORLD]: return
	
	#If it's an item, add it to the inventory
	inventory.first_add_item(collision.get_collider())
