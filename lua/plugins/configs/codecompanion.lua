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
  prompt_library = {
      ["pytest"] = {
          strategy = "inline",
          prompts = {
              role = "system",
              content = [[
              As a Senior Python Developer, generate unit tests. Return only code without description.

              context```
              Use these rules:
              * use Python 3.11;
              * use pytest;
              * use assertpy; 
              * test function names should be written in a given-when-then convention without adding comments in the test's code like #Give
              * use @pytest.fixture whenever it is needed; 
              * tests should be written as standalone functions
              ```
              ]]
          }
      }
  }
})
