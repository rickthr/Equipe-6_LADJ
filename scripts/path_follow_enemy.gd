extends PathFollow2D

@export var speed: float = 30

@export var state = "patrol"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == "patrol":
		progress += delta * speed 

func _on_vision_body_entered(body:Node2D) -> void:
	if body.is_in_group("Player"):
		state = "following"

func _on_vision_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		state = "patrol"
