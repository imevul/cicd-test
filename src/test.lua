-- Test Lua File
print("Hello from test addon!")

-- Initialize addon
local addonName = "TestAddon"
local addon = {}

function addon:OnLoad()
    print(addonName .. " loaded successfully!")
end

-- Run initialization
addon:OnLoad()
