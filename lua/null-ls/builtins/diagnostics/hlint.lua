local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local DIAGNOSTICS = methods.internal.DIAGNOSTICS

return h.make_builtin({
    name = "hlint",
    meta = {
        url = "https://github.com/ndmitchell/hlint",
        description = "Haskell source code suggestions",
    },
    method = DIAGNOSTICS,
    filetypes = { "haskell" },
    generator_opts = {
        command = "hlint",
        args = { "-" },
        format = "line",
        to_stdin = true,
        from_stderr = false,
        on_output = h.diagnostics.from_pattern(
            [[(%d+):(%d+)-(%d+): (%w+): (.*)]],
            { "row", "col", "end_col", "severity", "message" }, {
                severities = {
                    Error = h.diagnostics.severities["error"],
                    Warning = h.diagnostics.severities["warning"],
                },
            }),
        check_exit_code = function(code)
            return code >= 0
        end,
    },
    factory = h.generator_factory,
})
