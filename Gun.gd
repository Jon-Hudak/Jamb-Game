extends Node2D

signal gun_shot

@export var damage : int = 0 
@export var bullet_speed : int = 0
@export var extra_bullets_in_spread : int = 0
@export var spread_angle : float = 0.0
var fire_rate : float = 0
@export var fired_by_player : bool = false
@export var resource:Resource
@export var bullet_scene: PackedScene
@export var current_weapon : Resource
#@export var change_weapon_delay = 0.5
@export var target : Vector2
@onready var timer : Timer = $FireRateTimer
@export var isNested = false
var bullet_spread_array : Array[float] =[0]
@export var isAttacking : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	
	update_gun()
	print($Barrel)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !isAttacking:
		
		if isNested:
			get_parent().look_at(target)
			
		else: 
			look_at(target)
			
func update_gun():	
	damage += resource.damage
	bullet_speed += resource.bullet_speed
	extra_bullets_in_spread += resource.extra_bullets_in_spread
	spread_angle += resource.bullet_spread_angle
	fire_rate += resource.fire_rate
	get_bullet_spread_array()
	
	
func shoot():
	if timer.time_left<=0:
		for angle in bullet_spread_array:
			instance_bullet(angle)
		if fire_rate>0.1:
			timer.start(fire_rate)
		
	

func get_bullet_spread_array():
	bullet_spread_array=[0]
	
	for bullet in extra_bullets_in_spread:
		bullet_spread_array.push_back(spread_angle * (bullet+1))
		bullet_spread_array.push_back(spread_angle * (bullet+1) * -1)
		
func circle_attack():
	
	for angle in [deg_to_rad(0),deg_to_rad(45),deg_to_rad(90),deg_to_rad(135),deg_to_rad(180),deg_to_rad(-45),deg_to_rad(-90),deg_to_rad(-135),]:
		instance_bullet(angle)
		


func weapon_change():
	get_bullet_spread_array()

func instance_bullet(angle=0):
	var new_bullet = bullet_scene.instantiate() 
	new_bullet.sprite=resource.bullet_sprite
	new_bullet.sprite_scale=resource.bullet_sprite_scale
	new_bullet.rotation= angle + global_rotation
	new_bullet.damage= damage
	new_bullet.speed = bullet_speed
	
	new_bullet.global_position= $Barrel.global_position + Vector2(0,0).rotated(rotation)
	if fired_by_player:
		new_bullet.set_collision_mask_value(3, true) #if gun is fired by player, bullets detect enemies and vice versa
	else:
		new_bullet.set_collision_mask_value(2, true)
		new_bullet.modulate = Color(1,0,0)
	
	get_tree().root.add_child(new_bullet)
