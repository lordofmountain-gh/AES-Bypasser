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

    for normal,replace in filter do
        str= string.gsub(string.lower(str),normal,replace)
    end 

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

    scrollingframe.Position = game:GetService("CoreGui").ExperienceChat.appLayout.Position + UDim2.new(0,0,0,125)

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
uis.InputBegan:Connect(function(key)

if key.KeyCode == settings.key then
    if settings.bypasserturnedon == true then
        settings.bypasserturnedon =false
        notify('bypasser turned off',2)
        elseif settings.bypasserturnedon == false then
            settings.bypasserturnedon = true
            notify('bypassed turned on',2)
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

task.spawn(function()
while task.wait(150) do
    notify("Join our community! \n discord.gg/XDSYdXkx",12)
end
end)
