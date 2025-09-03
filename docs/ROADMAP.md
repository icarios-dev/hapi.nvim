# Hapi.nvim Roadmap

This document outlines the planned features, improvements, and next
steps for Hapi.nvim.

## Short-term goals

- Define the request block format precisely:
  - Ensure it is easy to write, pleasant to read, and efficient to
    parse.
  - Allow for future evolution without breaking existing workflows.
- Define the expected output format and presentation:
  - Clarify how API responses should appear in the output buffer.
  - Specify streaming behavior, handling of headers/body, and separation
    of plugin messages from API results.
- Refine parsing of Markdown-like request blocks.
- Enhance multi-block selection and execution workflow.
- Add configuration options for buffer/window behavior and notifications.

## Medium-term goals

- Introduce better error handling and retry mechanisms.
- Support additional HTTP methods and authentication schemes.
- Provide optional integration with Neovim keymaps for faster workflow.
- Explore enhanced visualization of API responses (e.g., JSON formatting, tables).
- Add integrated Neovim documentation for easy access to usage
  instructions via :help.

## Long-term vision

- Extend Hapi.nvim into a comprehensive API development toolkit within Neovim.
- Keep the plugin modular and easily extensible by the community.
- Make the plugin known and develop a community of users.
- Conquer the world.
