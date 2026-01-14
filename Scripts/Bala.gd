extends Area2D

@export var velocidad = 600

func _process(delta):
	position.y -= velocidad * delta

# Conecta la señal "screen_exited" del VisibleOnScreenNotifier2D a este script
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free() # Elimina la bala para liberar memoria
