repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

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

local Main = Instance.new("Frame")
Main.Parent = Gui
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Size = UDim2.new(0, 920, 0, 600)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.BackgroundColor3 = Color3.fromRGB(18,18,22)
Main.BorderSizePixel = 0
Main.Active = true
Main.ClipsDescendants = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(45,45,55)
Stroke.Thickness = 1
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local UIScale = Instance.new("UIScale", Gui)
UIScale.Scale = 1
local function updateScale()
	local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920,1080)
	local s = math.clamp(math.min(vp.X/1366, vp.Y/768), 0.6, 1)
	UIScale.Scale = s
end
updateScale()
pcall(function() workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale) end)
Gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateScale)

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

Main.ZIndex = 2
Shadow.ZIndex = 1
local function syncShadow()
	local p = Main.Position
	Shadow.Position = UDim2.new(p.X.Scale, p.X.Offset - 20, p.Y.Scale, p.Y.Offset - 20)
end
Main:GetPropertyChangedSignal("Position"):Connect(syncShadow)
syncShadow()



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

-- Dragging moved to Header to not block buttons
do
	local dragging, dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	Header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	Header.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then update(input) end
	end)
end

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
	Title.Text = "remotes.lua  |  expensiveproblems  —  Enter to toggle"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(235,235,240)
Title.TextXAlignment = Enum.TextXAlignment.Left

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
CountLabel.Position = UDim2.new(1, -120, 0, 94)
CountLabel.Size = UDim2.new(0, 110, 0, 22)
CountLabel.BackgroundTransparency = 1
CountLabel.Text = "0 remotes"
CountLabel.Font = Enum.Font.Gotham
CountLabel.TextSize = 12
CountLabel.TextColor3 = Color3.fromRGB(160,160,170)
CountLabel.TextXAlignment = Enum.TextXAlignment.Right

local RescanBtn = Instance.new("TextButton", Main)
RescanBtn.Position = UDim2.new(0, 270, 0, 94)
RescanBtn.Size = UDim2.new(0, 60, 0, 22)
RescanBtn.Text = "↻ Rescan"
RescanBtn.Font = Enum.Font.GothamBold
RescanBtn.TextSize = 11
RescanBtn.BackgroundColor3 = Color3.fromRGB(38,38,48)
RescanBtn.TextColor3 = Color3.fromRGB(200,200,210)
RescanBtn.BorderSizePixel = 0
RescanBtn.ZIndex = 5
Instance.new("UICorner", RescanBtn).CornerRadius = UDim.new(1,0)

local IntervalBox = Instance.new("TextBox", Main)
IntervalBox.Position = UDim2.new(0, 335, 0, 94)
IntervalBox.Size = UDim2.new(0, 36, 0, 22)
IntervalBox.Text = "5"
IntervalBox.PlaceholderText = "s"
IntervalBox.Font = Enum.Font.Gotham
IntervalBox.TextSize = 11
IntervalBox.BackgroundColor3 = Color3.fromRGB(33,33,40)
IntervalBox.TextColor3 = Color3.new(1,1,1)
IntervalBox.BorderSizePixel = 0
IntervalBox.ZIndex = 5
Instance.new("UICorner", IntervalBox).CornerRadius = UDim.new(0, 6)
local IntervalPad = Instance.new("UIPadding", IntervalBox)
IntervalPad.PaddingLeft = UDim.new(0, 4)

local AutoToggle = Instance.new("TextButton", Main)
AutoToggle.Position = UDim2.new(0, 376, 0, 94)
AutoToggle.Size = UDim2.new(0, 44, 0, 22)
AutoToggle.Text = "Auto: OFF"
AutoToggle.Font = Enum.Font.GothamBold
AutoToggle.TextSize = 10
AutoToggle.BackgroundColor3 = Color3.fromRGB(60,60,70)
AutoToggle.TextColor3 = Color3.new(1,1,1)
AutoToggle.BorderSizePixel = 0
AutoToggle.ZIndex = 5
Instance.new("UICorner", AutoToggle).CornerRadius = UDim.new(1,0)

local SpyBtn = Instance.new("TextButton", Main)
SpyBtn.Name = "SpyBtn"
SpyBtn.Position = UDim2.new(0, 425, 0, 94)
SpyBtn.Size = UDim2.new(0, 60, 0, 22)
SpyBtn.Text = "Spy: OFF"
SpyBtn.Font = Enum.Font.GothamBold
SpyBtn.TextSize = 10
SpyBtn.BackgroundColor3 = Color3.fromRGB(60,60,70)
SpyBtn.TextColor3 = Color3.new(1,1,1)
SpyBtn.BorderSizePixel = 0
SpyBtn.ZIndex = 5
Instance.new("UICorner", SpyBtn).CornerRadius = UDim.new(1,0)

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
Info.TextXAlignment = Enum.TextXAlignment.Left
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
HoneypotReason.TextXAlignment = Enum.TextXAlignment.Left
HoneypotReason.TextTruncate = Enum.TextTruncate.AtEnd
HoneypotReason.Visible = false

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

local ArgsLabel = Instance.new("TextLabel", InfoPanel)
ArgsLabel.Position = UDim2.new(0, 12, 0, 148)
ArgsLabel.Size = UDim2.new(1, -24, 0, 14)
ArgsLabel.BackgroundTransparency = 1
ArgsLabel.Text = "Arguments (comma separated, supports: \"hi\", 123, true, nil, {a=1})"
ArgsLabel.Font = Enum.Font.Gotham
ArgsLabel.TextSize = 10
ArgsLabel.TextColor3 = Color3.fromRGB(150,150,165)
ArgsLabel.TextXAlignment = Enum.TextXAlignment.Left

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
Args.TextXAlignment = Enum.TextXAlignment.Left
Args.TextYAlignment = Enum.TextYAlignment.Top
Args.BorderSizePixel = 0
Args.TextWrapped = true
Instance.new("UICorner", Args).CornerRadius = UDim.new(0, 6)
local ArgsPad = Instance.new("UIPadding", Args)
ArgsPad.PaddingLeft = UDim.new(0, 8)
ArgsPad.PaddingTop = UDim.new(0, 6)

local ArgHint = Instance.new("TextButton", InfoPanel)
ArgHint.Name = "ArgHint"
ArgHint.Position = UDim2.new(0, 12, 0, 202)
ArgHint.Size = UDim2.new(1, -24, 0, 28)
ArgHint.BackgroundTransparency = 1
ArgHint.Text = "Detecting expected args... (click to fill)"
ArgHint.TextWrapped = true
ArgHint.TextYAlignment = Enum.TextYAlignment.Top
ArgHint.Font = Enum.Font.Gotham
ArgHint.TextSize = 9
ArgHint.TextColor3 = Color3.fromRGB(150,150,165)
ArgHint.TextXAlignment = Enum.TextXAlignment.Left
ArgHint.AutoButtonColor = false
ArgHint.BorderSizePixel = 0
ArgHint.TextTruncate = Enum.TextTruncate.AtEnd

local TargetLabel = Instance.new("TextLabel", InfoPanel)
TargetLabel.Position = UDim2.new(0, 12, 0, 234)
TargetLabel.Size = UDim2.new(1, -24, 0, 14)
TargetLabel.BackgroundTransparency = 1
TargetLabel.Text = "Target Player (username field)"
TargetLabel.Font = Enum.Font.GothamBold
TargetLabel.TextSize = 11
TargetLabel.TextColor3 = Color3.fromRGB(180,180,195)
TargetLabel.TextXAlignment = Enum.TextXAlignment.Left

local UsernameBox = Instance.new("TextBox", InfoPanel)
UsernameBox.Name = "UsernameBox"
UsernameBox.Position = UDim2.new(0, 12, 0, 250)
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
TargetToggle.Position = UDim2.new(1, -70, 0, 250)
TargetToggle.Size = UDim2.new(0, 58, 0, 32)
TargetToggle.Text = "OFF"
TargetToggle.Font = Enum.Font.GothamBold
TargetToggle.TextSize = 11
TargetToggle.BackgroundColor3 = Color3.fromRGB(60,60,70)
TargetToggle.TextColor3 = Color3.new(1,1,1)
TargetToggle.BorderSizePixel = 0
Instance.new("UICorner", TargetToggle).CornerRadius = UDim.new(0, 6)

local TargetStatus = Instance.new("TextLabel", InfoPanel)
TargetStatus.Position = UDim2.new(0, 12, 0, 284)
TargetStatus.Size = UDim2.new(1, -24, 0, 12)
TargetStatus.BackgroundTransparency = 1
TargetStatus.Text = "Toggle ON to inject target into FireServer args"
TargetStatus.Font = Enum.Font.Gotham
TargetStatus.TextSize = 10
TargetStatus.TextColor3 = Color3.fromRGB(140,140,155)
TargetStatus.TextXAlignment = Enum.TextXAlignment.Left

local ModeLabel = Instance.new("TextLabel", InfoPanel)
ModeLabel.Position = UDim2.new(0, 12, 0, 300)
ModeLabel.Size = UDim2.new(0, 80, 0, 22)
ModeLabel.BackgroundTransparency = 1
ModeLabel.Text = "Inject mode:"
ModeLabel.Font = Enum.Font.Gotham
ModeLabel.TextSize = 11
ModeLabel.TextColor3 = Color3.fromRGB(160,160,175)
ModeLabel.TextXAlignment = Enum.TextXAlignment.Left

local ModeButton = Instance.new("TextButton", InfoPanel)
ModeButton.Position = UDim2.new(0, 92, 0, 300)
ModeButton.Size = UDim2.new(1, -104, 0, 22)
ModeButton.Text = "First Arg = Player Name (string)"
ModeButton.Font = Enum.Font.Gotham
ModeButton.TextSize = 11
ModeButton.BackgroundColor3 = Color3.fromRGB(36,36,44)
ModeButton.TextColor3 = Color3.new(1,1,1)
ModeButton.BorderSizePixel = 0
Instance.new("UICorner", ModeButton).CornerRadius = UDim.new(0, 6)

local PlayerListLabel = Instance.new("TextLabel", InfoPanel)
PlayerListLabel.Position = UDim2.new(0, 12, 0, 328)
PlayerListLabel.Size = UDim2.new(0.5, 0, 0, 16)
PlayerListLabel.BackgroundTransparency = 1
PlayerListLabel.Text = "Player List (click to select)"
PlayerListLabel.Font = Enum.Font.GothamBold
PlayerListLabel.TextSize = 11
PlayerListLabel.TextColor3 = Color3.fromRGB(180,180,195)
PlayerListLabel.TextXAlignment = Enum.TextXAlignment.Left

local RefreshPlayers = Instance.new("TextButton", InfoPanel)
RefreshPlayers.Position = UDim2.new(1, -70, 0, 326)
RefreshPlayers.Size = UDim2.new(0, 58, 0, 18)
RefreshPlayers.Text = "Refresh"
RefreshPlayers.Font = Enum.Font.GothamBold
RefreshPlayers.TextSize = 10
RefreshPlayers.BackgroundColor3 = Color3.fromRGB(42,42,52)
RefreshPlayers.TextColor3 = Color3.fromRGB(210,210,220)
RefreshPlayers.BorderSizePixel = 0
Instance.new("UICorner", RefreshPlayers).CornerRadius = UDim.new(1,0)

local PlayerSearch = Instance.new("TextBox", InfoPanel)
PlayerSearch.Position = UDim2.new(0, 12, 0, 346)
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
PlayerList.Position = UDim2.new(0, 12, 0, 376)
PlayerList.Size = UDim2.new(1, -24, 0, 80)
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

local HoneypotToggle = Instance.new("TextButton", InfoPanel)
HoneypotToggle.Name = "HoneypotToggle"
HoneypotToggle.Position = UDim2.new(0, 12, 0, 468)
HoneypotToggle.Size = UDim2.new(1, -24, 0, 20)
HoneypotToggle.Text = "🛡  Block honeypots: ON (tap to disable risky filter)"
HoneypotToggle.Font = Enum.Font.GothamBold
HoneypotToggle.TextSize = 10
HoneypotToggle.BackgroundColor3 = Color3.fromRGB(38,78,52)
HoneypotToggle.TextColor3 = Color3.fromRGB(140,255,170)
HoneypotToggle.BorderSizePixel = 0
Instance.new("UICorner", HoneypotToggle).CornerRadius = UDim.new(0, 6)

local Run = Instance.new("TextButton", InfoPanel)
Run.Position = UDim2.new(0, 12, 0, 492)
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
Log.TextXAlignment = Enum.TextXAlignment.Left
Log.TextTruncate = Enum.TextTruncate.AtEnd

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
local safeGetFullName
local BlockHoneypots = true
local PendingConfirm = nil
local RescanInterval = 5
local AutoRescanEnabled = false
local function tableCount(t) local c=0 for _ in pairs(t) do c+=1 end return c end

local HoneypotKeywords = {"ban","kick","punish","log","cheat","exploit","detect","anticheat","byfron","flag","report","moderate","crash","shutdown","honeypot","trap","warn","jail","blacklist","antiexploit","ac6"}
local HoneypotPathKeywords = {"admin","moderation","security","anticheat","audit","logs","ban"}
local UselessSubstrings = {"coregui","robloxreplicatedstorage","corepackages","analyticsservice","socialservice","chatservice","insertservice","voicechat","textchatservice","robloxcore","defaultchat"}
local function isUselessRemote(obj)
	local ok, path = pcall(function() return safeGetFullName(obj) end)
	if not ok then path = obj:GetFullName() end
	path = path:lower()
	for _,kw in ipairs(UselessSubstrings) do
		if path:find(kw,1,true) then return true end
	end
	local p = obj.Parent
	while p do
		if p == game:GetService("CoreGui") then return true end
		pcall(function()
			if p == game:GetService("RobloxReplicatedStorage") then return true end
		end)
		if p.Name == "RobloxReplicatedStorage" or p.Name == "CorePackages" or p.Name == "CoreGui" then return true end
		p = p.Parent
	end
	if obj:IsDescendantOf(game:GetService("CoreGui")) then return true end
	local ok2 = pcall(function() return obj:IsDescendantOf(game:GetService("RobloxReplicatedStorage")) end)
	if ok2 and obj:IsDescendantOf(game:GetService("RobloxReplicatedStorage")) then return true end
	return false
end
local function isKickBanRemote(obj)
	local ok, path = pcall(function() return safeGetFullName(obj) end)
	if not ok then path = obj.Name end
	local n = obj.Name:lower()
	path = path:lower()
	if n:find("kick",1,true) or n:find("ban",1,true) then return true, "name:"..(n:find("kick",1,true) and "kick" or "ban") end
	if path:find("kick",1,true) or path:find("ban",1,true) then return true, "path:"..(path:find("kick",1,true) and "kick" or "ban") end
	return false
end

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
	if path:find("workspace") or path:find("players.") then
		score += 10
		table.insert(reasons, "unusual location")
	end
	if name:match("^%w+remote$") and #name < 14 then
	else
		if name:len() <= 3 and name:match("^[a-z]+$") then
			score += 8
		end
	end
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

local ObservedArgs = {}

local function inferHintFromName(name)
	name=name:lower()
	if name:find("kick") or name:find("ban") then return "⚠ Ban remote - do not fire" end
	return nil
end
local function argToString(v)
	local t=typeof(v)
	if t=="string" then return string.format("%q", v)
	elseif t=="Vector3" then return string.format("Vector3.new(%g,%g,%g)", v.X, v.Y, v.Z)
	elseif t=="CFrame" then return "CFrame.new(...)"
	elseif t=="Instance" then return pcall(function() return v:GetFullName() end) and v:GetFullName() or tostring(v)
	else return tostring(v) end
end
local function findAliasNames(src, remoteName)
	local aliases={}
	for var in src:gmatch("local%s+([%w_]+)%s*=%s*[^\n]-WaitForChild%(%s*["']"..remoteName.."["']%s*%)") do
		table.insert(aliases, var)
	end
	for var in src:gmatch("([%w_]+)%s*=%s*[^\n]-WaitForChild%(%s*["']"..remoteName.."["']%s*%)") do
		if not table.find(aliases, var) then table.insert(aliases, var) end
	end
	-- also direct indexing: PowerRemotes.ClickPower
	table.insert(aliases, remoteName)
	return aliases
end
if not table.find then
	function table.find(t,v) for _,x in ipairs(t) do if x==v then return true end end return false end
end

local function detectExpectedArgs(remote)
	-- WAY BETTER: live spy > alias-aware decompile > getgc > heuristics, figures out without knowing
	if ObservedArgs[remote] and #ObservedArgs[remote] > 0 then
		local types, vals, preview = {}, {}, {}
		for _,v in ipairs(ObservedArgs[remote]) do
			table.insert(types, typeof(v))
			table.insert(vals, argToString(v))
			table.insert(preview, typeof(v)..":"..tostring(v):sub(1,20))
		end
		local sig = "("..table.concat(types, ", ")..")"
		local ex = "("..table.concat(vals, ", ")..")"
		local what = "CHANGE: "..table.concat(preview, " | ")
		return "↻ Live captured "..sig.." — "..what.." — vals "..ex.." — click to fill (do action again to update)"
	end
	if ObservedArgs[remote] and #ObservedArgs[remote]==0 then
		return "Expects: () no args — leave Args empty (live captured 0 args) — click to fill empty"
	end
	-- alias-aware deep decompile scan
	local searchName = remote.Name
	local examples = {}
	local tried = 0
	for _,v in ipairs(game:GetDescendants()) do
		if v:IsA("LocalScript") or v:IsA("Script") or v:IsA("ModuleScript") then
			local ok, src = pcall(function() if decompile then return decompile(v) end return nil end)
			if ok and src and type(src)=="string" and #src>30 and src:find(searchName,1,true) then
				local aliases = findAliasNames(src, searchName)
				for _,alias in ipairs(aliases) do
					for args in src:gmatch(alias.."%s*:%s*FireServer%s*%((.-)%)") do
						args=args:gsub("%s+", " "):gsub("^%s+",""):gsub("%s+$","")
						if args=="" then args="<no args>" end
						table.insert(examples, {alias=alias, args=args, script=v:GetFullName()})
						if #examples>=3 then break end
					end
					for args in src:gmatch(alias.."%s*:%s*InvokeServer%s*%((.-)%)") do
						args=args:gsub("%s+", " "):gsub("^%s+",""):gsub("%s+$","")
						if args=="" then args="<no args>" end
						table.insert(examples, {alias=alias, args=args, script=v:GetFullName()})
						if #examples>=3 then break end
					end
					if #examples>=3 then break end
				end
			end
			if #examples>=3 then break end
			tried+=1
			if tried>120 then break end
		end
	end
	if #examples>0 then
		local e = examples[1]
		if e.args=="<no args>" then return "Expects: () no args — leave Args empty (found in "..e.script:match("[^.]+$")..") — click to fill empty" end
		local typeHints={}
		for part in e.args:gmatch("[^,]+") do
			part=part:match("^%s*(.-)%s*$")
			if part:match('^["\']') then table.insert(typeHints, "string")
			elseif part:match("^Vector3") or part:match("^CFrame") then table.insert(typeHints, part:match("^%w+"))
			elseif tonumber(part) then table.insert(typeHints, "number")
			elseif part=="true" or part=="false" then table.insert(typeHints, "boolean")
			elseif part:match("^nil") then table.insert(typeHints, "nil")
			else table.insert(typeHints, "var:"..part:sub(1,12)) end
		end
		return "Found in "..e.script:match("[^.]+$").." via "..e.alias..": ("..e.args..") => ("..table.concat(typeHints, ", ")..") — CHANGE: "..e.args.." — Possible: try same types with different values — click to fill"
	end
	if getgc then
		local gcFound={}
		pcall(function()
			for _,v in ipairs(getgc(true)) do
				if type(v)=="function" then
					local ok, consts = pcall(function() if debug and debug.getconstants then return debug.getconstants(v) end end)
					if ok and consts then
						for _,c in ipairs(consts) do if c==searchName then table.insert(gcFound, "const") break end end
					end
				end
				if #gcFound>0 then break end
			end
		end)
		if #gcFound>0 then return "Referenced in GC — enable Spy ON and do action that triggers '"..searchName.."' to capture live args" end
	end
	local hint = inferHintFromName(searchName)
	if hint then return hint.." (heuristic) — click to fill, or do action to capture live" end
	return "Unknown — figuring out: enable Spy ON, do an action that triggers '"..searchName.."' in game to capture live args. Detected 0 decompile refs. Try common: 1, \"test\", true, Vector3 — will show live types when captured"
end

local function updateArgHint(remote)
	ArgHint.Text = "Figuring out args for '"..remote.Name.."'... (spy listening — do action in game)"
	ArgHint.TextColor3 = Color3.fromRGB(150,150,165)
	task.spawn(function()
		local ok, res = pcall(detectExpectedArgs, remote)
		if ok then
			ArgHint.Text = res
			if res:find("Live:") then 
				ArgHint.TextColor3 = Color3.fromRGB(110,200,160)
				-- auto-fill Args with live vals
				if ObservedArgs[remote] then
					local parts={}
					for _,v in ipairs(ObservedArgs[remote]) do table.insert(parts, argToString(v)) end
					if #parts>0 then
						Args.Text = table.concat(parts, ", ")
						Log.Text = "Auto-filled Args from live spy: "..Args.Text
					end
				end
			elseif res:find("Found") then ArgHint.TextColor3 = Color3.fromRGB(110,200,160)
			elseif res:find("Expects") or res:find("Possible") then ArgHint.TextColor3 = Color3.fromRGB(180,190,255)
			else ArgHint.TextColor3 = Color3.fromRGB(150,150,165) end
		else
			ArgHint.Text = "Unknown — spy waiting for '"..remote.Name.."' (do action in game)"
		end
	end)
end
ArgHint.MouseButton1Click:Connect(function()
	local t = ArgHint.Text
	local inside = t:match("%((.-)%)")
	if inside and inside:match("%S") and not inside:find("Live:") then
		if inside:find("vals:") then inside = t:match("vals:%s*%((.-)%)") or inside end
		Args.Text = inside
		notify("Filled args from detection: "..inside)
	end
end)

local function ParseArgs(text)
	if not text or text:match("^%s*$") then return {}, 0 end
	local args = {}
	local n = 0
	local i = 1
	local len = #text
	local function skipSpace()
		while i <= len and text:sub(i,i):match("%s") do i += 1 end
	end
	local function push(v)
		n += 1
		args[n] = v
	end
	while i <= len do
		skipSpace()
		if i > len then break end
		local c = text:sub(i,i)
		if c == '"' or c == "'" then
			local quote = c
			i += 1
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
			push(str)
		elseif c == "{" or c == "[" then
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
				if ok then push(tbl) else push(chunk) end
			else
				push(chunk)
			end
		else
			local start = i
			while i <= len and text:sub(i,i) ~= "," do i+=1 end
			local part = text:sub(start, i-1):match("^%s*(.-)%s*$")
			if part ~= "" then
				if part == "nil" then push(nil)
				elseif part == "true" then push(true)
				elseif part == "false" then push(false)
				elseif tonumber(part) then push(tonumber(part))
				elseif part == "$target" and TargetEnabled and TargetPlayer then
					push(TargetPlayer.Name)
				else
					push(part)
				end
			end
		end
		skipSpace()
		if i <= len and text:sub(i,i) == "," then i+=1 end
	end
	return args, n
end

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
			NameLbl.TextXAlignment = Enum.TextXAlignment.Left
			NameLbl.TextTruncate = Enum.TextTruncate.AtEnd

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
	local isKB, why = isKickBanRemote(obj)
	if isKB then
		Run.Text = "⛔ KICK/BAN — BLOCKED"
		Run.BackgroundColor3 = Color3.fromRGB(110,20,20)
		Run.AutoButtonColor = false
	else
		Run.Text = "Fire / Invoke  ▶"
		Run.BackgroundColor3 = Color3.fromRGB(80,130,255)
		Run.AutoButtonColor = true
	end
	local hp = getHoneypotInfo(obj)
	Info.Text = "Name: "..obj.Name.."\nType: "..obj.ClassName.."\n\nPath:\n"..safeGetFullName(obj)
	HoneypotBadge.Visible = true
	HoneypotReason.Visible = true
	if isKB then
		HoneypotBadge.BackgroundColor3 = Color3.fromRGB(90,15,15)
		HoneypotBadge.TextColor3 = Color3.fromRGB(255,90,90)
		HoneypotBadge.Text = "⛔ KICK/BAN — PERMANENTLY BLOCKED ("..why..")"
		HoneypotReason.Text = "Kick/Ban remotes are never fireable — anti-ban protection"
		HoneypotBadge.Visible = true
		HoneypotReason.Visible = true
	else
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
	end
	updateArgHint(obj)
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
	if isUselessRemote(obj) then return end
	Remotes[obj] = true
	local Button = Instance.new("TextButton", List)
	Button.Size = UDim2.new(1, -6, 0, 28)
	Button.TextXAlignment = Enum.TextXAlignment.Left
	Button.Text = "["..obj.ClassName.."] "..safeGetFullName(obj)
	local isKB = isKickBanRemote(obj)
	local hpEarly = getHoneypotInfo(obj)
	if isKB then
		Button.BackgroundColor3 = Color3.fromRGB(85,15,15)
		Button.TextColor3 = Color3.fromRGB(255,110,110)
		Button.Text = "⛔ KICK/BAN "..Button.Text
	elseif hpEarly.level == "HONEYPOT" then
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
	Button.TextTruncate = Enum.TextTruncate.AtEnd
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

local SpyEnabled = false
local SpyHookOld = nil
-- Minimal spy: only stores args, no UI work inside __namecall to avoid break
local function setSpy(enabled)
	SpyEnabled = enabled
	if enabled and not SpyHookOld and hookmetamethod and getnamecallmethod then
		pcall(function()
			local wrapper = function(self, ...)
				local m
				pcall(function() m = getnamecallmethod() end)
				-- ultra-minimal: only if SpyEnabled and valid remote, no IsA heavy checks, no UI
				if SpyEnabled and m and (m == "FireServer" or m == "InvokeServer") then
					local isRemote = false
					pcall(function() isRemote = typeof(self)=="Instance" and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) end)
					if isRemote then
						-- only capture if not from our own script
						local fromUs = false
						pcall(function() if checkcaller then fromUs = checkcaller() end end)
						if not fromUs then
							ObservedArgs[self] = {...}
							-- don't call AddRemote or UI here (breaks) — queue for main thread
							if not Remotes[self] then
								task.spawn(function() pcall(function() AddRemote(self) end) end)
							end
						end
					end
				end
				return SpyHookOld(self, ...)
			end
			if newcclosure then wrapper = newcclosure(wrapper) end
			SpyHookOld = hookmetamethod(game, "__namecall", wrapper)
		end)
		Log.Text = "Spy ON — capturing (minimal, safe)"
		ArgHint.Text = "Spy ON — do action in game to capture — select remote to see"
	else
		if not enabled then
			Log.Text = "Spy OFF — game not hooked (safe)"
			ArgHint.Text = "Spy OFF — enable Spy to figure out args"
		else
			Log.Text = SpyEnabled and "Spy ON" or "Spy OFF"
		end
	end
end
-- Poll to update UI outside __namecall (safe)
task.spawn(function()
	while true do
		task.wait(0.5)
		if SpyEnabled and Selected and ObservedArgs[Selected] then
			pcall(function()
				local types={}
				for _,v in ipairs(ObservedArgs[Selected]) do table.insert(types, typeof(v)) end
				local n=#ObservedArgs[Selected]
				if n==0 then
					ArgHint.Text = "↻ Live: () no args — leave Args empty"
				else
					ArgHint.Text = "↻ Live: ("..table.concat(types, ", ")..") - "..n.." args — click to fill"
				end
				ArgHint.TextColor3 = Color3.fromRGB(110,200,160)
			end)
		end
	end
end)
-- Spy starts OFF to not break games. Enable via Spy button.


local function Scan()
	for _,v in ipairs(game:GetDescendants()) do
		if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
			AddRemote(v)
		end
	end
	applyFilter()
end

-- Spy mode: start empty, remotes added as you play
-- Scan() -- disabled initial scan, use Rescan button for all
notify("Spy mode: list empty -- do actions in game to capture remotes + args")
Log.Text = "Spy active -- 0 spied -- Rescan for all"

local function doRescan()
	local before = tableCount(Remotes)
	Scan()
	local after = tableCount(Remotes)
	notify("Rescanned — "..after.." remotes ("..(after-before>=0 and "+"..(after-before) or tostring(after-before)).." new)")
end
RescanBtn.MouseButton1Click:Connect(doRescan)
IntervalBox.FocusLost:Connect(function(enter)
	if enter then
		local n = tonumber(IntervalBox.Text)
		if n and n >= 1 and n <= 60 then
			RescanInterval = n
			IntervalBox.BackgroundColor3 = Color3.fromRGB(33,33,40)
			notify("Rescan interval: "..n.."s")
		else
			IntervalBox.BackgroundColor3 = Color3.fromRGB(70,30,35)
			notify("Interval 1-60s only")
		end
	end
end)
AutoToggle.MouseButton1Click:Connect(function()
	AutoRescanEnabled = not AutoRescanEnabled
	if AutoRescanEnabled then
		AutoToggle.Text = "Auto: ON"
		AutoToggle.BackgroundColor3 = Color3.fromRGB(45,160,90)
		notify("Auto-rescan ON every "..RescanInterval.."s")
	else
		AutoToggle.Text = "Auto: OFF"
		AutoToggle.BackgroundColor3 = Color3.fromRGB(60,60,70)
		notify("Auto-rescan OFF")
	end
end)
SpyBtn.MouseButton1Click:Connect(function()
	setSpy(not SpyEnabled)
	if SpyEnabled then
		SpyBtn.Text = "Spy: ON"
		SpyBtn.BackgroundColor3 = Color3.fromRGB(45,160,90)
		notify("Spy ON — remotes will appear as you do actions")
	else
		SpyBtn.Text = "Spy: OFF"
		SpyBtn.BackgroundColor3 = Color3.fromRGB(60,60,70)
		notify("Spy OFF — hook disabled (safe)")
	end
end)
task.spawn(function()
	while true do
		task.wait(RescanInterval)
		if AutoRescanEnabled then
			pcall(doRescan)
		end
	end
end)

-- Spy: DescendantAdded disabled — remotes only appear when spied (hook)
-- game.DescendantAdded:Connect(function(obj)
-- 	if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then AddRemote(obj) end
-- end)

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
			Run.AutoButtonColor = true
			ArgHint.Text = "Select a remote to detect args"
		end
		applyFilter()
	end
end)

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
	local full = string.format('local remote = %s\nremote:%s(%s)', path, Selected:IsA("RemoteEvent") and "FireServer" or "InvokeServer", Args.Text)
	if setClipboard(full) then notify("Copied code") else notify("Code: "..full) end
end)

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

Run.MouseButton1Click:Connect(function()
	if not Selected then notify("Select a remote first!") return end
	local isKB, why = isKickBanRemote(Selected)
	if isKB then
		notify("⛔ BLOCKED: Kick/Ban remote ("..why..") — firing permanently disabled")
		Log.Text = "Blocked kick/ban: "..Selected.Name.." ("..why..") — protected"
		Run.Text = "⛔ KICK/BAN BLOCKED"
		return
	end
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
	local args, n = ParseArgs(Args.Text)
	if Selected.Name:lower():find("clickpower") and n == 0 then
		if TargetEnabled then
			notify("ClickPower takes 0 args — skipping target injection")
		end
	else
		if TargetEnabled then
			if not TargetPlayer then
				notify("Target toggle is ON but username invalid — firing without target")
			else
				local mode = Modes[ModeIndex]
				if mode:find("Player Object") then
					table.insert(args, 1, TargetPlayer)
					n += 1
				elseif mode:find("Replace %$target") then
					local replaced=false
					for i=1,n do
						local v=args[i]
						if type(v)=="string" and v:find("%$target") then
							args[i] = v:gsub("%$target", TargetPlayer.Name)
							replaced=true
						end
					end
					if not replaced then
						table.insert(args, 1, TargetPlayer.Name)
						n += 1
					end
				elseif mode:find("Last Arg") then
					n += 1
					args[n] = TargetPlayer.Name
				else
					table.insert(args, 1, TargetPlayer.Name)
					n += 1
				end
			end
		end
	end
	local unpackFn = table.unpack or unpack
	local ok, err = pcall(function()
		if Selected:IsA("RemoteEvent") then
			Selected:FireServer(unpackFn(args, 1, n))
		elseif Selected:IsA("RemoteFunction") then
			Selected:InvokeServer(unpackFn(args, 1, n))
		end
	end)
	if ok then
		local targetInfo = (TargetEnabled and TargetPlayer and not Selected.Name:lower():find("clickpower")) and (" → "..TargetPlayer.Name) or ""
		notify("Fired: "..Selected.Name..targetInfo.." ["..tostring(n).." args]")
		Log.Text = "Last: "..Selected.Name.." ("..Selected.ClassName..") fired at "..os.date("%X")..targetInfo
	else
		notify("Error: "..tostring(err))
		warn("[remotes.lua | expensiveproblems] Fire error: "..tostring(err))
	end
end)

CloseBtn.MouseButton1Click:Connect(function() Gui:Destroy() Shadow:Destroy() end)
MinBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.Return or i.KeyCode == Enum.KeyCode.KeypadEnter then
		Main.Visible = not Main.Visible
		Shadow.Visible = Main.Visible
	end
end)

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	List.CanvasSize = UDim2.new(0,0,0, Layout.AbsoluteContentSize.Y + 10)
end)
PLLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	PlayerList.CanvasSize = UDim2.new(0,0,0, PLLayout.AbsoluteContentSize.Y + 8)
end)

notify("Loaded — expensiveproblems • "..tostring(tableCount(Remotes)).." remotes found")
