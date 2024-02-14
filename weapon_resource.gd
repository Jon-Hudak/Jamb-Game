extends Resource
class_name Weapon_Resource

@export var weapon_name : String


#treat -1 as infinite
@export var current_ammo : int = -1 
@export var magazine_size : int = -1 
@export var fire_rate : float = 0.1
@export var damage : float
@export var bullet_speed : int = 100
@export var auto_fire : bool = true
@export var extra_bullets_in_spread : int = 0 #Always one bullet in the middle. Each additional bullet adds 1 to either side of center. A 1 means 3 bullets will be fired. 2 will fire 5 bullets.
@export var bullet_spread_angle : float = 0.1

@export var gun_sprite : Texture
@export var bullet_sprite : Texture
@export var gun_sprite_scale : float = 1
@export var bullet_sprite_scale : float = 1
 


