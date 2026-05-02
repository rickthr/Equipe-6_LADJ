extends Node

var chave: bool = false
var ultima_cena : String = ""
func _ready() -> void:
	pass # Replace with function body.
func ir_para_cena(nome_cena: String):
	if get_tree().current_scene.name != "game_over":
		ultima_cena = get_tree().current_scene.scene_file_path
	
	get_tree().change_scene_to_file("res://scenes/" + nome_cena + ".tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
