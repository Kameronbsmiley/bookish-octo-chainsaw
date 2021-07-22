extends Control

onready var leaderboard_tscn = load("res://SCENES/leaderboard.tscn")

func _on_Button_pressed():
	get_tree().change_scene("res://SCENES/World.tscn")

func _on_leaderboard_pressed():
	var leaderboard = leaderboard_tscn.instance()
	get_node("/root").add_child(leaderboard)
	queue_free()

