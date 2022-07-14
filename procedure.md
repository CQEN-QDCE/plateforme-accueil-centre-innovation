### Procédure d'installation de Ruby
https://platoniq.github.io/decidim-install/decidim-focal/

# Tout d'abord, gardons notre système à jour :
 - sudo apt update
 - sudo apt upgrade
 - sudo apt autoremove

# Installez ruby, en utilisant la méthode rbenv .
 - git clone https://github.com/rbenv/rbenv.git ~/.rbenv
 - echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
 - echo 'eval "$(rbenv init -)"' >> ~/.bashrc
 - source ~/.bashrc

# Maintenant, vous devez vérifier si vous avez correctement installé rbenv, l'exécution de la commande type rbenv devrait vous donner cette réponse :
<!--decidim@decidim:~$ type rbenv
rbenv is a function
rbenv ()
{
    local command;
    command="${1:-}";
    if [ "$#" -gt 0 ]; then
        shift;
    fi;
    case "$command" in
        rehash | shell)
            eval "$(rbenv "sh-$command" "$@")"
        ;;
        *)
            command rbenv "$command" "$@"
        ;;
    esac
}-->

# Installez ruby-build pour simplifier l'installation de ruby ​​:
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

À ce stade, vous devriez être en mesure d'exécuter la commande rbenv install -l qui vous donnera toutes les versions de ruby ​​disponibles :
rbenv install -l
<!--Available versions:
  2.5.8
  2.6.6
  2.7.1
  ...
  rbx-5.0
  truffleruby-20.1.0
  truffleruby+graalvm-20.1.0-->

# Nous allons utiliser la version 2.6.3, alors exécutez ces commandes :
 - rbenv install 3.0.4
 - rbenv global 3.0.4
<!--Remplacer 3.0.4 par la version que vous souhaitez installer-->

# Vous pouvez maintenant vérifier que tout est en ordre en exécutant la commande
 - ruby -v:
 <!--ruby 2.6.3p62 (2019-04-16 revision 67580) [x86_64-linux]-->

# Nous allons maintenant installer les gems et le bundler avec les commandes suivantes :
 - echo "gem: --no-document" > ~/.gemrc 
 - gem install bundler
 - gem env home
 - bundler install

# Précision sur la création des pages avec Jekyll:
 Pour s'assurer que le liens hypertexte soit généré d'une manière compatible avec le service de site static S3, il faut:
  - Ajouter dans le fichier nom-de-la-page.markdown  qui se trouve dans le dossier _pages un permalink: /nom-de-la-page/index.html ce qui va générer automatiquement 
    un nouveau fichier nom-de-la-page/index.html dans le dossier _site.
 
