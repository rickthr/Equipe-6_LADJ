extends PathFollow2D

@export var speed: float = 50
@export var state = "patrol"

signal enemy_following()

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if state == "patrol":
		progress += delta * speed


func _on_vision_player_detected(body: Node2D) -> void:
	state = "following"


func _on_vision_player_lost() -> void:
	_iniciar_retorno()
	
func _iniciar_retorno():
	await get_tree().create_timer(3.0).timeout
	state = "returning"

func retomar_patrol():
	state = "patrol"
