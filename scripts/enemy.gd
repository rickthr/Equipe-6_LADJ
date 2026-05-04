extends CharacterBody2D

@onready var vision: Area2D = $vision
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var speed: int = 30

signal inimigo_morrer

var vida = 3

func _physics_process(delta: float) -> void:
	animated_sprite_2d.play("idle")

func morrer():
	vida -= 1
	print(vida)
	if vida == 0:
		animated_sprite_2d.play("Dead")
		set_physics_process(false)
		await animated_sprite_2d.animation_finished
		queue_free()

func _ready() -> void:
	add_to_group("Inimigo")
	inimigo_morrer.connect(morrer)


func _on_vision_player_detected(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("detectou o player")
