# vision.gd (Area2D)
extends Area2D

@onready var raycast: RayCast2D = $RayCast2D

signal player_detected(body: Node2D)

var player_inside: Node2D = null
var is_detected: bool = false

func _physics_process(delta: float) -> void:
	if player_inside == null:
		is_detected = false
		return
	raycast.target_position = raycast.to_local(player_inside.global_position)
	raycast.force_raycast_update()
	
	if raycast.get_collider() == player_inside:
		if not is_detected:
			is_detected = true
			player_detected.emit(player_inside)
		else:
			is_detected = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_inside = body

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_inside = null
		is_detected = false
