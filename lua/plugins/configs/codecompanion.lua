require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "openai",
    },
    inline = {
      adapter = "openai",
    },
    agent = {
      adapter = "openai",
    },
  },
  adapters = {
    openai = function()
      return require("codecompanion.adapters").extend("openai", {
          env = {
            api_key = "cmd:echo ${OPENAI_TOKEN}"
          },
      })
    end,
    llama3 = function()
      return require("codecompanion.adapters").extend("ollama", {
        name = "llama3",
        schema = {
          model = {
            default = "llama3.1:latest",
          },
          num_ctx = {
            default = 16384,
          },
          num_predict = {
            default = -1,
          },
        },
      })
    end,
  },
})
