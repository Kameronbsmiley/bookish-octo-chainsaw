extends AnimationPlayer

signal halfway_done

func _process(delta):
	if self.current_animation_position == 0.7:
		emit_signal("halfway_done")
		print("half")
	
