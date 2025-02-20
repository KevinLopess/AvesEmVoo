extends MarginContainer

@onready var score_label: Label = $Label  # Obtém a Label automaticamente
@onready var background: ParallaxBackground = $"../ParallaxBackground"  # Obtém o ParallaxBackground

func _process(delta: float) -> void:
	"""
	Atualiza a Label a cada frame com a pontuação do ParallaxBackground.
	"""
	if score_label and background:
		score_label.text = str(background.score)  # Apenas exibe o número
