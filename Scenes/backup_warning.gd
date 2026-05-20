extends Label

@export var flash_gradient: Gradient

var time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	time += 1
	modulate = flash_gradient.sample((time % 100) / 100.0)
