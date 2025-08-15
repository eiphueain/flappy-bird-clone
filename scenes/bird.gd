extends CharacterBody2D

# how quickly the bird drops 
const GRAVITY : int = 1000
# limits the max fall speed of the bird
const MAX_VEL : int = 600
# how much the bird jumps up
const FLAP_SPEED : int = -500
# checks if the bird is flying
var flying : bool = false
# checks if the bird is falling
var falling : bool = false
# defines the start position aka x, y coordinates of the bird
const START_POS = Vector2(100,400)

# called when the node enters the scene tree for the first time
func _ready():
	reset()

# resets the bird to its original state
func reset():
	falling = false
	flying = false
	position = START_POS
	set_rotation(0)

# called every frame, delta is the time passed since the last frame
func _physics_process(delta):
	if flying or falling:
		velocity.y += GRAVITY * delta #WTF is this
		# terminal velocity
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL
		if flying:
			set_rotation(deg_to_rad(velocity.y * 0.05))
			$AnimatedSprite2D.play()
		elif falling:
			set_rotation(PI/2)
			$AnimatedSprite2D.stop()
		move_and_collide(velocity * delta)
	else: #if the bird isn't flying or falling, the animation just stops
		$AnimatedSprite2D.stop()

# allows bird to flap and fly upwards
func flap():
	velocity.y = FLAP_SPEED
