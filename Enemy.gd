extends CharacterBody2D
signal enemy_died
var return_position
@export var health=20
@onready var player = get_node("/root/Main/Player")

func _ready():
	return_position = get_viewport_rect().size / 2
	

func _physics_process(_delta):
	if global_position.distance_to(return_position) > 1:
		velocity= 200 * global_position.direction_to(return_position)
		move_and_slide()
	$Gun.target=player.global_position
	$Gun.shoot()

func take_damage(damage):
	$BloodParticles.emitting= true
	health-=damage
	if health<=0:
		queue_free()
		emit_signal("enemy_died")
		
	
