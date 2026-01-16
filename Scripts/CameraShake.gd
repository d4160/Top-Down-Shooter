extends Camera2D

var fuerza_temblor = 0.0

func _process(delta):
	if fuerza_temblor > 0:
		# 1. Mueve la cámara a una posición aleatoria
		offset = Vector2(randf_range(-fuerza_temblor, fuerza_temblor), randf_range(-fuerza_temblor, fuerza_temblor))

		# 2. Reduce la fuerza poco a poco (se calma)
		fuerza_temblor = lerp(fuerza_temblor, 0.0, 5.0 * delta)
	else:
		# 3. Si no hay temblor, regresa al centro
		offset = Vector2.ZERO

# Esta función la llamaremos desde otros scripts para activar el temblor
func aplicar_temblor(intensidad):
	fuerza_temblor = intensidad
