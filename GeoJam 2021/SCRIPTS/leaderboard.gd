extends Node

var player_template = preload("res://SCENES/leaderboard_player_template.tscn")
onready var mainmenu_tscn = preload("res://SCENES/MainMenu.tscn")

var show_popup: bool = false
var time: float = 0.0
var deaths: int = 0

func _ready():
	if show_popup:
		$FinishSound.play()
		$GameOverPopUp.popup()
		$GameOverPopUp/VBoxContainer/time.text = "time: " + str("%.1f" % time)
		$GameOverPopUp/VBoxContainer/deaths.text = "deaths: " + str(deaths)
		$GameOverPopUp.get_close_button().hide()
	render_screen()

func render_screen():
	#Clear
	var to_be_cleared = $MarginContainer/VBoxContainer/ScrollContainer/player_container.get_children()
	for item in to_be_cleared:
		item.queue_free()
	
	var top_scores = $"/root/networking".top_scores
	#Render new
	for index in range(top_scores.size()):
		var player = player_template.instance()
		player.init(index, top_scores[index].N, top_scores[index].T, top_scores[index].D)
		$MarginContainer/VBoxContainer/ScrollContainer/player_container.add_child(player)

func _on_ok_pressed():
	var player_name = $GameOverPopUp/VBoxContainer/input.text
	print("Submiting score", player_name, " ", time)
	$"/root/networking".rpc("submit_score", player_name, time, deaths)
	$GameOverPopUp.hide()
	yield(get_tree().create_timer(1),"timeout")
	render_screen()				

func _on_menu_pressed():
	get_tree().change_scene_to(mainmenu_tscn)
	queue_free()
