local App = require('weblit-app')

App.bind(
    {
        host = "0.0.0.0",
        port = 8080
    }
)
require("weblit-websocket")
--App.use(require('weblit-logger'))
App.use(require('weblit-auto-headers'))

local Connections = {}

local function GenerateId()
    local Id = math.random(1000000, 9999999)
    if Connections[Id] then
        return GenerateId()
    end
    return Id
end

App.route(
    {
        method = "GET",
        path = "/ping/",
    },
    function (Request, Response)
        Response.body = "pong"
        Response.code = 200
    end
)

App.route(
    {
        method = "GET",
        path = "/installer",
    },
    function (Request, Response)
        Response.body = ({require("coro-http").request("GET", "https://raw.githubusercontent.com/CoreBytee/RemoteMacro/main/Receiver/Installer.lua")})[2]
        Response.code = 200
    end
)

App.route(
    {
        method = "GET",
        path = "/hook/",
    },
    function (Request, Response)
        Response.body = "abc"
        Response.code = 200
        
        print("Got hook request")
        print("Checking authentication")
        if Request.query.token ~= Config.Token then
            print("Authentication failed")
            Response.code = 401
            return
        end
        print("Authentication succeeded")
        print("Sending request to Clients '" .. Request.query.command .. "'")

        for Id, Connection in pairs(Connections) do
            Connection.Write(
                {
                    payload = Request.query.command
                }
            )
        end
    end
)

App.websocket(
    {
        path = "/socket/",
    },
    function (Request, Read, Write)
        if Request.query.token ~= Config.Token then
            return
        end
        local Id = GenerateId()
        Connections[Id] = {
            Read = Read,
            Write = Write,
        }
        print("New connection: " .. Id)
        while true do
            local Message = Read()

            if not Message then break end
        end
        Write()
        Connections[Id] = nil
        print("Connection closed: " .. Id)
    end
)


App.start()