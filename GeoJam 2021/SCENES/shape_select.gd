extends HBoxContainer



var current_shape = 0
export var basic_cube_sprite = preload("res://ASSETS/box.png")
export var bouncy_circle_sprite = preload("res://ASSETS/Circle.png")
export var dash_triangle_sprite = preload("res://ASSETS/Triangle.png")



var shapes = [{"shape": basic_cube_sprite, "color": Color.brown},
{"shape": bouncy_circle_sprite, "color": Color.blue},
{"shape": dash_triangle_sprite, "color": Color.darkgoldenrod},
{"shape": basic_cube_sprite, "color": Color.saddlebrown}]

func _ready():
	$shape.texture = shapes[current_shape].shape
	$shape.modulate = shapes[current_shape].color

func _process(delta):
	if Input.is_action_just_pressed("switch_next"):
		current_shape += 1
		current_shape = clamp(current_shape, 0, len(shapes) - 1)
		$shape.texture = shapes[current_shape].shape
		$shape.modulate = shapes[current_shape].color
	if Input.is_action_just_pressed("switch_previous"):
		current_shape -= 1
		current_shape = clamp(current_shape, 0, len(shapes) - 1)
		$shape.texture = shapes[current_shape].shape
		$shape.modulate = shapes[current_shape].color

