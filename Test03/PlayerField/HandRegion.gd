extends Node

const CardBase = preload("res://Card/CardBase.tscn")
const PlayerDeck = preload("res://Card/PlayerDeck.gd")

onready var CenterHand = get_viewport().get_visible_rect().size/2 - Vector2(CardOffset.x/2,0) + Vector2(0,CardOffset.y * 1.5)
onready var deckSize = 5

var CardOffset = Vector2(171,264)

var cardDrawn

func _ready():
	pass

func _on_PlayerDeck_pressed():
	drawPlayerCard(1)
	
func drawPlayerCard(delta):
	var new_card = CardBase.instance()
	var tweenDraw = new_card.get_node("Draw")
	$PlayerHand.add_child(new_card)
	new_card.connect("mouse_entered", self, "_on_CardEntered", [$PlayerHand.get_child_count() - 1, 1])
	new_card.connect("mouse_exited", self, "_on_CardExited", [$PlayerHand.get_child_count() - 1, 1])
	tweenDraw.interpolate_property(
		new_card, "rect_position", 
		$PlayerDeck.rect_position, CenterHand, 1.0 * delta, 
		Tween.TRANS_QUINT, Tween.EASE_OUT)
	tweenDraw.start()
	CenterHand += Vector2(new_card.rect_size.x/2,0)
	deckSize -= 1
	if deckSize == 0:
		$PlayerDeck.disabled = true
	
func _on_CardEntered(cardNum, delta):
	var Count = $PlayerHand.get_child_count()
	var Card = $PlayerHand.get_child(cardNum)
	var tweenHover = Card.get_node("Hover")
	var tweenDraw = Card.get_node("Draw")
	tweenHover.interpolate_property(
		Card, "rect_scale", 
		Card.rect_scale, Vector2(1.5,1.5), 0.2 * delta, 
		Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	tweenHover.interpolate_property(
		Card, "rect_position", 
		Card.rect_position, Vector2(Card.rect_position.x, Card.rect_position.y * 0.8), 0.2 * delta, 
		Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	tweenHover.start()

func _on_CardExited(cardNum, delta):
	var Count = $PlayerHand.get_child_count()
	var Card = $PlayerHand.get_child(cardNum)
	var tweenHover = Card.get_node("Hover")
	var tweenDraw = Card.get_node("Draw")
	tweenHover.interpolate_property(
		Card, "rect_scale", 
		Card.rect_scale, Vector2(1,1), 0.2 * delta, 
		Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	tweenHover.interpolate_property(
		Card, "rect_position", 
		Card.rect_position, Vector2(Card.rect_position.x, Card.rect_position.y / 0.8), 0.2 * delta, 
		Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	tweenHover.start()


