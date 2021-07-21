class_name Checkpoint
extends Area2D

var is_active = false setget set_is_active

func _ready():
	self.connect("body_entered", self, "new_checkpoint")


func new_checkpoint(body):
	if body.checkpoint:
		body.checkpoint.is_active = false
	body.checkpoint = self
	self.is_active = true

# If player's active checkpoint is NOT me: I is_active should become false
#func check_active(checkpoint_position):
#	if is_active:
#		is_active = false
#		$flag.modulate = Color.white
#	print(checkpoint_position)


func set_is_active(value):
	is_active = value
	if is_active:
		$flag.modulate = Color.darkred
		$CPUParticles2D.emitting = true
	else:
		$flag.modulate = Color.white
