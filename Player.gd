extends CharacterBody2D
@export var max_health : int = 20
@export var health : int = max_health
@export var speed : int = 200
@onready var animation_tree = $AnimationTree
var status_effect_resources : Array[Status_Effects_Resource]


func _ready():
		global_position=Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y - 80)
		$Gun.fired_by_player=true
		
func _physics_process(_delta):
	var input_direction = Vector2(
	Input.get_action_strength("right") - Input.get_action_strength("left"),
	Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	var shot_direction = Vector2(
	Input.get_action_strength("shoot_right") - Input.get_action_strength("shoot_left"),
	Input.get_action_strength("shoot_down") - Input.get_action_strength("shoot_up")
	)

	$Gun.target=shot_direction if shot_direction!= Vector2.ZERO else get_global_mouse_position() 
	velocity=speed*input_direction.normalized()
	
	# Flip sprite whan moving left
	$Sprite2D.flip_h=true if input_direction.x<0 else false
	
	
	if Input.is_action_pressed("shoot") || Input.is_action_pressed("shoot_up") || Input.is_action_pressed("shoot_down") || Input.is_action_pressed("shoot_right") || Input.is_action_pressed("shoot_left"):
		$Gun.shoot()
		
		if global_position.direction_to(get_global_mouse_position()).x<0:
			#flip sprite when aiming left (overwrites movement)
			$Sprite2D.flip_h=true 
		else:
			$Sprite2D.flip_h=false
				
			
	if velocity!=Vector2.ZERO:
		move_and_slide()
		set_walking(true)
		update_blend_position(input_direction)
	else:
		set_walking(false)
	
func take_damage(damage):
	$BloodParticles.emitting= true
	health-=damage
	if health<=0:
		get_tree().reload_current_scene()
			
	
func pickup_weapon(weapon):
	$Gun.resource=preload("res://Resources/shotgun.tres")
	$Gun.weapon_change()
	
func set_walking(value):
	animation_tree["parameters/conditions/is_walking"] = value
	animation_tree["parameters/conditions/idle"] = !value

func update_blend_position(direction : Vector2):
	animation_tree["parameters/Walking/blend_position"] = direction
	animation_tree["parameters/Idle/blend_position"] = direction
	
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
		$Gun.spread_angle += new_resource.bullet_spread_angle
		$Gun.weapon_change()
		#$Gun.bullet_spread_angle += new_resource.bullet_spread_angle
