extends Panel

var selected_type = ""
var selected = false

func _process(delta: float) -> void:
	visible = selected

func _on_character_selected(data: Dictionary) -> void:
	selected_type = "Characters"
	activate()
	reset()
	$"%FilepathLabel".text = data["filepath"]
	$"%EnabledField".set_value(data["enabled"])
	$"%EnabledField".activate()
	$"%NameField".set_value(data["name"])
	$"%NameField".activate()
	$"%CharacterSmallSpriteField".set_value(data["smallSprite"])
	$"%CharacterSmallSpriteField".activate()
	$"%CharacterBigSpriteField".set_value(data["bigSprite"])
	$"%CharacterBigSpriteField".activate()
	$"%TaintedNameField".set_value(data["taintedName"])
	$"%TaintedNameField".activate()
	$"%TaintedField".set_value(data["hasTaintedVersion"])
	$"%TaintedField".activate()
	$"%TCharacterSmallSpriteField".set_value(data["taintedSmallSprite"])
	$"%TCharacterSmallSpriteField".activate()
	$"%TCharacterBigSpriteField".set_value(data["taintedBigSprite"])
	$"%TCharacterBigSpriteField".activate()

func _on_challenge_selected(data: Dictionary) -> void:
	selected_type = "Challenges"
	activate()
	reset()
	$"%FilepathLabel".text = data["filepath"]
	$"%EnabledField".set_value(data["enabled"])
	$"%EnabledField".activate()
	$"%NameField".set_value(data["name"])
	$"%NameField".activate()
	$"%CharacterField".set_value(data["character"])
	$"%CharacterField".activate()
	$"%BossField".set_value(data["boss"])
	$"%BossField".activate()
	
func _on_niche_selected(data: Dictionary) -> void:
	selected_type = "Niche"
	activate()
	reset()
	$"%FilepathLabel".text = data["filepath"]
	$"%EnabledField".set_value(data["enabled"])
	$"%EnabledField".activate()
	$"%NameField".set_value(data["name"])
	$"%NameField".activate()
	$"%CharacterField".set_value(data["suggested_character"])
	$"%CharacterField".activate()
	$"%BossField".set_value(data["boss"])
	$"%BossField".activate()
	$"%ObjectiveField".set_value(data["objective"])
	$"%ObjectiveField".activate()

func reset():
	$"%EnabledField".reset()
	$"%NameField".reset()
	$"%CharacterSmallSpriteField".reset()
	$"%CharacterBigSpriteField".reset()
	$"%TaintedNameField".reset()
	$"%TaintedField".reset()
	$"%TCharacterSmallSpriteField".reset()
	$"%TCharacterBigSpriteField".reset()
	$"%CharacterField".reset()
	$"%BossField".reset()
	$"%ObjectiveField".reset()

func activate():
	selected = true
	
func deactivate():
	selected = false
	reset()
