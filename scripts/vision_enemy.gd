# vision.gd (Area2D)
extends Area2D

@onready var raycast: RayCast2D = $RayCast2D

signal player_detected(body: Node2D)
signal player_lost()

var tracked_body: Node2D = null
var is_player_visible: bool = false

func _physics_process(delta: float) -> void:
	# Pega todos os corpos dentro da área
	var bodies = get_overlapping_bodies()
	var player_in_area: Node2D = null

	for body in bodies:
		if body.is_in_group("Player"):
			player_in_area = body
			break

	if player_in_area:
		# Checa linha de visão com raycast
		raycast.target_position = raycast.to_local(player_in_area.global_position)
		raycast.force_raycast_update()

		var collider = raycast.get_collider()
		if collider and collider.is_in_group("Player"):
			if not is_player_visible:
				is_player_visible = true
				tracked_body = player_in_area
				player_detected.emit(tracked_body)  # ← sinal mais simples
		else:
			_lose_player()
	else:
		_lose_player()

func _lose_player():
	if is_player_visible:
		is_player_visible = false
		tracked_body = null
		player_lost.emit()
