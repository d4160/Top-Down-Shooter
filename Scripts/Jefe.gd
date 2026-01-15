extends Area2D

@export var salud_maxima = 20.0
@export var velocidad_base = 150.0
@export var escena_bala: PackedScene

var salud_actual: float
var fase_actual = 1
var direccion = 1
var tiempo_ataque = 0.0
var intervalo_ataque = 1.5
var rotacion_rafaga = 0.0

@onready var health_bar = get_node_or_null("ProgressBar")
@onready var timer_ataque = Timer.new()

func _ready():
	salud_actual = salud_maxima
	if health_bar:
		health_bar.max_value = salud_maxima
		health_bar.value = salud_actual
	
	add_child(timer_ataque)
	timer_ataque.wait_time = intervalo_ataque
	timer_ataque.timeout.connect(_on_timer_ataque_timeout)
	timer_ataque.start()
	
	# Conectar señal de Victoria para cambiar de escena
	GameManager.victory.connect(_on_victory)

func _on_victory():
	get_tree().change_scene_to_file("res://Scenes/Victory.tscn")

func _process(delta):
	actualizar_fase()
	manejar_movimiento(delta)
	
	if fase_actual == 3:
		rotacion_rafaga += delta * 5.0 # Velocidad de rotación de la ráfaga

func actualizar_fase():
	var porcentaje_vida = (salud_actual / salud_maxima) * 100.0
	
	if porcentaje_vida > 50:
		if fase_actual != 1:
			cambiar_a_fase(1)
	elif porcentaje_vida > 20:
		if fase_actual != 2:
			cambiar_a_fase(2)
	else:
		if fase_actual != 3:
			cambiar_a_fase(3)

func cambiar_a_fase(nueva_fase):
	fase_actual = nueva_fase
	match fase_actual:
		1:
			intervalo_ataque = 1.5
		2:
			intervalo_ataque = 1.0
		3:
			intervalo_ataque = 0.5
	
	timer_ataque.wait_time = intervalo_ataque
	print("Jefe entrando a Fase: ", fase_actual)

func manejar_movimiento(delta):
	match fase_actual:
		1:
			# Movimiento horizontal simple
			position.x += velocidad_base * direccion * delta
			if position.x > 500 or position.x < 100:
				direccion *= -1
		2:
			# Movimiento horizontal más rápido y zig-zag leve
			position.x += velocidad_base * 1.5 * direccion * delta
			position.y += sin(Time.get_ticks_msec() * 0.005) * 2.0
			if position.x > 500 or position.x < 100:
				direccion *= -1
		3:
			# Persecución suave del jugador (asumiendo que existe un grupo "jugador")
			var jugadores = get_tree().get_nodes_in_group("jugador")
			if jugadores.size() > 0:
				var jugador = jugadores[0]
				position.x = move_toward(position.x, jugador.position.x, velocidad_base * 2.0 * delta)

func _on_timer_ataque_timeout():
	atacar()

func atacar():
	if escena_bala == null: return
	
	match fase_actual:
		1:
			disparar_bala(Vector2.DOWN)
		2:
			disparar_bala(Vector2.DOWN)
			disparar_bala(Vector2(-0.5, 1).normalized())
			disparar_bala(Vector2(0.5, 1).normalized())
		3:
			# Ráfaga circular rotatoria
			var num_balas = 12
			for i in range(num_balas):
				var angulo = i * TAU / num_balas + rotacion_rafaga
				disparar_bala(Vector2.DOWN.rotated(angulo))

func disparar_bala(dir: Vector2):
	var bala = escena_bala.instantiate()
	get_parent().add_child(bala)
	bala.position = position
	if bala.has_method("set_direction"):
		bala.set_direction(dir)

func recibir_danio(cantidad):
	salud_actual -= cantidad
	if health_bar:
		health_bar.value = salud_actual
	
	if salud_actual <= 0:
		morir()

func morir():
	# Efectos de explosión o similar aquí
	GameManager.add_score(100) # Gran puntaje por el jefe
	GameManager.win_game()
	queue_free()

func _on_area_entered(area):
	if area.is_in_group("balas_jugador"):
		recibir_danio(1)
		area.queue_free()
