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
var bullet_spread_array : Array[float] =[0]


# Called when the node enters the scene tree for the first time.
func _ready():
	look_at(target)
	update_gun()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
			
			var new_bullet = bullet_scene.instantiate() 
			new_bullet.sprite=resource.bullet_sprite
			new_bullet.sprite_scale=resource.bullet_sprite_scale
			new_bullet.rotation= rotation + angle
			new_bullet.damage= damage
			new_bullet.speed = bullet_speed
			
			new_bullet.global_position= global_position + Vector2(50,0).rotated(rotation)
			if fired_by_player:
				new_bullet.set_collision_mask_value(3, true) #if gun is fired by player, bullets detect enemies and vice versa
			else:
				new_bullet.set_collision_mask_value(2, true)
				new_bullet.modulate = Color(1,0,0)
			
			owner.add_child(new_bullet)
		if fire_rate>0.2:
			timer.start(fire_rate)
		
	

func get_bullet_spread_array():
	bullet_spread_array=[0]
	
	for bullet in extra_bullets_in_spread:
		bullet_spread_array.push_back(spread_angle * (bullet+1))
		bullet_spread_array.push_back(spread_angle * (bullet+1) * -1)
		
		

func weapon_change():
	get_bullet_spread_array()


