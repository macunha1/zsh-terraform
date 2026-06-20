# Terraform ZSH Plugin

Terraform is a tool from HashiCorp for managing infrastructure safely and
efficiently. `zsh-terraform` focuses on the part Terraform intentionally leaves
to your shell: getting to the right command quickly, with completion that
matches the Terraform executable on your machine.

Instead of shipping a static list of commands that ages every time Terraform
changes, `zsh-terraform` asks `terraform -help` for the available commands and
options, then turns that output into ZSH completion on demand. The result is a
completion layer that follows your installed Terraform version, works across
version switches, and avoids making every shell startup pay the full discovery
cost.

If you move between Terraform projects, versions, and workspaces all day, this
keeps the repetitive shell work small. Convenience aliases shorten the common
commands, generated completion keeps flags aligned with your Terraform version,
and cached command metadata makes later completions fast without overwriting
completion files that can still be reused.

# Features

- Native ZSH autocompletion generated from Terraform's own help output
- Per-command completion caching under
  `${XDG_CACHE_HOME:-$HOME/.cache}/zsh/terraform_completion`
- Version-aware cache entries, so switching Terraform versions does not
  overwrite generated completion files that can be kept and reused
- Convenience aliases for high-frequency commands such as `init`, `plan`,
  `apply`, `destroy`, `workspace`, `state`, and `validate`
- Composable alias patterns, so commands like `tfip` (`init` then `plan`) and
  `tfia` (`init` then `apply`) are easier to recall and faster to type
- Dynamic completion for values Terraform knows at runtime, including state
  addresses and workspace names

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

# Details

## Convenience aliases

The plugin adds short aliases for the Terraform commands that tend to sit in
the tightest feedback loop. `tf` maps to `terraform`, while focused aliases
cover common operations without making you retype or recall the full command
shape each time.

| Alias  |     Command    |
| ------ | -------------- |
| `tfi`  | `tf init`      |
| `tfp`  | `tf plan`      |
| `tfa`  | `tf apply`     |
| `tfd`  | `tf destroy`   |
| `tfw`  | `tf workspace` |
| `tfst` | `tf state`     |
| `tfv`  | `tf validate`  |

Some aliases are intentionally composed from lower-level aliases. For example,
`tfip` runs `tfi` followed by `tfp`, and `tfia` runs `tfi` followed by `tfa`.
That keeps repeated workflows fast and keeps customization predictable: if you
override a lower-level alias such as `tfi`, the composed aliases follow it too.

e.g.:

```sh
alias tfi='tf init -no-color -reconfigure'
```

Will also be applied to composed `tfip`, `tfia`, and `tfid`, and also their
`-auto-approve` equivalents: `tfia!` and `tfid!`

## Completion cache

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

Generated files are kept by Terraform version and executable path, so switching
Terraform versions creates or reuses the relevant cache entries instead of
overwriting completion files for other versions. Once a branch cache file
exists, later completions source it and do not rewrite it.

When the plugin loads, it preloads any existing branch cache files for the
active Terraform version and executable path into zsh memory. Missing branch
files are still generated on demand and then reused by later shells.

The checked-in [\_terraform](_terraform) file is a generator and dispatcher. It
reads command and subcommand help to cache command labels and flag labels, and
still asks Terraform for dynamic values such as state addresses and workspace
names when needed.
