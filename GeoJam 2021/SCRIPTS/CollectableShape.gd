extends Area2D

export var sprite = preload("res://ASSETS/box.png")

func _ready():
	self.connect("body_entered", self, "collected")

func _process(delta):
	$ShapeSprite.texture = sprite

func collected(body):
	queue_free()
	body.shape_popup(body.current_shape_list)
