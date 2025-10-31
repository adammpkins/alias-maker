# Alias Maker

A simple zsh plugin for creating and managing custom shell aliases from the command line.

## Installation

### Manual Installation

1. Clone the repository to any directory:

```zsh
git clone https://github.com/MefitHp/alias-maker.git ~/zsh-plugins/alias-maker
```

2. Source the plugin in your `~/.zshrc`:

```zsh
# Load alias-maker plugin
if [[ -f ~/zsh-plugins/alias-maker/alias-maker.plugin.zsh ]]; then
    source ~/zsh-plugins/alias-maker/alias-maker.plugin.zsh
fi
```

3. Reload your shell:

```zsh
source ~/.zshrc
```

### Oh-My-Zsh Installation (Optional)

If you use Oh-My-Zsh, you can install it as a custom plugin:

```zsh
git clone https://github.com/MefitHp/alias-maker.git ~/.oh-my-zsh/custom/plugins/alias-maker
```

Then add `alias-maker` to your plugins list in `~/.zshrc`:

```zsh
plugins=(git alias-maker)
```

## Usage

The plugin provides three commands for managing aliases:

```zsh
mkalias <alias_name> '<alias_command>'   # Create a new alias
rmalias <alias_name>                     # Delete an alias  
lsalias                                  # List all aliases
```

Additional options for `mkalias`:
```zsh
mkalias -l | --list                      # List aliases (same as lsalias)
mkalias -h | --help                      # Show help
```

### Examples

**Create aliases:**
```zsh
mkalias ll 'ls -la'
mkalias gcm 'git commit -m'
mkalias serve 'python -m http.server 8000'
```

**List your aliases:**
```zsh
lsalias
```

**Remove an alias:**
```zsh
rmalias ll
```

## Features

- **Safe quoting**: Commands are automatically escaped to prevent issues with special characters like `$`
- **Newline handling**: Ensures proper formatting when appending to your `.zshrc`
- **Immediate availability**: Aliases are sourced automatically after creation
- **Clean removal**: Deletes alias from both `.zshrc` and current shell session

## Requirements

- Zsh shell
- Write access to `~/.zshrc`

No framework dependencies required.
