local textchatservice = game:GetService("TextChatService")
local uis = cloneref(game:GetService("UserInputService"))
local coregui = cloneref(game.CoreGui)
local tweenservice = cloneref(game:GetService("TweenService"))

if textchatservice.ChatVersion == Enum.ChatVersion.LegacyChatService then
    setreadonly(task,false)
    local oldwait = task.wait
    task.wait = function() end
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AnthonyIsntHere/anthonysrepository/refs/heads/main/scripts/AntiChatLogger.lua"))() -- credits to anthonyisnthere for anti chatlogger
    task.wait = oldwait
    wait()
    setreadonly(task,true)
end

local filter = loadstring(game:HttpGet("https://raw.githubusercontent.com/lordofmountain-gh/AES-Bypasser/refs/heads/main/chatfilters/mainfilter"))()

local settings = {
    bypasserturnedon = true,
    key = Enum.KeyCode.F2,
    isselectingkey=false,
}

local function mk(i)
    local gui = i

    local dragging
    local dragInput
    local dragStart
    local startPos
    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    uis.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end


local screengui = Instance.new("ScreenGui",coregui)
screengui.ResetOnSpawn = false

local scrollingframe = Instance.new("ScrollingFrame",screengui)
scrollingframe.Size= UDim2.new(0, 235,0, 550)
scrollingframe.BackgroundTransparency = 1
scrollingframe.ScrollBarThickness = 0
Instance.new("UIListLayout",scrollingframe)

local function notify(str:string,time:number)
    local frame = Instance.new("Frame",scrollingframe)
    frame.Size = UDim2.new(0, 240,0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(45,45,45)
    frame.BorderSizePixel = 0
    
    local text = Instance.new("TextLabel",frame)
    text.BackgroundTransparency = 1
    text.Size = UDim2.new(0, 235,0, 55)
    text.Text = "AES BYPASSER".."\n"..str
    text.TextColor3 = Color3.fromRGB(255,255,255)
    text.TextXAlignment = Enum.TextXAlignment.Center
    text.TextYAlignment = Enum.TextYAlignment.Center

    local timebar = Instance.new("Frame",frame)
    timebar.BorderSizePixel = 0
    timebar.Size = UDim2.new(0, 0,0, 5)
    timebar.Position = UDim2.new(0, 0,0.917, 0)
    timebar.BackgroundColor3 = Color3.fromRGB(31, 121, 255)
    local tween = tweenservice:Create(timebar,TweenInfo.new(time,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Size = UDim2.new(0, 240,0, 5)})
    tween:Play()
    tween.Completed:Connect(function()
    frame:Destroy()
    end)
end

function replaceletters(str:string)
local word = str
local finalword =""
local split = string.split(word," ")

for _,words in split do
local firstalphabet = string.lower(words:sub(1,1))

for normal,replaced in filter do
if firstalphabet == normal then
firstalphabet = string.gsub(firstalphabet,normal,replaced)
end

if replaced == firstalphabet then
words = string.gsub(string.lower(words),normal,replaced)
end
end
finalword = finalword.." "..words
end
str = finalword
    return str
end


if textchatservice.ChatVersion == Enum.ChatVersion.TextChatService then
   local textbox = game:GetService("CoreGui").ExperienceChat.appLayout.chatInputBar.Background.Container.TextContainer.TextBoxContainer.TextBox
   
   getconnections(textbox.FocusLost)[1]:Disable()

    textbox.FocusLost:Connect(function()
        if settings.bypasserturnedon == true then

        textchatservice.TextChannels[tostring(textchatservice:FindFirstChildOfClass("ChatInputBarConfiguration").TargetTextChannel)]:SendAsync(replaceletters(textbox.Text))
        task.wait() 
        textbox.Text = ""
        else
            textchatservice.TextChannels[tostring(textchatservice:FindFirstChildOfClass("ChatInputBarConfiguration").TargetTextChannel)]:SendAsync(textbox.Text)
            task.wait() 
            textbox.Text = ""
        end
    end)

    scrollingframe.Position = game:GetService("CoreGui").ExperienceChat.appLayout.Position + UDim2.new(0,0,0,150)

elseif textchatservice.ChatVersion == Enum.ChatVersion.LegacyChatService then
    
    scrollingframe.Position = game:GetService("Players").LocalPlayer.PlayerGui.Chat.Frame.Position + UDim2.new(0,0,0,150)
    
    local old
    old = hookmetamethod(game,"__namecall",function(...)
    local args = {...}
    if tostring(args[1]) == "SayMessageRequest" then
        if settings.bypasserturnedon == true then
        return old(args[1],replaceletters(args[2]),args[3])
        end
    end
    return old(...)
    end)

end


notify(`To toggle the bypasser press {settings.key.Name}`,5)
notify("press f3 to toggle the key and the toggling",5)

if uis:GetPlatform() == Enum.Platform.Windows then 

    uis.InputBegan:Connect(function(key)

        if key.KeyCode == settings.key then
            
            if uis:GetFocusedTextBox() == nil then
            if settings.bypasserturnedon == true then
                settings.bypasserturnedon =false
                notify('bypasser turned off',2)
                elseif settings.bypasserturnedon == false then
                    settings.bypasserturnedon = true
                    notify('bypassed turned on',2)
                end
            end
            
            elseif settings.isselectingkey == true then
                if key.KeyCode ~= Enum.KeyCode.F3 then
                settings.isselectingkey = false
                settings.key = key.KeyCode
                notify("selected key "..settings.key.Name,3)
                end
        
            elseif key.KeyCode == Enum.KeyCode.F3 then
                if settings.isselectingkey == false then
                    settings.isselectingkey = true
                    notify("now selecting key",2)
                elseif settings.isselectingkey == true then
                    settings.isselectingkey = false
                    notify('turned off selecting key',2)
                end
            
        end
        
        end)

    else

    local textbutton = Instance.new("TextButton",screengui)
    textbutton.Size = UDim2.new(0, 50,0, 50)
    textbutton.BorderSizePixel = 0
    textbutton.Text = "Toggle"
    textbutton.BackgroundColor3 = Color3.fromRGB(45,45,45)
    textbutton.TextColor3 = Color3.fromRGB(255,255,255)
    textbutton.Position = UDim2.new(0.34, 0,0.376, 0)
    mk(textbutton)
    Instance.new("UICorner",textbutton)

    textbutton.MouseButton1Down:Connect(function()
        if settings.bypasserturnedon == true then
            settings.bypasserturnedon =false
            notify('bypasser turned off',2)
        elseif settings.bypasserturnedon == false then
            settings.bypasserturnedon = true
            notify('bypassed turned on',2)
        end
    end)

end




task.spawn(function()
while task.wait(150) do
    notify("Join our community! \n discord.gg/XDSYdXkx",12)
end
end)
