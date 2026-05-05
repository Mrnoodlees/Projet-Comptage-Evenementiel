import paho.mqtt.client as mqtt
import json
import time
import psycopg2
import threading

# --- CONFIGURATION BDD ---
DB_CONFIG = {
    'host': 'localhost',
    'database': 'projet_comptage',
    'user': 'leo',
    'password': 'test'
}

<<<<<<< Updated upstream
# --- CONFIGURATION MULTI-WLED ---
# Associe l'ID de ton récepteur au Topic de son WLED
MAPPING_LED = {
    "PORTE_02": "wled/porte1",
    "PORTE_01": "wled/porte_entree",  # Exemple pour tes autres équipements
    "PORTE_03": "wled/porte_labo"    # Exemple
}
DUREE_FLASH = 0.2  # Temps d'allumage en secondes

ANALYSE_ACTIVE = True 
suivi_appareils = {} 
verrou = threading.Lock()
=======
# Paramètres globaux
DUREE_FLASH_VERT = 0.5  
suivi_appareils = {}    # État en temps réel (mémoire vive)
verrou = threading.Lock() 

def piloter_led(client, target_topic, faisceau, mode):
    """Envoie les commandes JSON à WLED pour le retour visuel"""
    if not target_topic: return
    topic_api = f"{target_topic}/api"
    
    # Segment 0 = Back (b), Segment 1 = Front (f)
    if faisceau == 'b': 
        seg_id, start, stop = 0, 0, 16  
    else: 
        seg_id, start, stop = 1, 16, 32 

    if mode == "VERT":
        payload = {"seg": [{"id": seg_id, "start": start, "stop": stop, "on": True, "col": [[0, 255, 0]], "bri": 255}]}
    elif mode == "ROUGE":
        payload = {"seg": [{"id": seg_id, "start": start, "stop": stop, "on": True, "col": [[255, 0, 0]], "bri": 255}]}
    else: # OFF
        payload = {"seg": [{"id": seg_id, "on": False}]}
>>>>>>> Stashed changes

def piloter_led(client, topic, action):
    """ Envoie l'ordre à la LED spécifique (ON ou OFF) """
    try:
<<<<<<< Updated upstream
        client.publish(topic, action)
=======
        client.publish(topic_api, json.dumps(payload))
>>>>>>> Stashed changes
    except Exception as e:
        print(f"❌ Erreur MQTT LED sur {topic} : {e}")

def get_config_from_db(dev_id):
<<<<<<< Updated upstream
    """ Récupère les paramètres de l'appareil en BDD """
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        cur.execute("SELECT role_f, role_b, sensibilite, temps_bloque FROM appareils WHERE id = %s", (dev_id,))
=======
    """Récupère dynamiquement les réglages depuis PostgreSQL"""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        cur.execute("SELECT role_f, role_b, sensibilite, temps_bloque, topic_wled FROM appareils WHERE id = %s", (dev_id,))
>>>>>>> Stashed changes
        res = cur.fetchone()
        cur.close()
        conn.close()
        return res 
<<<<<<< Updated upstream
    except Exception as e:
        return None

# --- BOUCLE DE SURVEILLANCE ACTIVE (Blocages + Heartbeat) ---
def surveillance_active(client):
    """ Vérifie en continu les blocages et les déconnexions (Heartbeat) """
=======
    except: return None

# --- THREAD DE SURVEILLANCE DES BLOCAGES ---
def surveillance_active(client):
    """Vérifie si un faisceau est coupé depuis trop longtemps sans attendre le signal '0'"""
>>>>>>> Stashed changes
    while True:
        now_utc = time.time() 
        with verrou:
            for dev_id, infos in suivi_appareils.items():
                config = get_config_from_db(dev_id)
                if not config: continue
                
<<<<<<< Updated upstream
                # 1. GESTION DES BLOCAGES (Faisceau resté à 1)
                t_bloque_seuil = float(config[3])
                for cle in ["f", "b"]:
                    p = infos[cle]
                    if p["start_1"] > 0 and not p["bloque"]:
                        duree_actuelle = now - p["start_1"]
                        if duree_actuelle > t_bloque_seuil:
                            p["bloque"] = True
                            nom_faisceau = "FRONT" if cle == "f" else "BACK"
                            label_bdd = config[0] if cle == "f" else config[1]
                            
                            alerte = {
                                "id": dev_id,
                                "status": "BLOCAGE",
                                "position": nom_faisceau,
                                "type": label_bdd,
                                "duree_obstruction": round(duree_actuelle, 1),
                                "timestamp": now
                            }
                            client.publish("porte/alerte", json.dumps(alerte))
                            print(f"🚨 BLOCAGE : {dev_id} | {nom_faisceau} ({label_bdd})")

                # 2. GESTION DU HEARTBEAT (ESP débranché)
                if (now - infos["last_seen"]) > 120:
                    if not infos.get("offline_sent", False):
                        msg_off = {
                            "id": dev_id,
                            "status": "OFFLINE",
                            "message": "Appareil ne répond plus (débranché)"
                        }
                        client.publish("porte/alerte", json.dumps(msg_off))
                        print(f"👻 OFFLINE : {dev_id} est injoignable")
                        infos["offline_sent"] = True
                else:
                    infos["offline_sent"] = False

        time.sleep(1)

def on_connect(client, userdata, flags, rc, properties=None):
    client.subscribe("porte/oscillo/brut")
    client.subscribe("porte/control")
    client.subscribe("recepteur/status")
    client.subscribe("emeteur/status")
    print(f"✅ Logic Bridge opérationnel. Mapping actif pour : {list(MAPPING_LED.keys())}")

def on_message(client, userdata, msg):
    global suivi_appareils, ANALYSE_ACTIVE
    now = time.time()

    if msg.topic == "porte/control":
        cmd = msg.payload.decode().upper()
        if cmd == "START": ANALYSE_ACTIVE = True
        elif cmd == "STOP": ANALYSE_ACTIVE = False
        return

=======
                t_bloque_seuil = float(config[3]) 
                target_topic = config[4]          
                
                for cle in ["f", "b"]:
                    p = infos[cle]
                    if p["start_ms"] > 0 and not p["bloque"]:
                        # Estimation basée sur le temps système pour le blocage en cours
                        duree_estimee = (time.time() * 1000 - p["last_sys_ms"]) / 1000
                        
                        if duree_estimee > t_bloque_seuil:
                            p["bloque"] = True 
                            if target_topic:
                                piloter_led(client, target_topic, cle, "ROUGE")
                            client.publish("porte/alerte", json.dumps({"id": dev_id, "status": "BLOCAGE", "position": cle}))
                            print(f"🚨 BLOCAGE ROUGE : {dev_id} | {cle}")
        time.sleep(0.4) 

def on_connect(client, userdata, flags, rc, properties=None):
    client.subscribe("porte/oscillo/brut") 
    print("✅ Logic Bridge opérationnel (Précision MS activée)")

def on_message(client, userdata, msg):
    """Cœur de la logique de comptage"""
    global suivi_appareils
>>>>>>> Stashed changes
    try:
        payload = json.loads(msg.payload.decode())
        dev_id = payload.get('id')
        esp_ms = payload.get('ms') # Millis() de l'ESP pour la précision
        
        if not dev_id or esp_ms is None: return

        with verrou:
            if dev_id not in suivi_appareils:
                suivi_appareils[dev_id] = {
<<<<<<< Updated upstream
                    "f": {"start_1": 0, "bloque": False, "last_pass_time": 0},
                    "b": {"start_1": 0, "bloque": False, "last_pass_time": 0},
                    "last_seen": now,
                    "offline_sent": False
                }
            else:
                suivi_appareils[dev_id]["last_seen"] = now

        # LOGIQUE OSCILLO
        if msg.topic == "porte/oscillo/brut" and ANALYSE_ACTIVE:
            config = get_config_from_db(dev_id)
            if not config: return 
            
            sensibilite = float(config[2]) / 1000.0
            t_bloque_seuil = float(config[3])

            for cle in ["f", "b"]:
                if cle not in payload: continue
                signal = payload[cle] 
                p = suivi_appareils[dev_id][cle] 
                nom_faisceau = "f" if cle == "f" else "b"
                label_bdd = config[0] if cle == "f" else config[1]

                if signal == 1:
                    if p["start_1"] == 0: 
                        p["start_1"] = now
                else:
                    if p["start_1"] != 0:
                        duree = now - p["start_1"]
                        
                        # CAS : Passage valide
                        if sensibilite <= duree <= t_bloque_seuil:
                            if (now - p["last_pass_time"] > 0.6):
                                res = {
                                    "id": dev_id, "faisceau": nom_faisceau, 
                                    "type": label_bdd, "duree": round(duree, 3)
                                }
                                client.publish("porte/passage", json.dumps(res))
                                print(f"🚀 PASSAGE : {dev_id} | {nom_faisceau}")
                                
                                # --- GESTION FLASH LED DYNAMIQUE ---
                                if dev_id in MAPPING_LED:
                                    target_topic = MAPPING_LED[dev_id]
                                    piloter_led(client, target_topic, "ON")
                                    # Extinction automatique après DUREE_FLASH
                                    threading.Timer(DUREE_FLASH, piloter_led, [client, target_topic, "OFF"]).start()
                                
                                p["last_pass_time"] = now
                        
                        elif p["bloque"]:
                            fin_alerte = {
                                "id": dev_id, "status": "LIBERE",
                                "position": nom_faisceau, "type": label_bdd,
                                "duree_totale": round(duree, 1)
                            }
                            client.publish("porte/alerte", json.dumps(fin_alerte))
                            print(f"ℹ️ FIN BLOCAGE : {dev_id} | {nom_faisceau} ({round(duree, 1)}s)")

                        p["start_1"] = 0
                        p["bloque"] = False

=======
                    "f": {"start_ms": 0, "bloque": False, "last_pass_ms": 0, "last_sys_ms": 0}, 
                    "b": {"start_ms": 0, "bloque": False, "last_pass_ms": 0, "last_sys_ms": 0}
                }
        
        config = get_config_from_db(dev_id)
        if not config: return 
        sensibilite = float(config[2]) / 1000.0 
        t_bloque_seuil = float(config[3])
        target_topic = config[4]                

        for cle in ["f", "b"]:
            if cle not in payload: continue
            signal = payload[cle] 
            p = suivi_appareils[dev_id][cle] 
            label_bdd = config[0] if cle == "f" else config[1]

            if signal == 1:
                # DÉBUT DE COUPURE
                if p["start_ms"] == 0: 
                    p["start_ms"] = esp_ms 
                    p["last_sys_ms"] = time.time() * 1000 # Référence système pour le thread blocage
            else:
                # FIN DE COUPURE
                if p["start_ms"] != 0:
                    # Calcul de la durée exacte grâce aux millisecondes de l'ESP
                    duree = (esp_ms - p["start_ms"]) / 1000.0 

                    # CAS 1 : Passage valide
                    if sensibilite <= duree <= t_bloque_seuil:
                        # Anti-rebond
                        if (esp_ms - p["last_pass_ms"] > 600):
                            # --- MODIFIÉ : Retrait de 'ts_event' ---
                            res = {
                                "id": dev_id, 
                                "faisceau": cle, 
                                "type": label_bdd, 
                                "duree": round(duree, 3)
                            }
                            client.publish("porte/passage", json.dumps(res))
                            print(f"🚀 PASSAGE VALIDE : {dev_id} | {cle} ({duree}s)")
                            
                            if target_topic:
                                piloter_led(client, target_topic, cle, "VERT")
                                threading.Timer(DUREE_FLASH_VERT, piloter_led, [client, target_topic, cle, "OFF"]).start()
                            
                            p["last_pass_ms"] = esp_ms
                    
                    # CAS 2 : Sortie de blocage
                    elif p["bloque"]:
                        if target_topic:
                            piloter_led(client, target_topic, cle, "OFF")
                        client.publish("porte/alerte", json.dumps({"id": dev_id, "status": "LIBERE", "position": cle}))
                        print(f"ℹ️ FIN BLOCAGE : {dev_id} | {cle}")

                    # Reset des compteurs
                    p["start_ms"] = 0
                    p["bloque"] = False
                    
>>>>>>> Stashed changes
    except Exception as e:
        print(f"❌ Erreur : {e}")

# --- LANCEMENT ---
client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
<<<<<<< Updated upstream
client.username_pw_set("leo", "test") 
=======
client.username_pw_set("leo", "test")
>>>>>>> Stashed changes
client.on_connect = on_connect
client.on_message = on_message

try:
    client.connect("localhost", 1883, 60)
<<<<<<< Updated upstream
    
    daemon = threading.Thread(target=surveillance_active, args=(client,), daemon=True)
    daemon.start()
    
=======
    threading.Thread(target=surveillance_active, args=(client,), daemon=True).start()
>>>>>>> Stashed changes
    client.loop_forever()
except Exception as e:
    print(f"❌ Erreur Connexion : {e}")