extends Area2D

@export var velocidad = 400
@export var escena_bala : PackedScene # Aquí arrastraremos la escena de la bala luego

var tamano_pantalla

func _ready():
	tamano_pantalla = get_viewport_rect().size
	add_to_group("jugador") # Aseguramos que esté en el grupo para el jefe
	
	# Conectar señal de Game Over para cambiar de escena
	GameManager.game_over.connect(_on_game_over)

func _on_game_over():
	get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")

func _process(delta):
	# Movimiento
	var direccion = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	position += direccion * velocidad * delta
	
	# Mantener dentro de la pantalla (Clamping)
	position.x = clamp(position.x, 0, tamano_pantalla.x)
	position.y = clamp(position.y, 0, tamano_pantalla.y)

	# Disparo (Espacio o Enter)
	if Input.is_action_just_pressed("shoot"):
		disparar()

func disparar():
	if escena_bala:
		var bala = escena_bala.instantiate()
		bala.position = $Cañon.global_position
		get_parent().add_child(bala) # Añadimos la bala al mundo, no al jugador
		
func _on_area_entered(area):
	if area.is_in_group("balas_jefe"):
		GameManager.lose_life()         # Restamos vida global
		area.queue_free()
		
		if GameManager.lives <= 0:
			queue_free()
	
	elif area.is_in_group("enemigos"):
		GameManager.lose_life()    
		if GameManager.lives <= 0:
			queue_free()     # Restamos vida global
	
