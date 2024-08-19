extends CharacterBody2D

var SPEED = 130.0
var JUMP_VELOCITY = -250.0

var taille = 2
var monde = 1
var teleportdirection = 1
var input_string = ""

var coyote_time = 0.1
var coyote_timer = 0.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var required_input_sequence = ["up","down","right","left"]
var current_input_sequence = []
var on_correct_blocks = false
var teleport_target_position = Vector2(-355, -718)  # Position cible dans le deuxième monde
#var target_world = "res://second_world.tscn"  # Chemin vers la scène du deuxième monde
var start_position = Vector2(-421, -758)  # Position de départ du joueur

@onready var meteor_manager = $groupemeteor  # Référence au gestionnaire de météorites
@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape_node = $CollisionShape2D
@onready var timer = $LabelKey/Timer
@onready var label_key = $LabelKey

# Ajout de références aux Area2D dans la scène pour la détection des blocs
@onready var block_area_1 = $"../tpvertrouge"
@onready var block_area_2 = $"../tprougevert"

func _ready() -> void:
	timer.wait_time = 2.0
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	if monde == 2:
		position = start_position

func check_input_string():
	match input_string:
		"HIGH":
			if taille < 4:
				adjust_size(2)
				taille += 1
		"LOW":
			if taille > 0:
				adjust_size(0.5)
				taille -= 1
		"BN":
			print("BN détecté !")
	if input_string != "":
		timer.start()

func _input(event):
	# Vérifie si le personnage est en contact avec le sol, un mur ou le plafond
	if is_on_floor() or is_on_wall() or is_on_ceiling():
		return  # Ne pas permettre l'écriture si le personnage touche un obstacle

	# Si aucune des conditions ci-dessus n'est vraie, on traite l'entrée de texte
	if event is InputEventKey and event.pressed:
		var key = event.as_text_key_label()
		if key != "Q" and key != "D" and key != "Space" and key != "S" and key != "Z" and key != "Left" and key != "Right" and key != "Up" and key != "Down":  # Exclure les touches de déplacement
			input_string += key
			label_key.text = input_string
			check_input_string()

		

func _physics_process(delta):
# Capture des touches pour la séquence de téléportation
	if on_correct_blocks:
		if Input.is_action_just_pressed("InputUp"):
			current_input_sequence.append("up")
		elif Input.is_action_just_pressed("Inputdown"):
			current_input_sequence.append("down")
		elif Input.is_action_just_pressed("ImputLeft"):
			current_input_sequence.append("left")
		elif Input.is_action_just_pressed("InputRight"):
			current_input_sequence.append("right")

	# Limiter la taille de la séquence à celle requise
	if len(current_input_sequence) > len(required_input_sequence):
		current_input_sequence.remove_at(0)
		print(current_input_sequence)

	# Vérifier si la séquence est correcte
	if (current_input_sequence == required_input_sequence) and on_correct_blocks:
		teleport_player()
	# Changement de taille
	if Input.is_action_just_pressed("Grandir") and taille < 4:
		adjust_size(2)
		taille += 1

	if Input.is_action_just_pressed("Rapeticir") and taille > 0:
		adjust_size(0.5)
		taille -= 1

	if monde == 3:
		var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = direction * SPEED
		if direction.x > 0:
			animated_sprite.flip_h = false
		elif direction.x < 0:
			animated_sprite.flip_h = true

	if monde == 1 or monde == 2:
		var direction = Input.get_axis("move_left", "move_right")
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true

		if is_on_floor():
			coyote_timer = coyote_time
		else:
			coyote_timer -= delta

		if not is_on_floor():
			velocity.y += gravity * delta

		# Effacer le texte lors du saut
		if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_timer > 0):
			velocity.y = JUMP_VELOCITY - (taille * 50 + 1)
			coyote_timer = 0
			reset_input_string()  # Réinitialise le texte lors du saut

		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			animated_sprite.play("jump")

		if direction != 0:
			velocity.x = direction * (SPEED + (80 - taille * 20))
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func adjust_size(scale_factor):
	if collision_shape_node.shape is CapsuleShape2D:
		var collision_shape = collision_shape_node.shape as CapsuleShape2D
		var current_bottom_y = position.y + collision_shape.height / 2 + collision_shape.radius
		animated_sprite.scale.y *= scale_factor
		collision_shape.height *= scale_factor
		position.y = current_bottom_y - (collision_shape.height / 2 + collision_shape.radius)
	else:
		print("Erreur : La forme de collision n'est pas une capsule")

func _on_timer_timeout() -> void:
	reset_input_string()  # Réinitialiser le texte lorsque le timer expire

func reset_input_string() -> void:
	input_string = ""
	label_key.text = input_string

func _on_tpvertrouge():
	on_correct_blocks = true
	teleport_target_position = Vector2(-421, -758)
	teleportdirection = 2
	
func _exit_tpvertrouge():
	on_correct_blocks = false
	
func _on_tprougebleu():
	on_correct_blocks = true
	teleport_target_position = Vector2(-325, -2158)
	teleportdirection = 3

func _exit_tpbleurouge():
	on_correct_blocks = false
	
func _on_tpbleurouge():
	on_correct_blocks = true
	teleport_target_position = Vector2(362, -760)
	teleportdirection = 2
	
func _exit_tprougebleu():
	on_correct_blocks = false
	
func _on_tprougevert_body_entered(body):
	on_correct_blocks = true
	teleport_target_position = Vector2(1594, -165)
	teleportdirection = 1

func _on_tprougevert_body_exited(body):
	on_correct_blocks = false

func teleport_player():
	monde = teleportdirection
	print(monde)
	position = teleport_target_position
	current_input_sequence = []

func _on_meteorite_entered(body: Node) -> void:
	print(body,body.name)
	if body is RigidBody2D and body.name == "Meteorite":
		reset_level()

func reset_level():
	# Réinitialiser la position du joueur
	position = start_position
	meteor_manager.start_spawn_pattern()
