extends Node

var custom_characters = []
var custom_challenges = []
var custom_niche = []

func _ready():
	var dir = DirAccess.open("user://custom")
	if dir == null:
		DirAccess.make_dir_absolute("user://custom")
		DirAccess.make_dir_absolute("user://custom/characters")
		DirAccess.make_dir_absolute("user://custom/characters/data")
		DirAccess.make_dir_absolute("user://custom/characters/sprites")
		DirAccess.make_dir_absolute("user://custom/characters/sprites/big")
		DirAccess.make_dir_absolute("user://custom/challenges")
		DirAccess.make_dir_absolute("user://custom/niche")
		
	var characterdata = DirAccess.get_files_at("user://custom/characters/data")
	var charactersprites = DirAccess.get_files_at("user://custom/characters/sprites")
	var characterspritesbig = DirAccess.get_files_at("user://custom/characters/sprites/big")
	var challenges = DirAccess.get_files_at("user://custom/challenges")
	var niche = DirAccess.get_files_at("user://custom/niche")
	
	for d in characterdata:
		var data = FileAccess.get_file_as_string("user://custom/characters/data/"+d)
		if data != "":
			var parsed = JSON.parse_string(data)
			if parsed["enabled"] == "true":
				var small_img = null
				var big_img = null
				var t_small_img = null
				var t_big_img = null
				for ss in charactersprites:
					if ss == parsed["smallSprite"]:
						var _data = Image.load_from_file("user://custom/characters/sprites/"+ss)
						small_img = ImageTexture.create_from_image(_data)
					if parsed["hasTaintedVersion"] == "true" and ss == parsed["taintedSmallSprite"]:
						var _data = Image.load_from_file("user://custom/characters/sprites/"+ss)
						t_small_img = ImageTexture.create_from_image(_data)
				for bs in characterspritesbig:
					if bs == parsed["bigSprite"]:
						var _data = Image.load_from_file("user://custom/characters/sprites/big/"+bs)
						big_img = ImageTexture.create_from_image(_data)
					if parsed["hasTaintedVersion"] == "true" and bs == parsed["taintedBigSprite"]:
						var _data = Image.load_from_file("user://custom/characters/sprites/big/"+bs)
						t_big_img = ImageTexture.create_from_image(_data)
				custom_characters.append( { "name": parsed["name"], "small_sprite": small_img, "big_sprite": big_img } )
				if parsed["hasTaintedVersion"] == "true":
					custom_characters.append( { "name": parsed["taintedName"], "small_sprite": t_small_img, "big_sprite": t_big_img } )
				else:
					custom_characters.append( { "name": "__DUMMY", "small_sprite": null, "big_sprite": null } )
	for c in challenges:
		var data = FileAccess.get_file_as_string("user://custom/challenges/"+c)
		if data != "":
			var parsed = JSON.parse_string(data)
			if parsed["enabled"] == "true":
				custom_challenges.append( { "name": parsed["name"], "character": parsed["character"], "boss": parsed["boss"] } )

	for n in niche:
		var data = FileAccess.get_file_as_string("user://custom/niche/"+n)
		if data != "":
			var parsed = JSON.parse_string(data)
			if parsed["enabled"] == "true":
				custom_niche.append( { "name": parsed["name"], "suggested_character": parsed["suggested_character"], "boss": parsed["boss"], "objective": parsed["objective"] } )
