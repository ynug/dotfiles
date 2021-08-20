########################################
# 環境変数
export LANG=ja_JP.UTF-8

# XDG Base Directory Specification
export XDG_CONFIG_HOME=~/.config

# vim は nvim を利用する
alias vim='nvim'

# 色を使用出来るようにする
autoload -Uz colors
colors

# git user情報はグローバルで持たずに各リポジトリで持つ
git config --global user.useConfigOnly true
git config --global --unset user.name
git config --global --unset user.email
git config pull.rebase false

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# プロンプト
PROMPT="%{${fg[cyan]}%}[%~]%{${reset_color}%}
👉 " 


# 処理が一定時間以上かかった場合に時間を表示する
REPORTTIME=1

# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

########################################
# 補完
# 補完機能を有効にする
autoload -Uz compinit
compinit

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                     /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin


########################################
# vcs_info
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b] %c%u%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a] %c%u%f'

function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
    RPROMPT="${vcs_info_msg_0_}"
}
add-zsh-hook precmd _update_vcs_info_msg


########################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# フローコントロールを無効にする
setopt no_flow_control

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 戻り値が 0 以外の場合終了コードを表示
setopt print_exit_value

# zsh には グロッビングという機能があり特殊な文字をグロブ展開する
# * ? [ ] は、グロブ展開の文字列で、
# コマンドに含まれているとファイル検索処理が走ってコマンドを正しく認識しない
# 基本的にグロッビング機能を使っていないので無効化する
setopt nonomatch

########################################
# キーバインド

# 起動時に、anyenvのコマンドがある場合初期化処理を行う
if builtin command -v anyenv > /dev/null; then
  export PYENV_ROOT="$HOME/.anyenv/envs/pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"

  eval "$(anyenv init -)"

  eval "$(pyenv init -)"
fi

# Androidのsdkがある場合PATHを追加する
path=(
  ~/Library/Android/sdk/platform-tools(N-/)
  $path
)
