extends ParallaxBackground

# Velocidade do movimento do fundo
var scroll_speed = -100

func _process(delta: float) -> void:
	# Move o fundo com base na velocidade
	scroll_offset.x += scroll_speed * delta
