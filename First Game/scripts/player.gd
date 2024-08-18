extends CharacterBody2D


var SPEED = 130.0
var JUMP_VELOCITY = -250.0

var taille = 2
var monde = 1
var input_string = ""

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

@onready var collision_shape_node = $CollisionShape2D

@onready var timer = $LabelKey/Timer



func check_input_string():
	match input_string:
		"BONJOUR":
			print("Bonjour détecté !")
			# Ajouter l'effet correspondant
		"AUREVOIR":
			print("Au revoir détecté !")
		# Ajouter l'effet correspondant
		"BN":
			print("BN détecté !")
	if input_string :
		timer.start()



func _input(event):
	if not is_on_floor() or not is_on_wall() or not is_on_ceiling():
		if event is InputEventKey and event.pressed:
			var key = event.as_text_key_label()
			if key != "Q" and key != "D" and key != "Space" and key != "S" and key != "Z" and key != "Left" and key != "Right" and key != "Up" and key != "Down":  # Exclure les touches de déplacement
				input_string += key
				$LabelKey.text = input_string
				
func _physics_process(delta):

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
		
	if is_on_wall() or is_on_ceiling() or is_on_floor():
		check_input_string()
		input_string = ""
		
	if monde == 3:
		var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = direction * SPEED
		if direction.x > 0:
			animated_sprite.flip_h = false
		elif direction.x < 0:
			animated_sprite.flip_h = true

			
	if monde == 1 or monde == 2:
				# Get the input direction: -1, 0, 1
		var direction = Input.get_axis("move_left", "move_right")
			# Flip the Sprite
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
			
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY - (taille * 50 + 1)
			
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
		#collision_shape.radius *= scale_factor
		position.y = current_bottom_y - (collision_shape.height/2 + collision_shape.radius)
	else : 
		print("Erreur : La forme de collision n'est pas une capsule")



func _on_timer_timeout() -> void:
	input_string = ""
	$LabelKey.text = input_string # Replace with function body.
