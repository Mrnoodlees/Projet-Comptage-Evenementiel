import paho.mqtt.client as mqtt

def on_message(client, userdata, msg):
    print(f"Reçu : {msg.topic} {msg.payload.decode()}")

client = mqtt.Client()
client.username_pw_set("leo", "test")
client.on_message = on_message
client.connect("localhost", 1883, 60)
client.subscribe("porte/oscillo/brut")
client.loop_forever()