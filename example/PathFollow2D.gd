extends PathFollow2D

const speed = 100

func _process(delta : float):
	offset += delta * speed
