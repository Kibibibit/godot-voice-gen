extends Control

@onready
var text: TextEdit = $TextEdit

@onready
var button: Button = $Button


@onready
var pitch: Slider = $HSliderPitch

@onready
var pitch_label: Label = $Pitch

@onready
var pitch_range: Slider = $HSliderRange

@onready
var range_label: Label = $Range

@onready
var speed: Slider = $HSliderSpeed

@onready
var speed_label: Label = $Speed

@onready
var voice_gen: VoiceGen = $VoiceGen

@onready
var voice: Slider = $VSliderVoice

@onready
var voice_label: Label = $Voice

func _play():
	voice_gen.play(text.text)

func _ready():
	button.button_up.connect(_play)
	voice.max_value = voice_gen.voices.size()-1

func _process(_delta):
	pitch_label.text = "Pitch: x%s"%pitch.value
	range_label.text = "Pitch Range: +-%s"%pitch_range.value
	speed_label.text = "Speed: %ss"%speed.value
	voice_label.text = voice_gen.voices[voice.value]
	voice_gen.voice = round(voice.value)
	voice_gen.pitch = pitch.value
	voice_gen.pitch_range = pitch_range.value
	voice_gen.speed = speed.value
	
