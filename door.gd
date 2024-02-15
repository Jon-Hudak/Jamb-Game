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
		body.update_stats(player_status_effects)
	
	door_entered.emit(name, enemy_status_effects)

func set_label(text:String):
	$DoorLabel.text=text

func update_door():
	player_status_effects = [status_effect_resource_array.pick_random()]
	#, status_effect_resource_array.pick_random()]
	enemy_status_effects = [status_effect_resource_array.pick_random(), status_effect_resource_array.pick_random()]
	
	
	var door_text = "Behind Door:"
	for bonus in player_status_effects:
		door_text+="\n"+bonus.door_message
	door_text+="\n\nEnemy:"
	for penalty in enemy_status_effects:
		if penalty.isDebuff==false:
			door_text+= "\n" + penalty.door_message
	change_door_label(door_text)
