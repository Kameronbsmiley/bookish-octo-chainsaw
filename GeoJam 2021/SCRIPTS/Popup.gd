extends Node2D

func _process(delta):
	if self.visible == true:
		if Input.is_action_just_pressed("jump"):
			$Button.emit_signal("pressed")
