extends Node

const terrains = {
	"snow": {
		"type": "ut",
		"id": 0,
		"variants": 3
	},
	"seabed": {
		"type": "ut",
		"id": 1
	},
	"greybrick": {
		"type": "ut",
		"id": 2
	},
	"bluepipe": {
		"type": "pipe",
		"id": 0,
		"sticky": true
	},
	"backwall": {
		"type": "ut_back",
		"id": 0
	}
}

const objects = {
	"igloo": "res://objects/spawns/igloo.tscn",
	"crate": "res://objects/blocks/crate.tscn",
	"cage": "res://objects/cage/cage.tscn",
	"coin": "res://objects/coins/coin.tscn",
	"ten_coin": "res://objects/coins/ten_coin.tscn",
	"girder": "res://objects/girder/girder.tscn",
	"hoz_platform": "res://objects/girder/moving_girder.tscn",
	"spikes": "res://objects/spikes/spikes.tscn",
	"switch": "res://objects/switch/switch.tscn",
	"switch_block": "res://objects/switch/switch_block.tscn",
	"pipe_entrance": "res://objects/warp/pipe_entrance.tscn",
	"airball": "res://enemies/airball/air_ball.tscn",
	"snowball": "res://enemies/snowball/snowball.tscn",
	"fireball_launcher": "res://enemies/fireball/fireball_launcher.tscn",
	"fish": "res://enemies/fish/fish.tscn",
	"pufferfish": "res://enemies/fish/pufferfish.tscn",
	"jumpy": "res://enemies/jumpy/jumpy.tscn",
	"nolok": "res://enemies/nolok/nolok.tscn"
}

var inv_objects: Dictionary;
func _init():
	for k in objects:
		inv_objects[objects[k]] = k
		assert(not terrains.has(k), "duplicate key: " + k)
