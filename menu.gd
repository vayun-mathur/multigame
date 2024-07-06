extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func playBlackjack():
	get_tree().change_scene_to_file("res://blackjack/blackjack.tscn")


func playTicTacToe():
	get_tree().change_scene_to_file("res://tictactoe/tictactoe.tscn")
	
func playWordMaster():
	get_tree().change_scene_to_file("res://wordmaster/word_master.tscn")
	
func playSolitaire():
	get_tree().change_scene_to_file("res://solitaire/solitaire.tscn")

