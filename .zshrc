# get version control info
autoload -Uz vcs_info

# customize the way git looks with zstyle
zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

# Run vcs_info before each prompt to get version control information
precmd() { vcs_info }

# Enables dynamic/customizable prompts in ZSH
setopt PROMPT_SUBST
# Right side prompt that shows user@machine in red brackets
RPROMPT='%F{red}[%F{yellow}%n%F{green}@%F{blue}%M%F{red}]'

# History in cache directory
HISTFILE="$HOME/.cache/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory # appends new entries to history instead of overwriting
setopt SHARE_HISTORY # enables shared command history between shells
setopt HIST_IGNORE_DUPS # will not record duplicate commands run consecutively

alias vim=nvim
alias ls='lsd --group-dirs first'
alias ll='ls -Alh'
alias cat='bat'
alias open='xdg-open'

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)   #include hidden files

LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:';
export LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Function to set prompt color based on vi mode
# In order this formats the left prompt in 2 levels:
# 1st level is red brackets around the CWD followed by vcs_info if present
# 2nd level (new line) is the space where you type commands
function set_prompt_color_vi_mode {
    if [[ $KEYMAP == vicmd ]]; then
        PROMPT='%F{red}[%F{magenta}%~%F{red}] ${vcs_info_msg_0_}
%F{yellow}V%{$reset_color%}%f '
    else
        PROMPT='%F{red}[%F{magenta}%~%F{red}] ${vcs_info_msg_0_}
%F{green}$%{$reset_color%}%f '
    fi
}

# Run the function to set initial prompt color
set_prompt_color_vi_mode

# Function to update prompt color when vi mode changes
function zle-line-init zle-keymap-select {
    set_prompt_color_vi_mode
    zle reset-prompt
}

# Explicitly register zle-keymap-select and zle-line-init as ZLE widgets
zle -N zle-keymap-select
zle -N zle-line-init

# Use vim keys in tab complete menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Load zsh-syntax-hilighting; should be last
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
