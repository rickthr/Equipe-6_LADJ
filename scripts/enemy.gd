extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	animated_sprite_2d.play("idle")
const SPEED = 300.0

var vida := 3
