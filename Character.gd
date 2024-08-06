extends CharacterBody2D

# big differences between GDScript: the header classifies the Object type (extends)
# You DO NOT have to have preprocessor directives before compilation (#include iostream, stdin.h)
# Nor do you have to include namespace definitions like (using namespace std)


# about variable types in GDScript: they do not require datatype definition, this means
# that GDScript is dynamically (not statically typed like C++), meaning whatever you declare  here,
# will not be forced to stay (like you can set a string to an integer later)

# declare your variables below using the var keyword
# note that semicolons are not required for GDScript, as they are not really necessary as no console output
# is being displayed

var speed = 200
var health = 5

var is_invincible = false

# lesson 4
var score = 0
var jumps = 2

# declare constants,

const jump_height = -350

# show this later in physics process
const gravity = 9.8 # show her this after 

# onready lets your code access nodes and their attributes 

@onready var animations = $AnimatedSprite2D

var hitbox # you can also declare without onready by using the ready function


func _ready():
	# about functions: compared to C++, where you would have to define functions as
		# (datatype) function_name(parameters and their datatype)
		# you only have to use func, as GDScript not require return values in functions
		
		# a thing  to note is that some functions have the prefix underscore_,
		# these are called built in functions and come with the class (CharacterBody2D)
		
		# lets use the _ready() function
	
	# you can declare in here
	hitbox = $Area2D
		

func _physics_process(delta):
	# physics process and process are infinite loops, the biggest difference is that process accounts
	# for laggy devices by having a changing fps speed, while physics doesnt care what speed and runs anyway
	# lets use physics process 
	
	# delta is the dynamic value that represents how many ticks have run since the function began calling
	
	# unlike C++, gdscript uses elif instead of else if, idk why though
	if (Input.is_action_pressed("ui_right")):
		
		animations.flip_h = false
		if (is_on_floor()):
			animations.play("Run")
		velocity.x = speed
	elif (Input.is_action_pressed("ui_left")):
		
		animations.flip_h = true
		if (is_on_floor()):
			animations.play("Run")
		velocity.x = -speed
	else:
		velocity.x = 0
	
	# only do is_on_floor, and do jumps > 0 for lesson 4
	if ( (is_on_floor() or jumps > 0) and Input.is_action_just_pressed("ui_up")):
		animations.play("Jump")
		velocity.y = jump_height
		
		# lesson 4 unlikc c++, you cant do jumps--
		jumps -= 1
		if (jumps >= 0 and is_on_floor() == false):
			animations.play("DoubleJump")
		
	elif (is_on_floor() == false):
		
		if (velocity.y > 0):
			animations.play("Fall")
		velocity.y += gravity
	
	# lesson 4
	if (is_on_floor()):
		jumps = 2
		
	if (velocity == Vector2.ZERO):
		animations.play("Idle")
			
	move_and_slide()
	

# FOR PART 3
@onready var iframe = $Timer
@onready var hp_bar = $Label

# lesson 4
@onready var score_bar = $Label2

func _on_area_2d_area_entered(area):
	if area.is_in_group("Danger") and is_invincible == false:
		health -= 1
		animations.modulate = Color(1.0, 0.2, 0.2, 0.5)
		iframe.start()
		is_invincible = true
		hp_bar.text = "Health " + str(health)
	
	if health == 0:
		self.queue_free()
		
	if area.is_in_group("Collectible"):
		score += 1
		area.queue_free()
		score_bar.text = "Score "  + str(score)
		
		
func _on_timer_timeout():
	if is_invincible == true:
		animations.modulate = Color(1.0, 1.0, 1.0, 1.0)
		is_invincible = false
