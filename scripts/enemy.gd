extends CharacterBody2D

@onready var vision: Area2D = $vision

@export var speed: int = 30


func _on_vision_player_detected(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("detectou o player")


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		print(body.name)
