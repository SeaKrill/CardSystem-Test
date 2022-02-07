extends Node

const CardBase = preload("res://Card/CardBase.tscn")
const PlayerDeck = preload("res://Card/PlayerDeck.gd")

onready var CenterHand = get_viewport().get_visible_rect().size/2 - Vector2(CardOffset.x/2,0) + Vector2(0,CardOffset.y * 1.5)
onready var mouseCheck = false
onready var deckSize = 15

var CardOffset = Vector2(171,264)
var cardMargin = CardOffset.x/2

func _ready():
	pass
	
func _on_PlayerDeck_pressed():
	
	var new_card = CardBase.instance()
	var tweenDraw = new_card.get_node("Draw")
	var cardsInHand = $PlayerHand.get_child_count()
	var centerOfCards = ($PlayerHand.get_child_count() * cardMargin - new_card.rect_size.x)/2
	
	for i in cardsInHand:
		var Card = $PlayerHand.get_child(i)
		tweenDraw.interpolate_property(
			Card, "rect_position", 
			Card.rect_position, Vector2(CenterHand.x - centerOfCards + i * cardMargin, CenterHand.y), 
			1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
			
	$PlayerHand.add_child(new_card)	
	
	new_card.connect("mouse_entered", self, "_on_CardEntered", [$PlayerHand.get_child_count() - 1, 1])
	new_card.connect("mouse_exited", self, "_on_CardExited", [$PlayerHand.get_child_count() - 1, 1])
	
	tweenDraw.interpolate_property(
		new_card, "rect_position", 
		$PlayerDeck.rect_position, Vector2(CenterHand.x - centerOfCards + cardsInHand * cardMargin, CenterHand.y), 
		1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenDraw.start()
	
	deckSize -= 1
	if deckSize == 0:
		$PlayerDeck.disabled = true
		
func _on_CardEntered(cardNum, delta):
	var Count = $PlayerHand.get_child_count()
	var Card = $PlayerHand.get_child(cardNum)
	var tweenHover = Card.get_node("Hover")
	var tweenDraw = Card.get_node("Draw")
	if tweenDraw.is_active() == true:
		pass
	else:
		mouseCheck = true
		tweenHover.interpolate_property(
			Card, "rect_scale", 
			Card.rect_scale, Vector2(1.5,1.5), 0.2 * delta, 
			Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
		tweenHover.interpolate_property(
			Card, "rect_position", 
			Card.rect_position, Vector2(Card.rect_position.x, CenterHand.y * 0.8), 0.2 * delta, 
			Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
		tweenHover.start()
#		if cardNum > 0:
#			print("left")
#		if cardNum + 1 < Count:
#			print("right")

func _on_CardExited(cardNum, delta):
	var Count = $PlayerHand.get_child_count()
	var Card = $PlayerHand.get_child(cardNum)
	var tweenHover = Card.get_node("Hover")
	var tweenDraw = Card.get_node("Draw")
	if tweenDraw.is_active() == true:
		pass
	if mouseCheck == false:
		pass
	else:
		tweenHover.interpolate_property(
			Card, "rect_scale", 
			Card.rect_scale, Vector2(1,1), 0.2 * delta, 
			Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
		tweenHover.interpolate_property(
			Card, "rect_position", 
			Card.rect_position, Vector2(Card.rect_position.x, CenterHand.y), 0.2 * delta, 
			Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
		tweenHover.start()
		mouseCheck = false
		
