extends Control

var original_card: Card = null
var dragging: Card = null
var dragSprite: Sprite2D = null
var dragging_bool: int = 0

func color(suit: Card.Suit):
	match suit:
		Card.Suit.heart:
			return 1
		Card.Suit.diamond:
			return 1
		Card.Suit.club:
			return 0
		Card.Suit.spade:
			return 0

var deck: Array[Card] = Card.createDeck()

var deck_card: Card = null
var card_positions: Dictionary = {}
var stacks: Dictionary = {}

func canStack(bottom: Card, top: Card):
	if bottom.suit == Card.Suit.none:
		return top.value == 1
	if card_positions[bottom].x > 6:
		return top.suit == bottom.suit and top.value == bottom.value + 1
	if bottom.value == top.value + 1:
		if bottom.value == 14:
			return true
		return color(bottom.suit) != color(top.suit)
	return false

var deckStacked: Array[Card] = []

func onDeckInput(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		var mouseEvent: InputEventMouseButton = event
		if mouseEvent.button_index == MOUSE_BUTTON_LEFT and mouseEvent.pressed:
			if deck_card != null and card_positions[deck_card] == Vector2i(-1, 0):
				deck_card.area2D.get_parent().remove_child(deck_card.area2D)
				deckStacked.push_front(deck_card)
				deck_card = null
			if deck.size() == 0 and len(deckStacked) > 0:
				deck = deckStacked
				deckStacked = []
			if deck.size() > 0:
				deck_card = deck.pop_back()
				deck_card.createSprite(self, Vector2(300, 100))
				deck_card.area2D.connect("input_event", self.onSpriteClicked(deck_card))
				card_positions[deck_card] = Vector2i(-1, 0)
				stacks[Vector2i(-1, 0)] = deck_card


func onSpriteClicked(card: Card):
	return func(_viewport, event, _shape_idx):
		if event is InputEventMouseButton:
			var mouseEvent: InputEventMouseButton = event
			if mouseEvent.button_index == MOUSE_BUTTON_LEFT and mouseEvent.pressed:
				if dragging_bool < 2:
					if card.value == 14 or card.suit == Card.Suit.none:
						return
					dragging_bool = 2
					print("down ", card.value)
					card.sprite.visible = false
					original_card = card
					dragging = Card.new(card.value, card.suit)
					dragging.createSprite(self, mouseEvent.global_position)
					dragging.value = -100
					dragging.area2D.z_index = 100
					dragging.area2D.connect("input_event", self.onSpriteClicked(dragging))
			elif mouseEvent.button_index == MOUSE_BUTTON_LEFT and not mouseEvent.pressed:
				print("up ", card.value)
				print(stacks[Vector2i(7, -1)].area2D.position)
				if dragging_bool > 0:
					if dragging == card:
						original_card.sprite.visible = true
						self.remove_child(dragging.area2D)
						dragging_bool -= 1
					else:
						print(card_positions[card], stacks)
						if card != deck_card and canStack(card, original_card) and not stacks.has(card_positions[card] + Vector2i(0, 1)):
							print("stacker")
							if original_card != deck_card:
								# if it is upside down, flip it
								if not stacks[card_positions[original_card] - Vector2i(0, 1)].isFaceUp:
									stacks[card_positions[original_card] - Vector2i(0, 1)].flip()
									stacks[card_positions[original_card] - Vector2i(0, 1)].setClickable(true)
								# if it was already right side up, extend the collision box
								else:
									var below_card = stacks[card_positions[original_card] - Vector2i(0, 1)]
									((below_card.area2D.get_child(0) as CollisionShape2D).shape as RectangleShape2D).extents = Vector2(50, 75)
									(below_card.area2D.get_child(0) as CollisionShape2D).position = Vector2(0, 0)
							
							# remove the card from the old stack and add to the new stack
							var stack_origin = card_positions[original_card].x
							var stack_origin_height = card_positions[original_card].y
							var stack_to = card_positions[card].x
							var stack_to_height = card_positions[card].y+1
							while stacks.has(Vector2i(stack_origin, stack_origin_height)):
								var card_: Card = stacks[Vector2i(stack_origin, stack_origin_height)]
								stacks.erase(Vector2i(stack_origin, stack_origin_height))
								card_positions[card_] = Vector2i(stack_to, stack_to_height)
								stacks[Vector2i(stack_to, stack_to_height)] = card_
								card_.area2D.z_index = stack_to_height
								if stack_to >= 7:
									card_.area2D.position = Vector2(450 + (stack_to-7)*150, 100)
								else:
									card_.area2D.position = Vector2(100 + 125*stack_to, 400 + 50*stack_to_height)



								stack_origin_height += 1
								stack_to_height += 1
							

							# shrink the collision box of the card that has just been hidden
							((card.area2D.get_child(0) as CollisionShape2D).shape as RectangleShape2D).extents = Vector2(50, 25)
							(card.area2D.get_child(0) as CollisionShape2D).position = Vector2(0, -50)
							dragging_bool -= 1
							resort_nodes()

							if original_card == deck_card:
								if deckStacked.size() > 0:
									deck_card = deckStacked.pop_front()
									deck_card.createSprite(self, Vector2(300, 100))
									deck_card.area2D.connect("input_event", self.onSpriteClicked(deck_card))
									card_positions[deck_card] = Vector2i(-1, 0)
									stacks[Vector2i(-1, 0)] = deck_card
								else:
									deck_card = null

func compare_nodes(a, b):
	return a.z_index < b.z_index

func resort_nodes():
	var children = get_children()
	children.sort_custom(self.compare_nodes)
	for i in range(children.size()):
		move_child(children[i], i)

# Called when the node enters the scene tree for the first time.
func _ready():
	deck.shuffle()
	for i in range(4):
		var card = Card.new(1, Card.Suit.heart)
		card.createSprite(self, Vector2(450+i*150, 100))
		card.suit = Card.Suit.none
		card.area2D.connect("input_event", self.onSpriteClicked(card))
		card.area2D.z_index = -1
		card.area2D.remove_child(card.sprite)
		card_positions[card] = Vector2i(i+7, -1)
		stacks[Vector2i(i+7, -1)] = card
	for stack in range(7):
		var back = Card.new(14, Card.Suit.club)
		back.createSprite(self, Vector2(100 + 125*stack, 350))
		back.area2D.connect("input_event", self.onSpriteClicked(back))
		back.area2D.remove_child(back.sprite)
		back.area2D.z_index = -1
		card_positions[back] = Vector2i(stack, -1)
		stacks[Vector2i(stack, -1)] = back
		for card in range(stack+1):
			var c: Card = deck.pop_back()
			c.createSprite(self, Vector2(100 + 125*stack, 400 + 50*card))
			#on left click on sprite
			c.area2D.connect("input_event", self.onSpriteClicked(c))
			c.area2D.z_index = card
			card_positions[c] = Vector2i(stack, card)

			stacks[Vector2i(stack, card)] = c
			if card != stack:
				c.flip()
				c.setClickable(false)
	resort_nodes()

func back(_viewport, event, _shape_idx):
	# go to scene menu.tscn
	if event is InputEventMouseButton:
		var mouseEvent: InputEventMouseButton = event
		if mouseEvent.button_index == MOUSE_BUTTON_LEFT and mouseEvent.pressed:
			get_tree().change_scene_to_file("res://menu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if dragging:
		dragging.area2D.set_position(get_viewport().get_mouse_position())
	pass
