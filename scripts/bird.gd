extends CharacterBody2D

# Parâmetros do pássaro ajustáveis no Editor
@export var gravity: float = 900  # Força gravitacional aplicada ao pássaro, puxando-o para baixo
@export var jump_force: float = -400  # Força aplicada quando o jogador pressiona o botão de pulo
@export var max_rotation: float = 30  # Inclinação máxima do pássaro ao subir, usada para suavizar a rotação
@export var fall_rotation: float = 90  # Inclinação máxima ao cair, para simular um mergulho mais natural
@export var rotation_speed: float = 5  # Velocidade de interpolação da rotação ao subir e cair
@export var float_amplitude: float = 10  # Distância de flutuação enquanto o jogo não inicia, criando um efeito de "bater asas"
@export var float_speed: float = 2  # Velocidade da oscilação da flutuação enquanto o jogo não inicia

# Variáveis de estado do jogo
var is_alive = false  # Indica se o jogo está rodando ou se o pássaro está na fase de espera
var start_position: Vector2  # Guarda a posição inicial do pássaro para reiniciar corretamente
var float_time = 0.0  # Tempo de oscilação para a animação de flutuação
var screen_height: float  # Altura da tela, usada para detectar se o pássaro caiu para fora

func _ready():
	"""
	Função executada quando o nó é carregado.
	Inicializa a posição do pássaro e configura valores iniciais.
	"""
	start_position = position  # Salva a posição inicial para futuras reinicializações
	rotation = deg_to_rad(0)  # Garante que o pássaro inicie reto
	screen_height = get_viewport_rect().size.y  # Obtém a altura da tela para verificar saída

func _physics_process(delta):
	"""
	Função chamada a cada quadro para atualizar a física do pássaro.
	Se o jogo ainda não começou, faz o pássaro flutuar.
	Se o jogo estiver rodando, aplica gravidade e controla a rotação do pássaro.
	"""
	if not is_alive:
		# Movimento de flutuação enquanto o jogo não começa
		float_time += delta  # Atualiza o tempo para criar a oscilação senoidal
		position.y = start_position.y + sin(float_time * float_speed) * float_amplitude  # Movimento de espera
		
		# Se o jogador pressionar "Pular", inicia o jogo
		if Input.is_action_just_pressed("Pular"):
			start_game()
		return  # Sai da função para evitar execução da física antes do jogo iniciar

	# Aplicação da gravidade
	velocity.y += gravity * delta

	# Se o jogador pressionar "Pular", aplica a força do pulo
	if Input.is_action_just_pressed("Pular"):
		velocity.y = jump_force

	# Ajuste de rotação baseado na velocidade vertical
	if velocity.y < 0:  # Se estiver subindo
		rotation = lerp(rotation, deg_to_rad(-max_rotation), delta * rotation_speed)
	else:  # Se estiver caindo
		rotation = lerp(rotation, deg_to_rad(fall_rotation), delta * rotation_speed)

	# Move o pássaro de acordo com a física
	move_and_slide()

	# Verifica se o pássaro saiu da tela para ativar o Game Over
	if position.y > screen_height:
		game_over()

func start_game():
	"""
	Inicia o jogo ao pressionar "Pular" ou o botão de Start.
	Reseta a posição e a velocidade do pássaro.
	"""
	var buttonStart = get_node("../VBoxContainer/StartButton")  # Obtém o botão de iniciar
	if buttonStart:
		buttonStart.hide()  # Esconde o botão Start após o jogo iniciar
	
	var buttonRestart = get_node("../VBoxContainer/RestartButton")  # Obtém o botão de reinício
	if buttonRestart:
		buttonRestart.show()  # Exibe o botão Restart caso esteja oculto
	
	is_alive = true  # Define que o jogo começou
	position = start_position  # Reseta a posição inicial do pássaro
	velocity = Vector2.ZERO  # Zera a velocidade para evitar quedas bruscas
	rotation = deg_to_rad(0)  # Reseta a rotação do pássaro para posição inicial

func game_over():
	"""
	Ativa a tela de Game Over e troca para a cena correspondente.
	"""
	is_alive = false  # O jogo para
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")  # Muda para a cena de Game Over

func _on_start_button_pressed() -> void:
	"""
	Chamado quando o botão de Start é pressionado.
	Inicia o jogo.
	"""
	start_game()

func _on_quit_button_pressed() -> void:
	"""
	Chamado quando o botão de sair é pressionado.
	Encerra o jogo.
	"""
	get_tree().quit()

func _on_restart_button_pressed() -> void:
	"""
	Chamado quando o botão de reiniciar é pressionado.
	Reinicia a cena principal do jogo.
	"""
	get_tree().change_scene_to_file("res://scenes/main.tscn")  # Reinicia o jogo trocando para a cena inicial
