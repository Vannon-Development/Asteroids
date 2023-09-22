extends Node2D

signal create_asteroid
signal asteroid_dead

var size: int
var small_visual: Node2D
var medium_visual: Node2D
var large_visual: Node2D

var velocity: Vector2
var angVelocity: float
var paused: bool

func _ready():
	size = get_meta("Size")
	small_visual = get_node(get_meta("SmallVisual")) as Node2D
	medium_visual = get_node(get_meta("MediumVisual")) as Node2D
	large_visual = get_node(get_meta("LargeVisual")) as Node2D
	
	var sizePrefix: String
	if size == 0: sizePrefix = "Small"
	elif size == 1: sizePrefix = "Medium"
	else: sizePrefix = "Large"
	
	var speedRange = get_meta(sizePrefix + "SpeedRange")
	var angRange = get_meta(sizePrefix + "AngleRange")
	velocity = Vector2.RIGHT.rotated(randf_range(0, 2 * PI)) * randf_range(speedRange.x, speedRange.y)
	angVelocity = randf_range(angRange.x, angRange.y)
	
	small_visual.visible = size == 0
	(small_visual as CollisionPolygon2D).disabled = size != 0
	medium_visual.visible = size == 1
	(medium_visual as CollisionPolygon2D).disabled = size != 1
	large_visual.visible = size >= 2
	(large_visual as CollisionPolygon2D).disabled = size != 2

func _physics_process(delta):
	if paused: return
	position += velocity * delta
	if position.x < 0: position.x += 800
	if position.x >= 800: position.x -= 800
	if position.y < 0: position.y += 800
	if position.y >= 800: position.y -= 800
	rotation_degrees += angVelocity * delta

func _on_area_entered(area):
	if size == 0: queue_free()
	elif size == 1:
		create_asteroid.emit(0, position, 3)
		queue_free()
	else:
		create_asteroid.emit(1, position, 2)
		queue_free()
	area.queue_free()
	asteroid_dead.emit(self)
