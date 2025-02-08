extends Node2D

func _ready():
	$StartButton.connect("pressed", _on_start_button_pressed)

func _on_start_button_pressed():
	$Bird.start_game()  # Inicia o jogo chamando o método no Bird
	$StartButton.hide()  # Esconde o botão
