extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _on_button_mouse_entered() -> void:
	$Button.add_theme_font_size_override("font_size",48)


func _on_button_mouse_exited() -> void:
	$Button.add_theme_font_size_override("font_size",36)


func _on_button_focus_entered() -> void:
	$Button.add_theme_font_size_override("font_size",48)


func _on_button_focus_exited() -> void:
	$Button.add_theme_font_size_override("font_size",36)


func _on_button_pressed() -> void:
	$select.play()
	await $select.finished
	get_tree().change_scene_to_file("res://scenes/menu_de_inicio.tscn")
