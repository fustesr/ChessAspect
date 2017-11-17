# ChessAspect

Membre de l'équipe : 
* Virgile Lafontaine
* Fustes Raphaël

------------------

Objectif atteint : le jeu a été modifié sans touché au code source.

Trois aspects ont été implementés :
<br/><br/>

* HumanAspect.aj

Vérifie les moves du joueurs humain

* BotAspect.aj

Vérifie les moves de la StupidAI

* Logger.aj

S'occupe de la journalisation des coups. Le fichier de log peut etre trouvé à la racine du projet (au meme niveau que les sources)

-----------------

Cas d'erreur/vérification corrigés avec les aspects :
* Déplacement sur soi-meme
* Déplacement depuis une case vide
* Déplacement hors du board
* Déplacement sur une piece alliée
* Gestion des mouvements spécifiques à chaque piece d'un jeu d'échec
