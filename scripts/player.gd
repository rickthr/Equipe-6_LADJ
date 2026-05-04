extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var animator: AnimationPlayer = $Animator
@onready var sprite2d: Sprite2D = $Sprite2D

const SPEED = 100.0

var vida: int = 10
var is_attacking: bool = false
var last_direction = Vector2(0, 1)

func tomou_dano() -> void:
	vida -= 1
	print(vida)
	if vida == 0:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		queue_free()
	
func _physics_process(delta: float) -> void:
	
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")
	
	hitbox.rotation = - last_direction.angle() + deg_to_rad(90)

		
	if direction_y != 0:
		velocity.y = direction_y * SPEED
		
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	if direction_x !=0:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


	if is_attacking == true:
		if direction_y > 0:
			animator.play("Attack Down")
		elif direction_y < 0:
			animator.play("Attack Up")
		else:
			if direction_x > 0:
				animator.play("Attack Direita")
			elif direction_y < 0:
				animator.play("Attack Esquerda")
	else:
		if velocity.y > 0:
			animator.play("Run Down")
			last_direction = Vector2(0, 1)
		elif velocity.y < 0:
			animator.play("Run Up")
			last_direction = Vector2(0, -1)
		elif velocity.x != 0:
			if velocity.x < 0:
				animator.play("Run Esquerda")
			else:
				animator.play("Run Direita")
			last_direction = Vector2(-direction_x, 0)
		elif velocity.x == 0 and velocity.y == 0:
			animator.play("Idle")

	move_and_slide()# Movimentação do player


	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		tomou_dano()


func _on_animator_animation_finished(anim_name: StringName) -> void:
	if anim_name.begins_with("Attack"):
		is_attacking = false
