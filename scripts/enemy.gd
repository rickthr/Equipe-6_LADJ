extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var nav_agent: NavigationAgent2D = $nav_agent

@export var speed: int = 30
@export var target: Node2D = null
var vida = 3
var is_Following = false
var return_target: Vector2 = Vector2.ZERO
var path_follow: Node = null

signal inimigo_morrer

func _enter_tree() -> void:
	path_follow = get_parent()

func _ready() -> void:
	add_to_group("Inimigo")
	inimigo_morrer.connect(morrer)

func _physics_process(delta: float) -> void:
	animated_sprite_2d.play("idle")
	
	if is_Following == true and target != null:
		nav_agent.target_position = target.global_position
		
		if nav_agent.is_navigation_finished():
			velocity = Vector2.ZERO
			return
		
		var direction = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = direction * speed
		move_and_slide()
	elif path_follow != null and path_follow.state == "returning":
		nav_agent.target_position = return_target
		
		if nav_agent.is_navigation_finished():
			velocity = Vector2.ZERO
			position = Vector2.ZERO  
			path_follow.retomar_patrol()
		
		var direction = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		position = Vector2.ZERO 


func _on_vision_player_detected(body: Node2D) -> void:
		print("detectou o player")
		target = body          
		is_Following = true

func _on_vision_player_lost() -> void:
		start_returning()
		target = null
		return_target = path_follow.global_position

func start_following():
	if is_Following:
		return
	is_Following = true
	var global_pos = global_position
	reparent(get_tree().current_scene)
	global_position = global_pos

func start_returning():
	is_Following = false
	target = null
	await get_tree().create_timer(3.0).timeout
	if not is_Following:
		var global_pos = global_position
		global_position = global_pos

func morrer():
	vida -= 1
	print(vida)
	if vida == 0:
		animated_sprite_2d.play("Dead")
		set_physics_process(false)
		await animated_sprite_2d.animation_finished
		queue_free()
