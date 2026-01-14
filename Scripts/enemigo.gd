extends Area2D

@export var velocidad = 200

func _process(delta):
	position.y += velocidad * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

# Conecta la señal "area_entered" del propio Area2D a este script
func _on_area_entered(area):
	if area.name == "Jugador":
		area.queue_free() # Destruye al jugador (Game Over simple)
		queue_free()
	elif "Bala" in area.name: # Si usas nombres o grupos para identificar balas
		area.queue_free() # Destruye la bala
		queue_free() # Destruye al enemigo
		# Aquí sumarías puntos
