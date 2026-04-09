import paho.mqtt.client as mqtt
import json
import time
import psycopg2
import threading

# --- CONFIGURATION CONNEXION BASE DE DONNÉES ---
DB_CONFIG = {
    'host': 'localhost',
    'database': 'projet_comptage',
    'user': 'leo',
    'password': 'test'
}

# Paramètres globaux
DUREE_FLASH_VERT = 0.5  # Temps de maintien du vert (en secondes) pour que l'œil le voie
ANALYSE_ACTIVE = True   # Flag pour activer/désactiver le traitement
suivi_appareils = {}    # Dictionnaire stockant l'état en temps réel de chaque capteur (faisceaux, temps)
verrou = threading.Lock() # Verrou pour éviter les conflits entre le thread principal et la surveillance

def piloter_led(client, target_topic, faisceau, mode):
    """
    Envoie une commande JSON à WLED pour changer l'état d'un segment spécifique.
    mode: "VERT" (succès), "ROUGE" (blocage), "OFF" (éteindre)
    faisceau: 'b' (Back, LEDs 0-15), 'f' (Front, LEDs 16-30)
    """
    if not target_topic: return
    topic_api = f"{target_topic}/api"
    
    # Définition des zones physiques sur la bande LED
    if faisceau == 'b': 
        seg_id, start, stop = 0, 0, 16  # Segment 0 pour le faisceau Arrière
    else: 
        seg_id, start, stop = 1, 16, 32 # Segment 1 pour le faisceau Avant

    # Construction du message JSON selon le mode choisi
    if mode == "VERT":
        payload = {"seg": [{"id": seg_id, "start": start, "stop": stop, "on": True, "col": [[0, 255, 0]], "bri": 255}]}
    elif mode == "ROUGE":
        payload = {"seg": [{"id": seg_id, "start": start, "stop": stop, "on": True, "col": [[255, 0, 0]], "bri": 255}]}
    else: # Mode OFF
        payload = {"seg": [{"id": seg_id, "on": False}]}

    try:
        # Publication du message JSON sur le topic API de WLED
        client.publish(topic_api, json.dumps(payload))
    except Exception as e:
        print(f"❌ Erreur MQTT LED : {e}")

# --- THREAD DE SURVEILLANCE DES BLOCAGES (ROUGE) ---
def surveillance_active(client):
    """Boucle de fond qui vérifie si un faisceau est coupé depuis trop longtemps"""
    while True:
        now = time.time()
        with verrou:
            for dev_id, infos in suivi_appareils.items():
                config = get_config_from_db(dev_id)
                if not config: continue
                
                t_bloque_seuil = float(config[3]) # Récupération du seuil de blocage (ex: 5s)
                target_topic = config[4]          # Récupération du topic WLED depuis la BDD (NOUVEAU)
                
                for cle in ["f", "b"]:
                    p = infos[cle]
                    # Si le faisceau est coupé (start_1 > 0) et qu'on dépasse le seuil sans être déjà marqué "bloqué"
                    if p["start_1"] > 0 and not p["bloque"]:
                        duree_actuelle = now - p["start_1"]
                        if duree_actuelle > t_bloque_seuil:
                            p["bloque"] = True # On marque l'état comme bloqué
                            
                            # Allumage immédiat de la LED en ROUGE
                            if target_topic:
                                piloter_led(client, target_topic, cle, "ROUGE")
                            
                            # Notification MQTT pour les autres systèmes (Alerte)
                            client.publish("porte/alerte", json.dumps({"id": dev_id, "status": "BLOCAGE", "position": cle}))
                            print(f"🚨 BLOCAGE ROUGE : {dev_id} | {cle}")
        time.sleep(0.3) # Petite pause pour ne pas surcharger le CPU

def get_config_from_db(dev_id):
    """Va chercher les réglages (sensibilité, seuils et topic WLED) de l'appareil dans PostgreSQL"""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        # NOUVEAU : Ajout de 'topic_wled' dans la requête SELECT
        cur.execute("SELECT role_f, role_b, sensibilite, temps_bloque, topic_wled FROM appareils WHERE id = %s", (dev_id,))
        res = cur.fetchone()
        cur.close()
        conn.close()
        return res 
    except: return None

def on_connect(client, userdata, flags, rc, properties=None):
    """Callback lors de la connexion au broker MQTT"""
    client.subscribe("porte/oscillo/brut") # S'abonne aux signaux des capteurs
    print("✅ Logic Bridge opérationnel (Vert sur passage, Rouge sur blocage)")

def on_message(client, userdata, msg):
    """Traitement principal : reçoit les signaux 0 ou 1 des faisceaux"""
    global suivi_appareils
    now = time.time()

    try:
        # Décodage du message JSON reçu de l'ESP32
        payload = json.loads(msg.payload.decode())
        dev_id = payload.get('id')
        if not dev_id: return

        # Initialisation des données de suivi si c'est la première fois qu'on voit cet appareil
        with verrou:
            if dev_id not in suivi_appareils:
                suivi_appareils[dev_id] = {
                    "f": {"start_1": 0, "bloque": False, "last_pass_time": 0}, 
                    "b": {"start_1": 0, "bloque": False, "last_pass_time": 0}
                }
        
        # Récupération de la config pour connaître les temps de filtrage ET le topic WLED
        config = get_config_from_db(dev_id)
        if not config: return 
        sensibilite = float(config[2]) / 1000.0 # Convertit ms en secondes
        t_bloque_seuil = float(config[3])
        target_topic = config[4]                # NOUVEAU : Récupération depuis la base de données

        for cle in ["f", "b"]:
            if cle not in payload: continue
            signal = payload[cle] 
            p = suivi_appareils[dev_id][cle] 
            
            # Détermination dynamique du rôle (Entrée/Sortie) via la BDD
            label_bdd = config[0] if cle == "f" else config[1]

            if signal == 1:
                # DÉBUT DE COUPURE : On enregistre juste l'heure du début
                if p["start_1"] == 0: 
                    p["start_1"] = now 
            else:
                # FIN DE COUPURE : Le signal repasse à 0
                if p["start_1"] != 0:
                    duree = now - p["start_1"]

                    # CAS 1 : C'était un passage normal (entre min sensibilité et max blocage)
                    if sensibilite <= duree <= t_bloque_seuil:
                        # Anti-rebond : évite de compter deux fois le même passage (0.6s)
                        if (now - p["last_pass_time"] > 0.6):
                            # On publie l'événement de passage avec le TYPE (Entrée/Sortie)
                            res = {
                                "id": dev_id, 
                                "faisceau": cle, 
                                "type": label_bdd, 
                                "duree": round(duree, 3)
                            }
                            client.publish("porte/passage", json.dumps(res))
                            print(f"🚀 PASSAGE COMPTÉ (VERT) : {dev_id} | {cle} ({label_bdd})")
                            
                            # ALLUMAGE VERT TEMPORAIRE (Flash)
                            if target_topic:
                                piloter_led(client, target_topic, cle, "VERT")
                                # Utilisation d'un Timer pour éteindre automatiquement après 0.5s
                                threading.Timer(DUREE_FLASH_VERT, piloter_led, [client, target_topic, cle, "OFF"]).start()
                            
                            p["last_pass_time"] = now
                    
                    # CAS 2 : On sort d'un état de blocage (le signal était resté à 1 trop longtemps)
                    elif p["bloque"]:
                        if target_topic:
                            piloter_led(client, target_topic, cle, "OFF") # On éteint la LED rouge
                        
                        # Information de fin d'alerte
                        client.publish("porte/alerte", json.dumps({"id": dev_id, "status": "LIBERE", "position": cle}))
                        print(f"ℹ️ FIN BLOCAGE (OFF) : {dev_id} | {cle}")

                    # Réinitialisation des variables pour la prochaine détection
                    p["start_1"] = 0
                    p["bloque"] = False
    except Exception as e:
        print(f"❌ Erreur : {e}")

# --- LANCEMENT DU PROGRAMME ---
client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)

client.username_pw_set("leo", "test") # Authentification MQTT
client.on_connect = on_connect
client.on_message = on_message

try:
    # Connexion au broker local
    client.connect("localhost", 1883, 60)
    
    # Lancement du thread de surveillance en arrière-plan
    threading.Thread(target=surveillance_active, args=(client,), daemon=True).start()
    
    # Maintien du programme en vie pour écouter les messages
    client.loop_forever()
except Exception as e:
    print(f"❌ Erreur Connexion : {e}")
