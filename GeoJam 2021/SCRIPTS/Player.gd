extends KinematicBody2D


var velocity = Vector2.ZERO
export var acceleration = 5
export var friction = 5
export var gravity = 20
#export var speed = 300
#export var jumpforce = 300
export var big_square = "res://ASSETS/box.png"

onready var tilemap = "../TileMap"

var time_stop: bool = false

enum {
	basic_cube,
	big_cube,
	dash_triangle,
	bouncy_circle
}

var current_shape = basic_cube

func _ready():
	$Sprite.self_modulate = Color.brown

func _physics_process(delta):
	switch_shape()
	match current_shape:
		
		basic_cube:
			movement(20,200,200, delta)
		big_cube:
			velocity += Vector2.DOWN * delta * 200


			var collision = move_and_collide(velocity)
			
			if !collision:
				return
			if collision.collider is TileMap:
				var tile_pos = collision.collider.world_to_map(position)
#				var tile_id = collision.collider.get_cellv(tile_pos)
#				var tile_name = collision.collider.tile_set.tile_get_name(tile_id)
				if collision.collider.get_cellv(tile_pos) == 1:
					$CPUParticles2D.emitting = true
				collision.collider.break_blocks(tile_pos)
				$CPUParticles2D.emitting = true
				
#				print("tile_name")

		dash_triangle:
			velocity.y = 0
			if Input.is_action_pressed("click"):	
				$Sprite.scale = Vector2(2,0.5)
				time_stop = true
			if Input.is_action_just_released("click"):
				time_stop = false
				$Sprite.scale = Vector2(1,1)
				velocity.x = transform.origin.direction_to(get_global_mouse_position()).x * 500

			move_and_slide(velocity, Vector2.UP)

			
		bouncy_circle:
			Input.action_release("left")
			Input.action_release("right")
			Input.action_press("jump")
			movement(10,100,400, delta)





func movement(gravity, speed, jumpforce, delta): # Will take variables based on current switch state
	var hdir = Input.get_action_strength("right") - Input.get_action_strength("left") # Get movement direction (horizontal direction)
	
	velocity.x = hdir * speed
	
	
	
	
	
	velocity.y +=gravity
	
	velocity.y = clamp(velocity.y, -800, 800)
	

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jumpforce
	
	velocity = move_and_slide(velocity, Vector2.UP)
#	print(velocity)


func switch_shape():
	if time_stop == true:
		return
		
	if Input.is_action_just_pressed("switch_1") or (current_shape == dash_triangle and is_on_wall()):
		current_shape = basic_cube
		$Sprite.self_modulate = Color.brown
		scale = Vector2(1,1)
		Input.action_release("jump")
		
	if Input.is_action_just_pressed("switch_2"):
		velocity = Vector2.ZERO
		current_shape = big_cube
		$Sprite.self_modulate = Color.coral
		scale = Vector2(2,2)
		
	if Input.is_action_just_pressed("switch_3"):
		velocity = Vector2.ZERO
		current_shape = dash_triangle
		$Sprite.self_modulate = Color.darkgoldenrod
		scale = Vector2(1,1)
		
	if Input.is_action_just_pressed("switch_4"):
		current_shape = bouncy_circle
		$Sprite.self_modulate = Color.blue
		scale = Vector2(1,1)
