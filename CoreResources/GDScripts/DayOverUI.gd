extends Control

class_name DayoverUI

signal next_day_UI_finished

func day_timeout():
	visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(%Background, "modulate", Color(0,0,0,1), 1)
	tween.play()
	
	var timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.start()
	
	await timer.timeout
	%NextDay.visible = true
	remove_child(timer)


func _on_next_day_pressed():
	%NextDay.visible = false
	
	var tween = get_tree().create_tween()
	tween.tween_property(%Background, "modulate", Color(0,0,0,0), 1)
	tween.play()
	
	var timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.start()
	
	await timer.timeout
	remove_child(timer)
	visible = false
	next_day_UI_finished.emit()
