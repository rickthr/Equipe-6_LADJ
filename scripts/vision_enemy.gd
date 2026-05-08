# vision.gd (Area2D)
extends Area2D

@onready var raycast: RayCast2D = $RayCast2D

signal player_detected(body: Node2D)

var player_inside: Node2D = null
var is_detected: bool = false
var detection_Progress: float = 0.0
@export var detection_Time: float = 0.4

func _physics_process(delta: float) -> void:
	if player_inside == null:
		detection_Progress = 0.0
		is_detected = false
		return
	raycast.target_position = raycast.to_local(player_inside.global_position)
	raycast.force_raycast_update()
	
	if raycast.get_collider() == player_inside:
		if not is_detected:
			detection_Progress += delta
			if detection_Progress >= detection_Time:
				is_detected = true
				detection_Progress = 0.0
				player_detected.emit(player_inside)
		else:
			detection_Progress = 0.0
			is_detected = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_inside = body

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_inside = null
		is_detected = false
		detection_Progress = 0.0
