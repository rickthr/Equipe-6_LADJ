extends CharacterBody2D

@onready var vision: Area2D = $vision
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var nav_agent: NavigationAgent2D = $nav_agent


@export var speed: int = 100
@export var target: CharacterBody2D

signal inimigo_morrer

var vida = 3
var is_Following = false

func _physics_process(delta: float) -> void:
	animated_sprite_2d.play("idle")
	if is_Following == true:
		var direction = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = direction * speed
		
		move_and_slide()
		

func go_to_target():
	nav_agent.target_position = target.global_position

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


func _on_path_follow_2d_enemy_following() -> void:
	is_Following = true
	


func _on_nav_timer_timeout() -> void:
	go_to_target()
