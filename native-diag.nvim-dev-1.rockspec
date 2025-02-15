package = "native-diag.nvim"
version = "dev-1"
source = {
    url = "git+ssh://git@github.com-personal/nikita-voronoy/native-diag.nvim.git"
}
description = {
    summary = "nvim** is a lightweight Neovim plugin that displays diagnostic information as virtual lines on demand.",
    detailed =
    "**native_diag.nvim** is a lightweight Neovim plugin that displays diagnostic information as virtual lines on demand. When your cursor is positioned directly over a diagnostic error, pressing the configured key (default: `<S-j>`) will temporarily show the diagnostic as virtual lines. These virtual lines automatically disappear when you move the cursor or enter insert mode.",
    homepage = "*** please enter a project homepage ***",
    license = "*** please specify a license ***"
}
build = {
    type = "builtin",
    modules = {
        ["native-diag.init"] = "lua/native-diag/init.lua"
    },
    copy_directories = {
        "doc"
    }
}
