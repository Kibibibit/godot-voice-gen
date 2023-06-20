extends Node
class_name VoiceGen

var voices = [
	"dan",
	"danwahwah",
	"danbackwards"
]

var sounds = {
	
}

const numbers = {
	"0":"zero",
	"1":"one",
	"2":"two",
	"3":"three",
	"4":"four",
	"5":"five",
	"6":"six",
	"7":"seven",
	"8":"eight",
	"9":"nine"
}

var queue: Array = []
var pitch_curve: Array = []

@export
var player: Node

var timer: Timer

@export
var pitch: float
@export
var pitch_range: float
@export
var speed: float
@export
var question_pitch: float
@export
var question_length: int
@export
var voice: int = 0


func _ready():
	timer = Timer.new()
	timer.autostart = false
	timer.one_shot = true
	timer.name = "Timer"
	add_child(timer)
	assert(
		player.get_class() == "AudioStreamPlayer2D" || 
		player.get_class() == "AudioStreamPlayer3D" || 
		player.get_class() == "AudioStreamPlayer",
		"Player must be an AudioStreamPlayer, either standard, 2D or 3D"
	)
	
	
	for v in voices:
		sounds[v] = {}
		for letter in "abcdefghijklmnopqrstuvwxyz":
			sounds[v][letter] = load("res://assets/%s/%s.wav" % [v,letter])
			print("Loaded %s/%s.wav" % [v,letter])

	timer.timeout.connect(_play_sound)

func play(text: String):
	stop()
	
	for number in numbers.keys():
		while (text.contains(number)):
			text = text.replace(number, numbers[number])
	queue = text.to_lower().split()
	pitch_curve = []
	for i in range(0,queue.size()):
		pitch_curve.append(max(0.01, pitch + randf_range(-pitch_range,pitch_range)))
		if (queue[i] == "?"):
			for q in question_length:
				if (i-q > 0):
					var mult = question_length-q
					pitch_curve[i-q-1] = pitch + question_pitch*(mult)
					
	

		
	_play_sound()

func stop():
	timer.stop()
	player.stop()
	queue = []
	
func _play_sound():
	player.stop()
	if (queue.is_empty()):
		return
	var c = queue.pop_front()
	var p = pitch_curve.pop_front()
	if (sounds[voices[voice]].has(c)):
		player.pitch_scale = p
		player.stream = sounds[voices[voice]][c]
		player.play()
	
	timer.start(speed)


