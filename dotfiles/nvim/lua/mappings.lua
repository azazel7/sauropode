require "nvchad.mappings"

local map = vim.keymap.set

map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })

map("n", "<F7>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<C-o>", ":e ", { desc = "Open a file" })
map("i", "<C-o>", "<ESC>:e ", { desc = "Open a file" })

map("n", "<F8>", "<cmd>w<CR>", { desc = "file save" })
map("n", "<C-a>", "<cmd>%y+<CR>", { desc = "file copy whole" })

map("n", "<F3>", "<cmd>set nu!<CR>", { desc = "toggle line number" })
--map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })
map("n", "<leader>s", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })

map("n", "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "format files" })

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "lsp diagnostic loclist" })

-- tabufline
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })

map("n", "<tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "buffer goto next" })
map("n", "<C-l>", function()
  require("nvchad.tabufline").next()
end, { desc = "buffer goto next" })

map("n", "<C-tab>", function()
  require("nvchad.tabufline").prev()
end, { desc = "buffer goto prev" })
map("n", "<C-h>", function()
  require("nvchad.tabufline").prev()
end, { desc = "buffer goto prev" })

map("n", "<leader>x", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "buffer close" })

-- Comment
map("n", "<F6>", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "comment toggle" })

map(
  "v",
  "<F6>",
  "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  { desc = "comment toggle" }
)

-- nvimtree
map("n", "<F12>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })

-- telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })
map("n", "<leader>th", "<cmd>Telescope themes<CR>", { desc = "telescope nvchad themes" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map(
  "n",
  "<leader>fa",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "telescope find all files" }
)

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- new terminals
map("n", "<leader>h", function()
  require("nvchad.term").new { pos = "sp" }
end, { desc = "terminal new horizontal term" })

map("n", "<leader>v", function()
  require("nvchad.term").new { pos = "vsp" }
end, { desc = "terminal new vertical window" })

-- toggleable
map({ "n", "t" }, "<A-v>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "terminal toggleable vertical term" })

map({ "n", "t" }, "<A-h>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal new horizontal term" })

map({ "n", "t" }, "<A-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal toggle floating term" })

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "whichkey query lookup" })

-- blankline
map("n", "<leader>cc", function()
  local config = { scope = {} }
  config.scope.exclude = { language = {}, node_type = {} }
  config.scope.include = { node_type = {} }
  local node = require("ibl.scope").get(vim.api.nvim_get_current_buf(), config)

  if node then
    local start_row, _, end_row, _ = node:range()
    if start_row ~= end_row then
      vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start_row + 1, 0 })
      vim.api.nvim_feedkeys("_", "n", true)
    end
  end
end, { desc = "blankline jump to current context" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "<leader>w", "<cmd> lua vim.lsp.buf.format()<CR><cmd>w<CR>", { desc = "Format Rust" })
map("n", "<F9>", "<cmd> set invpaste paste?<CR>", { desc = "Toggle Paste Mode" })
map("i", "<F9>", "<cmd> set invpaste paste?<CR>", { desc = "Toggle Paste Mode" })

-- Useless
map("n", "è", "`")
map("n", "é", "~")
map("n", "à", "@")

-- Disable
map("n", "Q", "")
map("n", "q:", "")

map("n", "<leader><leader>w", "<cmd> HopWordAC <CR>", { desc = "EasyMotion w"})
map("n", "<leader><leader>b", "<cmd> HopWordBC <CR>", { desc = "EasyMotion b"})
map("n", "<leader><leader>W", "<cmd> HopWORDAC <CR>", { desc = "EasyMotion W"})
map("n", "<leader><leader>B", "<cmd> HopWORDBC <CR>", { desc = "EasyMotion B"})
map("n", "<leader><leader>e", "<cmd> HopEndWordAC <CR>", { desc = "EasyMotion e"})
map("n", "<leader><leader>ge", "<cmd> HopEndWordBC <CR>", { desc = "EasyMotion ge"})
map("n", "<leader><leader>E", "<cmd> HopEndWORDAC <CR>", { desc = "EasyMotion E"})
map("n", "<leader><leader>gE", "<cmd> HopEndWORDBC <CR>", { desc = "EasyMotion gE"})

map("n", "<leader><leader>f", "<cmd> :set foldmethod=syntax <CR>", { desc = "Activate Fold Syntax"})
map("n", "<leader>fv", "<cmd>lua require(\"telescope.builtin\").find_files({cwd=\"~/.config/nvim\"})<CR>", { desc = "Telescope in Nvim config"})

