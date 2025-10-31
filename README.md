# Alias Maker Plugin

The Alias Maker plugin is a zsh plugin that allows you to easily create and manage custom zsh aliases from the
command line.

## Installation

1.  Clone the Alias Maker repository:
# Alias Maker Plugin

Alias Maker is a zsh plugin that lets you create and manage custom aliases from the command line.

## Installation

1. Clone the repository:

```zsh
git clone https://github.com/MefitHp/alias-maker.git ~/.oh-my-zsh/custom/plugins/alias-maker
```

2. Add `alias-maker` to your plugin list in `~/.zshrc`:

```zsh
plugins=(git other-plugin alias-maker)
```

3. Reload your shell:

```zsh
source ~/.zshrc
```

## Usage

This plugin exposes two commands: `mkalias` and `rmalias`.

```zsh
mkalias <alias_name> '<alias_command>'   # Create a new alias
mkalias -l | --list                      # List aliases defined in your ~/.zshrc
lsalias                                  # List aliases (shortcut)
mkalias -h | --help                      # Show help
rmalias <alias_name>                     # Delete an alias
```

### Create a new alias

```zsh
mkalias myalias 'ls -la'
```

This appends the alias to `~/.zshrc` and sources it immediately.

### Delete an alias

```zsh
rmalias myalias
```

### List aliases

```zsh
lsalias
```

Example output:

```
🔧 Custom aliases found in /Users/YOUR_USER/.zshrc:
    - zshconfig → mate ~/.zshrc
    - ohmyzsh  → mate ~/.oh-my-zsh
```
### Delete an existing custom zsh alias
