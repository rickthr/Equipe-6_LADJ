extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

signal tomar_dano



var vida := 1


func deu_dano():
	$Hitbox_Atack.monitoring = true
	await get_tree().get_frame()
	for body in $Hitbox_Atack.get_overlapping_bodies():
		if body.is_in_group("inimigo"):
			body.emit_signal("dano")
			print("acertou")
		await get_tree().create_timer(0.1)  
		$Hitbox_Atack.monitoring = false

func tomou_dano():
	vida-=1
	print(vida)
	if vida == 0:
		get_tree().change_scene_to_file("res://game_over.tscn")
		queue_free()



func _ready() -> void:
	tomar_dano.connect(tomou_dano)
	add_to_group("jogador")
	
	
func _physics_process(delta: float) -> void:
	
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")
	if Input.is_action_just_pressed("atack"):
		deu_dano()
	
		
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.x, 0, SPEED)
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_hitbox_atack_body_entered(body: Node2D) -> void:
	if Input.is_action_just_pressed("atack"):
		body.emit_signal("dano")
		print("funcionou")
