extends Control

class_name DayoverUI

signal next_day_UI_finished

@onready var tween
@onready var timer = %Timer
@onready var nextDay = %NextDay
@onready var background = %Background
#

func day_timeout():
	visible = true
	manage_tween()
	tween.tween_property(background, "modulate", Color(0, 0, 0, 1), 1)
	tween.play()
	await get_tree().create_timer(1).timeout
	handle_transitions()

func _on_next_day_pressed():
	nextDay.visible = false
	manage_tween()
	tween.tween_property(background, "modulate", Color(0, 0, 0, 0), 1)
	tween.play()
	await get_tree().create_timer(1).timeout
	handle_transitions()

func handle_transitions():
	if background.modulate.a < 0.7:
		nextDay.visible = false
		visible = false
		emit_signal("next_day_UI_finished")
	else:
		nextDay.visible = true

func manage_tween():
	if tween:
		tween.kill()
	tween = create_tween()
