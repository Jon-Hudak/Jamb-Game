extends CharacterBody2D

signal boss_died

@export var max_health : int = 20

@export var speed= 300
@export var range_to_target : int = 350
@export var timer_min : float = 1
@export var timer_max : float = 2
@onready var player = get_node("/root/Main/Player")
@onready var move_timer = $MoveTimer
@onready var shoot_timer = $ShootTimer
@export var status_effect_resource : Array[Status_Effects_Resource]
var strafe_direction : Vector2 = Vector2.ZERO
var direction : Vector2 = Vector2.ZERO
var isAttacking : bool = false
var health : int
var added_speed : int = 0
var attack_list : Array = [ "shoot","bowling_attack", "circle_attack",]
var current_attack = attack_list[0]


func _ready():
	if status_effect_resource:
		update_stats(status_effect_resource)
	health=max_health
	print("damage: ",$Gun.damage, "Health: ", max_health, "currHP",health )
	$Gun.target=player.global_position
	move_timer.start(calculate_timer())
	
	
	#direction=update_direction()

func _physics_process(_delta):
	$Gun.target=player.global_position
	
	if isAttacking && current_attack=="bowling_attack":
		if move() == true:
			update_direction(player,false)
			
			
	else:
		shoot()
		if move() == true:
			update_direction(player,true)
	
	
		

func take_damage(damage):
	$BloodParticles.emitting= true
	health-=damage
	if health<=0:
		queue_free()
		emit_signal("enemy_died")
		
func shoot():
	$Gun.target=player.global_position
	$Gun.shoot()
	
func update_direction(target=player, random : bool = true):
	var direction_to_target = global_position.direction_to(target.global_position)
	#var randomized_direction = 1 if randi_range(0,1) == 1 else -1
	var randomized_direction = deg_to_rad(randi_range(1,360))
	if !random || global_position.distance_to(target.global_position)>range_to_target:
		direction=direction_to_target
	else:
		direction = direction_to_target.rotated(deg_to_rad(90*randomized_direction))
	
func move():
	velocity = direction * (speed + added_speed)
	return move_and_slide()
	
func calculate_timer(min=timer_max, max=timer_max):
	return randf_range(min, max)


func _on_move_timer_timeout():
	current_attack=attack_list.pick_random()
	call(current_attack)
	print(current_attack)
	
	


func _on_shoot_timer_timeout():
	added_speed=0
	update_direction(player, true)
	move_timer.start(calculate_timer())
	isAttacking=false


func bowling_attack():
	
	print("bowling_attack")
	update_direction(player, false)
	shoot_timer.start(calculate_timer(5,10))
	isAttacking=true

func circle_attack():
	$Gun.circle_attack()
	print("circle_attack")
	shoot()	
	shoot_timer.start(calculate_timer())
	isAttacking=true
	
	
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

