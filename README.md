# Terraform ZSH Plugin

Plugin for Terraform, extending original oh-my-zsh plugin with aliases and
autocompletion.

Terraform is a tool from Hashicorp for managing infrastructure safely and
efficiently.

# Requirements

- [Terraform](https://terraform.io/)

# Installation

- [Antigen](#antigen)
- [Oh My Zsh](#oh-my-zsh)
- [Manual](#manual-git-clone)

## Antigen

1. Add the following to your `.zshrc`:

   ```sh
   antigen bundle macunha1/zsh-terraform
   ```

2. Start a new terminal session.

## Oh My Zsh

1. Clone this repository into `$ZSH_CUSTOM/plugins` (by default
   `~/.oh-my-zsh/custom/plugins`)

   ```sh
   git clone https://github.com/macunha1/zsh-terraform \
       ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/terraform
   ```

2. Add the plugin to the list of plugins for Oh My Zsh to load (inside
   `~/.zshrc`):

   ```sh
   plugins=(terraform)
   ```

3. Start a new terminal session.

## Manual (Git Clone)

1. Clone this repository somewhere on your machine. This guide will assume
   `~/.zsh/zsh-terraform`.

   ```sh
   git clone https://github.com/macunha1/zsh-terraform ~/.zsh/zsh-terraform
   ```

2. Add the following to your `.zshrc`:

   ```sh
   source ~/.zsh/zsh-terraform/terraform.zsh
   ```

3. Start a new terminal session.

### Features

- Terraform ZSH autocompletion
- Terraform completion cache under
  `${XDG_CACHE_HOME:-$HOME/.cache}/zsh/terraform_completion`
- Terraform aliases

### Completion cache

The plugin generates native ZSH completion metadata from Terraform's own help
output instead of maintaining a static command map in this repository. Completion
metadata is cached per Terraform version, executable path, and command branch:

```sh
${XDG_CACHE_HOME:-$HOME/.cache}/zsh/terraform_completion/
└── <terraform_version>/
    └── native-<terraform_binary_path>/
        ├── <subcommand-A>.zsh
        ├── <subcommand-B>.zsh
        ├── <subcommand-1>-<subcommand-N>.zsh
        └── root.zsh
```

Older generated files are kept, so switching Terraform versions creates new
cache entries without deleting completions for previous versions. Once a branch
cache file exists, later completions source it and do not rewrite it.

When the plugin loads, it preloads any existing branch cache files for the
active Terraform version and executable path into zsh memory. Missing branch
files are still generated on demand and then reused by later shells.

The checked-in [\_terraform](_terraform) file is a generator and dispatcher. It
reads command and subcommand help to cache command labels and flag labels, and
still asks Terraform for dynamic values such as state addresses and workspace
names when needed.
