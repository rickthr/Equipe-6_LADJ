extends Area2D

var was_detected: bool = false

signal player_lost()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") and was_detected:
		was_detected = false
		player_lost.emit()
		print("perdeu player")
