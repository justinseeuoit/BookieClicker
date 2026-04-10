extends Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	# Left click to start or continue
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			start_game()

	# Press P to toggle pause
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

func start_game():
	visible = false
	get_tree().paused = false

func toggle_pause():
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused
