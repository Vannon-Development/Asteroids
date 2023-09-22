extends Node2D

signal level_pause
signal level_play
signal reset_game

var level_label: Label
var instructions: Label
var hit_prompt: Label
var lives_prompt: Label
var level: int
var end_mode: bool

func _ready():
	level_label = get_node("Level Label")
	instructions = get_node("Instructions")
	hit_prompt = get_node("Hit")
	lives_prompt = get_node("Lives")
	level = 1

func set_level(l: int):
	level = l
	level_label.text = "Level " + str(level)
	instructions.visible = level == 1
	
func show_screen(hit = false, lives = 3):
	visible = true
	if hit && lives == 0:
		game_over()
		return
		
	hit_prompt.visible = hit
	if lives == 1: lives_prompt.text = "Last Try!"
	else: lives_prompt.text = str(lives) + " Tries Left"
	lives_prompt.visible = hit
	level_pause.emit()

func _input(event):
	if event.is_action_released("Start Level"):
		if end_mode:
			end_mode = false
			reset_game.emit()
		else:
			visible = false
			level_play.emit()

func game_over():
	level_label.text = "Game Over"
	instructions.visible = false
	hit_prompt.visible = false
	lives_prompt.visible = false
	end_mode = true
	level_pause.emit()
