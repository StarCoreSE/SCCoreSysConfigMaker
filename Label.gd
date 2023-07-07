extends Control

onready var hslider = $HSlider
onready var label = $HSlider/Label

func _ready():
	hslider.connect("value_changed", self, "_on_slider_value_changed")

func _on_HSlider_changed():
	label.text = str(value)
