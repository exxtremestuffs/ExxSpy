--[[
    COMPATIBILITYLAYER - A CROSS-EXPLOIT COMPATIBILITY LAYER
]]

local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local CompatibilityLayer = {}

function CompatibilityLayer.setClipboard(ascii: string)
    assert(Package.checkTypeOf(ascii, "string"))
    if setclipboard then
        setclipboard(ascii)
    else
        StarterGui:SetCore("SendNotification", { Title = "COMPATIBILITY LAYER NOTIFICATION", Text = "Your exploit does not support copying to clipboard, a popup will be displayed instead." })

        local popupScreenGui = Instance.new("ScreenGui")
        local popupBackground = Instance.new("Frame")
        local popupInstructions = Instance.new("TextLabel")
        local popupText = Instance.new("TextBox")

        pcall(function()
            popupBackground.BorderSizePixel = 0
            popupBackground.BackgroundTransparency = 0.3
            popupBackground.BackgroundColor3 = Color3.new()
            popupBackground.Size = UDim2.fromScale(0.5, 0.5)
            popupBackground.Position = UDim2.fromScale(0.25, 0.25)
            popupBackground.Parent = popupScreenGui

            popupInstructions.Text = "Press CTRL/CMD + C to copy text"
            popupInstructions.TextScaled = true
            popupInstructions.Size = UDim2.fromScale(1, 0.25)
            popupInstructions.BackgroundTransparency = 1
            popupInstructions.Parent = popupBackground

            popupText.Text = ascii
            popupText.Position = UDim2.fromScale(0.1, 0.6)
            popupText.Size = UDim2.fromScale(0.8, 0.3)
            popupText.BackgroundColor3 = 1
            popupText.BorderColor3 = Color3.new(1, 1, 1)
            popupText.Parent = popupBackground

            popupScreenGui.DisplayOrder = 2^1024

            CompatibilityLayer.protectGui(popupScreenGui)

            local closeEvent = Instance.new("BindableEvent")

            UserInputService.InputBegan:Connect(function(input: InputObject)
                if input.KeyCode == Enum.KeyCode.C and (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftSuper) or UserInputService:IsKeyDown(Enum.KeyCode.RightSuper)) then
                    RunService.RenderStepped:Wait()
                    closeEvent:Fire()
                end
            end)

            closeEvent.Event:Wait()
        end)

        popupScreenGui:Destroy()
    end
end

function CompatibilityLayer.protectGui(gui: ScreenGui)
    if syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = CoreGui
    elseif gethui then
        gui.Parent = gethui()
    else
        StarterGui:SetCore("SendNotification", { Title = "COMPATIBILITY LAYER NOTIFICATION", Text = "Your exploit does not support gui protection, some games may detect a gui being created." })
    end
end

return Package.newClass("CompatibilityLayer", CompatibilityLayer)