# Projet Comptage Evenementiel
Ce projet consiste en la conception et la réalisation d’un système de comptage événementiel destiné aux concerts et événements gratuits sans billetterie.
L’objectif est d’estimer en temps réel le nombre de personnes présentes sur un site, afin de garantir la sécurité du public et de fournir des informations fiables aux organisateurs, aux services de sécurité et aux autorités.

Le système repose sur des barrières infrarouges autonomes, composées de modules émetteurs et récepteurs pilotés par des ESP32. La coupure du faisceau infrarouge permet de détecter les passages, qui sont ensuite filtrés et comptabilisés par le firmware embarqué.

Les modules communiquent via Wi-Fi avec un serveur local hébergé sur un PC de sécurité, assurant l’affichage et la gestion des alertes en temps réel (indications lumineuses et sonores).
Les données de comptage sont ensuite centralisées sur un serveur distant (VPS) pour la consultation à distance, l’archivage et la supervision globale.