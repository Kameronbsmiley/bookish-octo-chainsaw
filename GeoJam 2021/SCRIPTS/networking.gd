extends Node


var SERVER_PORT = 4242
var LINODE = "173.255.248.250"  #Make Environtment var?
var SERVER_IP = LINODE
var LOCAL_HOST = "127.0.0.1"
var peer

remotesync var top_scores = [{"N": "Nico", "T": 209}]

func _ready():
	print("args:", OS.get_cmdline_args())
	var is_server = false
	if "server" in OS.get_cmdline_args():
		is_server = true
		
	init_connection(is_server)
	get_tree().connect("network_peer_connected", self, "_player_connected")
	if is_server:
		print("is listening: ", peer.is_listening())
	
func init_connection(is_server: bool):
	if is_server:
		print("Starting as server")
		peer = WebSocketServer.new()  #NetworkedMultiplayerENet
		peer.listen(SERVER_PORT, PoolStringArray(), true)
#		peer.create_server(SERVER_PORT)
	else:
		print("Starting as client")
		peer = WebSocketClient.new()
		if "local" in OS.get_cmdline_args():
			print("Using localhost")
			SERVER_IP = LOCAL_HOST
		var url = "ws://" + (SERVER_IP) + ":" + str(SERVER_PORT)
		var error = peer.connect_to_url(url, PoolStringArray(), true);
		if error != OK:
			print("Error connecting: ", error)
#		peer.create_client(SERVER_IP,SERVER_PORT)
	get_tree().network_peer = peer

func _player_connected(id):
	if not is_network_master():
		return
	print("Sending top scores to:", id)
	rset_id(id, "top_scores", top_scores)

master func submit_score(player_name, best_time, difficulty):
	var sender_id = get_tree().get_rpc_sender_id()
	print(sender_id, " submit score: ", player_name, " ", best_time)
	top_scores.append({"N":player_name, "T":best_time})
	rset_id(sender_id, "top_scores", top_scores)

func _process(delta):
	peer.poll()
