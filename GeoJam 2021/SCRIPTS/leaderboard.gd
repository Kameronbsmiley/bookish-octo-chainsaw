extends Node

var player_template = preload("res://SCENES/leaderboard_player_template.tscn")
onready var mainmenu_tscn = preload("res://SCENES/MainMenu.tscn")

var show_popup: bool = false
var time: float = 0.0

func _ready():
	if show_popup:
		$GameOverPopUp.popup()
		$GameOverPopUp/VBoxContainer/player_time.text = str(time)
		$GameOverPopUp.get_close_button().hide()
	render_screen()

func render_screen():
	#Clear
	var to_be_cleared = $MarginContainer/VBoxContainer/player_container.get_children()
	for item in to_be_cleared:
		item.queue_free()
	
	#Render new
	for score in $"/root/networking".top_scores:
		var player = player_template.instance()
		player.init(score.N, score.T)
		$MarginContainer/VBoxContainer/player_container.add_child(player)

func _on_ok_pressed():
	var player_name = $GameOverPopUp/VBoxContainer/input.text
	print(player_name)
	$"/root/networking".rpc("submit_score", player_name, time, 1)
	$GameOverPopUp.hide()
	render_screen()				

func _on_menu_pressed():
	get_tree().change_scene_to(mainmenu_tscn)
	queue_free()
