extends Area2D

@export var velocidad = 400
@export var escena_bala : PackedScene 

# Variables para el disparo especial
@export var cooldown_especial : float = 1.0 
var puede_disparar_especial : bool = true

var tamano_pantalla

func _ready():
	tamano_pantalla = get_viewport_rect().size
	add_to_group("jugador")
	GameManager.game_over.connect(_on_game_over)

func _on_game_over():
	get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")

func _process(delta):
	# Movimiento del jugador
	var direccion = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	position += direccion * velocidad * delta
	
	position.x = clamp(position.x, 0, tamano_pantalla.x)
	position.y = clamp(position.y, 0, tamano_pantalla.y)

	# Disparo Normal
	if Input.is_action_just_pressed("shoot"):
		disparar()

	# Disparo Especial
	if Input.is_action_just_pressed("special_shoot") and puede_disparar_especial:
		disparar_especial()

func disparar():
	if escena_bala:
		var bala = escena_bala.instantiate()
		bala.position = $Cañon.global_position
		# IMPORTANTE: Como tu bala usa set_direction, debemos dársela al disparo normal también
		# Asumimos que el disparo normal va hacia arriba (Vector2.UP)
		if bala.has_method("set_direction"):
			bala.set_direction(Vector2.UP)
		get_parent().add_child(bala) 
		
		var bala2 = escena_bala.instantiate()
		bala2.position = $Cañon2.global_position
		if bala2.has_method("set_direction"):
			bala2.set_direction(Vector2.UP)
		get_parent().add_child(bala2)

func disparar_especial():
	if escena_bala:
		var cantidad_balas = 10
		var grados_separacion = 10.0
		
		# Calculamos el arco total para centrarlo
		# Si son 10 balas separadas 10 grados, hay 9 espacios entre ellas. Total 90 grados de ancho.
		var angulo_total = (cantidad_balas - 1) * grados_separacion
		var angulo_inicio = -angulo_total / 2.0 # Empezamos a la izquierda del centro
		
		for i in range(cantidad_balas):
			var bala = escena_bala.instantiate()
			bala.position = global_position # Salen desde el centro del jugador
			
			# 1. Calculamos el ángulo offset para esta bala específica
			var angulo_actual = angulo_inicio + (i * grados_separacion)
			
			# 2. Tomamos el vector "Frente" (UP) y lo rotamos
			# Convertimos grados a radianes porque rotated() usa radianes
			var vector_direccion = Vector2.UP.rotated(deg_to_rad(angulo_actual))
			
			get_parent().add_child(bala)
			
			# 3. Llamamos a TU función en Bala.gd
			if bala.has_method("set_direction"):
				bala.set_direction(vector_direccion)
				
			# Opcional: Rotar la imagen de la bala para que apunte a donde va
			# + PI/2 suele ser necesario si el sprite de la bala apunta hacia arriba por defecto
			bala.rotation = vector_direccion.angle() + PI/2

		iniciar_cooldown()

func iniciar_cooldown():
	puede_disparar_especial = false
	await get_tree().create_timer(cooldown_especial).timeout
	puede_disparar_especial = true

func _on_area_entered(area):
	if area.is_in_group("balas_jefe") or area.is_in_group("enemigos"):
		GameManager.lose_life()
		if area.is_in_group("balas_jefe"):
			area.queue_free()
		
		if GameManager.lives <= 0:
			queue_free()
