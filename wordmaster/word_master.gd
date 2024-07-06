extends Node2D

var row: int = 0;
var guess: String = ""
var complete = false;
var word: String;

var wordList: Array[String];

# on key press
func _input(event):
	if complete:
		return
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_ENTER:
				if guess.length() != 5:
					return
				if guess.to_lower() not in wordList: 
					return
				var marked = [false, false, false, false, false];
				for i in range(5):
					var box = get_node("GridContainer/char" + str(row*5+i)+"/Polygon2D")
					if guess[i] == word[i]:
						box.color = Color(0, 0.5, 0)
						marked[i] = true;
					else:
						box.color = Color(0.1, 0.1, 0.1)
				for i in range(5):
					if guess[i] == word[i]:
						continue;
					for j in range(5):
						if marked[j] or i == j:
							continue;
						if guess[i] == word[j]:
							# change color to yellow
							var box = get_node("GridContainer/char" + str(row*5+i)+"/Polygon2D")
							box.color = Color(0.5, 0.5, 0)
							marked[j] = true;
							break;
				
				if(guess == word):
					print("You win!")
					complete = true;
					return;
				row += 1
				guess = ""
				if(row==6):
					print("You lose!")
					complete = true;
					return;
				pass
			elif event.keycode == KEY_BACKSPACE:
				print("Backspace pressed")
				# remove last character from guess
				guess = guess.left(guess.length() - 1)
				var label = get_node("GridContainer/char" + str(row*5+guess.length()))
				label.text = ""
			elif guess.length() < 5:
				print("Key pressed: " + str(event.as_text_keycode()))
				# get label
				var label = get_node("GridContainer/char" + str(row*5+guess.length()))
				label.text = str(event.as_text_keycode())
				# add key to guess
				guess += str(event.as_text_keycode()).to_lower()
				print("Guess: " + guess)

# Called when the node enters the scene tree for the first time.
func _ready():
	# read text file
	var file = FileAccess.open("res://wordmaster/words_alpha.txt", FileAccess.READ)
	var text = file.get_as_text()
	for listword in text.split("\r\n"):
		if listword.length() == 5:
			wordList.append(listword)
	word = wordList[randi() % wordList.size()]
	print(word)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func back(_viewport, event, _shape_idx):
	# go to scene menu.tscn
	if event is InputEventMouseButton:
		var mouseEvent: InputEventMouseButton = event
		if mouseEvent.button_index == MOUSE_BUTTON_LEFT and mouseEvent.pressed:
			get_tree().change_scene_to_file("res://menu.tscn")
