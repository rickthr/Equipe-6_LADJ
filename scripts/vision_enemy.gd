extends Area2D
@onready var raycast = $RayCast2D
@onready var default_target_position: Vector2 = raycast.target_position

signal player_detected(body: Node2D, detected: bool)

func _is_detected(player):
	raycast.target_position = raycast.to_local(player.global_position)
	raycast.force_raycast_update()
	
	var collider = raycast.get_collider()
	
	if collider and collider.is_in_group("Player"):
		return true
	return false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and _is_detected(body) == true:
		player_detected.emit(body, true)
		

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		raycast.target_position = default_target_position
		raycast.force_raycast_update()
		
		player_detected.emit(body, false)
