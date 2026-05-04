extends Node2D

@onready var follower: PathFollow2D = $"../PathFollow2D"
#@onready var watcher: PathPointWatcher = $"."
var speed: float = 30.0

var stopped := false


func _ready() -> void:
	#watcher.point_reached.connect(_on_point_reached)
	#watcher.path_finished.connect(_on_path_finished)
	pass

func _process(delta: float) -> void:
	if stopped:
		return

	follower.progress += speed * delta


func _on_point_reached(point_index: int, progress: float, position: Vector2) -> void:
	print("Reached point:", point_index)

	# Example: stop at point 2
	if point_index == 2:
		stopped = true


func _on_path_finished() -> void:
	print("Path finished")
	stopped = true
