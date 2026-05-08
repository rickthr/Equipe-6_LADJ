extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var nav_agent: NavigationAgent2D = $nav_agent

@onready var hitbox_down: Area2D = $hitbox_attack_down
@onready var hitbox_up: Area2D = $hitbox_attack_up
@onready var hitbox_direita: Area2D = $hitbox_attack_direita
@onready var hitbox_esquerda: Area2D = $hitbox_attack_esquerda

@onready var vision: Area2D = $vision
@onready var detection_area: Area2D = $detection_area

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
var facing_direction: Vector2 = Vector2.DOWN
var last_global_position: Vector2 = Vector2.ZERO

signal inimigo_morrer

func _enter_tree() -> void:
	path_follow = get_parent()

func _ready() -> void:
	add_to_group("Inimigo")
	inimigo_morrer.connect(morrer)

func _physics_process(delta: float) -> void:
	if is_attacking:
			return
	var moviment = global_position - last_global_position
	if moviment.length() > 5.0:
		_update_facing(moviment.normalized())
	last_global_position = global_position
	
	if is_Following == true and target != null:
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
		_update_facing(direction)
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
		_update_facing(direction)
		move_and_slide()
	else:
		var direction = path_follow.get_forward_direction()
		_update_facing(direction)
		velocity = Vector2.ZERO



func _update_facing(direction:Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		facing_direction = Vector2(sign(direction.x), 0)
	else:
		facing_direction = Vector2(0, sign(direction.y))
	
	if facing_direction == Vector2.DOWN:
		animated_sprite_2d.play("Down")
		vision.rotation_degrees = 0
		detection_area.rotation_degrees = 0
	elif facing_direction == Vector2.UP:
		animated_sprite_2d.play("Up")
		vision.rotation_degrees = 180
		detection_area.rotation_degrees = 180
	elif facing_direction == Vector2.RIGHT:
		animated_sprite_2d.play("Side")
		animated_sprite_2d.flip_h = false
		vision.rotation_degrees = -90
		detection_area.rotation_degrees = -90
	else:
		animated_sprite_2d.play("Side")
		animated_sprite_2d.flip_h = true
		vision.rotation_degrees = 90
		detection_area.rotation_degrees = 90
		


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
	
	var hitbox_atual: Area2D
	if facing_direction == Vector2.DOWN:
		animated_sprite_2d.play("Ataque_baixo")
		hitbox_atual = hitbox_down
	elif facing_direction == Vector2.UP:
		animated_sprite_2d.play("Ataque_up")
		hitbox_atual = hitbox_up
	elif facing_direction == Vector2.RIGHT:
		animated_sprite_2d.play("Ataque_lado")
		animated_sprite_2d.flip_h = false
		hitbox_atual = hitbox_direita
	else:
		animated_sprite_2d.play("Ataque_lado")
		animated_sprite_2d.flip_h = true
		hitbox_atual = hitbox_esquerda
		
		
	hitbox_atual.get_node("CollisionShape2D").disabled = false
	
	await animated_sprite_2d.animation_finished
	
	var acertou = false
	for body in hitbox_atual.get_overlapping_bodies():
		if body.is_in_group("Player"):
			acertou = true
			body.tomou_dano()
			print("dano dado")
		if not acertou:
			print("acertou ninguem")
			
	hitbox_atual.get_node("CollisionShape2D").disabled = true
	is_attacking = false
	
	await  get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func morrer():
	vida -= 1
	print(vida)
	if path_follow != null and path_follow.state == "patrol":
		vida = 0
		path_follow.speed = 0
	if vida == 0:
		animated_sprite_2d.play("Dead")
		set_physics_process(false)
		await animated_sprite_2d.animation_finished
		queue_free()
