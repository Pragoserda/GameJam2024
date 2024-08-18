extends CharacterBody2D


var SPEED = 130.0
var JUMP_VELOCITY = -250.0
var taille = 2
var monde = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape_node = $CollisionShape2D

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
		#$AnimatedSprite2D.position.y += -11
		#$CollisionShape2D.position.y += -11
		#$AnimatedSprite2D.scale.y *= 2
		#$CollisionShape2D.scale.y *= 2		
		adjust_size(2)
		taille += 1
	
	if Input.is_action_just_pressed("Rapeticir") and taille > 0:
		#$AnimatedSprite2D.position.y += 11
		#$CollisionShape2D.position.y += 11
		#$AnimatedSprite2D.scale.y *= 0.5 
		#$CollisionShape2D.scale.y *= 0.5	
		adjust_size(0.5)	
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
	
func adjust_size(scale_factor):
	if collision_shape_node.shape is CapsuleShape2D:
		var collision_shape = collision_shape_node.shape as CapsuleShape2D
		var current_bottom_y = position.y + collision_shape.height/2 + collision_shape.radius
		animated_sprite.scale.y *= scale_factor
		collision_shape.height *= scale_factor
		collision_shape.radius *= scale_factor
		position.y = current_bottom_y - (collision_shape.height/2 + collision_shape.radius)
	else : 
		print("Erreur : La forme de collision n'est pas une capsule")
