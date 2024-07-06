extends Node2D
	
class Rectangle:
	var x: float
	var y: float
	var width: float
	var height: float
	func _init(_x: float, _y: float, _w: float, _h: float):
		x = _x
		y = _y
		width = _w
		height = _h
	
class Player:
	var name: String
	var hand: Array[Card]
	func _init(_name: String, _hand: Array[Card]):
		name = _name
		hand = _hand

class BlackjackGame:
	var deck: Array[Card]
	var players: Array[Player]
	func _init(_deck: Array[Card], _players: Array[Player]):
		deck = _deck
		players = _players

func handValue(hand: Array[Card]) -> int:
	var sum = 0;
	var aces = 0;
	for card in hand:
		if card.value == 1:
			aces += 1
		elif card.value > 10:
			sum += 10
		else:
			sum += card.value
	while aces > 0:
		if sum + 11 <= 21:
			sum += 11
		else:
			sum += 1
		aces -= 1
	return sum

var game: BlackjackGame = null;

# TODO: Implement these functions
func gameOver(): 
	var hitButton = get_node("HitButton")
	var standButton = get_node("StandButton")
	#disable hit and stand buttons
	hitButton.disabled = true
	standButton.disabled = true
	pass

func hit():
	var player = 1
	var card: Card = game.deck.pop_back()
	card.createSprite(self, Vector2(300+game.players[player].hand.size()*120, 450))
	# add the card to the player's hand
	game.players[player].hand.append(card)
	var hand_value: int = handValue(game.players[player].hand)
	# change the label to display the new hand value
	get_node("PlayerLabel").text = "You ("+str(hand_value)+")"
	if hand_value >= 21:
		gameOver()

var standing = false;
var standTime: float = 0.0
var turnedOver = false;
var flippedSprite: Sprite2D = null;

func stand():
	standing = true;
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	var deck = Card.createDeck()
	deck.shuffle()
	game = BlackjackGame.new(deck, [Player.new("Dealer", []), Player.new("You", [])])
	var card: Card = game.deck.pop_back()
	card.createSprite(self, Vector2(300+game.players[0].hand.size()*120, 275))
	game.players[0].hand.append(card)
	card = game.deck.pop_back()
	card.createSprite(self, Vector2(300+game.players[0].hand.size()*120, 275))
	game.players[0].hand.append(card)
	get_node("DealerLabel").text = "Dealer ("+str(handValue(game.players[0].hand))+")"
	card = game.deck.pop_back()
	card.createSprite(self, Vector2(300+game.players[0].hand.size()*120, 275))
	game.players[0].hand.append(card)
	card.flip()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(standing):
		standTime += delta
		if(standTime > 1.0):
			if(!turnedOver): 
				var card: Card = game.players[0].hand[2]
				card.flip()
				standTime = 0.0
				var label = get_node("DealerLabel")
				label.text = "Dealer ("+str(handValue(game.players[0].hand))+")"
				turnedOver = true
			elif handValue(game.players[0].hand) < 17:
				var card: Card = game.deck.pop_back()
				card.createSprite(self, Vector2(300+game.players[0].hand.size()*120, 275))
				game.players[0].hand.append(card)
				get_node("DealerLabel").text = "Dealer ("+str(handValue(game.players[0].hand))+")"
				standTime = 0.0
			else:
				gameOver()
				standing = false
				standTime = 0.0
	pass


func back(_viewport, event, _shape_idx):
	# go to scene menu.tscn
	if event is InputEventMouseButton:
		var mouseEvent: InputEventMouseButton = event
		if mouseEvent.button_index == MOUSE_BUTTON_LEFT and mouseEvent.pressed:
			get_tree().change_scene_to_file("res://menu.tscn")
