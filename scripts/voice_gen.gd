extends Node
class_name VoiceGen

const voices = [
	"dan",
	"danwahwah",
	"danbackwards"
]

const _numbers = {
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

var _sounds = {
	
}

var _queue: Array = []
var _pitch_curve: Array = []
var _timer: Timer

## This is the directory where all the voice assets are stored.
@export_dir var voice_path: String

## This should be any of the AudioStreamPlayer objects, and will be used to play the audio
@export var player: Node

@export_group("Voice Settings")

## This is the base pitch that the voice will be played at, as a multiplier of the base
## audio's pitch. This will also increase the speed of the player.
@export var pitch: float

## The pitch multiplier [pitch] will be modified up and down by up to this amount randomly
## on each letter.
@export var pitch_range: float

## This is the time in seconds each letter is played for.
@export var speed: float

## This is the amount the pitch multiplier will increase by for each letter at the end of a question.
@export var question_pitch: float
## This is how many letters before a question mark the pitch will rise for
@export var question_length: int
## This choses which voice from [voices] will play
@export var voice: int = 0


func _ready():
	_timer = Timer.new()
	_timer.autostart = false
	_timer.one_shot = true
	_timer.name = "Timer"
	add_child(_timer)
	assert(
		player.get_class() == "AudioStreamPlayer2D" || 
		player.get_class() == "AudioStreamPlayer3D" || 
		player.get_class() == "AudioStreamPlayer",
		"Player must be an AudioStreamPlayer, either standard, 2D or 3D"
	)
	
	
	for v in voices:
		_sounds[v] = {}
		for letter in "abcdefghijklmnopqrstuvwxyz":
			_sounds[v][letter] = load("%s/%s/%s.wav" % [voice_path,v,letter])
			print("Loaded %s/%s/%s.wav" % [voice_path,v,letter])

	_timer.timeout.connect(_play_sound)

func play(text: String):
	stop()
	
	for number in _numbers.keys():
		while (text.contains(number)):
			text = text.replace(number, _numbers[number])
	_queue = text.to_lower().split()
	_pitch_curve = []
	## Handling pithc changes
	for i in range(0,_queue.size()):
		_pitch_curve.append(max(0.01, pitch + randf_range(-pitch_range,pitch_range)))
		## if its a question mark, go back a few steps and raise the pitch
		if (_queue[i] == "?"):
			for q in question_length:
				if (i-q > 0):
					var mult = question_length-q
					_pitch_curve[i-q-1] = pitch + question_pitch*(mult)
					
	_play_sound()

func stop():
	_timer.stop()
	player.stop()
	_queue = []
	
func _play_sound():
	player.stop()
	if (_queue.is_empty()):
		return
	var c = _queue.pop_front()
	var p = _pitch_curve.pop_front()
	if (_sounds[voices[voice]].has(c)):
		player.pitch_scale = p
		player.stream = _sounds[voices[voice]][c]
		player.play()
	
	_timer.start(speed)


