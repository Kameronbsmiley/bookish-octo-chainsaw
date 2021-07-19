extends Node2D

export var level_switch = "res://SCENES/Test.tscn"



func _on_Exit_body_entered(body):
	get_tree().change_scene(level_switch)
