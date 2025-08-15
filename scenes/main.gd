extends Node

@export var pipe_scene : PackedScene
@onready var sfx_fall: AudioStreamPlayer = $sfx_fall
@onready var sfx_score: AudioStreamPlayer = $sfx_score
@onready var sfx_start: AudioStreamPlayer = $sfx_start



var game_running : bool
var game_over : bool
var scroll 
var score
const SCROLL_SPEED : int = 3
var screen_size : Vector2i
var ground_height : int
var pipes : Array
const PIPE_DELAY : int = 100
const PIPE_RANGE : int = 200
var sfx_fall_play : int = 0

func _ready():
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game()

func new_game():
	#reset variables
	game_running = false
	game_over = false
	score = 0
	$ScoreLabel.text = "SCORE: " + str(score)
	scroll = 0
	$GameOver.hide()
	get_tree().call_group("pipes", "queue_free")
	pipes.clear()
	generate_pipes()
	$Bird.reset()

func _input(event):
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false:
					start_game()
				else:
					if $Bird.flying:
						$Bird.flap()
						check_top()

func start_game():
	game_running = true
	$Bird.flying = true
	$Bird.flap()
	# start pipe timer
	$PipeTimer.start()
	$sfx_start.play()
	
func _process(delta):
	if game_running:
		scroll += SCROLL_SPEED
		#reset scroll
		if scroll >= screen_size.x:
			scroll = 0
		#move ground node
		$Ground.position.x = -scroll
		# pipes
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED
		
func _on_pipe_timer_timeout():
	generate_pipes()

func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(scored)
	add_child(pipe)
	pipes.append(pipe)

func scored():
	score += 1
	$ScoreLabel.text = "SCORE: " + str(score)
	$sfx_score.play()
	
func check_top():
	if $Bird.position.y < 0:
		$Bird.falling = true
		stop_game()

func stop_game():
	$PipeTimer.stop()
	$Bird.flying = false
	game_running = false
	game_over = true
	$GameOver.show()
	if sfx_fall_play <1:
		$sfx_fall.play()
		sfx_fall_play += 1

func bird_hit():
	$Bird.falling = true
	stop_game()
	
func _on_ground_hit() -> void:
	$Bird.falling = false
	stop_game()


func _on_game_over_restart():
	new_game() # Replace with function body.
