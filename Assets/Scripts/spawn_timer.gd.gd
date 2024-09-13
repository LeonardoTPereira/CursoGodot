extends Timer

@export var min_time:= 1.0
@export var max_time:= 2.0

func _ready():
	spawn_time()
	#timeout.connect(spawn_time)
	
func spawn_time():
	set_wait_time(randf_range(min_time, max_time))
