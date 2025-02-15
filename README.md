# native_diag.nvim

**native_diag.nvim** is a lightweight Neovim plugin that displays diagnostic information as virtual lines on demand. When your cursor is positioned directly over a diagnostic error, pressing the configured key (default: `<S-j>`) will temporarily show the diagnostic as virtual lines. These virtual lines automatically disappear when you move the cursor or enter insert mode.

## Features

- **On-Demand Diagnostics**: Only shows virtual diagnostic lines when you explicitly trigger them with a key binding and if the cursor is on an error.
- **Automatic Hiding**: Once you move the cursor or enter insert mode, the virtual diagnostic lines are hidden automatically.
- **Customizable Key Mapping**: The default key is set to `<S-j>`, but you can easily change it during setup.

## Requirements

- **Neovim 0.8+**: Utilizes Neovim's built-in LSP and diagnostic APIs.

## Installation

### Using lazy.nvim

If you are using [lazy.nvim](https://github.com/folke/lazy.nvim) as your plugin manager, add the following to your configuration:

```lua
{
  "nikita-voronoy/native-diag.nvim",
  config = function()
    require("native-diag").setup({
      keymap = "<S-j>",  -- Customize the key binding if desired
    })
  end,
},
```

### Using packer.nvim

For those using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
  "nikita-voronoy/native-diag.nvim",
  config = function()
    require('native-diag').setup({
      keymap = '<S-j>',  -- Customize the key binding if desired
    })
  end
}
```

## Usage

1. **Setup**: In your Neovim configuration, initialize the plugin:
   ```lua
   require("native-diag").setup({
       keymap = "<S-j>",  -- Change this to your preferred key binding if needed
   })
   ```

2. **Trigger Diagnostics**: In normal mode, position your cursor on a line that contains a diagnostic error. Press `<S-j>` to display the error as virtual lines.

3. **Auto Hide**: Once you move the cursor (or enter insert mode), the virtual diagnostic lines will automatically be hidden.

## How It Works

- **Diagnostic Check**: When you press the key binding, the plugin checks if there are any diagnostics on the current line and whether your cursor is positioned within the diagnostic range.
- **Displaying Virtual Lines**: If a diagnostic is detected under the cursor, the plugin uses Neovim’s `vim.diagnostic.show` API to display virtual lines (with virtual text disabled).
- **Auto Removal**: An autocommand is registered to hide these diagnostics as soon as you move the cursor or enter insert mode, ensuring that the display is temporary.

## Contributing

Contributions, issues, and feature requests are welcome!  
Please check the [issues page](https://github.com/nikita-voronoy/native-diag.nvim/issues) for details.

## License

This plugin is distributed under the [MIT License](LICENSE).
