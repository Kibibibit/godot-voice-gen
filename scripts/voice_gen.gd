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
@onready
var player: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready
var timer: Timer = $Timer

@export
var pitch: float
@export
var pitch_range: float
@export
var speed: float
@export
var voice: int = 0

func _ready():
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
	_play_sound()

func stop():
	timer.stop()
	player.stop()
	queue = []
	
func _play_sound():
	player.stop()
	if (queue.is_empty()):
		print("empty queue")
		return
	var c = queue.pop_front()
	if (sounds[voices[voice]].has(c)):
		player.pitch_scale = max(0.01, pitch + randf_range(-pitch_range,pitch_range))
		player.stream = sounds[voices[voice]][c]
		player.play()
	
	timer.start(speed)


