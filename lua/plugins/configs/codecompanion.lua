require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "llama3",
    },
    inline = {
      adapter = "llama3",
    },
    agent = {
      adapter = "llama3",
    },
  },
  adapters = {
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
