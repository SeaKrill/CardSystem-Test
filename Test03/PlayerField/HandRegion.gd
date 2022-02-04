extends Node

const CardBase = preload("res://Card/CardBase.tscn")
const PlayerDeck = preload("res://Card/PlayerDeck.gd")

onready var CenterHand = get_viewport().get_visible_rect().size/2 - Vector2(CardOffset.x/2,0) + Vector2(0,CardOffset.y * 1.5)
onready var mouseCheck = false
onready var deckSize = 5


var CardOffset = Vector2(171,264)

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
#	moveCard($PlayerHand.get_child_count() - 1)

	
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

#func moveCard(cardNum):
#	if cardNum > 0:
#		var Card = $PlayerHand.get_child(cardNum - 1)
#		if Card.get_node("Draw").is_active() == true:
#			yield(Card.get_node("Draw"), "tween_all_completed")
#			Card.rect_position -= Vector2(Card.rect_size.x/2,0)
#		else:
#			Card.rect_position -= Vector2(Card.rect_size.x/2,0)
			
			#try to use groups to move all cards at the same time?
			# get_tree().call_group("Cards", rect.position, Vector2(rect.position.x + 100, 0)?
			# get_tree().call_group("Cards", "Move function", param?
			
			#figure out way to set a standard y point that they return to when not hovered.
