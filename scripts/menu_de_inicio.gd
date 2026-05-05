extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.grab_focus()
	
	$Button.focus_neighbor_bottom = $Button.get_path_to($Button2)
	$Button2.focus_neighbor_top = $Button2.get_path_to($Button)
	$Button2.focus_neighbor_bottom = $Button2.get_path_to($Button3)
	$Button3.focus_neighbor_top = $Button3.get_path_to($Button2)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_3_pressed() -> void:
	$select.play()
	await $select.finished
	get_tree().quit()


func _on_button_mouse_entered() -> void:
	$Button.add_theme_font_size_override("font_size",84)


func _on_button_mouse_exited() -> void:
	$Button.add_theme_font_size_override("font_size",70)


func _on_button_focus_entered() -> void:
	$Button.add_theme_font_size_override("font_size",84)


func _on_button_focus_exited() -> void:
	$Button.add_theme_font_size_override("font_size",70)


func _on_button_2_focus_entered() -> void:
	$Button2.add_theme_font_size_override("font_size",84)


func _on_button_2_focus_exited() -> void:
	$Button2.add_theme_font_size_override("font_size",70)


func _on_button_2_mouse_entered() -> void:
	$Button2.add_theme_font_size_override("font_size",84)


func _on_button_2_mouse_exited() -> void:
	$Button2.add_theme_font_size_override("font_size",70)


func _on_button_3_focus_entered() -> void:
	$Button3.add_theme_font_size_override("font_size",84)


func _on_button_3_focus_exited() -> void:
	$Button3.add_theme_font_size_override("font_size",70)


func _on_button_3_mouse_entered() -> void:
	$Button3.add_theme_font_size_override("font_size",84)


func _on_button_3_mouse_exited() -> void:
	$Button3.add_theme_font_size_override("font_size",70)


func _on_button_2_pressed() -> void:
	$select.play()
	await $select.finished
	get_tree().change_scene_to_file("res://scenes/configurções.tscn")
