extends Area2D

@export var velocidad = 200

func _process(delta):
	position.y += velocidad * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

# Conecta la señal "area_entered" del propio Area2D a este script
func _on_area_entered(area):
	# 1. ¿Me tocó una bala?
	if area.is_in_group("balas"):
		area.queue_free()  # Destruimos la bala
		queue_free()       # Nos destruimos a nosotros (el enemigo)
		# Aquí podrías poner: Global.puntos += 10
		
	# 2. ¿Me tocó el jugador?
	elif area.is_in_group("jugador"):
		area.queue_free()  # Destruimos al jugador
		queue_free()       # Destruimos al enemigo
		# Aquí podrías poner: get_tree().reload_current_scene() para reiniciar
