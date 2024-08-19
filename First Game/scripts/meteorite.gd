extends RigidBody2D



@export var min_speed = 150.0  # Vitesse minimale
@export var max_speed = 300.0  # Vitesse maximale

signal meteorite_entered(player)

func _ready() -> void:
	# Appliquer une vitesse aléatoire pour chaque météorite
	var speed = randf_range(min_speed, max_speed)
	linear_velocity.y = speed  # Déplacement vers le bas

func _process(delta):
	if position.x < -600:
		queue_free()
		
func _on_body_entered(body: Node) -> void:
	emit_signal("meteorite_entered", body)
	print("oui")
	queue_free()  
