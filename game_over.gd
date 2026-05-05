extends Node2D

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_node("Player")
	$Button.grab_focus()
	$Button2.focus_neighbor_top = $Button2.get_path_to($Button)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_button_pressed() -> void:
	$select.play()
	if Global.ultima_cena != "":
		get_tree().change_scene_to_file(Global.ultima_cena)


func _on_button_2_pressed() -> void:
	$select.play()
	await $select.finished
	get_tree().change_scene_to_file("res://scenes/menu_de_inicio.tscn")


func _on_button_mouse_entered() -> void:
	$Button.add_theme_font_size_override("font_size",48)


func _on_button_mouse_exited() -> void:
	$Button.add_theme_font_size_override("font_size",36)


func _on_button_2_mouse_entered() -> void:
	$Button2.add_theme_font_size_override("font_size",48)


func _on_button_2_mouse_exited() -> void:
	$Button2.add_theme_font_size_override("font_size",36)


func _on_button_focus_entered() -> void:
	$Button.add_theme_font_size_override("font_size",48)


func _on_button_focus_exited() -> void:
	$Button.add_theme_font_size_override("font_size",36)


func _on_button_2_focus_entered() -> void:
	$Button2.add_theme_font_size_override("font_size",48)


func _on_button_2_focus_exited() -> void:
	$Button2.add_theme_font_size_override("font_size",36)
