extends PathFollow2D

@export var speed: float = 50

@export var state = "patrol"

var bodies_detected = []

signal enemy_following()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == "patrol":
		progress += delta * speed 
	if state == "following":
		emit_signal("enemy_following")
		progress += 0


func _on_vision_player_detected(body: Node2D, detected: bool) -> void:
	if detected:
		state = "following"
		bodies_detected.append(body)
	elif bodies_detected.size() > 0:
		bodies_detected.erase(body)
	if bodies_detected.size() <= 0:
		state = "patrol"
	
