extends Node2D


@export var spawn_positions : Array[Vector2] = [Vector2(500, -1000),Vector2(500, -1100),Vector2(500, -960),Vector2(500, -910),Vector2(510, -1125),Vector2(510, -960),Vector2(520, -975),Vector2(520, -1050),Vector2(520, -870),Vector2(530, -1060),Vector2(540, -900),Vector2(540, -1070),Vector2(540, -850),Vector2(540, -1100),Vector2(550, -1070),Vector2(560, -1100),Vector2(580, -1025),Vector2(600, -1000),Vector2(610, -1050),Vector2(610, -910),Vector2(620, -1025),Vector2(640, -1010),Vector2(640, -960)]

@export var spawn_interval : float = 2.0  # Intervalle de temps entre chaque météorite
var spawn_timer = 0.0
@onready var player = $Player

func _ready() -> void:
	spawn_timer = spawn_interval
	start_spawn_pattern()

func _process(delta: float) -> void:
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_meteorite()
		spawn_timer = spawn_interval

func start_spawn_pattern():
	spawn_timer = spawn_interval
	# Ajouter ici la logique pour lancer le pattern prédéfini, par exemple avec des séquences d’apparition spécifiques.

func spawn_meteorite():
	for spawn_position in spawn_positions:
		var meteorite = load("res://scenes/meteorite.tscn").instantiate()
		meteorite.position = spawn_position
		add_child(meteorite)
		meteorite.connect("body_entered",Callable( self, "_on_meteorite_entered"))
		
func _on_meteorite_entered(body: Node):
	print("Collision détectée avec le joueur !")
	player.reset_level()
