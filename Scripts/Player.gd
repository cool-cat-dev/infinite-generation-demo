extends CharacterBody2D

const SPEED = 600.0

@onready var sprite = $AnimatedSprite2D  # Ensure you have an AnimatedSprite2D node as a child

func _physics_process(delta):
	var input_vector = Vector2.ZERO

	# Get movement input
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1

	# Normalize to avoid diagonal speed boost
	input_vector = input_vector.normalized()

	# Apply movement
	velocity = input_vector * SPEED
	move_and_slide()

	# Handle animations
	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			sprite.play("right")
		elif input_vector.x < 0:
			sprite.play("left")
		elif input_vector.y > 0:
			sprite.play("down")
		elif input_vector.y < 0:
			sprite.play("up")
	else:
		sprite.stop()
