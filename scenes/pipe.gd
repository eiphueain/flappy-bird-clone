extends Area2D
@onready var sfx_hit: AudioStreamPlayer = $sfx_hit
var sfx_hit_play : int = 0

signal hit
signal scored


func _on_body_entered(body):
	hit.emit()
	if sfx_hit_play < 1:
		$sfx_hit.play()
		sfx_hit_play += 1

 # Replace with function body.


func _on_score_area_body_entered(body):
	scored.emit()
