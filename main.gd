extends Control

@onready
var text: TextEdit = $TextEdit

@onready
var button: Button = $Button


@onready
var pitch: Slider = $Grid/HSliderPitch

@onready
var pitch_label: Label = $Grid/Pitch

@onready
var pitch_range: Slider = $Grid/HSliderRange

@onready
var range_label: Label = $Grid/Range

@onready
var speed: Slider = $Grid/HSliderSpeed

@onready
var speed_label: Label = $Grid/Speed

@onready
var q_pitch: Slider = $Grid/HSliderQuestionPitch

@onready
var q_pitch_label: Label = $Grid/QuestionPitch

@onready
var q_length: Slider = $Grid/HSliderQuestionLength

@onready
var q_length_label: Label = $Grid/QuestionLength

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
	q_pitch_label.text = "Question Pitch: +%s"%q_pitch.value
	q_length_label.text = "Question Length: %s letters" % q_length.value
	voice_label.text = voice_gen.voices[voice.value]
	voice_gen.voice = round(voice.value)
	voice_gen.pitch = pitch.value
	voice_gen.pitch_range = pitch_range.value
	voice_gen.speed = speed.value
	voice_gen.question_pitch = q_pitch.value
	voice_gen.question_length = round(q_length.value)
	
