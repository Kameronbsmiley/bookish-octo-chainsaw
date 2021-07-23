extends Node2D

signal game_over(player_name, best_time, difficulty)
onready var leaderboard_tscn = preload("res://SCENES/leaderboard.tscn")

var time = 0.0
var player_deaths = 0

func _ready():
	for shape in $Shapes.get_children():
		shape.connect("body_entered", $Player, "add_shape")

	#Connect gameover
	$Exit.connect("body_entered", self, "leaderboard")
	#Connect death  count
	$Player.connect("died", self, "_on_player_died")

func leaderboard(_ignore):
	var leaderboard = leaderboard_tscn.instance()
	leaderboard.show_popup = true
	leaderboard.time = time
	leaderboard.deaths = player_deaths
	#pass time
	get_node("/root").add_child(leaderboard)
	queue_free()

func _process(delta):
	time += delta
	$CanvasLayer/Time.text = "Time: " + str("%.1f" % time)


func _on_Area2D_body_entered(body):
	leaderboard(body)
	pass # Replace with function body.

func _on_player_died():
	player_deaths += 1
	$CanvasLayer/Deaths.text = "Deaths: " + str(player_deaths)
