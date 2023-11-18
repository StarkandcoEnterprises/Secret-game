extends WorldObject

class_name PlantedSeed 

var planted_days = 0
var max_planted_days = 100

func grow():
	planted_days += 1
	if max_planted_days / planted_days == 4:
		pass #TODO update sprite to next stage
	elif max_planted_days / planted_days == 2:
		pass #TODO update sprite to next stage
	elif max_planted_days / planted_days == 1.33333:
		pass #TODO update sprite to next stage
	elif max_planted_days / planted_days == 1:
		pass #TODO some plant grown logic here
