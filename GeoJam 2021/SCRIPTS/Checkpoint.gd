class_name Checkpoint
extends Area2D

var is_active = false setget set_is_active
var can_play_effect = true
func _ready():
	self.connect("body_entered", self, "new_checkpoint")

func new_checkpoint(body):
	if body.checkpoint:
		body.checkpoint.is_active = false
	
	body.checkpoint = self
	self.is_active = true
	

func set_is_active(value):
	is_active = value
	if is_active:
		$flag.modulate = Color.darkred
		if can_play_effect:
			$CPUParticles2D.emitting = true
			$CheckpointSound.play()
		can_play_effect = false
	else:
		$flag.modulate = Color.white
