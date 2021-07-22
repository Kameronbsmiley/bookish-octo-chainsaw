extends Node


var SERVER_PORT = 4242
var SERVER_IP = LINODE
var LINODE = "173.255.248.250"  #Make Environtment var?
var LOCAL_HOST = "127.0.0.1"

var top_scores = [{"N": "Kameron", "T": 1.9},
{"N": "Kameron", "T": .9},
{"N": "Kameron", "T": 1.2},
{"N": "Kameron", "T": 3.2}]

func _ready():
	print("args:", OS.get_cmdline_args())
	var is_server = false
	if "server" in OS.get_cmdline_args():
		is_server = true
		print("Starting as server")
		
	init_connection(is_server)
	get_tree().connect("network_peer_connected", self, "_player_connected")
	
func init_connection(is_server: bool):
	var peer = NetworkedMultiplayerENet.new()
	if is_server:
		peer.create_server(SERVER_PORT)
	else:
		if "local" in OS.get_cmdline_args():
			SERVER_IP = LOCAL_HOST
		peer.create_client(SERVER_IP,SERVER_PORT)
	get_tree().network_peer = peer

func _player_connected(id):
	if not is_network_master():
		return
	rset_id(id, "top_scores", top_scores)

master func submit_score(player_name, best_time, difficulty):
	top_scores.append({"N":player_name, "T":best_time})

	var sender_id = get_tree().get_rpc_sender_id()
	rset_id(sender_id, "top_scores", top_scores)
