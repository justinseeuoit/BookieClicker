extends VBoxContainer

@onready var book_label: Label = $BookLabel
@onready var book_per_sec_label: Label = $BookPerSecLabel

func _on_game_books_changed(amount: float) -> void:
	book_label.text = format_number(amount) + " Books"

func _on_game_books_per_second_changed(amount: float) -> void:
	book_per_sec_label.text = format_number(amount) + " PER SECOND"

func format_number(n: float) -> String:
	var value: float
	var suffix: String
	
	if n < 1e3:
		return str("%.1f" % n)
	if n < 1e6:
		value = n / 1e3
		suffix = "k"
	elif n < 1e9:
		value = n / 1e6
		suffix = "M"
	elif n < 1e12:
		value = n / 1e9
		suffix = "B"
	else:
		value = n / 1e12
		suffix = "T"
	return "%.1f" % value + suffix
