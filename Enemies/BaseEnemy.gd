extends CharacterBody2D

class_name BaseEnemy

@export var idle_speed = 100
@export var chase_speed = 200
@export var damage = 10
@export var health = 100
@export var max_health = 100
@export var knockback_force = 200
@export var loot_table: Dictionary = preload("res://Enemies/ExampleLootTable.gd").LOOT_TABLE_1

var player = null
var attack_timer = Timer.new()

func _ready():
	add_child(attack_timer)
	attack_timer.wait_time = 1.0  # Adjust as needed
	attack_timer.one_shot = true
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	get_node("HealthBar").max_value = max_health
	get_node("HealthBar").value = health

func _process(_delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * chase_speed
		get_node("AttackBase").look_at(player.global_position)
	else:
		velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * idle_speed
	move_and_slide()

func _on_player_detection_area_body_entered(body):
	if body is Hannah:
		player = body

func _on_player_detection_area_body_exited(body):
	if body == player:
		player = null

func _on_attack_area_body_entered(body):
	if body == player:
		attack_timer.start()

func _on_attack_timer_timeout():
	if player:
		player.decrease_health(damage)
		var direction = (player.global_position - global_position).normalized()
		player.knockback(direction * knockback_force)
		attack_timer.start()

func take_damage(amount):
	health -= amount
	get_node("HealthBar").value = health

	
	var damage_label = Label.new()
	damage_label.text = str(amount)
	get_tree().get_first_node_in_group("MainWorld").add_child(damage_label)
	damage_label.modulate = Color.RED
	damage_label.global_position = global_position + Vector2(0, -50)

	var tween = get_tree().create_tween().set_parallel(true)

	tween.tween_property(damage_label, "global_position", global_position + Vector2(0, -100), 1.0).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(damage_label, "modulate.a", 0, 1.0)
	
	tween.chain().tween_callback(damage_label.queue_free)
	
	if health <= 0:
		die()

func knockback(force):
	velocity += force

func die():
	drop_loot()
	call_deferred("queue_free")

func drop_loot():
	for item_path in loot_table.keys():
		var chance = loot_table[item_path]
		if randf() < chance:
			var item = load(item_path).instantiate()
			get_parent().add_child(item)
			item.global_position = global_position
