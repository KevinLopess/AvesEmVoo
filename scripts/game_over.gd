extends Control

func _on_quit_game_btn_pressed() -> void:
	get_tree().quit()

func _on_restart_game_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
