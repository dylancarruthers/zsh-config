# Path to your oh-my-zsh configuration.
ZSH=$HOME/.zsh/oh-my-zsh
PATH=$HOME/bin:$PATH
OSTYPE=$(env uname)
if [ -f /var/lib/gems/1.8/bin ]; then
  PATH=/usr/local/bin:/usr/local/sbin:$PATH:/var/lib/gems/1.8/bin
fi
if [ "$OSTYPE" = 'Darwin' ]; then 
  PATH=/usr/local/bin:/usr/local/sbin:$PATH
  ZSH_THEME="bira"
else
  ZSH_THEME="steeef"
fi
# Set name of the theme to load.
# Look in $HOME/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in $HOME/.oh-my-zsh/plugins/*)
# Custom plugins may be added to $HOME/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
alias l='ls -lah'
TMUX="/usr/local/bin/tmux"
if [ -x $TMUX ]; then
    alias tm="$TMUX attach|| $TMUX"
    plugins=(git perl debian ssh-agent syntax-highlighting git-completion symfony2 tmux tab-completion docker)
else
    plugins=(git perl debian ssh-agent syntax-highlighting git-completion symfony2 tab-completion docker)
fi

source $ZSH/oh-my-zsh.sh

export EDITOR='vim'

if [ -f $HOME/.zsh/no_correct ]; then    
  while read -r COMMAND; do
    alias $COMMAND="nocorrect $COMMAND"
  done < $HOME/.zsh/no_correct
fi

# Customize to your needs...
setopt prompt_subst
local git=$(git_prompt_info)
if [ ${#git} != 0 ]; then
  ((git=${#git} - 10))
else
  git=0
fi

/usr/bin/ssh-add -l &>/dev/null
if [ "$?" = 2 ]; then
    test -r ~/.ssh-agent && \
        eval "$(<~/.ssh-agent)" >/dev/null

    /usr/bin/ssh-add -l &>/dev/null
    if [ "$?" = 2 ]; then
        (umask 066; /usr/bin/ssh-agent > ~/.ssh-agent)
        eval "$(<~/.ssh-agent)" >/dev/null
        /usr/bin/ssh-add
    fi
fi
KEYCHAIN=`which keychain`
for key in id_dsa id_rsa github_id_rsa git_id_rsa; do
  if [ -f $HOME/.ssh/$key ]; then
    $KEYCHAIN -q $HOME/.ssh/$key;
  fi;
done;
$KEYCHAIN -q

[ -z "$HOSTNAME" ] && HOSTNAME=`env uname -n`

if [ "$HOSTNAME" = "scooter" ]; then 
  alias sql='mysql -hkermit.reivernet.com -udylanc rss' 
else 
  if [ -d /var/lib/mysql/reivernet ]; then
    alias sql='mysql -hlocalhost -uroot -phmm reivernet'
  else
    alias sql='mysql -hlocalhost -uroot -phmm getin2net'
  fi
fi

[ -f $HOME/.keychain/$HOSTNAME-sh ] && \
  . $HOME/.keychain/$HOSTNAME-sh
[ -f $HOME/.keychain/$HOSTNAME-sh-gpg ] && \
  . $HOME/.keychain/$HOSTNAME-sh-gpg

echo
echo "Kernel:" $(env uname -r | /usr/bin/awk '{print $1}') "; Userspace: " $(/usr/bin/getconf LONG_BIT) "bit"

if [ -f $HOME/.iterm2_shell_integration.zsh ]; then
    source $HOME/.iterm2_shell_integration.zsh
fi

if [ -f $HOME/.zsh/tmuxinator.zsh ]; then
    source ~/.zsh/tmuxinator.zsh
fi

# Reivernet scripts
if [ -r /var/lib/mysql/reivernet ]; then
    SESSION_TYPE="console"
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        SESSION_TYPE="remote/ssh"
    else
        case $(ps -o comm= -p $PPID) in
            sshd|*/sshd) SESSION_TYPE=remote/ssh;;
        esac
    fi

    if [ "$SESSION_TYPE" = "remote/ssh" ]; then
        MESSAGE=""

        [ ! -x /usr/sbin/zabbix_agentd ] && \
            MESSAGE="$MESSAGE\n - INFO: Zabbix is not installed, this server will not be monitored for load etc\n   To install run /reivernet/scripts/install_zabbix_agent"

        [ ! -x /etc/init.d/salt-minion ] && \
            MESSAGE="$MESSAGE\n - INFO: Salt Minion is not installed, this server will miss many important updates\n   To install run /reivernet/scripts/install_salt.sh"

        [ ! -x /sbin/ipset ] && \
            MESSAGE="$MESSAGE\n - WARNING! You are using an old firewall that may no longer be secure.\n   You must run /reivernet/scripts/install_ipset as soon as possible"

        [ -z "$MESSAGE" ] || \
            echo "\nSee #software_support on Slack for assistance:$MESSAGE"
    fi
fi
