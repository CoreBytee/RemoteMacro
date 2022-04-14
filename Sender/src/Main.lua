coroutine.wrap(
    function ()
        _G.process = require('process').globalProcess()
        _G.Parent = require("path").resolve(process.argv[0], "..")

        local FS = require("fs")

        local function Log(Text)
            FS.appendFileSync(Parent .. "/" .. "Log.txt", Text .. "\n")
        end

        local Config = require(Parent .. "/Config.lua")

        local Response, Body = require("coro-http").request(
            "GET",
            Config.Url .. "/hook/?command=" .. (args[1] or "unknown") .. "&token=" .. Config.Token
        )

        Log( "Received code " .. Response.code)
        Log( "Received body " .. Body .. "\n")
    end
)()



require("uv").run()