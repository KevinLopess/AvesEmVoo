extends ParallaxBackground

@export var base_speed: float = -100  # Velocidade base do fundo, que define a velocidade inicial da rolagem
var score: int = 0  # Pontuação do jogador

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	"""
	Ajusta a velocidade de rolagem com base na pontuação diretamente.
	
	A conta funciona da seguinte forma:
	- `1.0 + score * 0.05` cria um multiplicador que cresce conforme a pontuação.
	- O `1.0` garante que a velocidade base sempre esteja presente.
	- O `0.05` faz com que a cada ponto ganho, a velocidade aumente 5% do valor base.
	- `base_speed * (1.0 + score * 0.05)` ajusta a velocidade progressivamente, evitando mudanças abruptas.
	"""
	scroll_offset.x += base_speed * (1.0 + score * 0.05) * delta

func increase_score():
	"""
	Jogador ganha pontos e a velocidade da rolagem aumenta gradativamente.
	"""
	score += 1
