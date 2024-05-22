extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -250.0
const wall_jump_pushback = 500.0
var is_wall_sliding = true
var jump_count = 0
var max_jumps = 2
var Jump_Available: bool = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var coyote_timer = $Coyote_Timer
@export var Coyote_Time: float = 0.2

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	if is_on_floor():
		jump_count = 0
		if Jump_Available:
			if coyote_timer.is_stopped():
				coyote_timer.start(Coyote_Time)
			#get_tree().create_timer(Coyote_Time).timeout.connect(Coyote_Timeout)
		
	else:
		Jump_Available = true
		coyote_timer.stop()
	
	
	if Input.is_action_just_pressed("Jump") and jump_count < max_jumps and Jump_Available:
		velocity.y = JUMP_VELOCITY
		Jump_Available = false
		jump_count += 1
		
		
	handle_jump()

	
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("Idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func handle_jump():
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		if is_on_wall() and Input.is_action_pressed("move_right"):
			velocity.y = JUMP_VELOCITY
			velocity.x = --wall_jump_pushback
		if is_on_wall() and Input.is_action_pressed("move_left"):
			velocity.y = JUMP_VELOCITY
			velocity.x = wall_jump_pushback
		
func Coyote_Timeout():
	Jump_Available = false
