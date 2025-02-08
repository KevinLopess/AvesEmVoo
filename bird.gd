extends CharacterBody2D

@export var gravity: float = 900  # Gravidade puxando o pássaro para baixo
@export var jump_force: float = -400  # Força ao pressionar "Pular"
@export var max_rotation: float = 30  # Inclinação máxima ao subir
@export var fall_rotation: float = 90  # Inclinação ao cair
@export var rotation_speed: float = 5  # Velocidade da rotação
@export var float_amplitude: float = 10  # Distância de flutuação na espera
@export var float_speed: float = 2  # Velocidade da flutuação

var is_alive = false  # O jogo começa com o pássaro parado
var start_position: Vector2  # Guarda a posição inicial para flutuação
var float_time = 0.0  # Controle do movimento de flutuação

func _ready():
	start_position = position  # Guarda a posição inicial
	rotation = deg_to_rad(0)  # Garante que o pássaro inicie reto

func _physics_process(delta):
	if not is_alive:
		float_time += delta  # Atualiza o tempo da flutuação
		position.y = start_position.y + sin(float_time * float_speed) * float_amplitude  # Faz o pássaro flutuar
		return  # Sai da função, pois o jogo ainda não começou

	# Aplicar gravidade continuamente
	velocity.y += gravity * delta

	# Se o jogador apertar "Pular", faz o pássaro subir
	if Input.is_action_just_pressed("Pular"):
		velocity.y = jump_force

	# Ajustar rotação baseada na velocidade vertical
	if velocity.y < 0:  # Se estiver subindo
		rotation = lerp(rotation, deg_to_rad(-max_rotation), delta * rotation_speed)
	else:  # Se estiver caindo
		rotation = lerp(rotation, deg_to_rad(fall_rotation), delta * rotation_speed)

	move_and_slide()

func start_game():
	is_alive = true  # Ativa o jogo
	position = start_position  # Reseta posição antes do movimento normal
