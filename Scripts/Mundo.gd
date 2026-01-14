extends Node2D

@export var escena_enemigo : PackedScene

func _ready():
	# Conecta la señal "timeout" del Timer a este script
	$TimerEnemigos.timeout.connect(_on_timer_enemigos_timeout)

func _on_timer_enemigos_timeout():
	var enemigo = escena_enemigo.instantiate()
	
	# Posición aleatoria en X, y un poco arriba de la pantalla en Y
	var ancho_pantalla = get_viewport_rect().size.x
	var x_random = randf_range(30, ancho_pantalla - 30)
	
	enemigo.position = Vector2(x_random, -50)
	add_child(enemigo)
