extends PathFollow2D

@export var speed: float = 30
@export var state = "patrol"

@onready var enemy =$Enemy

var bodies_detected = []
var points = []

const TIME_BETWEEN_POINTS = 1


func _process(delta: float) -> void:
	if state == "patrol":
		progress += delta * speed

func _ready() -> void:
	var curve = $"..".curve
	
	for i in range(curve.point_count):
		points.append(curve.get_point_position(i))
	




func _on_vision_player_detected(body: Node2D, detected: bool) -> void:
	if detected:
		state = "following"
		bodies_detected.append(body)
	elif bodies_detected.size() > 0:
		bodies_detected.erase(body)
	if bodies_detected.size() <= 0:
		state = "patrol"
	
