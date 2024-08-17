extends CharacterBody2D


var SPEED = 130.0
var JUMP_VELOCITY = -250.0
var taille = 2
var monde = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY - (taille * 50 + 1)

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	#changement de taille
	if Input.is_action_just_pressed("Grandir") and taille < 4:
		$AnimatedSprite2D.scale.y *= 2
		$CollisionShape2D.scale.y *= 2
		$AnimatedSprite2D.position.y += -11
		$CollisionShape2D.position.y += -11
		taille += 1
	
	if Input.is_action_just_pressed("Rapeticir") and taille > 0:
		$AnimatedSprite2D.scale.y *= 0.5 
		$CollisionShape2D.scale.y *= 0.5
		$AnimatedSprite2D.position.y += 11
		$CollisionShape2D.position.y += 11
		taille += -1
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	# Apply movement
	if direction:
		velocity.x = direction * (SPEED + (80-taille*20)) 
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
