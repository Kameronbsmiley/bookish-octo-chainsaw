extends Node2D


func _ready():
	for shape in $Shapes.get_children():
		shape.connect("body_entered", $Player, "add_shape")
	
