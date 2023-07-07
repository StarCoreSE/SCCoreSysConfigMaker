extends Control

func _ready():
	set_process(true)

	# Create background
	var bg_color = Color(0.8, 0.8, 0.8)
	var background = ColorRect.new()
	background.rect_min_size = Vector2(800, 600)
	background.color = bg_color
	add_child(background)

	# Create sliders
	var slider_range = 10000
	var slider_width = 400
	var slider_height = 20
	var label_offset = 30
	
	for i in range(3):
		var slider = HSlider.new()
		slider.rect_min_size = Vector2(slider_width, slider_height)
		slider.min_value = 1
		slider.max_value = slider_range
		slider.value = slider_range / 2
		slider.set_anchor(MARGIN_RIGHT, 1.0)
		slider.set_begin(Vector2(-slider_width, i * (slider_height + label_offset)))
		slider.connect("value_changed", self, "_on_slider_value_changed", [i])
		add_child(slider)

		var label = Label.new()
		label.rect_min_size = Vector2(100, 20)
		label.align = Label.ALIGN_RIGHT
		label.set_anchor(MARGIN_RIGHT, 1.0)
		label.set_begin(Vector2(-label.rect_min_size.x - 10, i * (slider_height + label_offset)))
		label.text = "Slider " + str(i + 1) + ": " + str(slider.value)
		add_child(label)

func _on_slider_value_changed(value: float, index: int):
	var label = get_child(index * 2 + 1)
	label.text = "Slider " + str(index + 1) + ": " + str(value)
