extends CharacterBody2D

const SPRINT_SPEED = 500.0
const CROUCH_SPEED = 120.0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_attacking =false
var is_blocking =false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	handle_combat()

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_attacking and not Input.is_action_pressed("crouch"):
		velocity.y = JUMP_VELOCITY

	var current_speed = SPEED

	if Input.is_action_pressed("sprint") and is_on_floor() and not is_blocking:
		current_speed= SPRINT_SPEED
	elif Input.is_action_pressed("crouch") and is_on_floor():
		current_speed = CROUCH_SPEED
	elif is_blocking:
		current_speed = CROUCH_SPEED / 2

	
	var direction := Input.get_axis("left", "right")
	
	if is_attacking and is_on_floor():
		velocity.x= move_toward(velocity.x, 0, SPEED)
	elif direction:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
	
	

	move_and_slide()

func handle_combat():
	if Input.is_action_pressed("block") and not is_attacking:
		is_blocking = true
	else:
		is_blocking= false
		
	if Input.is_action_just_pressed("attack") and not is_blocking and not is_attacking:
		is_attacking = true
		print("удар кинжалом")
		
		await get_tree().create_timer(0.3).timeout
		is_attacking = false
