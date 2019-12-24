function tf_prompt_info() {
    # dont show 'default' workspace in home dir
    [[ "$PWD" == ~ ]] && return
    # check if in terraform dir
    if [ -d .terraform ]; then
      workspace=$(terraform workspace show 2> /dev/null) || return
      echo "[${workspace}]"
    fi
}

# If you notice, aliases are bounded to each other
# Why? Gives the freedom to override the lower levels and affect all of them
# e.g.: alias tfi=terraform init -no-color -reconfigure

alias tf=terraform

alias tfi='tf init'
alias tfp='tf plan'
alias tfa='tf apply'

alias tfip='tfi && tfp'
alias tfia='tfi && tfa'
alias tfia!='tfi && tfa -auto-approve'

alias tf.12u='tf 0.12upgrade'
alias tfc='tf console'

alias tfd='tf destroy'
alias tfid='tfi && tfd'
alias tfid!='tfi && tfd -auto-approve' # DANGER!

alias tfg='tf graph'
alias tfc='tf console'
alias tfget='tf get'
alias tfimp='tf import'
alias tfo='tf output'
alias tfprov='tf providers'
alias tfpush='tf push'
alias tfr='tf refresh'
alias tfs='tf show'
alias tfstate='tf state'
alias tft='tf taint'
alias tfunt='tf untaint'
alias tfv='tf validate'
alias tfver='tf version'
alias tfw='tf workspace'

complete -o nospace -C $(which terraform) terraform
