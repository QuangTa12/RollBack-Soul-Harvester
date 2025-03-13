local lookingforStyle = "Don Lorenzo"
local rollSlot = "Slot1"
local rollLuckySpin = true

repeat wait()
until game:IsLoaded() and game:FindFirstChild("CoreGui") and pcall(function() return game.CoreGui end)

local plr = game.Players.LocalPlayer

spawn(function()
    repeat wait()
    until game:FindFirstChild("CoreGui")
    and game.CoreGui:FindFirstChild("RobloxPromptGui")
    and game.CoreGui.RobloxPromptGui:FindFirstChild("promptOverlay")
    while wait(2) do
        local ErrPrompt = game.CoreGui.RobloxPromptGui.promptOverlay:FindFirstChild("ErrorPrompt")
        if ErrPrompt
        and not string.find(ErrPrompt.MessageArea.ErrorFrame.ErrorMessage.Text, "Error Code: 268") then
            if string.find(ErrPrompt.MessageArea.ErrorFrame.ErrorMessage.Text, "There has been a data issue") then
                ErrPrompt.MessageArea.ErrorFrame.ErrorMessage.Text = "Script will rejoin in 10 seconds"
                wait(10)
            end
            game:GetService("TeleportService"):Teleport(game.PlaceId, plr)
            wait(10)
        end
    end
end)

local Data
repeat wait(1)
    Data = game:GetService("ReplicatedStorage").Data:InvokeServer()
until Data and Data.Spins and Data.LuckySpins

local spinAmount = rollLuckySpin and Data.LuckySpins or Data.Spins
if spinAmount == 0 then
    print("No spins available")
    return
end

game:GetService("ReplicatedStorage").Loaded:FireServer()
wait(1)

if plr.PlayerStats.Style.Value == lookingforStyle then
    return print("Style already matched (" .. lookingforStyle .. ")")
end

game:GetService("ReplicatedStorage").Packages.Knit.Services.StyleService.RE.Slot:FireServer(rollSlot)
wait(1)

print("Freezing data")
game:GetService("ReplicatedStorage").Packages.Knit.Services.CustomizationService.RE.Customize:FireServer(unpack({
    [1] = "Emotes",
    [2] = "Default\255",
    [3] = "1"
}))

wait(2)

game:GetService("ReplicatedStorage").Packages.Knit.Services.StyleService.RF.SetTargetRollStyle:InvokeServer(lookingforStyle)

for i = 1, spinAmount do
    game:GetService("ReplicatedStorage").Packages.Knit.Services.StyleService.RE.Spin:FireServer(rollLuckySpin)
    wait(1)
    print("Rolled: " .. plr.PlayerStats.Style.Value)
    if plr.PlayerStats.Style.Value == lookingforStyle then
        break
    end
end
if plr.PlayerStats.Style.Value ~= lookingforStyle then
    print("Out of Spin, rejoining")
    game:GetService("TeleportService"):Teleport(game.PlaceId, plr)
else
    print("Style matched (" .. lookingforStyle .. "), saving data")
    game:GetService("ReplicatedStorage").Packages.Knit.Services.CustomizationService.RE.Customize:FireServer(unpack({
        [1] = "Emotes",
        [2] = "Default",
        [3] = "1"
    }))

    print("Rejoining")
    game:GetService("TeleportService"):Teleport(game.PlaceId, plr)
end
-- duoc code boi banana developer
