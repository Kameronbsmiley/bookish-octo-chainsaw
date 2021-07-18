extends KinematicBody2D


var velocity = Vector2.ZERO
export var acceleration = 5
export var friction = 5
export var gravity = 20
#export var speed = 300
#export var jumpforce = 300
export var big_square = "res://ASSETS/box.png"

enum {
	basic_cube,
	big_cube,
	dash_triangle,
	bouncy_circle
}

var current_shape = basic_cube


func _physics_process(delta):
	switch_shape()
	match current_shape:
		
		basic_cube:
			movement(300,200,150, delta)
		big_cube:
			movement(800,50,0, delta)



func movement(gravity, speed, jumpforce, delta): # Will take variables based on current switch state
	var hdir = Input.get_action_strength("right") - Input.get_action_strength("left") # Get movement direction (horizontal direction)
	velocity.x = hdir * speed
	
	velocity.y += gravity * delta
#	velocity.y = clamp(velocity.y, -300, 300)
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jumpforce
	move_and_slide(velocity, Vector2.UP)


func switch_shape():
	if Input.is_action_just_pressed("switch_1"):
		current_shape = basic_cube
		modulate = Color.black
		scale = Vector2(1,1)
	if Input.is_action_just_pressed("switch_2"):
		current_shape = big_cube
		scale = Vector2(2,2)
	if Input.is_action_just_pressed("switch_3"):
		current_shape = dash_triangle
	if Input.is_action_just_pressed("switch_4"):
		current_shape = bouncy_circle
