# Path to your oh-my-zsh configuration.
ZSH=$HOME/.zsh/oh-my-zsh
PATH=~/bin:$PATH
OSTYPE=`uname`
if [[ $OSTYPE == 'Darwin' ]]; then 
  PATH=/usr/local/bin:/usr/local/sbin:$PATH
  ZSH_THEME="bira"
else
  ZSH_THEME="steeef"
fi
# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git perl debian ssh-agent syntax-highlighting)

source $ZSH/oh-my-zsh.sh

if [ -f ~/.zsh_nocorrect ]; then    
  while read -r COMMAND; do
    alias $COMMAND="nocorrect $COMMAND"
  done < ~/.zsh_nocorrect
fi

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias l='ls -lah'

# Customize to your needs...
setopt prompt_subst
local git=$(git_prompt_info)
if [ ${#git} != 0 ]; then
  ((git=${#git} - 10))
else
  git=0
fi

KEYCHAIN=`which keychain`
for key in id_dsa id_rsa github_id_rsa git_id_rsa; do
  if [ -f ~/.ssh/$key ]; then
    $KEYCHAIN -q ~/.ssh/$key;
  fi;
done;

[ -z "$HOSTNAME" ] && HOSTNAME=`uname -n`

if [ "$HOSTNAME" = "scooter" ]; then 
  alias sql='mysql -hkermit.reivernet.com -udylanc rss' 
else 
  alias sql='mysql -hlocalhost -uroot -phmm getin2net'
fi

[ -f $HOME/.keychain/$HOSTNAME-sh ] && \
  . $HOME/.keychain/$HOSTNAME-sh
[ -f $HOME/.keychain/$HOSTNAME-sh-gpg ] && \
  . $HOME/.keychain/$HOSTNAME-sh-gpg

[ -s "/root/.scm_breeze/scm_breeze.sh" ] && source "/root/.scm_breeze/scm_breeze.sh"

[ -s "/home/dylanc/.scm_breeze/scm_breeze.sh" ] && source "/home/dylanc/.scm_breeze/scm_breeze.sh"
