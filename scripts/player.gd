extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0

var vida = 2

func tomou_dano() -> void:
	vida -= 1
	$hit.play()
	var tween = get_tree().create_tween()
	tween.tween_property(self,"modulate", Color.RED,0.5)
	tween.tween_property(self,"modulate", Color.WHITE,0.5)
	if vida == 0:
		animated_sprite_2d.play("Dead")
		set_physics_process(false)
		await animated_sprite_2d.animation_finished
		Global.ir_para_cena("game_over")
		queue_free()
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

func _ready() -> void:
	add_to_group("Player")
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
		
	var aguarda_diretion = "down"
	
	if direction_y > 0:
		aguarda_diretion = "down"
		animated_sprite_2d.play("Down")
	elif direction_y<0:
		aguarda_diretion = "up"
		animated_sprite_2d.play("Up")
	elif direction_x !=0:
		aguarda_diretion = "lado"
		animated_sprite_2d.play("De_lado")
	else:
		if aguarda_diretion == "up":
			animated_sprite_2d.play("idle_up")
		elif aguarda_diretion == "lado":
			animated_sprite_2d.play("idle_lado")
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
		
	move_and_slide()

func _on_morte_body_entered(body: Node2D) -> void:
	tomou_dano()
