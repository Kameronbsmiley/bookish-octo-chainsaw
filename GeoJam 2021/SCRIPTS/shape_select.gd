extends VBoxContainer



var current_shape = 0
export var basic_cube_sprite = preload("res://ASSETS/box.png")
export var bouncy_circle_sprite = preload("res://ASSETS/Circle.png")
export var dash_triangle_sprite = preload("res://ASSETS/Triangle.png")



var shapes = [{"shape": basic_cube_sprite, "color": Color.brown},
{"shape": bouncy_circle_sprite, "color": Color.blue},
{"shape": dash_triangle_sprite, "color": Color.darkgoldenrod},
{"shape": basic_cube_sprite, "color": Color.saddlebrown}]

func _ready():
	$MarginContainer/shape_select/.get_child(current_shape).modulate = shapes[current_shape].color
	
func _process(delta):
	if Input.is_action_just_pressed("switch_next"):
		$MarginContainer/shape_select/.get_child(current_shape).modulate = Color.white
		current_shape += 1
		current_shape = clamp(current_shape, 0, len(shapes) - 1)
		$MarginContainer/shape_select/.get_child(current_shape).modulate = shapes[current_shape].color
	if Input.is_action_just_pressed("switch_previous"):
		$MarginContainer/shape_select/.get_child(current_shape).modulate = Color.white
		current_shape -= 1
		current_shape = clamp(current_shape, 0, len(shapes) - 1)
		$MarginContainer/shape_select/.get_child(current_shape).modulate = shapes[current_shape].color
	if current_shape == 0:
		$shape_select/Q.hide()
		$shape_select/empty.show()
	else:
		$shape_select/Q.show()
		$shape_select/empty.hide()
	if current_shape == 3:
		$shape_select/E.hide()
		$shape_select/empty2.show()
	else:
		$shape_select/E.show()
		$shape_select/empty2.hide()
