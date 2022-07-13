<!-- LOGO DU PROJET OU DE L'ORGANISME PUBLIQUE -->

<div>
    <img src="./images/mcn.png" />
</div>

<!-- PROJET -->
# Fonctionnement du Pipeline: 
  Explication sur le fonctionnement du pipeline ainsi que les pré-requis pour héberger un site localement
  Cette plate forme Web est un site statique développé en Ruby avec Jekyll, déployé sur AWS S3 et exposé avec AWS CloudFront.

# Site: 
<!-- TODO: METTRE À JOUR L'URL DE LA PAGE D'ACCUEIL UNE FOIS LE DÉPLOIEMENT EN PROD COMPLÉTÉ -->
- https://cqen-qdce.github.io/plateforme-accueil-centre-innovation/

### Pipeline de déploiement en production
Le pipeline fonctionne sur : 
-	AWS CodePipeline
Le pipeline est démarré par : 
-	Un Github Pull Request se faisant accepter sur la branche main OU tout autre push sur la branche main. Il est aussi possible de démarrer le pipeline manuellement à partir de l'interface d'AWS. Pour ce faire, aller sur AWS CodePipeline, seléctionner le pipeline voulu et cliquer sur « release change ».

Vous pourrez ensuite voir le processus s’exécuter et voir les détails de chaque étape d'exécution en clicant sur le pipeline en exécution.

### Étapes pour héberger le site localement:
1. Cloner le projet.
2. Faire la commande `git submodule init` pour initialiser le submodule dans votre répertoire local, puis `git submodule update` pour pull la dernière version du submodule.
3. Avoir ruby v3.0.4 ou + installé sur votre poste et faire la commande ```gem install jekyll bundler``` [Suivre la procédure d'installation](./procedure.md)
4. Faire la commande ```bundle exec jekyll server``` à la racine du site.

### Pour mettre à jour le submodule (contenu du site): 
```bash
git submodule update --remote
``` 

### Explication des dossiers
- `_layouts` : fichiers html faisant office de template, un layout est le html qui englobe le contenu d'une page, plusieurs layouts peuvent être utilisés l'un dans l'autre
- `_include` : layouts imbriqués dans ceux plus généraux dans - `_layouts` :
- `_posts` : fichiers markdown contenant certains paramètres et son contenu, ce sont les articles qui seront utilisés et listés sur le site
- `_sass` : scss disponible du site et des thèmes
- `.github/workflow` : contient les paramètres de build pour github pages, notamment quel token utiliser
- `assets` : (à vérifier) contient les contenus multimédia du site ainsi que les feuilles de style utilisées, le css généré par le css se retrouvera dans ce dossier lors du build
- `_site` : (généré lors d'un push) site résultant du build