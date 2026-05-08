extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var nav_agent: NavigationAgent2D = $nav_agent
@onready var hitbox_attack:Area2D = $hitbox_attack

@export var speed: int = 60
@export var attack_range: float = 20
@export var attack_cooldown: float = 2.0
var can_attack: bool = true
var is_attacking: bool = false
var target: Node2D = null
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
		if is_attacking:
			return
			
		nav_agent.target_position = target.global_position
		var distance = global_position.distance_to(target.global_position)
		
		if distance <= attack_range and can_attack and not is_attacking:
			attack()
			return
			
		if nav_agent.is_navigation_finished():
			velocity = Vector2.ZERO
			return
		
		var next_pos = nav_agent.get_next_path_position()
		var direction = (next_pos - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	
	elif path_follow != null and path_follow.state == "returning":
		nav_agent.target_position = return_target
		
		if nav_agent.is_navigation_finished():
			velocity = Vector2.ZERO
			await get_tree().process_frame
			path_follow.retomar_patrol()
			return
		var next_pos = nav_agent.get_next_path_position()
		var direction = (next_pos - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO


func _on_vision_player_detected(body: Node2D) -> void:
	if path_follow != null and path_follow.state == "returning":
		path_follow.state = "following"
		position = Vector2.ZERO
	target = body          
	is_Following = true
	$detection_area.was_detected = true

func _on_detection_area_player_lost() -> void:
		is_Following = false
		target = null
		if path_follow != null:
			return_target = path_follow.global_position

			nav_agent.target_position = global_position 
			await get_tree().process_frame
			nav_agent.target_position = return_target
			

func attack():
	is_attacking = true
	can_attack = false
	velocity = Vector2.ZERO
	animated_sprite_2d.play("Ataque_baixo") 
	$hitbox_attack/CollisionShape2D.disabled = false
	
	await animated_sprite_2d.animation_finished
	for body in hitbox_attack.get_overlapping_bodies():
		if body.is_in_group("Player"):
			body.tomou_dano()


	$hitbox_attack/CollisionShape2D.disabled = true
	is_attacking = false
	
	await  get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func morrer():
	vida -= 1
	print(vida)
	if vida == 0:
		animated_sprite_2d.play("Dead")
		set_physics_process(false)
		await animated_sprite_2d.animation_finished
		queue_free()
