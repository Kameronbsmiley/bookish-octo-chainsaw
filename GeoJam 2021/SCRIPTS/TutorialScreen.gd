extends Control


onready var basic_cube = $Control/BasicCube
onready var bouncy_circle = $Control/BouncyCircle
onready var dash_triangle = $Control/DashTriangle
onready var big_square = $Control/BigSquare
onready var basic_controls = $Control/BasicControls
onready var play_button = $Play

var current_page = 0

func _ready():
	yield(get_tree().create_timer(1),"timeout")
	$AnimationPlayer.play_backwards("Transition")
	play_button.visible = false

func _process(delta):
	current_page = clamp(current_page, 0, 5)

	match current_page:

		0:
			basic_cube.visible = false
			bouncy_circle.visible = false
			dash_triangle.visible = false
			big_square.visible = false
			basic_controls.visible = true

		1:
			
			basic_cube.visible = true
			bouncy_circle.visible = false
			basic_controls.visible = false

		2:
			basic_cube.visible = false
			bouncy_circle.visible = true
			dash_triangle.visible = false

		3:
			bouncy_circle.visible = false
			dash_triangle.visible = true
			big_square.visible = false

		4:
			dash_triangle.visible = false
			big_square.visible = true
			play_button.visible = false
		5:
			big_square.visible = false
			play_button.visible = true

func _on_Next_pressed():
	current_page += 1


func _on_Previous_pressed():
	current_page -= 1


func _on_Skip_pressed():
	get_tree().change_scene("res://SCENES/World.tscn")


func _on_Play_pressed():
	get_tree().change_scene("res://SCENES/World.tscn")

