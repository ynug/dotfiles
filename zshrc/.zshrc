########################################
# Locale
# opencode で文字化けするため未設定
# export LANG=ja_JP.UTF-8

########################################
# Editor
# デフォルトエディタを Neovim にする
export EDITOR='nvim'
export VISUAL='nvim'
alias vim='nvim'

########################################
# History
HISTFILE="${HOME}/.zsh_history"
# メモリ上に保持するヒストリ件数
HISTSIZE=10000
# 履歴ファイルに保存する件数
SAVEHIST=10000

########################################
# Shell options
# 8bit 文字をそのまま扱う
setopt print_eight_bit
# Ctrl+S / Ctrl+Q のフロー制御を無効化する
setopt no_flow_control
# Ctrl+D でシェルを終了しない
setopt ignore_eof
# コマンドライン中の # 以降をコメントとして扱う
setopt interactive_comments
# ディレクトリ名だけで cd できるようにする
setopt auto_cd
# 複数シェル間でヒストリを共有する
setopt share_history
# 同じコマンドの重複履歴を減らす
setopt hist_ignore_all_dups
# 先頭がスペースのコマンドをヒストリに残さない
setopt hist_ignore_space
# ヒストリ保存時に余分な空白を詰める
setopt hist_reduce_blanks
# ヒストリファイル保存時の重複を減らす
setopt hist_save_no_dups
# コマンド実行ごとにヒストリへ追記する
setopt inc_append_history
# 非0終了時に終了コードを表示する
setopt print_exit_value
# マッチしないグロブをエラーにしない
setopt nonomatch

########################################
# 実行時間表示
# 3秒以上かかったコマンドの実行時間を表示する
REPORTTIME=3

########################################
# PATH
# path / PATH の重複を自動で除去する
typeset -U path PATH

# 存在するディレクトリだけ PATH の先頭へ追加する
path=(
  ~/Library/Android/sdk/platform-tools(N-/)
  ~/apache-maven-3.9.11/bin(N-/)
  /opt/homebrew/opt/mysql-client/bin(N-/)
  $path
)

########################################
# Completion
# 補完システムを初期化する
autoload -Uz compinit
# 補完キャッシュを使って補完初期化を行う
compinit -d "${HOME}/.zcompdump"
# 小文字入力でも大文字にマッチするようにする
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

########################################
# mise
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

########################################
# starship
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
