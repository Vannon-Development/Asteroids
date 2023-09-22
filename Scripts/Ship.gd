extends Area2D

signal ship_destroyed

var accel: float
var turnSpeed: float
var normal_visual: Node2D
var jet_visual: Node2D
var fire_position: Node2D
var shot: PackedScene
var fire_time: float
var max_speed: float

var velocity: Vector2
var next_fire: float
var paused: bool
var hit_allowed_time: int

func _ready():
	accel = get_meta("Acceleration")
	turnSpeed = get_meta("TurnSpeed")
	normal_visual = get_node(get_meta("NormalSprite"))
	jet_visual = get_node(get_meta("JetSprite"))
	fire_position = get_node(get_meta("FirePosition"))
	shot = preload("res://Objects/Shot.tscn")
	fire_time = get_meta("FireTime")
	max_speed = get_meta("MaxSpeed")
	
func _process(_delta):
	if paused: return
	var jet = Input.is_action_pressed("jet")
	normal_visual.visible = !jet
	jet_visual.visible = jet

func _physics_process(delta):
	if paused: return
	if Input.is_action_pressed("Left"): rotation_degrees -= turnSpeed * delta
	if Input.is_action_pressed("Right"): rotation_degrees += turnSpeed * delta
	if Input.is_action_pressed("jet"): velocity += Vector2.RIGHT.rotated(rotation) * (accel * delta)
	if Input.is_action_just_pressed("Fire"): force_fire()
	elif Input.is_action_pressed("Fire"): try_fire()
		
	if velocity.length() >= max_speed: velocity = Vector2.RIGHT.rotated(velocity.angle()) * max_speed
		
	position += velocity * delta
	if position.x < 0: position.x += 800
	if position.x >= 800: position.x -= 800
	if position.y < 0: position.y += 800
	if position.y >= 800: position.y -= 800
	
func try_fire():
	if Time.get_ticks_msec() >= next_fire: force_fire()

func force_fire():
	var s = shot.instantiate() as Node2D
	s.global_position = fire_position.global_position
	s.rotation = rotation
	get_node("/root").add_child(s)
	next_fire = Time.get_ticks_msec() + fire_time

func _on_ship_hit(_area):
	if paused || Time.get_ticks_msec() < hit_allowed_time: return
	ship_destroyed.emit()

func unpause():
	paused = false
	hit_allowed_time = Time.get_ticks_msec() + 2500
