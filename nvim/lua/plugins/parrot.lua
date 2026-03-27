return {
  "frankroeder/parrot.nvim",
  dependencies = { 'ibhagwan/fzf-lua', 'nvim-lua/plenary.nvim' },
  config = function()
    -- Helper function to get API key from macOS Keychain
    local function get_keychain_api_key(service_name)
      local user = os.getenv("USER") or ""
      local handle = io.popen(
        "security find-generic-password -a '" .. user .. "' -s '" .. service_name .. "' -w 2>/dev/null"
      )
      if handle then
        local result = handle:read("*a")
        handle:close()
        local key = result:gsub("%s+$", "") -- trim trailing whitespace
        if key ~= "" then
          return key
        end
      end
      return os.getenv("ANTHROPIC_API_KEY") or ""
    end
    require("parrot").setup {
      providers = {
        anthropic = {
          name = "anthropic",
          endpoint = "https://api.anthropic.com/v1/messages",
          model_endpoint = "https://api.anthropic.com/v1/models",
          api_key = get_keychain_api_key("anthropic-api-key"),
          params = {
            chat = { max_tokens = 4096 },
            command = { max_tokens = 4096 },
          },
          topic = {
            model = "claude-haiku-4-5",  -- Updated from claude-3-5-haiku-latest
            params = { max_tokens = 32 },
          },
          headers = function(self)
            return {
              ["Content-Type"] = "application/json",
              ["x-api-key"] = self.api_key,
              ["anthropic-version"] = "2023-06-01",  -- Still current
            }
          end,
          models = {
            -- "claude-opus-4-5",    -- Latest (recommended)
            "claude-sonnet-4-6",  -- Fast + intelligent
            "claude-haiku-4-5",   -- Fastest
            -- Legacy options if needed:
            -- "claude-opus-4-5",
            -- "claude-sonnet-4",
          },
          preprocess_payload = function(payload)
            -- (unchanged - still needed for Anthropic API)
            for _, message in ipairs(payload.messages) do
              message.content = message.content:gsub("^%s*(.-)%s*$", "%1")
            end
            if payload.messages[1] and payload.messages[1].role == "system" then
              payload.system = payload.messages[1].content
              table.remove(payload.messages, 1)
            end
            return payload
          end,
        },
      },
    }
  end,
}
