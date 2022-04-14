local Args = {...}
local BaseUrl = Args[1]
local Safe = Args[2]
local Token = Args[3]
local Name = Args[4]

local SocketUrl
local HttpUrl

if Safe == "true" then
    SocketUrl = "wss" .. BaseUrl
    HttpUrl = "https" .. BaseUrl
else
    SocketUrl = "ws" .. BaseUrl
    HttpUrl = "http" .. BaseUrl
end

term.clear()

local function CanConnect()
    return ({http.get(HttpUrl .. "/ping/")})[1] ~= nil
end

local function SetOutput(Bool)
    for Index, Side in pairs(redstone.getSides()) do
        redstone.setOutput(Side, Bool)
    end
end

local function Connect()
    print("Connecting")
    local Socket = http.websocket(SocketUrl .. "/socket/?token=" .. Token .. "&name=" .. Name)
    print("Connected! as " .. Name)

    while true do
        local Message = Socket.receive()

        if Message == nil then
            break
        end
        print(Message)

        if Message == Name then
            SetOutput(true)
            sleep(1)
            SetOutput(false)
        end
    end
    
end

local function WriteFile(File, Data)
    local File = fs.open(File, "w")
    File.write(Data)
    File.close()
end

print("Checking for updates")
local Response = http.get("https://raw.githubusercontent.com/CoreBytee/RemoteMacro/main/Receiver/Version.lua")
if load(Response.readAll())() ~= require("Version") then
    print("Updating")
    local UpdateResponse = http.get("https://raw.githubusercontent.com/CoreBytee/RemoteMacro/main/Receiver/HubConnector.lua")
    local UpdatedVersion = http.get("https://raw.githubusercontent.com/CoreBytee/RemoteMacro/main/Receiver/Version.lua")
    
    WriteFile("HubConnector.lua", UpdateResponse.readAll())
    WriteFile("Version.lua", UpdatedVersion.readAll())

    os.reboot()
else
    print("No updates found")
end

while true do
    print("Trying to connect!")
    if CanConnect() then
        Connect()
    else
        print("Can't connect to hub")
        sleep(1)
    end
end