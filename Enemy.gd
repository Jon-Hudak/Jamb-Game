extends CharacterBody2D

signal enemy_died

@export var max_health : int = 20

@export var speed= 100
@export var range_to_player : int = 350
@export var timer_min : float = 0.1
@export var timer_max : float = 2
@onready var player = get_node("/root/Main/Player")
@onready var move_timer = $MoveTimer
@onready var shoot_timer = $ShootTimer
@export var status_effect_resource : Array[Status_Effects_Resource]
var strafe_direction : Vector2 = Vector2.ZERO
var direction : Vector2 = Vector2.ZERO
var isAttacking : bool = false
var health : int


func _ready():
	if status_effect_resource:
		update_stats(status_effect_resource)
	health=max_health
	#print("damage:", %Gun.damage, "Health: ", max_health, "currHP",health )
	$Gun.target=player.global_position
	move_timer.start(calculate_timer())
	
	#direction=update_direction()

func _physics_process(_delta):
	$Gun.target=player.global_position
	if isAttacking:
		shoot()
	
	else:
		move()
		

func take_damage(damage):
	$BloodParticles.emitting= true
	health-=damage
	if health<=0:
		queue_free()
		emit_signal("enemy_died")
		
func shoot():
	$Gun.target=player.global_position
	$Gun.shoot()
	


func update_direction():
	var direction_to_player = global_position.direction_to(player.global_position)
	#var randomized_direction = 1 if randi_range(0,1) == 1 else -1
	var randomized_direction = deg_to_rad(randi_range(1,360))
	if global_position.distance_to(player.global_position)>range_to_player:
		direction=direction_to_player
	else:
		direction= direction_to_player.rotated(deg_to_rad(90*randomized_direction))
	
func move():
	velocity = direction * speed
	move_and_slide()
	
func calculate_timer():
	return randf_range(timer_min,timer_max)


func _on_move_timer_timeout():
	update_direction()
	shoot_timer.start(calculate_timer())
	isAttacking=true


func _on_shoot_timer_timeout():
	move_timer.start(calculate_timer())
	isAttacking=false
	
func update_stats(new_resources : Array[Status_Effects_Resource]):
	for new_resource : Status_Effects_Resource in new_resources:
		speed += new_resource.movement_speed
		max_health+= new_resource.max_health
		health+=new_resource.max_health
		if health>max_health:
			health=max_health
		$Gun.fire_rate += new_resource.fire_rate
		$Gun.damage += new_resource.damage
		$Gun.bullet_speed += new_resource.bullet_speed
		$Gun.extra_bullets_in_spread += new_resource.extra_bullets_in_spread
		$Gun.weapon_change()
		#$Gun.bullet_spread_angle += new_resource.bullet_spread_angle

