extends Node2D

var asteroid_template: PackedScene
var ship: Node2D
var score: int
var score_label: Label
var asteroid_list: Array
var current_level: int
var level_screen: Node2D
var ship_lives: int

func _ready():
	randomize()
	asteroid_template = preload("res://Objects/Asteroid.tscn")
	ship = get_node("Ship") as Node2D
	level_screen = get_node("Level Screen")
	score = 0
	score_label = get_node("Score")
	ship_lives = 3
	
	start_level(1)
	
func start_level(level: int, hit = false):
	current_level = level
	ship.position = Vector2(400, 400)
	ship.rotation = 0
	ship.velocity = Vector2(0, 0)
	clear_asteroids()
	var points = level + 2
	while points > 0:
		var limit = 2
		if points < 3: limit = 0
		elif points < 6: limit = 1
		var size = mini(randi_range(0, 2), limit)
		if size == 0: points -= 1
		elif size == 1: points -= 3
		elif size == 2: points -= 6
		add_asteroid(size)
	level_screen.set_level(current_level)
	level_screen.show_screen(hit, ship_lives)

func add_asteroid(size: int):
	add_asteroid_at(size, random_location())
		
func add_asteroid_at(size: int, pos: Vector2, quantity = 1):
	for _count in quantity:
		var a = asteroid_template.instantiate() as Node2D
		a.set_meta("Size", size)
		a.position = pos
		a.create_asteroid.connect(add_asteroid_at)
		a.asteroid_dead.connect(asteroid_dead)
		call_deferred("add_child", a)
		asteroid_list.append(a)
	
func random_location():
	var x = randf_range(120, 800) * (-1 if randf() < 0.5 else 1)
	var y = randf_range(120, 800) * (-1 if randf() < 0.5 else 1)
	return Vector2(x, y)
	
func asteroid_dead(item: Node2D):
	var index = asteroid_list.find(item)
	set_score(score + (asteroid_list[index] as Node2D).size + 1)
	asteroid_list.remove_at(index)
	if asteroid_list.size() == 0: level_done()

func level_done():
	start_level(current_level + 1)

func _on_level_pause():
	ship.paused = true
	for item in asteroid_list: 
		item.paused = true
		item.visible = false

func _on_level_play():
	ship.unpause()
	for item in asteroid_list: 
		item.paused = false
		item.visible = true

func _on_ship_destroyed():
	ship_lives -= 1
	start_level(current_level, true)

func _on_reset(): #Asteroids doubled on level 1 after game over
	ship_lives = 3
	current_level = 1
	set_score(0)
	start_level(1)

func clear_asteroids():
	for item in asteroid_list: item.queue_free()
	asteroid_list.clear()

func set_score(s: int):
	score = s
	score_label.text = "Score: " + str(score)
