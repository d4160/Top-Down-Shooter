extends Node2D

@export var escenas_enemigos : Array[PackedScene]
@export var escena_jefe : PackedScene
@export var enemigos_para_jefe : int = 10
@export var posicion_y_jefe : float = 100.0
@export var escena_hud : PackedScene

var enemigos_derrotados : int = 0
var jefe_instanciado : bool = false

func _ready():
	# Instanciar HUD si está asignado
	if escena_hud:
		var hud = escena_hud.instantiate()
		add_child(hud)
		
	# Conecta la señal "timeout" del Timer a este script
	$TimerEnemigos.timeout.connect(_on_timer_enemigos_timeout)

func _on_timer_enemigos_timeout():
	if escenas_enemigos.is_empty() or jefe_instanciado:
		return
		
	var escena_aleatoria = escenas_enemigos.pick_random()
	var enemigo = escena_aleatoria.instantiate()
	
	# Conectar la señal de muerte del enemigo de forma segura
	if enemigo.has_signal("morir"):
		enemigo.connect("morir", _on_enemigo_derrotado)
	
	# Posición aleatoria en X, y un poco arriba de la pantalla en Y
	var ancho_pantalla = get_viewport_rect().size.x
	var x_random = randf_range(30, ancho_pantalla - 30)
	
	enemigo.position = Vector2(x_random, -50)
	add_child(enemigo)

func _on_enemigo_derrotado():
	enemigos_derrotados += 1
	GameManager.add_score(10) # Sumar puntos por enemigo
	print("Enemigos derrotados: ", enemigos_derrotados)
	
	if enemigos_derrotados >= enemigos_para_jefe and not jefe_instanciado:
		spawn_jefe()

func spawn_jefe():
	jefe_instanciado = true
	$TimerEnemigos.stop() # Detener la generación de enemigos normales
	
	if escena_jefe:
		var jefe = escena_jefe.instantiate()
		var ancho_pantalla = get_viewport_rect().size.x
		jefe.position = Vector2(ancho_pantalla / 2, posicion_y_jefe)
		add_child(jefe)
		print("¡El Jefe ha aparecido!")
