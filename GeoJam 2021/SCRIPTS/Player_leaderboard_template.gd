extends HBoxContainer

func init(index, player_name, player_time, deaths):
	$name.text = str(index + 1) + ". " + player_name
	$Time.text = str("%.1f" % player_time)
	$Deaths.text = str(deaths)
