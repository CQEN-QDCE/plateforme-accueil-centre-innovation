---
date: 2022-07-26T14:07:23Z
permalink: experimentations/ceai-cqen-documentation/installation_asea_ceai.html
layout: post
type: posts
project: ceai-cqen-documentation
github: https://github.com/CQEN-QDCE/ceai-cqen-documentation/blob/main/Experimentations/installation_asea_ceai.md
index: false
---
<!-- ENTETE -->
[![img](https://img.shields.io/badge/Lifecycle-Experimental-339999)](https://www.quebec.ca/gouv/politiques-orientations/vitrine-numeriqc/accompagnement-des-organismes-publics/demarche-conception-services-numeriques)
[![License](https://img.shields.io/badge/Licence-LiLiQ--R-blue)](LICENSE_FR)

---

<div>
    <img src="https://github.com/CQEN-QDCE/.github/blob/main/images/mcn.png" />
</div>
<!-- FIN ENTETE -->

# Installation d'un environnement AWS Secure Environment Accelerator comme environnement infonuagique du CEAI

## Objectif(s)

Pour son projet de mise en place du centre d'Expertise appliquée en innovation, le CQEN doit se doter d'un environnement infonuagique sécuritaire et innovant. AWS propose de faire l'essai d'une architecture développée avec le gouvernement fédérale nommé *AWS Secure Environment Accelerator*. Cet environnement dont l'installation est automatisé et est maintenue en code source ouvert, met en place le niveau de sécurité de l'information "PBMM".

Au départ, cet environnement a été conçu pour être l'extension infonuagique d'un environnement *on premise* sous domaine Microsoft. Un connecteur *Active Directory* y est normalement déployé pour fournir les identités des usagers au service *AWS Single Sign On* qui gère les accès aux différents comptes AWS.

Le CEAI ne possédant aucune installation *on premise* et n'ayant pas accès à l'annuaire Microsoft du MCN necéssite un environnement infonuagique isolé et déployant son propre service d'identification des usagers. Nous allons donc tester l'installation d'un environnement ASEA dans ces conditions.

## Hypothèse(s)

- L'environnement ASEA peut être installé et configuré sans connexion a un réseau d'entreprise ni déploiement de connecteur *Active Directory*.
- Le service *AWS Single Sign On* peut utiliser un service d'authentification tier (Keycloak) via le protocole OpenIdConnect.

## Démarche

1. Ouvrir un compte AWS et prendre contact avec son équipe de support afin de s'assurer que les limites associées aux nouveaux comptes AWS puissent être levées.  
1. Préparer le fichier de configuration. https://github.com/CQEN-QDCE/ceai-cqen-deployments/tree/main/ASEA/config
1. Installer ASEA. https://github.com/CQEN-QDCE/ceai-cqen-deployments/tree/main/ASEA
1. Déployer une instance Keycloak dans un compte de travail AWS. https://github.com/CQEN-QDCE/ceai-cqen-deployments/tree/main/sso
1. Configurer le service *AWS Single Sign On* pour utiliser l'instance Keycloak comme fournisseur d'identité. (Lien à venir)

## Résultat

- Un environnement ASEA a pu être installé et configuré sans connexion a un réseau d'entreprise ni déploiement de connecteur *Active Directory*.

Le fichier de configuration a laissé toute la latitude possible pour paramétrer l'installation de l'environnement ASEA selon nos spécifications. Aucun service inutile n'a du être déployé et l'environnement répond au besoin du CEAI.

-  Le service *AWS Single Sign On* peut utiliser un service d'authentification tier (Keycloak) mais ne peut le faire via le protocole OpenIdConnect.

Le déploiement d'une instance Keycloak dans les service ECS et RDS a été réalisé sans problème. Nous avons pu configurer le service *AWS Single Sign On* pour qu'il utilise cette instance comme fournisseur d'identité externe. Par contre, nous n'avons pas pu le faire via le protocole OpenIdConnect car celui-ci n'est pas supporté par le service AWS SSO. Il a quand même été possible de le faire via le protocole SAML, plus ancien mais fonctionnel. 

Un autre enjeu concerne le provisionnement des usagers à l'intérieur du service AWS SSO. Celui-ci ne peut être fait que par le protocole SCIM quand une source d'usager externe est configurée. Keycloak ne supportant pas le provisionnement externe via ce protocole, une solution devra être mise en place pour le provisionnement.

## Références

- https://github.com/CQEN-QDCE/ceai-cqen-deployments
- https://aws-samples.github.io/aws-secure-environment-accelerator/installation/install
- https://aws-samples.github.io/aws-secure-environment-accelerator/schema/en/index.html
- https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html
- https://docs.aws.amazon.com/singlesignon/latest/userguide/provision-automatically.html
- https://datatracker.ietf.org/doc/html/rfc7644
- https://www.keycloak.org/documentation