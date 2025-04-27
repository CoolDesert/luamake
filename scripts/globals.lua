local arguments = require "arguments"

local globals = {}

for k, v in pairs(arguments.args) do
    globals[k] = v
end

globals.mode = globals.mode or "release"

globals.hostos = globals.hostos or require "bee.platform".os
globals.hostshell = globals.hostshell or (function ()
    if globals.hostos == "windows" then
        if os.getenv "MSYSTEM" then
            return "sh"
        end
        return "cmd"
    end
    return "sh"
end)()
globals.os = globals.os or globals.hostos
globals.compiler = globals.compiler or (function ()
    if globals.os == "windows" then
        if globals.hostshell == "cmd" then
            return "msvc"
        else
            return "gcc"
        end
    end
    if globals.os == "linux" or globals.os == "netbsd" then
        return "gcc"
    end
    if globals.os == "emscripten" then
        return "emcc"
    end
    return "clang"
end)()

globals.arch = globals.arch or (function ()
    if globals.os == "windows" then
        return require "os_arch"
    end
end)()
globals.builddir = globals.builddir or "build"
globals.bindir = globals.bindir or "$builddir/bin"
globals.objdir = globals.objdir or "$builddir/obj"
globals.rootdir = "."
globals.workdir = WORKDIR

return globals
