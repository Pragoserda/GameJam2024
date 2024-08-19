extends Area2D

@onready var Joueur = %Player

func _on_body_entered(body):
	Joueur._on_tpbleurouge()

func _on_body_exited(body):
	Joueur._exit_tpbleurouge()
