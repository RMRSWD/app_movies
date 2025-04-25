Application de Films
##############################################################

API utilisées

Base URL : https://api.themoviedb.org/3/

Clé API : d569dcea3c12b769842598f44540a7f2
Rechercher des films (fetchMovies)      	  :   /search/movie?query={query}&api_key={apiKey}
Films populaires (fetchHotMovies)	          :   /movie/top_rated?api_key={apiKey}
Détails d'un film (fetchMovieDetailss)		  :   /movie/{movieId}?api_key={apiKey}&append_to_response=credits
Recommandations (fetchRecommendations)		  :   /movie/{movieId}/recommendations?api_key={apiKey}&language=en-US
Genres d'un film (fetchGenre)	        	  :   /movie/{movieId}?api_key={apiKey}
Détails d'un acteur (fetchActorDetails)		  :   /person/{personId}?api_key={apiKey}
Films liés à un acteur(fetchActorMoviesWithDetail):   /discover/movie?with_cast={personId}&api_key={apiKey}

##############################################################
SQLite
Pour une gestion locale, SQLite est utilisé pour stocker des informations sur :

- Les films favoris.
- L’historique des films récemment visionnés.
- Les notes personnelles attribuées par l'utilisateur.
##############################################################
Spécificités originales

Animations dynamiques :

    - Animation de survol (hover) sur les éléments des listes de films et recommandations avec AnimatedScale et MouseRegion.
    - Effet de mise en avant des films récemment consultés grâce à une animation d'opacité.

Base de données SQLite intégrée :

    - Gestion des films favoris et récemment consultés localement avec Sqflite.
    - Structure de la base de données optimisée pour gérer les genres, les acteurs, et les notes personnelles.

Fonctionnalité de notation personnalisée :

    - Chaque utilisateur peut ajouter ou modifier une note personnelle pour un film, stockée dans la base de données locale.

Navigation fluide :

    - Ajout d'un bouton "Home" global pour revenir à la page principale à tout moment.

#################################################################
Fonctionnalités

Recherche de films et séries :

- Recherche facile de films , séries.
- Affichage des résultats avec les informations principales (titre, affiche, note).
- Les films ou séries flous seront considérés comme regardés
Détails des films :

- Affichage des détails d’un film, y compris le synopsis, les genres et les acteurs.
- Liste des films similaires suggérés.
- Possibilité pour les utilisateurs de noter les films.

Détails des acteurs :

- Affichage des informations sur les acteurs, y compris la biographie et la liste des films dans lesquels ils ont joué.

Favoris et récemment visionnés :

- Stockage des films favoris et de l'historique des films récemment visionnés.
- Suppression individuelle ou totale des films récemment visionnés.

Films populaires liés :

- Affiche les films célèbres liés aux films que les utilisateurs ont ajoutés aux favoris dans l'interface des favoris.

Navigation rapide :

- Bouton Home pour revenir à l’écran d’accueil .

##############################################################

Limitations du projet

- Actuellement, l'application ne gère pas la pagination pour les longues listes de films. Les résultats complets de l'API ne sont pas paginés, ce qui limite l'expérience utilisateur pour des requêtes contenant de nombreux résultats.

- L'utilisation de FutureBuilder dans plusieurs écrans peut ralentir l'affichage lorsque les données de l'API prennent du temps à charger.

- Le code n'a pas été optimisé, certains endroits ont encore du code en double

--------------------------------------------------------------------------------------------------
Auteur
- VU THE DUC
