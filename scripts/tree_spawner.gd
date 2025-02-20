extends Node

class_name TreeSpawner  # Define uma classe chamada TreeSpawner, permitindo referência direta no código.

# Pré-carrega a cena da árvore (obstáculo), que será instanciada durante o jogo.
var tree_scene = preload("res://scenes/tree.tscn")

# Sinais que indicam eventos importantes no jogo.
signal bird_killed  # Emitido quando o pássaro colide com um obstáculo.
signal point_scored  # Emitido quando o jogador passa por um obstáculo sem colidir.

@export var tree_speed = -150  # Velocidade inicial das árvores (movendo-se para a esquerda).

# Obtém a referência do ParallaxBackground para sincronizar a velocidade do fundo com os obstáculos.
@onready var background = get_parent().get_node("ParallaxBackground")  

# Obtém a referência do Timer que controla o spawn das árvores.
@onready var spawn_timer = $SpawnTower  

func _ready() -> void:
	"""
	Função chamada quando o nó entra na árvore da cena.
	Inicia o temporizador e conecta os sinais necessários.
	"""
	spawn_timer.timeout.connect(spawn_tower)  # Conecta o evento de timeout do Timer à função que gera árvores.
	spawn_timer.start()  # Inicia o Timer para criar obstáculos periodicamente.
	
	# Conecta o sinal point_scored ao método increase_score do background.
	# Isso permite que a pontuação aumente conforme o jogador avança no jogo.
	point_scored.connect(background.increase_score)

func start_spawn_towers():
	"""
	Reinicia o temporizador de spawn das árvores.
	Essa função pode ser chamada para reativar a geração de obstáculos após um Game Over, por exemplo.
	"""
	spawn_timer.start()

func spawn_tower():
	"""
	Instancia uma nova árvore (obstáculo) e posiciona-a na tela de forma aleatória dentro de um intervalo permitido.
	"""
	var tree_obj = tree_scene.instantiate() as Tree_Complete  # Cria uma nova instância da árvore.
	add_child(tree_obj)  # Adiciona a árvore como filha do TreeSpawner, para que seja controlada pelo script.

	# Obtém as dimensões da tela (área visível).
	var viewport_rect = get_viewport().get_visible_rect()
	var screen_width = viewport_rect.end.x  # Posição X máxima da tela (direita).
	var screen_height = viewport_rect.size.y  # Altura total da tela.

	# Define a posição inicial da árvore à direita da tela.
	tree_obj.position.x = screen_width

	# Criar uma variação aleatória para mover as árvores mais para cima ou para baixo.
	var vertical_offset = randf_range(-600, 450)  # Define um deslocamento aleatório na altura.

	# Definir os limites de altura para que as árvores não fiquem muito altas ou muito baixas.
	var min_position_y = screen_height * 0.2
	var max_position_y = screen_height * 0.8
	var base_position_y = (min_position_y + max_position_y) / 2  # Posição central das árvores.

	# Aplica a variação de altura dentro dos limites estabelecidos.
	tree_obj.position.y = clamp(base_position_y + vertical_offset, min_position_y, max_position_y)

	# Define a velocidade da árvore corretamente.
	tree_obj.set_speed(tree_speed)

	# Conectar sinais da árvore para detectar colisões e pontuação.
	tree_obj.bird_entered.connect(on_bird_entered)  # Conecta o evento de colisão com o pássaro.
	tree_obj.scored_point.connect(on_point_scored)  # Conecta o evento de pontuação quando o jogador passa pela árvore.

func on_bird_entered():
	"""
	Função chamada quando o pássaro colide com uma árvore.
	Emite o sinal de Game Over e para a geração de novas árvores.
	"""
	bird_killed.emit()  # Dispara o evento de colisão, indicando que o jogo acabou.
	stop_timer()  # Para a geração de novas árvores.

func stop_timer():
	"""
	Para o Timer de spawn e faz com que todas as árvores parem de se mover.
	"""
	spawn_timer.stop()  # Para o temporizador de geração de novas árvores.

	# Percorre todas as árvores geradas e para o movimento delas.
	for tree_obj in get_children().filter(func (child): return child is Tree_Complete):
		(tree_obj as Tree_Complete).tree_speed = 0  # Define a velocidade da árvore como 0, parando o movimento.

func on_point_scored():
	"""
	Função chamada quando o jogador passa por uma árvore sem colidir.
	Emite o sinal para aumentar a pontuação.
	"""
	point_scored.emit()  # Dispara o evento indicando que o jogador marcou um ponto.
