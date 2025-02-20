extends ParallaxBackground  # Classe que permite a movimentação do fundo para criar efeito de parallax.

# Configuração da velocidade base do fundo, ajustável no editor.
@export var base_speed: float = -100  

# Variáveis de controle da pontuação do jogador.
var score: int = 0  # Pontuação atual do jogador.
var old_score: int = 0  # Guarda a pontuação anterior para referência.

# Obtém a referência do Timer de spawn dos obstáculos (árvores), que está na cena TreeSpawner.
@onready var spawn_timer = get_node_or_null("../TreeSpawner/SpawnTower")

func _process(delta: float) -> void:
	"""
	Chamado a cada frame do jogo.
	Faz com que o fundo se mova da direita para a esquerda, simulando deslocamento do cenário.
	Também ajusta a velocidade do fundo conforme a pontuação do jogador.
	"""
	
	# A velocidade do fundo aumenta conforme a pontuação cresce.
	# `1.0 + score * 0.05` adiciona um pequeno incremento na velocidade baseado no score.
	scroll_offset.x += base_speed * (1.0 + score * 0.05) * delta

	# Ajusta o tempo de spawn das árvores com base na pontuação do jogador.
	# Quanto maior a pontuação, menor o intervalo entre a geração dos obstáculos.
	
	# Se a pontuação for maior que 10 e o tempo de spawn ainda for 5.0 segundos, reduza para 4.0 segundos.
	if score > 10 and spawn_timer and spawn_timer.wait_time == 5.0:
		spawn_timer.wait_time = 4.0  

	# Se a pontuação for maior que 20 e o tempo de spawn ainda for 4.0 segundos, reduza para 3.5 segundos.
	if score > 20 and spawn_timer and spawn_timer.wait_time == 4.0:
		spawn_timer.wait_time = 3.5  

func increase_score():
	"""
	Incrementa a pontuação do jogador e consequentemente ajusta a velocidade do fundo.
	Chamado quando o jogador passa com sucesso por um obstáculo.
	"""
	score += 1  # Adiciona 1 ponto à pontuação total do jogador.
