local Arguments = {...}
local Host = Arguments[1]
local Safe = Arguments[2]
local Token = Arguments[3]
local Name = Arguments[4]

local VersionResponse = http.get("https://github.com/CoreBytee/RemoteMacro/raw/main/Receiver/Version.lua")
local HubConnectorResponse = http.get("https://raw.githubusercontent.com/CoreBytee/RemoteMacro/main/Receiver/HubConnector.lua")
local StartupResponse = http.get("https://github.com/CoreBytee/RemoteMacro/raw/main/Receiver/startup.lua")

local function WriteFile(File, Data)
    local File = fs.open(File, "w")
    File.write(Data)
    File.close()
end

WriteFile("Version.lua", VersionResponse.readAll())
WriteFile("HubConnector.lua", HubConnectorResponse.readAll())

WriteFile(
    "startup.lua",
    string.format(
        StartupResponse.readAll(),
        Host,
        Safe,
        Token,
        Name
    )
    
)

print("Installed!")
print("Restarting...")
sleep(2)
os.reboot()