extends Node2D

var nextRow: int = -1;
var nextCol: int = -1;

func grid00():
	play(0, 0)

func grid01():
	play(0, 1)

func grid02():
	play(0, 2)

func grid10():
	play(1, 0)

func grid11():
	play(1, 1)

func grid12():
	play(1, 2)

func grid20():
	play(2, 0)

func grid21():
	play(2, 1)

func grid22():
	play(2, 2)

var grid = [['', '', ''], ['', '', ''], ['', '', '' ]];
var player = 'X';

func checkWin():
	# check rows
	for i in range(3):
		if grid[i][0] == grid[i][1] and grid[i][1] == grid[i][2] and grid[i][0] != '':
			return true;
	# check columns
	for i in range(3):
		if grid[0][i] == grid[1][i] and grid[1][i] == grid[2][i] and grid[0][i] != '':
			return true;
	# check diagonals
	if grid[0][0] == grid[1][1] and grid[1][1] == grid[2][2] and grid[0][0] != '':
		return true;
	if grid[0][2] == grid[1][1] and grid[1][1] == grid[2][0] and grid[0][2] != '':
		return true;
	return false;

func play(row: int, col: int):
	if grid[row][col] == '':
		grid[row][col] = player;
		# create new sprite2D
		var sprite = Sprite2D.new();
		sprite.texture = load("res://tictactoe/" + str(player) + ".svg");
		sprite.position = Vector2(300 + 200 * col, 400 + 200 * row);
		add_child(sprite);
		if checkWin():
			print("Player " + player + " wins!");
			get_node("GridContainer").set("visible", false);
			get_node("currentPlayer").set("visible", false);
			return
		# if all cells are filled, it's a draw
		var isdraw = true;
		for i in range(3):
			for j in range(3):
				if grid[i][j] == '':
					isdraw = false;
		if isdraw:
			print("It's a draw!");
		var playersprite = get_node("currentPlayer");
		if player == 'X':
			player = 'O';
			playersprite.texture = load("res://tictactoe/O.svg");
		else:
			player = 'X';
			playersprite.texture = load("res://tictactoe/X.svg");

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
