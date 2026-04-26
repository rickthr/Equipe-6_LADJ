extends CharacterBody2D


const SPEED = 300.0

var vida = 1

func tomou_dano() -> void:
	vida -= 1
	print(vida)
	if vida == 0:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		queue_free()
	
func _physics_process(delta: float) -> void:
	
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")
	
		
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.x, 0, SPEED)
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()



func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): #condicional para ter ctz que o player quem toma dano (o inimigo tava dando dano nas paredes)
		print("dano")
		tomou_dano()
