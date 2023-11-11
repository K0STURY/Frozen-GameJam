extends CharacterBody2D

@export var speed = 400
@export var freezing: float = 0
@export var freezingSpeed: float
@export var torchHeal: float = 15
@export var progressBar: ProgressBar 

var inputDir: Vector2
var freezingTimer: Timer


func _ready():
	freezingTimer = Timer.new()
	add_child(freezingTimer)
	freezingTimer.one_shot = true
	freezingTimer.connect("timeout",self.Timeout)
	freezingTimer.wait_time = 100.0
	freezingTimer.start()

func Timeout():
	print_debug("dead")
	
func _process(_delta):
	progressBar.value = inverse_lerp(0, 100, freezingTimer.time_left)
	
func _physics_process(_delta):
	velocity = inputDir * speed
	GetInput()
	move_and_slide()
	look_at(get_global_mouse_position())

func GetInput():
	inputDir = Input.get_vector("left", "right", "up", "down")
	
func OnTorchBodyEntered(_body):
	print_debug("pickup")
	var timeLeft = freezingTimer.time_left
	freezingTimer.stop()
	freezingTimer.wait_time = timeLeft + torchHeal
	freezingTimer.start()
