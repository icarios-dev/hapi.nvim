# Hapi.nvim

Hapi.nvim is a Neovim plugin designed to make API development and
testing more seamless, interactive, and integrated directly within your
editor.

## Overview

The goal of Hapi.nvim is to allow developers to define, parse, and
execute HTTP requests directly from Markdown-like blocks in a Neovim
buffer. The plugin provides live streaming of API responses, isolated
output windows, and a clean separation between internal plugin messages
and API output.

## Vision

Hapi.nvim aims to be more than just a simple HTTP client:

- **Seamless integration**: Work with your existing Neovim workflow
  without leaving your editor.
- **Live streaming**: See API responses in real-time as they arrive.
- **Clean design**: Keep plugin internals separate from actual API
  responses for clarity and focus.
- **Extensible and open**: Designed to be easily extended with new
  features, while maintaining a philosophy of open development and user
  empowerment.

This project is in its early stages. The current version focuses on
creating a solid foundation for parsing requests, executing them
asynchronously, and displaying responses efficiently.

## Genesis

The idea for Hapi.nvim was inspired by the concept of Voiden. While the
original idea intrigued me, I wanted to experiment without leaving my
Neovim environment. Hapi.nvim implements what I understood from the
concept, entirely independently.

This project also marks two personal firsts: it is my first Neovim
plugin and my first experience developing in Lua.

## Getting Started

### Prerequisites

- Neovim 0.8+
- `curl` installed on your system
- [Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) installed

### Installation

Using [lazy.nvim]:

```lua
require("lazy").setup({
  {
    "your-username/Hapi.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("hapi.commands").register()
    end
  }
})
```
