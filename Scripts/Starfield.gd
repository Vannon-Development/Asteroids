extends Node2D

var stars: int
var starList: Array

func _ready():
	stars = get_meta("Stars")
	starList = get_meta("StarSprites")
	fill_stars()

func fill_stars():
	for index in stars:
		var sprite = Sprite2D.new()
		sprite.texture = starList[randi_range(0, starList.size() - 1)]
		sprite.position = Vector2(randf_range(0, 800), randf_range(0, 800))
		sprite.modulate = Color.from_hsv(randf(), randf_range(0, 0.25), 1.0)
		add_child(sprite)
