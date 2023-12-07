extends Control

class_name DayoverUI

signal next_day_UI_finished

@onready var tween
@onready var timer = %Timer
@onready var nextDay = %NextDay
@onready var background = %Background

func _ready():
	timer.timeout.connect(_on_timer_timeout)

func day_timeout():
	visible = true
	manage_tween()
	tween.tween_property(background, "modulate", Color(0, 0, 0, 1), 1)
	tween.play()
	timer.start(1)

func _on_next_day_pressed():
	nextDay.visible = false
	manage_tween()
	tween.tween_property(background, "modulate", Color(0, 0, 0, 0), 1)
	tween.play()
	timer.start(1)

func _on_timer_timeout():
	if background.modulate.a < 1:
		nextDay.visible = false
		visible = false
		emit_signal("next_day_UI_finished")
	else:
		nextDay.visible = true

func manage_tween():
	if tween:
		tween.kill()
	tween = create_tween()
