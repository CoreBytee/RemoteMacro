coroutine.wrap(
    function ()
        _G.process = require('process').globalProcess()
        _G.Parent = require("path").resolve(process.argv[0], "..")

        _G.Config = require(Parent .. "/Config.lua")

        require("bundle:/Server.lua")
    end
)()



require("uv").run()