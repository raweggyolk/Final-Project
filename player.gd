extends CharacterBody2D


const SPEED = 130.0
const ACCELERATION = 400.0
const FRICTION = 1000.0
const JUMP_VELOCITY = -300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var coyote_timer = $CoyoteTimer


func _physics_process(delta):
	apply_gravity(delta)
	handle_jump()
	var input_axis = Input.get_axis("move_left", "move_right")
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	move_and_slide()
	

	var was_on_floor = is_on_floor()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_timer.start()
	
	if input_axis > 0:
		animated_sprite.flip_h = false
	elif input_axis < 0:
		animated_sprite.flip_h = true
		
	if is_on_floor():
		if input_axis == 0:
			animated_sprite.play("Idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
func handle_jump():
	if is_on_floor():
		if Input.is_action_just_pressed("Jump"):
			velocity.y = JUMP_VELOCITY
	
	else:
		if Input.is_action_just_released("Jump") and velocity.y < JUMP_VELOCITY / 2:
			velocity.y =JUMP_VELOCITY / 2
			
func handle_acceleration(input_axis, delta):
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
			
func apply_friction(input_axis, delta):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
