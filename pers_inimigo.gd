extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var vida := 3
signal dano 

func tomou_dano():
	vida-=1
	print(vida)
	if vida == 0:
		queue_free()
	
func _ready() -> void:
		dano.connect(tomou_dano)
		add_to_group("inimigo")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("jogador"):
		body.emit_signal("tomar_dano")
	
