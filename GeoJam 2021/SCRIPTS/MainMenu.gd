extends Control

onready var leaderboard_tscn = load("res://SCENES/leaderboard.tscn")

var tut: bool = true

func _ready():
	$leaderboard.visible = true

func _on_Button_pressed():
	$Control/AnimationPlayer.play("Transition")
	$leaderboard.visible = false
	yield(get_node("Control/AnimationPlayer"),"animation_finished")
	if tut:
		get_tree().change_scene("res://SCENES/TutorialScreen.tscn")
		tut = false
	else:
		get_tree().change_scene("res://SCENES/World.tscn")

func _on_leaderboard_pressed():
	var leaderboard = leaderboard_tscn.instance()
	get_node("/root").add_child(leaderboard)
	queue_free()

