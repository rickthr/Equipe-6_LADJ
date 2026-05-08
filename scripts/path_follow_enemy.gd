extends PathFollow2D

@export var speed: float = 50
var state = "patrol"

func _process(delta: float) -> void:
	if state == "patrol":
		progress += delta * speed

func _on_vision_player_detected(body: Node2D) -> void:
	state = "following"

func _on_detection_area_player_lost() -> void:
	_iniciar_retorno()

func _iniciar_retorno():
	await get_tree().create_timer(1.25).timeout
	state = "returning"

func retomar_patrol():
	state = "patrol"
	print("voltou a patrol")
