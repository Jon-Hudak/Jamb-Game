extends Area2D
signal door_entered
const orig_status_effect_resource = preload("res://status_effects_resource.gd")
@export var status_effect_resource_array: Array[Status_Effects_Resource]
var player_status_effects : Array[Status_Effects_Resource]
var enemy_status_effects : Array[Status_Effects_Resource]
# Called when the node enters the scene tree for the first time.

func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func change_door_label(text : String):
	%DoorLabel.text=text

func show_doors():
	$DoorLabel.show()
	$AnimatedSprite2D.play()
	$CollisionShape2D.set_deferred("disabled",false)

func hide_doors():
	$DoorLabel.hide()
	$AnimatedSprite2D.play_backwards()
	$CollisionShape2D.set_deferred("disabled",true)
	

func _on_body_entered(body):
	if body.has_method("update_stats"):
		body.update_stats(status_effect_resource_array)
	
	door_entered.emit(name)

func set_label(text:String):
	$DoorLabel.text=text

func update_door():
	var door_bonuses = [status_effect_resource_array.pick_random(), status_effect_resource_array.pick_random()]
	var door_penalty = [status_effect_resource_array.pick_random()]
	var door_text = "Behind Door:"
	for bonus in door_bonuses:
		door_text+="\n"+bonus.door_message
			
	for penalty in door_penalty:
		if penalty.isDebuff==false:
			door_text+="\n\nEnemy:\n" + penalty.door_message
	change_door_label(door_text)
