return {
  {
    "yetone/avante.nvim",
    lazy = false,
    version = false,
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "zbirenbaum/copilot.lua",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
      {
        "ravitemer/mcphub.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        build = "npm install -g mcp-hub@latest",  -- Installs `mcp-hub` node binary globally
        config = function()
            require("mcphub").setup()
        end
      },
    },
    opts = {
      auto_suggestions_provider = "copilot",
      provider = "copilot",
      providers = {
        copilot = {
          model = "gpt-4o",
          extra_request_body = {
            temperature = 0,
            max_tokens = 4096,
          },
        },
      },
      behaviour = {
        auto_suggestions = false,
      },
      system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        return hub and hub:get_active_servers_prompt() or ""
      end,
      custom_tools = function()
        return {
            require("mcphub.extensions.avante").mcp_tool(),
        }
      end,
    },
    config = function(_, opts)
        require("avante").setup(opts)
    end,
  },
}
