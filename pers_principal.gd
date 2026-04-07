extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

signal inimigos 

var vida := 2
#var morreu: bool = false

func combate():
	vida-=1
	if vida == 0:
		get_tree().change_scene_to_file("res://game_over.tscn")
		queue_free()

func _ready() -> void:
	inimigos.connect(combate)
	
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
