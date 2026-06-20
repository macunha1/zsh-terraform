tf_prompt_info() {
	# dont show 'default' workspace in home dir
	[[ "$PWD" == ~ ]] && return
	# check if in terraform dir
	if [ -d .terraform ]; then
		workspace=$(terraform workspace show 2>/dev/null) || return
		echo "[${workspace}]"
	fi
}

# If you notice, aliases are bounded to each other
# Why? Gives the freedom to override the lower levels and to affect all of them
# e.g.: alias tfi=terraform init -no-color -reconfigure

alias tf=terraform

alias tfi='tf init'

alias tfp='tf plan'
alias tfip='tfi && tfp'

alias tfa='tf apply'
alias tfia='tfi && tfa'

alias tfd='tf destroy'
alias tfid='tfi && tfd'

# DANGER zone
alias tfa!='tfa -auto-approve'
alias tfia!='tfi && tfa!'
# DANGER++!!
alias tfd!='tfd -auto-approve'
alias tfid!='tfi && tfd!'

alias tfc='tf console'
alias tfg='tf graph'
alias tfc='tf console'
alias tfget='tf get'
alias tfimp='tf import'
alias tfo='tf output'
alias tfprov='tf providers'
alias tfpp='tf push'
alias tfr='tf refresh'
alias tfs='tf show'
alias tfst='tf state'
alias tft='tf taint'
alias tfunt='tf untaint'
alias tfv='tf validate'
alias tfver='tf version'
alias tfw='tf workspace'

__terraform_preload_completion_cache() {
	local terraform_path terraform_version terraform_path_key terraform_cache_dir terraform_cache_file

	terraform_path="${commands[terraform]:-}"
	[[ -n "$terraform_path" ]] || terraform_path="$(command -v terraform 2>/dev/null)" || return 0

	terraform_version="$("$terraform_path" version -json 2>/dev/null | sed -n 's/.*"terraform_version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1)"
	[[ -n "$terraform_version" ]] || terraform_version="$("$terraform_path" version 2>/dev/null | sed -n '1s/^Terraform v//p' | awk '{print $1}')"
	[[ -n "$terraform_version" ]] || return 0

	terraform_path_key="${terraform_path//[^A-Za-z0-9._-]/_}"
	terraform_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/terraform_completion/${terraform_version}/native-${terraform_path_key}"

	typeset -g _terraform_completion_path="$terraform_path"
	typeset -g _terraform_completion_version="$terraform_version"
	typeset -gA _terraform_generated_commands _terraform_generated_options

	for terraform_cache_file in "${terraform_cache_dir}"/*.zsh(N); do
		source "$terraform_cache_file"
	done
}

# Check if compinit/complete is loaded
command -v compinit >/dev/null || {
	autoload -Uz +X compinit && compinit -i
}

# Load generated native zsh Terraform completion.
fpath=("${${(%):-%N}:A:h}" $fpath)
autoload -Uz _terraform
compdef _terraform terraform
__terraform_preload_completion_cache
unfunction __terraform_preload_completion_cache
