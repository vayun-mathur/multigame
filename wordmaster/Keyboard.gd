extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func pressKey(key):
	var event: InputEventKey = InputEventKey.new()
	event.keycode = key
	event.pressed = true

	Input.parse_input_event(event)

func Q():
	pressKey(KEY_Q)
func W():
	pressKey(KEY_W)
func E():
	pressKey(KEY_E)
func R():
	pressKey(KEY_R)
func T():
	pressKey(KEY_T)
func Y():
	pressKey(KEY_Y)
func U():
	pressKey(KEY_U)
func I():
	pressKey(KEY_I)
func O():
	pressKey(KEY_O)
func P():
	pressKey(KEY_P)
func A():
	pressKey(KEY_A)
func S():
	pressKey(KEY_S)
func D():
	pressKey(KEY_D)
func F():
	pressKey(KEY_F)
func G():
	pressKey(KEY_G)
func H():
	pressKey(KEY_H)
func J():
	pressKey(KEY_J)
func K():
	pressKey(KEY_K)
func L():
	pressKey(KEY_L)
func Z():
	pressKey(KEY_Z)
func X():
	pressKey(KEY_X)
func C():
	pressKey(KEY_C)
func V():
	pressKey(KEY_V)
func B():
	pressKey(KEY_B)
func N():
	pressKey(KEY_N)
func M():
	pressKey(KEY_M)
func enter():
	pressKey(KEY_ENTER)
func backspace():
	pressKey(KEY_BACKSPACE)
