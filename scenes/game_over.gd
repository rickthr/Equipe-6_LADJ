extends Node2D

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_node("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_button_pressed() -> void:
	$select.play()
	if Global.ultima_cena != "":
		get_tree().change_scene_to_file(Global.ultima_cena)


func _on_button_2_pressed() -> void:
	$select.play()
