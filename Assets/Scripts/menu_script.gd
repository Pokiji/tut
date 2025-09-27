extends Control


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/Area Functionality/area_template.tscn")

	pass # Replace with function body.


func _on_credits_pressed() -> void:
#	change mine
	get_tree().change_scene_to_file("res://Assets/Scenes/Menu Scenes/creds.tscn")
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
