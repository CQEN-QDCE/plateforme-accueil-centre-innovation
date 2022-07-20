### Procédure d'installation de Ruby

# Prémière étape:
### Gardons notre système à jour :

```
sudo apt update
```

```
sudo apt upgrade
```

```
sudo apt autoremove
```

# Installez ruby, en utilisant la méthode rbenv:

```
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
```

```
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
```

```
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
```

```
source ~/.bashrc
```
# Vérifiez si vous avez correctement installé rbenv, l'exécution de la commande type rbenv devrait vous donner cette réponse :

```
type rbenv
```

```bash
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
}
```
# Installez ruby-build pour simplifier l'installation de ruby ​​:

```
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
```

À ce stade, vous devriez être en mesure d'exécuter la commande rbenv install -l qui vous donnera toutes les versions de ruby ​​disponibles :

```
rbenv install -l
```

```bash

Available versions:
  2.5.8
  2.6.6
  2.7.1
  3.0.4
  ...
  rbx-5.0
  truffleruby-20.1.0
  truffleruby+graalvm-20.1.0
```

# Utilisez la version 3.0.4 en exécutant les commandes suivantes :

```
rbenv install 3.0.4
```

```  
rbenv global 3.0.4
```
 Remplacer 3.0.4 par la version que vous souhaitez installer

# Vérifiez que tout est en ordre en exécutant la commande

```
ruby -v
```

```bash
ruby 2.6.3p62 (2019-04-16 revision 67580) [x86_64-linux]
```

# Installez les gems et le bundler avec les commandes suivantes :

```
echo "gem: --no-document" > ~/.gemrc 
```

```
gem install bundler
```

```
gem env home
```