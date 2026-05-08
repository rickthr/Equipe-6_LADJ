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

func get_forward_direction() -> Vector2:
	var curve = get_parent().curve
	var forward = curve.sample_baked_with_rotation(progress, true).basis_xform(Vector2.RIGHT)
	return forward.normalized()
