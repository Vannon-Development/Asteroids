extends Node2D

var speed: float

var kill_time

func _ready():
	speed = get_meta("Speed")
	kill_time = Time.get_ticks_msec() + (get_meta("Range") / speed) * 1000

func _physics_process(delta):
	position += Vector2.RIGHT.rotated(rotation) * (speed * delta)
	if position.x < 0: position.x += 800
	if position.x >= 800: position.x -= 800
	if position.y < 0: position.y += 800
	if position.y > 800: position.y -= 800
	if Time.get_ticks_msec() >= kill_time: queue_free()
