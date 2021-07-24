extends KinematicBody2D



var velocity = Vector2.ZERO
export var acceleration = 5
export var friction = 5
export var gravity = 20
var dead = false
#export var speed = 300
#export var jumpforce = 300
export var basic_cube_sprite = preload("res://ASSETS/box.png")
export var dash_triangle_sprite = preload("res://ASSETS/Triangle.png")
export var bouncy_circle_sprite = preload("res://ASSETS/Circle.png")

onready var next_shape = $next_shape
onready var previous_shape = $previous_shape

onready var tilemap = "../TileMap"

var checkpoint: Checkpoint
var time_stop: bool = false
var can_switch: bool = true

enum {
	basic_cube,
	bouncy_circle,
	dash_triangle,
	big_cube
}
signal died

var current_shape_list = 0

var current_shape = basic_cube

func _ready():
	$Sprite.self_modulate = Color8(171, 13, 31)
	next_shape.visible = false
	previous_shape.visible = false
	$Camera2D.pause_mode = Node.PAUSE_MODE_PROCESS

func _physics_process(delta):
	switch_shape()


	match current_shape:

		basic_cube:
			can_switch = true
			$Camera2D.offset_v = -0.3
			$Sprite.rotation_degrees = 0
			$Sprite.texture = basic_cube_sprite
			$Sprite.self_modulate = Color8(171, 13, 31)
			scale = Vector2(1,1)
			movement(10,150,200, delta)
			
			previous_shape.visible = false
			if current_shape_list > 0:
				if !is_on_floor():
					can_switch = true
					next_shape.visible = true
					next_shape.self_modulate = Color8(0, 118, 122)
					next_shape.texture = bouncy_circle_sprite
				else: 
					next_shape.visible = false
					can_switch = false
					

		bouncy_circle:
			$Camera2D.offset_v = 0
			$Sprite.texture = bouncy_circle_sprite
			$Sprite.self_modulate = Color8(0, 118, 122)
			scale = Vector2(1,1)
			Input.action_press("jump")
			movement(10,0,400, delta)
			
			previous_shape.visible = true
			previous_shape.self_modulate = Color8(171, 13, 31)
			previous_shape.texture = basic_cube_sprite
			if current_shape_list > 1:
				next_shape.visible = true
				next_shape.self_modulate = Color8(215, 133, 33)
				next_shape.texture = dash_triangle_sprite
			else: next_shape.visible = false

		dash_triangle:
			$Camera2D.offset_v = 0
			$Sprite.rotation_degrees = 0
			$Sprite.texture = dash_triangle_sprite
			$Sprite.self_modulate = Color8(215, 133, 33)
			scale = Vector2(1,1)
			Input.action_release("jump")
			
			previous_shape.visible = true
			previous_shape.self_modulate = Color8(0, 118, 122)
			previous_shape.texture = bouncy_circle_sprite
			
			if current_shape_list > 2:
				next_shape.visible = true
				next_shape.self_modulate = Color8(30, 66, 16)
				next_shape.texture = basic_cube_sprite
			else: next_shape.visible = false
			
			velocity.y = 0
			if Input.is_action_pressed("click"):
				$Sprite.scale = Vector2(1.5,0.5)
				if global_position.x > get_global_mouse_position().x:
					$Sprite.rotation_degrees = 270
				else:
					$Sprite.rotation_degrees = 90
				time_stop = true
			if Input.is_action_just_released("click"):
				time_stop = false
				$DashSound.play()
				$Sprite.scale = Vector2(1,1)
				velocity.x = transform.origin.direction_to(get_global_mouse_position()).x * 500
			# Switches back to cube if hitting a wall as triangle
			if is_on_wall():
				current_shape = basic_cube
			move_and_slide(velocity, Vector2.UP)

		big_cube:
			$Camera2D.offset_v = -0.3
			$Sprite.rotation_degrees = 0
			$Sprite.texture = basic_cube_sprite
			$Sprite.self_modulate = Color8(30, 66, 16)
			scale = Vector2(2,2)
			velocity += Vector2.DOWN * delta * 200
			previous_shape.visible = false
			next_shape.visible = false
			var collision = move_and_collide(velocity)
			if !collision:
				return
			if collision.collider is TileMap:
				var tile_pos = collision.collider.world_to_map(position)
#				var tile_id = collision.collider.get_cellv(tile_pos)
#				var tile_name = collision.collider.tile_set.tile_get_name(tile_id)
				if collision.collider.get_cellv(tile_pos) == 1:
					$CPUParticles2D.emitting = true
					$BreakBlockSound.play()
				collision.collider.break_blocks(tile_pos)

				$CPUParticles2D.emitting = true
				can_switch = false
				Input.action_release("jump")
			yield(get_tree().create_timer(0.5),"timeout")

			current_shape = basic_cube
			can_switch = true
			



func movement(gravity, speed, jumpforce, delta): # Will take variables based on current switch state
	if !dead:
		var hdir = Input.get_action_strength("right") - Input.get_action_strength("left") # Get movement direction (horizontal direction)
		
		velocity.x = hdir * speed
		velocity.y += gravity
		velocity.y = clamp(velocity.y, -800, 800)
		
		
		if is_on_floor() and Input.is_action_just_pressed("jump"):
			velocity.y = -jumpforce
			if current_shape == basic_cube or current_shape == bouncy_circle:
				$PlayerAnimation.play("CubeJump")
				$JumpSound.play()
			
		if is_on_floor() and velocity.x != 0:
			$Dust.emitting = true
#			if current_shape == basic_cube:
#				$PlayerAnimation.play("CubeWalk")
		velocity = move_and_slide(velocity, Vector2.UP)

func switch_shape():
#	if time_stop == true:
#		return


	var switched = false

		
	if Input.is_action_just_pressed("switch_previous") and can_switch:
		current_shape -= 1
		switched = true
		$PlayerAnimation.play("Switch")
		$SwitchSound.play()
	if Input.is_action_just_pressed("switch_next") and can_switch:
		current_shape += 1
		switched = true
		$PlayerAnimation.play("Switch")
		$SwitchSound.play()
	if !switched:
		return

	if current_shape == basic_cube:
		Input.action_release("jump")
#	if current_shape == bouncy_circle:
#		velocity.y = -400

	
		
	if current_shape == 3:
		velocity = Vector2.ZERO

	current_shape = clamp(current_shape, 0, current_shape_list)


func add_shape(_arg):
	current_shape_list += 1
	shape_popup(current_shape_list)

func die():
	can_switch = false
	dead = true
	emit_signal("died")
	$PlayerAnimation.play("Death")
	$DeathSound.play()
	$CanvasLayer/AnimationPlayer.play("Death")
	yield(get_tree().create_timer(0.75), "timeout")
	if checkpoint != null:
		respawn(checkpoint.global_position)
	dead = false
	current_shape = basic_cube
	can_switch = true
	
func respawn(checkpoint_pos):
	self.position = checkpoint_pos

func shape_popup(shape_to_show):
	match shape_to_show:
		
		1:
			$CanvasLayer/CirclePopup.visible = true
			get_tree().paused = true
		2:
			$CanvasLayer/TrianglePopup.visible = true
			get_tree().paused = true
		3:
			$CanvasLayer/CubePopup.visible = true
			get_tree().paused = true

func _on_Area2D_body_entered(body):
	if body.is_in_group("spike"):
		die()




func _on_PlayerAnimation_animation_finished(anim_name):
	if anim_name != "idle":
		$PlayerAnimation.play("idle")
