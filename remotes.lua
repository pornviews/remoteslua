repeat task.wait() until game:IsLoaded()

-- // remotes.lua | expensiveproblems - UPGRADED //
-- Fixed loader, player targeting, full overhaul
-- Original by wheresocyz -> rebranded expensiveproblems

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- cleanup old gui (prevents duplicates on re-execute)
local gethui = gethui or (get_hidden_gui or gethiddenGui)
local hostGui = nil
pcall(function()
	if gethui then hostGui = gethui() end
end)
if not hostGui then hostGui = PlayerGui end

if hostGui:FindFirstChild("RemotesLua") then hostGui:FindFirstChild("RemotesLua"):Destroy() end
if PlayerGui:FindFirstChild("RemotesLua") then PlayerGui:FindFirstChild("RemotesLua"):Destroy() end

local Gui = Instance.new("ScreenGui")
Gui.Name = "RemotesLua"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.IgnoreGuiInset = true
Gui.Parent = hostGui
pcall(function()
	if syn and syn.protect_gui then syn.protect_gui(Gui) end
end)

-- Main frame
local Main = Instance.new("Frame")
Main.Parent = Gui
Main.Size = UDim2.new(0, 920, 0, 560)
Main.Position = UDim2.new(0.5, -460, 0.5, -280)
Main.BackgroundColor3 = Color3.fromRGB(18,18,22)
Main.BorderSizePixel = 0
Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(45,45,55)
Stroke.Thickness = 1
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- shadow
local Shadow = Instance.new("ImageLabel", Gui)
Shadow.Name = "Shadow"
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0.5, -480, 0.5, -300)
Shadow.Size = UDim2.new(0, 960, 0, 600)
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageTransparency = 0.75
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10,10,118,118)
Shadow.ZIndex = 0

-- make Main above shadow
Main.ZIndex = 2
Shadow.ZIndex = 1

-- Draggable (custom, works on all executors)
do
	local dragging, dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	Main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	Main.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then update(input) end
	end)
end

-- Header
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 44)
Header.BackgroundColor3 = Color3.fromRGB(28,28,34)
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)
local HeaderFix = Instance.new("Frame", Header)
HeaderFix.Position = UDim2.new(0,0,1,-10)
HeaderFix.Size = UDim2.new(1,0,0,10)
HeaderFix.BackgroundColor3 = Color3.fromRGB(28,28,34)
HeaderFix.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
	Title.Text = "remotes.lua  |  expensiveproblems  —  Enter to toggle"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(235,235,240)
Title.TextXAlignment = Left

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -13)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.BackgroundColor3 = Color3.fromRGB(42,42,52)
CloseBtn.TextColor3 = Color3.fromRGB(200,200,210)
CloseBtn.BorderSizePixel = 0
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1,0)

local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = UDim2.new(0, 26, 0, 26)
MinBtn.Position = UDim2.new(1, -66, 0.5, -13)
MinBtn.Text = "—"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14
MinBtn.BackgroundColor3 = Color3.fromRGB(42,42,52)
MinBtn.TextColor3 = Color3.fromRGB(200,200,210)
MinBtn.BorderSizePixel = 0
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1,0)

-- Left panel (remote list)
local Search = Instance.new("TextBox", Main)
Search.Position = UDim2.new(0, 14, 0, 56)
Search.Size = UDim2.new(0.48, -14, 0, 32)
Search.PlaceholderText = "Search remotes... (name / path)"
Search.BackgroundColor3 = Color3.fromRGB(33,33,40)
Search.TextColor3 = Color3.fromRGB(255,255,255)
Search.PlaceholderColor3 = Color3.fromRGB(140,140,150)
Search.Font = Enum.Font.Gotham
Search.TextSize = 13
Search.ClearTextOnFocus = false
Search.Text = ""
Search.BorderSizePixel = 0
Instance.new("UICorner", Search).CornerRadius = UDim.new(0, 8)
local SearchPad = Instance.new("UIPadding", Search)
SearchPad.PaddingLeft = UDim.new(0, 10)

local FilterAll = Instance.new("TextButton", Main)
FilterAll.Position = UDim2.new(0, 14, 0, 94)
FilterAll.Size = UDim2.new(0, 52, 0, 22)
FilterAll.Text = "All"
FilterAll.Font = Enum.Font.GothamBold
FilterAll.TextSize = 11
FilterAll.BackgroundColor3 = Color3.fromRGB(80,130,220)
FilterAll.TextColor3 = Color3.new(1,1,1)
FilterAll.BorderSizePixel = 0
Instance.new("UICorner", FilterAll).CornerRadius = UDim.new(1,0)

local FilterEvent = Instance.new("TextButton", Main)
FilterEvent.Position = UDim2.new(0, 70, 0, 94)
FilterEvent.Size = UDim2.new(0, 84, 0, 22)
FilterEvent.Text = "RemoteEvent"
FilterEvent.Font = Enum.Font.GothamBold
FilterEvent.TextSize = 11
FilterEvent.BackgroundColor3 = Color3.fromRGB(38,38,48)
FilterEvent.TextColor3 = Color3.fromRGB(200,200,210)
FilterEvent.BorderSizePixel = 0
Instance.new("UICorner", FilterEvent).CornerRadius = UDim.new(1,0)

local FilterFunc = Instance.new("TextButton", Main)
FilterFunc.Position = UDim2.new(0, 158, 0, 94)
FilterFunc.Size = UDim2.new(0, 104, 0, 22)
FilterFunc.Text = "RemoteFunction"
FilterFunc.Font = Enum.Font.GothamBold
FilterFunc.TextSize = 11
FilterFunc.BackgroundColor3 = Color3.fromRGB(38,38,48)
FilterFunc.TextColor3 = Color3.fromRGB(200,200,210)
FilterFunc.BorderSizePixel = 0
Instance.new("UICorner", FilterFunc).CornerRadius = UDim.new(1,0)

local CountLabel = Instance.new("TextLabel", Main)
CountLabel.Position = UDim2.new(0.48, -110, 0, 94)
CountLabel.Size = UDim2.new(0, 110, 0, 22)
CountLabel.BackgroundTransparency = 1
CountLabel.Text = "0 remotes"
CountLabel.Font = Enum.Font.Gotham
CountLabel.TextSize = 12
CountLabel.TextColor3 = Color3.fromRGB(160,160,170)
CountLabel.TextXAlignment = Right

local List = Instance.new("ScrollingFrame", Main)
List.Position = UDim2.new(0, 14, 0, 122)
List.Size = UDim2.new(0.48, -14, 1, -136)
List.CanvasSize = UDim2.new(0,0,0,0)
List.ScrollBarThickness = 4
List.ScrollBarImageColor3 = Color3.fromRGB(70,70,85)
List.BackgroundTransparency = 1
List.BorderSizePixel = 0
List.AutomaticCanvasSize = Enum.AutomaticSize.None

local Layout = Instance.new("UIListLayout", List)
Layout.Padding = UDim.new(0, 5)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Right panel
local InfoPanel = Instance.new("Frame", Main)
InfoPanel.Position = UDim2.new(0.5, 6, 0, 56)
InfoPanel.Size = UDim2.new(0.5, -20, 1, -70)
InfoPanel.BackgroundColor3 = Color3.fromRGB(24,24,30)
InfoPanel.BorderSizePixel = 0
Instance.new("UICorner", InfoPanel).CornerRadius = UDim.new(0, 10)

local Info = Instance.new("TextLabel", InfoPanel)
Info.Position = UDim2.new(0, 12, 0, 12)
Info.Size = UDim2.new(1, -24, 0, 92)
Info.BackgroundTransparency = 1
Info.TextWrapped = true
Info.TextYAlignment = Enum.TextYAlignment.Top
Info.TextXAlignment = Left
Info.Font = Enum.Font.Gotham
Info.TextSize = 12
Info.TextColor3 = Color3.fromRGB(220,220,230)
Info.Text = "Select a remote\n\nTip: Use the Player List to target someone."

local HoneypotBadge = Instance.new("TextLabel", InfoPanel)
HoneypotBadge.Name = "HoneypotBadge"
HoneypotBadge.Position = UDim2.new(0, 12, 0, 82)
HoneypotBadge.Size = UDim2.new(1, -24, 0, 18)
HoneypotBadge.BackgroundColor3 = Color3.fromRGB(38,38,48)
HoneypotBadge.Text = "● SAFE — no honeypot signs"
HoneypotBadge.Font = Enum.Font.GothamBold
HoneypotBadge.TextSize = 10
HoneypotBadge.TextColor3 = Color3.fromRGB(90,200,120)
HoneypotBadge.BorderSizePixel = 0
Instance.new("UICorner", HoneypotBadge).CornerRadius = UDim.new(0, 6)
HoneypotBadge.Visible = false
local HoneypotReason = Instance.new("TextLabel", InfoPanel)
HoneypotReason.Name = "HoneypotReason"
HoneypotReason.Position = UDim2.new(0, 12, 0, 102)
HoneypotReason.Size = UDim2.new(1, -24, 0, 12)
HoneypotReason.BackgroundTransparency = 1
HoneypotReason.Text = ""
HoneypotReason.Font = Enum.Font.Gotham
HoneypotReason.TextSize = 9
HoneypotReason.TextColor3 = Color3.fromRGB(160,160,170)
HoneypotReason.TextXAlignment = Left
HoneypotReason.TextTruncated = true
HoneypotReason.Visible = false

-- copy buttons row
local CopyPath = Instance.new("TextButton", InfoPanel)
CopyPath.Position = UDim2.new(0, 12, 0, 118)
CopyPath.Size = UDim2.new(0.5, -16, 0, 24)
CopyPath.Text = "Copy Path"
CopyPath.Font = Enum.Font.GothamBold
CopyPath.TextSize = 11
CopyPath.BackgroundColor3 = Color3.fromRGB(36,36,44)
CopyPath.TextColor3 = Color3.new(1,1,1)
CopyPath.BorderSizePixel = 0
Instance.new("UICorner", CopyPath).CornerRadius = UDim.new(0, 6)

local CopyCode = Instance.new("TextButton", InfoPanel)
CopyCode.Position = UDim2.new(0.5, 4, 0, 118)
CopyCode.Size = UDim2.new(0.5, -16, 0, 24)
CopyCode.Text = "Copy Code"
CopyCode.Font = Enum.Font.GothamBold
CopyCode.TextSize = 11
CopyCode.BackgroundColor3 = Color3.fromRGB(36,36,44)
CopyCode.TextColor3 = Color3.new(1,1,1)
CopyCode.BorderSizePixel = 0
Instance.new("UICorner", CopyCode).CornerRadius = UDim.new(0, 6)

-- Args
local ArgsLabel = Instance.new("TextLabel", InfoPanel)
ArgsLabel.Position = UDim2.new(0, 12, 0, 148)
ArgsLabel.Size = UDim2.new(1, -24, 0, 14)
ArgsLabel.BackgroundTransparency = 1
ArgsLabel.Text = "Arguments (comma separated, supports: \"hi\", 123, true, nil, {a=1})"
ArgsLabel.Font = Enum.Font.Gotham
ArgsLabel.TextSize = 10
ArgsLabel.TextColor3 = Color3.fromRGB(150,150,165)
ArgsLabel.TextXAlignment = Left

local Args = Instance.new("TextBox", InfoPanel)
Args.Position = UDim2.new(0, 12, 0, 164)
Args.Size = UDim2.new(1, -24, 0, 36)
Args.PlaceholderText = 'Example: 1, true, "hello", $target'
Args.Text = ""
Args.BackgroundColor3 = Color3.fromRGB(36,36,44)
Args.TextColor3 = Color3.new(1,1,1)
Args.PlaceholderColor3 = Color3.fromRGB(120,120,130)
Args.Font = Enum.Font.Gotham
Args.TextSize = 12
Args.ClearTextOnFocus = false
Args.TextXAlignment = Left
Args.TextYAlignment = Top
Args.BorderSizePixel = 0
Args.TextWrapped = true
Instance.new("UICorner", Args).CornerRadius = UDim.new(0, 6)
local ArgsPad = Instance.new("UIPadding", Args)
ArgsPad.PaddingLeft = UDim.new(0, 8)
ArgsPad.PaddingTop = UDim.new(0, 6)

-- === USERNAME FIELD + TOGGLE + PLAYERLIST (REQUESTED FEATURE) ===
local TargetLabel = Instance.new("TextLabel", InfoPanel)
TargetLabel.Position = UDim2.new(0, 12, 0, 208)
TargetLabel.Size = UDim2.new(1, -24, 0, 14)
TargetLabel.BackgroundTransparency = 1
TargetLabel.Text = "Target Player (username field)"
TargetLabel.Font = Enum.Font.GothamBold
TargetLabel.TextSize = 11
TargetLabel.TextColor3 = Color3.fromRGB(180,180,195)
TargetLabel.TextXAlignment = Left

local UsernameBox = Instance.new("TextBox", InfoPanel)
UsernameBox.Name = "UsernameBox"
UsernameBox.Position = UDim2.new(0, 12, 0, 224)
UsernameBox.Size = UDim2.new(1, -90, 0, 32)
UsernameBox.PlaceholderText = "Username / DisplayName..."
UsernameBox.Text = ""
UsernameBox.BackgroundColor3 = Color3.fromRGB(33,33,40)
UsernameBox.TextColor3 = Color3.new(1,1,1)
UsernameBox.PlaceholderColor3 = Color3.fromRGB(130,130,140)
UsernameBox.Font = Enum.Font.Gotham
UsernameBox.TextSize = 12
UsernameBox.BorderSizePixel = 0
UsernameBox.ClearTextOnFocus = false
Instance.new("UICorner", UsernameBox).CornerRadius = UDim.new(0, 6)
local UsernameStroke = Instance.new("UIStroke", UsernameBox)
UsernameStroke.Color = Color3.fromRGB(60,60,75)
UsernameStroke.Thickness = 1
UsernameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
local UBP = Instance.new("UIPadding", UsernameBox)
UBP.PaddingLeft = UDim.new(0, 8)

local TargetToggle = Instance.new("TextButton", InfoPanel)
TargetToggle.Name = "TargetToggle"
TargetToggle.Position = UDim2.new(1, -70, 0, 224)
TargetToggle.Size = UDim2.new(0, 58, 0, 32)
TargetToggle.Text = "OFF"
TargetToggle.Font = Enum.Font.GothamBold
TargetToggle.TextSize = 11
TargetToggle.BackgroundColor3 = Color3.fromRGB(60,60,70)
TargetToggle.TextColor3 = Color3.new(1,1,1)
TargetToggle.BorderSizePixel = 0
Instance.new("UICorner", TargetToggle).CornerRadius = UDim.new(0, 6)

local TargetStatus = Instance.new("TextLabel", InfoPanel)
TargetStatus.Position = UDim2.new(0, 12, 0, 258)
TargetStatus.Size = UDim2.new(1, -24, 0, 12)
TargetStatus.BackgroundTransparency = 1
TargetStatus.Text = "Toggle ON to inject target into FireServer args"
TargetStatus.Font = Enum.Font.Gotham
TargetStatus.TextSize = 10
TargetStatus.TextColor3 = Color3.fromRGB(140,140,155)
TargetStatus.TextXAlignment = Left

-- Injection mode
local ModeLabel = Instance.new("TextLabel", InfoPanel)
ModeLabel.Position = UDim2.new(0, 12, 0, 274)
ModeLabel.Size = UDim2.new(0, 80, 0, 22)
ModeLabel.BackgroundTransparency = 1
ModeLabel.Text = "Inject mode:"
ModeLabel.Font = Enum.Font.Gotham
ModeLabel.TextSize = 11
ModeLabel.TextColor3 = Color3.fromRGB(160,160,175)
ModeLabel.TextXAlignment = Left

local ModeButton = Instance.new("TextButton", InfoPanel)
ModeButton.Position = UDim2.new(0, 92, 0, 274)
ModeButton.Size = UDim2.new(1, -104, 0, 22)
ModeButton.Text = "First Arg = Player Name (string)"
ModeButton.Font = Enum.Font.Gotham
ModeButton.TextSize = 11
ModeButton.BackgroundColor3 = Color3.fromRGB(36,36,44)
ModeButton.TextColor3 = Color3.new(1,1,1)
ModeButton.BorderSizePixel = 0
Instance.new("UICorner", ModeButton).CornerRadius = UDim.new(0, 6)

-- PlayerList
local PlayerListLabel = Instance.new("TextLabel", InfoPanel)
PlayerListLabel.Position = UDim2.new(0, 12, 0, 302)
PlayerListLabel.Size = UDim2.new(0.5, 0, 0, 16)
PlayerListLabel.BackgroundTransparency = 1
PlayerListLabel.Text = "Player List (click to select)"
PlayerListLabel.Font = Enum.Font.GothamBold
PlayerListLabel.TextSize = 11
PlayerListLabel.TextColor3 = Color3.fromRGB(180,180,195)
PlayerListLabel.TextXAlignment = Left

local RefreshPlayers = Instance.new("TextButton", InfoPanel)
RefreshPlayers.Position = UDim2.new(1, -70, 0, 300)
RefreshPlayers.Size = UDim2.new(0, 58, 0, 18)
RefreshPlayers.Text = "Refresh"
RefreshPlayers.Font = Enum.Font.GothamBold
RefreshPlayers.TextSize = 10
RefreshPlayers.BackgroundColor3 = Color3.fromRGB(42,42,52)
RefreshPlayers.TextColor3 = Color3.fromRGB(210,210,220)
RefreshPlayers.BorderSizePixel = 0
Instance.new("UICorner", RefreshPlayers).CornerRadius = UDim.new(1,0)

local PlayerSearch = Instance.new("TextBox", InfoPanel)
PlayerSearch.Position = UDim2.new(0, 12, 0, 320)
PlayerSearch.Size = UDim2.new(1, -24, 0, 24)
PlayerSearch.PlaceholderText = "Filter players..."
PlayerSearch.Text = ""
PlayerSearch.BackgroundColor3 = Color3.fromRGB(33,33,40)
PlayerSearch.TextColor3 = Color3.new(1,1,1)
PlayerSearch.PlaceholderColor3 = Color3.fromRGB(130,130,140)
PlayerSearch.Font = Enum.Font.Gotham
PlayerSearch.TextSize = 11
PlayerSearch.BorderSizePixel = 0
Instance.new("UICorner", PlayerSearch).CornerRadius = UDim.new(0, 6)
local PSP = Instance.new("UIPadding", PlayerSearch)
PSP.PaddingLeft = UDim.new(0, 8)

local PlayerList = Instance.new("ScrollingFrame", InfoPanel)
PlayerList.Position = UDim2.new(0, 12, 0, 350)
PlayerList.Size = UDim2.new(1, -24, 0, 96)
PlayerList.CanvasSize = UDim2.new(0,0,0,0)
PlayerList.ScrollBarThickness = 3
PlayerList.BackgroundColor3 = Color3.fromRGB(30,30,38)
PlayerList.BackgroundTransparency = 0
PlayerList.BorderSizePixel = 0
Instance.new("UICorner", PlayerList).CornerRadius = UDim.new(0, 6)
local PLLayout = Instance.new("UIListLayout", PlayerList)
PLLayout.Padding = UDim.new(0, 3)
PLLayout.SortOrder = Enum.SortOrder.LayoutOrder
local PLPad = Instance.new("UIPadding", PlayerList)
PLPad.PaddingTop = UDim.new(0, 4)
PLPad.PaddingLeft = UDim.new(0, 4)
PLPad.PaddingRight = UDim.new(0, 4)
PLPad.PaddingBottom = UDim.new(0, 4)

-- Honeypot block toggle Row (above Run)
local HoneypotToggle = Instance.new("TextButton", InfoPanel)
HoneypotToggle.Name = "HoneypotToggle"
HoneypotToggle.Position = UDim2.new(0, 12, 0, 452)
HoneypotToggle.Size = UDim2.new(1, -24, 0, 20)
HoneypotToggle.Text = "🛡  Block honeypots: ON (tap to disable risky filter)"
HoneypotToggle.Font = Enum.Font.GothamBold
HoneypotToggle.TextSize = 10
HoneypotToggle.BackgroundColor3 = Color3.fromRGB(38,78,52)
HoneypotToggle.TextColor3 = Color3.fromRGB(140,255,170)
HoneypotToggle.BorderSizePixel = 0
Instance.new("UICorner", HoneypotToggle).CornerRadius = UDim.new(0, 6)

-- Fire button
local Run = Instance.new("TextButton", InfoPanel)
Run.Position = UDim2.new(0, 12, 0, 476)
Run.Size = UDim2.new(1, -24, 0, 38)
Run.Text = "Fire / Invoke  ▶"
Run.BackgroundColor3 = Color3.fromRGB(80,130,255)
Run.TextColor3 = Color3.new(1,1,1)
Run.Font = Enum.Font.GothamBold
Run.TextSize = 13
Run.BorderSizePixel = 0
Run.AutoButtonColor = true
Instance.new("UICorner", Run).CornerRadius = UDim.new(0, 8)

local Log = Instance.new("TextLabel", InfoPanel)
Log.Position = UDim2.new(0, 12, 1, -26)
Log.Size = UDim2.new(1, -24, 0, 24)
Log.BackgroundTransparency = 1
Log.Text = "Ready • expensiveproblems"
Log.Font = Enum.Font.Gotham
Log.TextSize = 10
Log.TextColor3 = Color3.fromRGB(140,140,155)
Log.TextXAlignment = Left
Log.TextTruncated = true

-- state
local Remotes = {}
local Buttons = {}
local Selected = nil
local TargetPlayer = nil
local TargetEnabled = false
local ModeIndex = 1
local Modes = {
	"First Arg = Player Name (string)",
	"First Arg = Player Object",
	"Replace $target in args",
	"Append as Last Arg (string)",
}
local CurrentFilter = "All"
local safeGetFullName -- forward declare for honeypot
local BlockHoneypots = true -- toggle honeypot protection
local PendingConfirm = nil -- {obj = ..., untilTime = ...}
local function tableCount(t) local c=0 for _ in pairs(t) do c+=1 end return c end

local HoneypotKeywords = {"ban","kick","punish","log","cheat","exploit","detect","anticheat","byfron","flag","report","moderate","crash","shutdown","honeypot","trap","warn","jail","blacklist","antiexploit","ac6"}
local HoneypotPathKeywords = {"admin","moderation","security","anticheat","audit","logs","ban"}

local function getHoneypotInfo(obj)
	local name = obj.Name:lower()
	local path = ""
	pcall(function() path = safeGetFullName(obj):lower() end)
	local score = 0
	local reasons = {}
	for _,kw in ipairs(HoneypotKeywords) do
		if name:find(kw,1,true) then
			score += 35
			table.insert(reasons, "name:"..kw)
		end
	end
	for _,kw in ipairs(HoneypotPathKeywords) do
		if path:find(kw,1,true) then
			score += 25
			table.insert(reasons, "path:"..kw)
		end
	end
	-- rarely used / suspicious parent
	if path:find("workspace") or path:find("players.") then
		score += 10
		table.insert(reasons, "unusual location")
	end
	-- generic bait names like "BanRemote" "KickEvent"
	if name:match("^%w+remote$") and #name < 14 then
		-- not suspicious
	else
		if name:len() <= 3 and name:match("^[a-z]+$") then
			score += 8
		end
	end
	-- score clamp
	if score > 100 then score = 100 end
	local level = "SAFE"
	local color = Color3.fromRGB(90,200,120)
	if score >= 60 then level = "HONEYPOT" color = Color3.fromRGB(220,60,60)
	elseif score >= 30 then level = "RISKY" color = Color3.fromRGB(220,170,40)
	elseif score >= 15 then level = "CAUTION" color = Color3.fromRGB(200,150,50)
	end
	return {score=score, level=level, color=color, reasons=reasons, path=path}
end

local function notify(txt)
	Log.Text = txt
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "remotes.lua | expensiveproblems",
			Text = txt,
			Duration = 2
		})
	end)
end

safeGetFullName = function(obj)
	local ok, res = pcall(function() return obj:GetFullName() end)
	if ok then return res end
	-- fallback
	local n = obj.Name
	local cur = obj.Parent
	while cur and cur ~= game do
		n = cur.Name .. "." .. n
		cur = cur.Parent
	end
	return n
end

local function setClipboard(s)
	local did = false
	if setclipboard then pcall(setclipboard, s) did = true end
	if not did and toclipboard then pcall(toclipboard, s) did = true end
	if not did and set_clipboard then pcall(set_clipboard, s) did = true end
	return did
end

-- improved arg parser: supports quoted strings, numbers, bool, nil, and json-like tables
local function ParseArgs(text)
	if not text or text:match("^%s*$") then return {} end
	local args = {}
	local i = 1
	local len = #text
	local function skipSpace()
		while i <= len and text:sub(i,i):match("%s") do i += 1 end
	end
	while i <= len do
		skipSpace()
		if i > len then break end
		local c = text:sub(i,i)
		if c == '"' or c == "'" then
			local quote = c
			i += 1
			local start = i
			local str = ""
			while i <= len do
				local ch = text:sub(i,i)
				if ch == "\\" and i < len then
					str ..= text:sub(i+1,i+1)
					i += 2
				elseif ch == quote then
					i += 1
					break
				else
					str ..= ch
					i += 1
				end
			end
			table.insert(args, str)
		elseif c == "{" or c == "[" then
			-- try to parse as table/array via loadstring fallback
			local brace = c
			local close = brace == "{" and "}" or "]"
			local depth = 0
			local start = i
			while i <= len do
				local ch = text:sub(i,i)
				if ch == brace then depth += 1
				elseif ch == close then depth -= 1 if depth == 0 then i+=1 break end end
				i+=1
			end
			local chunk = text:sub(start, i-1)
			local fn, err = loadstring("return "..chunk)
			if fn then
				local ok, tbl = pcall(fn)
				if ok then table.insert(args, tbl) else table.insert(args, chunk) end
			else
				table.insert(args, chunk)
			end
		else
			local start = i
			while i <= len and text:sub(i,i) ~= "," do i+=1 end
			local part = text:sub(start, i-1):match("^%s*(.-)%s*$")
			if part ~= "" then
				if part == "nil" then table.insert(args, nil) -- hole handling below
				elseif part == "true" then table.insert(args, true)
				elseif part == "false" then table.insert(args, false)
				elseif tonumber(part) then table.insert(args, tonumber(part))
				elseif part == "$target" and TargetEnabled and TargetPlayer then
					-- will be replaced via injection logic, keep placeholder for now
					table.insert(args, TargetPlayer.Name)
				else
					-- check for game.Players.<name> or plain player name that matches target
					table.insert(args, part)
				end
			end
		end
		skipSpace()
		if i <= len and text:sub(i,i) == "," then i+=1 end
	end
	-- fix nil holes: ParseArgs can't have nil holes via table.insert, need to handle explicitly
	-- if user typed "nil" we need to keep position. Use second pass for nil
	-- simple: if raw text contains "nil" separated by commas, reconstruct with nil
	if text:find("nil") then
		local rawParts = {}
		for p in string.gmatch(text, "[^,]+") do table.insert(rawParts, p:match("^%s*(.-)%s*$")) end
		if #rawParts == #args + select(2, text:gsub("nil","")) - select(2, text:gsub("nil","")) then
		end
	end
	return args
end

-- player resolution
local function resolvePlayer(query)
	if not query or query:match("^%s*$") then return nil end
	query = query:lower():gsub("^%s+",""):gsub("%s+$","")
	for _,p in ipairs(Players:GetPlayers()) do
		if p.Name:lower() == query or p.DisplayName:lower() == query then
			return p
		end
	end
	for _,p in ipairs(Players:GetPlayers()) do
		if p.Name:lower():find(query, 1, true) or p.DisplayName:lower():find(query, 1, true) then
			return p
		end
	end
	return nil
end

local function updateTargetVisual()
	if TargetEnabled and TargetPlayer then
		TargetToggle.Text = "ON"
		TargetToggle.BackgroundColor3 = Color3.fromRGB(45, 160, 90)
		UsernameStroke.Color = Color3.fromRGB(45, 160, 90)
		TargetStatus.Text = "Targeting: "..TargetPlayer.Name.." ("..TargetPlayer.DisplayName..") • Mode: "..Modes[ModeIndex]
		TargetStatus.TextColor3 = Color3.fromRGB(120, 220, 160)
	elseif TargetEnabled and not TargetPlayer then
		TargetToggle.Text = "ON"
		TargetToggle.BackgroundColor3 = Color3.fromRGB(220, 160, 40)
		UsernameStroke.Color = Color3.fromRGB(220, 160, 40)
		TargetStatus.Text = "Toggle ON but no valid player found — check username"
		TargetStatus.TextColor3 = Color3.fromRGB(255, 200, 80)
	else
		TargetToggle.Text = "OFF"
		TargetToggle.BackgroundColor3 = Color3.fromRGB(60,60,70)
		UsernameStroke.Color = Color3.fromRGB(60,60,75)
		TargetStatus.Text = "Toggle ON to inject target into FireServer args"
		TargetStatus.TextColor3 = Color3.fromRGB(140,140,155)
	end
end

-- player list builder
local function clearPlayerList()
	for _,c in ipairs(PlayerList:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
end

local function buildPlayerList()
	clearPlayerList()
	local q = PlayerSearch.Text:lower()
	for _,p in ipairs(Players:GetPlayers()) do
		local hide = q ~= "" and not (p.Name:lower():find(q,1,true) or p.DisplayName:lower():find(q,1,true))
		if not hide then
			local Btn = Instance.new("TextButton", PlayerList)
			Btn.Size = UDim2.new(1, -4, 0, 28)
			Btn.BackgroundColor3 = (TargetPlayer == p) and Color3.fromRGB(80,130,220) or Color3.fromRGB(38,38,48)
			Btn.Text = ""
			Btn.BorderSizePixel = 0
			Btn.AutoButtonColor = false
			Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

			local Icon = Instance.new("TextLabel", Btn)
			Icon.Position = UDim2.new(0, 6, 0.5, -10)
			Icon.Size = UDim2.new(0, 20, 0, 20)
			Icon.BackgroundColor3 = Color3.fromRGB(55,55,68)
			Icon.Text = p.Name:sub(1,1):upper()
			Icon.Font = Enum.Font.GothamBold
			Icon.TextSize = 11
			Icon.TextColor3 = Color3.new(1,1,1)
			Icon.BorderSizePixel = 0
			Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)

			local NameLbl = Instance.new("TextLabel", Btn)
			NameLbl.Position = UDim2.new(0, 32, 0, 0)
			NameLbl.Size = UDim2.new(1, -70, 1, 0)
			NameLbl.BackgroundTransparency = 1
			NameLbl.Text = p.Name .. "  ·  " .. p.DisplayName
			NameLbl.Font = Enum.Font.Gotham
			NameLbl.TextSize = 11
			NameLbl.TextColor3 = Color3.new(1,1,1)
			NameLbl.TextXAlignment = Left
			NameLbl.TextTruncated = true

			local SelDot = Instance.new("Frame", Btn)
			SelDot.Position = UDim2.new(1, -16, 0.5, -4)
			SelDot.Size = UDim2.new(0, 8, 0, 8)
			SelDot.BackgroundColor3 = (TargetPlayer == p) and Color3.new(1,1,1) or Color3.fromRGB(80,80,95)
			SelDot.BorderSizePixel = 0
			Instance.new("UICorner", SelDot).CornerRadius = UDim.new(1,0)

			Btn.MouseButton1Click:Connect(function()
				TargetPlayer = p
				UsernameBox.Text = p.Name
				updateTargetVisual()
				buildPlayerList()
				notify("Selected target: "..p.Name)
			end)
		end
	end
	task.wait()
	PlayerList.CanvasSize = UDim2.new(0,0,0, PLLayout.AbsoluteContentSize.Y + 8)
end

-- remotes handling
local function applyFilter()
	local q = Search.Text:lower()
	for obj, btn in pairs(Buttons) do
		local matchesSearch = q == "" or btn.Text:lower():find(q,1,true)
		local matchesType = CurrentFilter == "All" or obj.ClassName == CurrentFilter
		btn.Visible = matchesSearch and matchesType
	end
	local visible = 0
	for _,b in pairs(Buttons) do if b.Visible then visible+=1 end end
	CountLabel.Text = tostring(visible).." shown / "..tostring(tableCount(Remotes)).." total"
end

local function selectRemote(obj)
	Selected = obj
	PendingConfirm = nil
	Run.Text = "Fire / Invoke  ▶"
	Run.BackgroundColor3 = Color3.fromRGB(80,130,255)
	local hp = getHoneypotInfo(obj)
	Info.Text = "Name: "..obj.Name.."\nType: "..obj.ClassName.."\n\nPath:\n"..safeGetFullName(obj)
	HoneypotBadge.Visible = true
	HoneypotReason.Visible = true
	HoneypotBadge.BackgroundColor3 = hp.level == "SAFE" and Color3.fromRGB(30,55,40) or (hp.level == "HONEYPOT" and Color3.fromRGB(70,30,35) or Color3.fromRGB(65,55,30))
	HoneypotBadge.TextColor3 = hp.color
	if hp.level == "SAFE" then
		HoneypotBadge.Text = "● SAFE — no ban signs"
		HoneypotReason.Text = ""
	elseif hp.level == "HONEYPOT" then
		HoneypotBadge.Text = "⛔ HONEYPOT — HIGH BAN RISK ("..hp.score..")"
		HoneypotReason.Text = "Flagged: "..table.concat(hp.reasons, ", ")
	elseif hp.level == "RISKY" then
		HoneypotBadge.Text = "⚠ RISKY — requires confirm ("..hp.score..")"
		HoneypotReason.Text = "Flagged: "..table.concat(hp.reasons, ", ")
	else
		HoneypotBadge.Text = "● CAUTION — "..hp.score.." — "..table.concat(hp.reasons, ", ")
		HoneypotReason.Text = "Low risk but check args"
	end
	-- highlight
	for o,b in pairs(Buttons) do
		if o == obj then
			b.BackgroundColor3 = Color3.fromRGB(80,130,220)
			b.TextColor3 = Color3.new(1,1,1)
		else
			b.BackgroundColor3 = Color3.fromRGB(38,38,45)
			b.TextColor3 = Color3.fromRGB(230,230,240)
		end
	end
end

local function AddRemote(obj)
	if Remotes[obj] then return end
	Remotes[obj] = true
	local Button = Instance.new("TextButton", List)
	Button.Size = UDim2.new(1, -6, 0, 28)
	Button.TextXAlignment = Left
	Button.Text = "["..obj.ClassName.."] "..safeGetFullName(obj)
	-- honeypot tint for list entry
	local hpEarly = getHoneypotInfo(obj)
	if hpEarly.level == "HONEYPOT" then
		Button.BackgroundColor3 = Color3.fromRGB(65,30,35)
		Button.TextColor3 = Color3.fromRGB(255,150,150)
		Button.Text = "⛔ "..Button.Text
	elseif hpEarly.level == "RISKY" then
		Button.BackgroundColor3 = Color3.fromRGB(65,55,25)
		Button.TextColor3 = Color3.fromRGB(255,220,140)
		Button.Text = "⚠ "..Button.Text
	else
		Button.BackgroundColor3 = Color3.fromRGB(38,38,45)
		Button.TextColor3 = Color3.fromRGB(230,230,240)
	end
	Button.Font = Enum.Font.Gotham
	Button.TextSize = 12
	Button.BorderSizePixel = 0
	Button.TextTruncated = true
	Button.LayoutOrder = 0
	Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
	local Pad = Instance.new("UIPadding", Button)
	Pad.PaddingLeft = UDim.new(0, 8)
	Buttons[obj] = Button
	Button.MouseButton1Click:Connect(function()
		selectRemote(obj)
	end)
	applyFilter()
end

local function Scan()
	for _,v in ipairs(game:GetDescendants()) do
		if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
			AddRemote(v)
		end
	end
	applyFilter()
end

Scan()

game.DescendantAdded:Connect(function(obj)
	if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
		AddRemote(obj)
	end
end)

game.DescendantRemoving:Connect(function(obj)
	if Remotes[obj] and Buttons[obj] then
		Buttons[obj]:Destroy()
		Buttons[obj] = nil
		Remotes[obj] = nil
		if Selected == obj then 
			Selected = nil
			Info.Text = "Select a remote"
			HoneypotBadge.Visible = false
			HoneypotReason.Visible = false
			PendingConfirm = nil
			Run.Text = "Fire / Invoke  ▶"
			Run.BackgroundColor3 = Color3.fromRGB(80,130,255)
		end
		applyFilter()
	end
end)

-- search
Search:GetPropertyChangedSignal("Text"):Connect(applyFilter)
PlayerSearch:GetPropertyChangedSignal("Text"):Connect(buildPlayerList)

FilterAll.MouseButton1Click:Connect(function()
	CurrentFilter = "All"
	FilterAll.BackgroundColor3 = Color3.fromRGB(80,130,220)
	FilterEvent.BackgroundColor3 = Color3.fromRGB(38,38,48)
	FilterFunc.BackgroundColor3 = Color3.fromRGB(38,38,48)
	applyFilter()
end)
FilterEvent.MouseButton1Click:Connect(function()
	CurrentFilter = "RemoteEvent"
	FilterEvent.BackgroundColor3 = Color3.fromRGB(80,130,220)
	FilterAll.BackgroundColor3 = Color3.fromRGB(38,38,48)
	FilterFunc.BackgroundColor3 = Color3.fromRGB(38,38,48)
	applyFilter()
end)
FilterFunc.MouseButton1Click:Connect(function()
	CurrentFilter = "RemoteFunction"
	FilterFunc.BackgroundColor3 = Color3.fromRGB(80,130,220)
	FilterAll.BackgroundColor3 = Color3.fromRGB(38,38,48)
	FilterEvent.BackgroundColor3 = Color3.fromRGB(38,38,48)
	applyFilter()
end)

-- username box handling
UsernameBox:GetPropertyChangedSignal("Text"):Connect(function()
	local p = resolvePlayer(UsernameBox.Text)
	TargetPlayer = p
	updateTargetVisual()
	buildPlayerList()
end)

TargetToggle.MouseButton1Click:Connect(function()
	TargetEnabled = not TargetEnabled
	if TargetEnabled and not TargetPlayer then
		local p = resolvePlayer(UsernameBox.Text)
		if p then TargetPlayer = p end
	end
	updateTargetVisual()
	buildPlayerList()
end)

ModeButton.MouseButton1Click:Connect(function()
	ModeIndex = ModeIndex % #Modes + 1
	ModeButton.Text = Modes[ModeIndex]
	updateTargetVisual()
end)

RefreshPlayers.MouseButton1Click:Connect(function()
	buildPlayerList()
	notify("Player list refreshed — "..tostring(#Players:GetPlayers()).." players")
end)

Players.PlayerAdded:Connect(function() task.wait(0.5) buildPlayerList() end)
Players.PlayerRemoving:Connect(function() task.wait(0.5) if TargetPlayer and not Players:FindFirstChild(TargetPlayer.Name) then TargetPlayer=nil updateTargetVisual() end buildPlayerList() end)

buildPlayerList()
updateTargetVisual()

-- copy buttons
CopyPath.MouseButton1Click:Connect(function()
	if not Selected then notify("No remote selected") return end
	local path = safeGetFullName(Selected)
	if setClipboard(path) then notify("Copied path") else notify(path) end
end)

CopyCode.MouseButton1Click:Connect(function()
	if not Selected then notify("No remote selected") return end
	local path = safeGetFullName(Selected)
	local code = ""
	if Selected:IsA("RemoteEvent") then
		code = 'game:GetService("ReplicatedStorage"):WaitForChild("'..Selected.Name..'"):FireServer('..Args.Text..') -- '..path
		if TargetEnabled and TargetPlayer then code ..= " -- target: "..TargetPlayer.Name end
	else
		code = 'game:GetService("ReplicatedStorage"):WaitForChild("'..Selected.Name..'"):InvokeServer('..Args.Text..') -- '..path
	end
	-- generate more accurate code using full path
	local full = string.format('local remote = %s\nremote:%s(%s)', path, Selected:IsA("RemoteEvent") and "FireServer" or "InvokeServer", Args.Text)
	if setClipboard(full) then notify("Copied code") else notify("Code: "..full) end
end)

-- Honeypot shield toggle
HoneypotToggle.MouseButton1Click:Connect(function()
	BlockHoneypots = not BlockHoneypots
	if BlockHoneypots then
		HoneypotToggle.Text = "🛡  Block honeypots: ON (tap to allow risky)"
		HoneypotToggle.BackgroundColor3 = Color3.fromRGB(38,78,52)
		HoneypotToggle.TextColor3 = Color3.fromRGB(140,255,170)
		notify("Honeypot shield ON — risky remotes blocked")
	else
		HoneypotToggle.Text = "⚠  Block honeypots: OFF (risky allowed with confirm)"
		HoneypotToggle.BackgroundColor3 = Color3.fromRGB(78,45,35)
		HoneypotToggle.TextColor3 = Color3.fromRGB(255,180,140)
		notify("Honeypot shield OFF — you must confirm risky remotes")
	end
end)

-- Fire logic with honeypot + injection
Run.MouseButton1Click:Connect(function()
	if not Selected then notify("Select a remote first!") return end
	-- honeypot check
	local hp = getHoneypotInfo(Selected)
	if hp.level == "HONEYPOT" and BlockHoneypots then
		notify("⛔ BLOCKED: "..Selected.Name.." flagged as honeypot ("..table.concat(hp.reasons, ", ")..") — disable shield to fire")
		Log.Text = "Blocked honeypot: "..Selected.Name.." — toggle shield OFF to allow"
		Run.Text = "⛔ BLOCKED — disable shield"
		Run.BackgroundColor3 = Color3.fromRGB(140,40,40)
		task.delay(2, function()
			Run.Text = "Fire / Invoke  ▶"
			Run.BackgroundColor3 = Color3.fromRGB(80,130,255)
		end)
		return
	end
	if hp.score >= 30 then
		if not PendingConfirm or PendingConfirm.obj ~= Selected or tick() > PendingConfirm.untilTime then
			PendingConfirm = {obj = Selected, untilTime = tick() + 3}
			Run.Text = "⚠ TAP AGAIN TO CONFIRM ("..hp.level..")"
			Run.BackgroundColor3 = hp.color
			notify(hp.level.." — "..table.concat(hp.reasons, ", ").." — tap Fire again in 3s to confirm")
			Log.Text = "Confirm required: "..Selected.Name.." ("..hp.level..")"
			task.delay(3, function()
				if PendingConfirm and PendingConfirm.obj == Selected and tick() > PendingConfirm.untilTime then
					PendingConfirm = nil
					Run.Text = "Fire / Invoke  ▶"
					Run.BackgroundColor3 = Color3.fromRGB(80,130,255)
				end
			end)
			return
		else
			PendingConfirm = nil
		end
	end
	local args = ParseArgs(Args.Text)

	-- injection logic for target player
	if TargetEnabled then
		if not TargetPlayer then
			notify("Target toggle is ON but username invalid — firing without target")
		else
			local mode = Modes[ModeIndex]
			if mode:find("Player Object") then
				table.insert(args, 1, TargetPlayer)
			elseif mode:find("Replace %$target") then
				for i,v in ipairs(args) do
					if type(v)=="string" and v:find("%$target") then
						args[i] = v:gsub("%$target", TargetPlayer.Name)
					end
				end
				-- if no placeholder found, insert as first arg
				local hasPlaceholder = Args.Text:find("%$target")
				if not hasPlaceholder then table.insert(args, 1, TargetPlayer.Name) end
			elseif mode:find("Last Arg") then
				table.insert(args, TargetPlayer.Name)
			else -- First Arg string
				table.insert(args, 1, TargetPlayer.Name)
			end
		end
	end

	-- execute
	local ok, err = pcall(function()
		if Selected:IsA("RemoteEvent") then
			Selected:FireServer(unpack(args))
		elseif Selected:IsA("RemoteFunction") then
			Selected:InvokeServer(unpack(args))
		end
	end)
	if ok then
		local targetInfo = (TargetEnabled and TargetPlayer) and (" → "..TargetPlayer.Name) or ""
		notify("Fired: "..Selected.Name..targetInfo.." ["..tostring(#args).." args]")
		Log.Text = "Last: "..Selected.Name.." ("..Selected.ClassName..") fired at "..os.date("%X")..targetInfo
	else
		notify("Error: "..tostring(err))
		warn("[remotes.lua | expensiveproblems] Fire error: "..tostring(err))
	end
end)

-- header buttons + hotkey
CloseBtn.MouseButton1Click:Connect(function() Gui:Destroy() Shadow:Destroy() end)
MinBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.Return or i.KeyCode == Enum.KeyCode.KeypadEnter then
		Main.Visible = not Main.Visible
		Shadow.Visible = Main.Visible
	end
end)

-- auto canvas update
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	List.CanvasSize = UDim2.new(0,0,0, Layout.AbsoluteContentSize.Y + 10)
end)
PLLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	PlayerList.CanvasSize = UDim2.new(0,0,0, PLLayout.AbsoluteContentSize.Y + 8)
end)

notify("Loaded — expensiveproblems • "..tostring(tableCount(Remotes)).." remotes found")

