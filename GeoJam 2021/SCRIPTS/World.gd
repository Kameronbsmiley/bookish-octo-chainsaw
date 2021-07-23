extends Node2D

signal game_over(player_name, best_time, difficulty)
onready var leaderboard_tscn = preload("res://SCENES/leaderboard.tscn")

var time = 0.0

func _ready():
	for shape in $Shapes.get_children():
		shape.connect("body_entered", $Player, "add_shape")

	#Connect gameover
	$Exit.connect("body_entered", self, "leaderboard")

func leaderboard(_ignore):
	var leaderboard = leaderboard_tscn.instance()
	leaderboard.show_popup = true
	leaderboard.time = time
	#pass time
	get_node("/root").add_child(leaderboard)
	queue_free()

func _process(delta):
	time += delta
	$CanvasLayer/time.text = str(time)


func _on_Area2D_body_entered(body):
	leaderboard(body)
	pass # Replace with function body.
