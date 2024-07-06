extends Node

class_name Card

enum Suit {heart, diamond, club, spade, none}

static var suitNames = ["heart", "diamond", "club", "spade"]
static var backTexture: Texture2D = load("res://deck/card back/card_back.png")

var value: int
var suit: Suit
var isFaceUp: bool = true;
var sprite: Sprite2D = null;
var area2D: Area2D = null;


func _init(_value: int, _suit: Suit):
	value = _value
	suit = _suit

static func createDeck() -> Array[Card]:
	var cards: Array[Card] = []
	for i in range(1, 14):
		for st in range(0, 4):
			cards.append(Card.new(i, st))
	return cards

func createSprite(parent: Node, position: Vector2 = Vector2()) -> Sprite2D:
	area2D = Area2D.new()
	var collision2d = CollisionShape2D.new()
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.extents = Vector2(50, 75)
	collision2d.shape = shape
	area2D.add_child(collision2d)
	sprite = Sprite2D.new()
	area2D.add_child(sprite)
	var asset = suitNames[suit] + "/" + str(value) + "_" + suitNames[suit]
	var cardTexture = load("res://deck/"+asset+".png")
	sprite.texture = cardTexture
	# set the position of the card
	parent.add_child(area2D)
	area2D.position = position
	return sprite

func setClickable(clickable: bool):
	area2D.set("mouse_filter", 1 if clickable else 0)
	area2D.set("input_pickable", clickable)

func flip():
	isFaceUp = !isFaceUp
	if isFaceUp:
		sprite.texture = load("res://deck/"+suitNames[suit]+"/"+str(value)+"_"+suitNames[suit]+".png")
	else:
		sprite.texture = Card.backTexture
