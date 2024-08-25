# github-link.nvim


## Install
```lua
  {
    dir = '~/dev/github-link.nvim',
    config = function()
      vim.keymap.set('n', '<leader>gc', require('github-link').copy_link, { desc = 'Copy github url' })
      vim.keymap.set('n', '<leader>go', require('github-link').open_link, { desc = 'Open github url' })
    end,
  }
```
