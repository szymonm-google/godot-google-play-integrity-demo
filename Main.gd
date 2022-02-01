extends Panel

var play_integrity = null
var results_label = null
var rng = RandomNumberGenerator.new()
const NONCE_LENGTH_BYTES = 32;

func _ready():
	results_label = get_node("Results")
	
	if !Engine.has_singleton("GodotGooglePlayIntegrity"):
		results_label.text = "COULDN'T LOAD PLAY INTEGRITY PLUGIN"
		return
		
	play_integrity = Engine.get_singleton("GodotGooglePlayIntegrity")
	play_integrity.connect("request_completed", self, "_on_request_completed")

func generate_nonce_base64():
	var array = PoolByteArray()
	array.resize(NONCE_LENGTH_BYTES)
	for i in NONCE_LENGTH_BYTES:
		array[i] = rng.randi_range(0, 255);
	return to_url_safe(Marshalls.raw_to_base64(array))

# Converts Base64 string to "URL and filename safe" variant.
# See RFC 3548 section 4.
func to_url_safe(string):
	return string.replace("+", "-").replace("/", "_")
	
func _on_GetTokenButton_pressed():
	play_integrity.requestIntegrityToken(generate_nonce_base64())
	results_label.text = "REQUESTING THE TOKEN..."

func _on_request_completed(token):
	results_label.text = "Received token: " + token
