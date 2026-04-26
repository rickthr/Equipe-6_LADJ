extends Area2D
@onready var raycasts = [$RayCast2D]

signal player_detected(body: Node2D)

var player: Node2D

func _physics_process(delta: float) -> void:
	if not player: return
	
	if _is_detected(player):
		player_detected.emit(player)
		player = null

func _is_detected(player):
	raycasts[0].look_at(player.global_position)
	
	for ray: RayCast2D in raycasts:
		if ray.get_collider():
			if ray.get_collider().is_in_group("Player"):
				return true
	return false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = null
