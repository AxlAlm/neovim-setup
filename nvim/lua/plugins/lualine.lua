return {
		'nvim-lualine/lualine.nvim',
		depdendecies = { 'nvim-tree/nvim-web-devicons', opt = true },
        config = function() 
            require('lualine').setup {
                options = { theme = "gruvbox" },
                sections = {
                    lualine_a = {
                        {
                            'filename',
                            file_status = true, -- displays file status (readonly status, modified status)
                            path = 1            -- 0 = just filename, 1 = relative path, 2 = absolute path
                        }
                    }
                }
            }
        end
}
