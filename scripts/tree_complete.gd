extends Node2D

class_name Tree_Complete  # Define uma classe personalizada chamada Tree_Complete, permitindo que seja referenciada por esse nome.

# Sinais emitidos quando certas condições são atendidas
signal bird_entered  # Emitido quando o pássaro colide com o obstáculo (Game Over).
signal scored_point  # Emitido quando o jogador passa por um obstáculo e ganha um ponto.

@export var base_tree_speed: int = -150  # Velocidade base inicial do obstáculo (movimento para a esquerda).
var tree_speed: float = -150  # Velocidade dinâmica do obstáculo, ajustada ao longo do jogo.

# Obtém a referência do ParallaxBackground para sincronizar a velocidade do fundo com os obstáculos.
@onready var background = get_parent().get_node_or_null("ParallaxBackground")

func _ready():
	"""
	Função chamada quando o nó entra na árvore da cena.
	Verifica se o ParallaxBackground está presente e conecta o sinal scored_point ao método increase_score do fundo.
	"""
	if background:
		scored_point.connect(background.increase_score)  # Conecta o evento de pontuação ao fundo, aumentando a velocidade progressivamente.

func set_speed(new_speed: int):
	"""
	Define uma nova velocidade para o obstáculo.
	Esse método pode ser chamado externamente para alterar a velocidade do objeto durante o jogo.
	"""
	tree_speed = new_speed

func _process(delta: float) -> void:
	"""
	Chamado a cada frame do jogo.
	Atualiza a posição do obstáculo com base na velocidade e no tempo decorrido (delta).
	Ajusta dinamicamente a velocidade do obstáculo com base na pontuação do jogador.
	"""
	# Ajusta a velocidade da árvore com base no progresso do jogador
	if background:
		tree_speed = base_tree_speed * (1.2 + background.score + 2 * 0.07)  
		# Quanto maior a pontuação, mais rápido os obstáculos se movem, criando uma progressão de dificuldade.

	# Move a árvore para a esquerda com base na velocidade e no tempo de atualização (delta)
	position.x += tree_speed * delta

	# Remove o obstáculo da árvore quando ele sair completamente da tela (evita consumo excessivo de memória)
	if position.x < -get_viewport().get_visible_rect().size.x:
		queue_free()  # Remove o nó da árvore de cena quando ele estiver completamente fora da tela.

func _scored_point(body):
	"""
	Função chamada quando o pássaro passa pelo obstáculo sem colidir.
	Emite o sinal scored_point, que aumenta a pontuação do jogador.
	"""
	scored_point.emit()

func _on_body_entered(body: Node2D) -> void:
	"""
	Função chamada quando o pássaro colide com o obstáculo.
	Emite um sinal indicando que o pássaro foi atingido e inicia a mudança de cena para a tela de Game Over.
	"""
	bird_entered.emit()  # Emite o sinal informando que o pássaro colidiu.

	# Adia a execução da função game_over para evitar erros de física, garantindo que a mudança de cena ocorra de forma segura.
	call_deferred("game_over")  

func game_over():
	"""
	Altera a cena para a tela de Game Over.
	Essa função é chamada quando o pássaro colide com um obstáculo.
	"""
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")  # Transição para a tela de Game Over.
