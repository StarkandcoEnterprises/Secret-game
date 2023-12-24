extends CharacterBody2D

class_name BaseEnemy

@export var idle_speed = 100
@export var chase_speed = 200
@export var damage = 10
@export var health = 100
@export var max_health = 100
@export var knockback_force = 200

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
	if health <= 0:
		die()

func knockback(force):
	velocity += force

func die():
	queue_free()
