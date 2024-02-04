extends HBoxContainer

const full = preload("res://objects/coins/tenIcon.png")

func collect(coin: int):
	get_node("Coin%s" % coin).texture = full
