extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.salvador_de_level = get_tree().current_scene.name
 
