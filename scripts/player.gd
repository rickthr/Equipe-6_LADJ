extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


var atacando : bool = false
var vida = 1

func tomou_dano() -> void:
	vida -= 1
	print(vida)
	if vida == 0:
		animated_sprite_2d.play("Dead")
		set_physics_process(false)
		await animated_sprite_2d.animation_finished
		Global.ir_para_cena("game_over")
		queue_free()
	
func _ready() -> void:
	pass
	
func ativar_dar_dano(area:Area2D):
	for shape in area.get_children():
		if shape == CollisionShape2D:
			shape.disable = false
func desativar_dar_dano(area:Area2D):
	for shape in area.get_children():
		if shape == CollisionShape2D:
			shape.disable = true
func checar_dano(area:Area2D):
	for body  in area.get_overlapping_bodies():
		if body.is_in_group("Inimigo"):
			body.emit_signal("inimigo_morrer")
			
func _physics_process(delta: float) -> void:
	
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")
	
		
		
	if direction_y != 0:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	if direction_x !=0:
		velocity.x = direction_x * SPEED
		animated_sprite_2d.flip_h = direction_x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction_y > 0:
		animated_sprite_2d.play("down")
	elif direction_y<0:
		animated_sprite_2d.play("up")
	elif direction_x !=0:
		animated_sprite_2d.play("de_lado")
	else:
		animated_sprite_2d.play("Idle")
		
		
	if Input.is_action_just_pressed("atack") and direction_y < 0:
		animated_sprite_2d.play("Ataque_up")
		$katana.play()
		set_physics_process(false)
		ativar_dar_dano($Dar_dano_cima)
		await get_tree().process_frame
		checar_dano($Dar_dano_cima)
		await animated_sprite_2d.animation_finished
		desativar_dar_dano($Dar_dano_cima)
		set_physics_process(true)
		
		
	elif Input.is_action_just_pressed("atack") and direction_y > 0:
		animated_sprite_2d.play("Ataque_down")
		$katana.play()
		set_physics_process(false)
		ativar_dar_dano($Dar_dano_down)
		await get_tree().process_frame
		checar_dano($Dar_dano_down)
		await animated_sprite_2d.animation_finished
		desativar_dar_dano($Dar_dano_down)
		set_physics_process(true)
		
	elif Input.is_action_just_pressed("atack") and direction_x != 0:
		animated_sprite_2d.play("Ataque_lado")
		$katana.play()
		set_physics_process(false)
		ativar_dar_dano($Dar_dano_lado)
		await get_tree().process_frame
		checar_dano($Dar_dano_lado)
		await animated_sprite_2d.animation_finished
		desativar_dar_dano($Dar_dano_lado)
		set_physics_process(true)
		atacando = false
		
	elif Input.is_action_just_pressed("atack"):
		animated_sprite_2d.play("Ataque_down")
		$katana.play()
		set_physics_process(false)
		ativar_dar_dano($Dar_dano_down)
		await get_tree().process_frame
		checar_dano($Dar_dano_down)
		await animated_sprite_2d.animation_finished
		desativar_dar_dano($Dar_dano_down)
		set_physics_process(true)
		atacando = false
	

	move_and_slide()



func _on_hitbox_body_entered(body: Node2D) -> void:
	print("entrou")
	if body.is_in_group("Player"): #condicional para ter ctz que o player quem toma dano (o inimigo tava dando dano nas paredes)
		print("dano")
		tomou_dano()

func _on_chave_body_entered(body: Node2D) -> void:
	Global.chave = true
	$"../chave/Sprite2D".visible = false

func _on_portal_body_entered(body: Node2D) -> void:
	if Global.chave == true:
		get_tree().change_scene_to_file("res://scenes/debug_scene.tscn")
	pass 


func _on_morte_body_entered(body: Node2D) -> void:
	tomou_dano()
