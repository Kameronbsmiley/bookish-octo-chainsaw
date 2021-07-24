extends Node


var SERVER_PORT = 4242
var LINODE = "li258-250.members.linode.com"  #Make Environtment var?

var SERVER_DOMAIN = LINODE

var LOCAL_HOST = "127.0.0.1"
var peer

#Initial scores to beat
remotesync var scores = [{"N": "Nico", "T": 209, "D": 0}]

remotesync var top_scores = []

func _ready():
	print("args:", OS.get_cmdline_args())
	var is_server = false
	if "server" in OS.get_cmdline_args():
		is_server = true
	update_top_scores()
	init_connection(is_server)
	get_tree().connect("network_peer_connected", self, "_player_connected")
	if is_server:
		print("is listening: ", peer.is_listening())
	
func init_connection(is_server: bool):
	if is_server:
		print("Starting as server")
		peer = WebSocketServer.new()  #NetworkedMultiplayerENet
		peer.ssl_certificate = load("res://CERTBOT/fullchain.crt")
		peer.private_key = load("res://CERTBOT/privkey.key")
		peer.listen(SERVER_PORT, PoolStringArray(), true)
#		peer.create_server(SERVER_PORT)
	else:
		print("Starting as client")
		peer = WebSocketClient.new()
		if "local" in OS.get_cmdline_args():
			print("Using localhost")
			SERVER_DOMAIN = LOCAL_HOST
		var url = "wss://" + (SERVER_DOMAIN) + ":" + str(SERVER_PORT)
		var error = peer.connect_to_url(url, PoolStringArray(), true)
		if error != OK:
			print("Error connecting: ", error)
#		peer.create_client(SERVER_IP,SERVER_PORT)
	get_tree().network_peer = peer

func _player_connected(id):
	if not is_network_master():
		return
	print("Sending top scores to:", id)
	rset_id(id, "top_scores", top_scores)

master func submit_score(player_name, best_time, deaths):
	var sender_id = get_tree().get_rpc_sender_id()
	print(sender_id, " submit score: ", player_name, " ", best_time, " ", deaths)
	scores.append({"N":player_name, "T":best_time, "D":deaths})
	update_top_scores()
	rset_id(sender_id, "top_scores", top_scores)
	
func sort_scores(a, b):
	if a.T < b.T:
		return true
	return false

func update_top_scores():
	"""
	Sorts scores and sets top 25
	Trim score list if too large 100
	"""
	scores.sort_custom(self, "sort_scores")
	if len(scores) > 100:
		scores = scores.slice(0, 99) #Set max size to 200
	top_scores = scores


func _process(delta):
	peer.poll()

