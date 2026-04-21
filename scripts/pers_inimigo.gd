extends CharacterBody2D

@onready var pers_inimigo: CharacterBody2D = $"."
@export var move_speed := 10
@export var distance := 160

var inimigo_centro := 16
var follow : = Vector2.ZERO

var vida := 3
signal dano 

func tomou_dano():
	vida-=1
	print(vida)
	if vida == 0:
		queue_free()
	
func _ready() -> void:
		dano.connect(tomou_dano)
		mover_inimigo()


	
func _physics_process(delta: float) -> void:
	pers_inimigo.position = pers_inimigo.position.lerp(follow, 0.5)
	
	
func mover_inimigo():
	var move_direction = distance * (Vector2.RIGHT)
	var duration = move_direction.length() / float(move_speed * inimigo_centro)
	var tween: Tween = get_tree().create_tween().set_loops().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "follow", move_direction,duration)
	tween.tween_property(self, "follow", Vector2.ZERO,duration)
	
	
func _on_area_2d_body_entered(body: Node2D) -> void: #FAZ O PROTAGONISTA TOMAR DANO
	print("jogador devia tomar dano")
	body.emit_signal("tomar_dano")
