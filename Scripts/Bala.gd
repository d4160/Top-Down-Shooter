extends Area2D

@export var velocidad = 600
var direccion = Vector2.UP

func _process(delta):
	position += direccion * velocidad * delta

func set_direction(nueva_dir: Vector2):
	direccion = nueva_dir.normalized()

# Conecta la señal "screen_exited" del VisibleOnScreenNotifier2D a este script
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free() # Elimina la bala para liberar memoria
