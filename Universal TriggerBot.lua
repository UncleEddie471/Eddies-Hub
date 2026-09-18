local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local lp = Players.LocalPlayer
local mouse = lp:GetMouse()

local shootKey = nil
local listening = false
local isSimulating = false
local alwaysOn = false
local headMult = 1
local originalHeadSizes = {}
local espEnabled = false
local highlights = {}
local npcHighlights = {}
local whitelist = {}

local gui = Instance.new("ScreenGui")
gui.Name = "ShootBind"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = gethui()

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 230, 0, 265)
main.Position = UDim2.new(0.5, -115, 0.5, -132)
main.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(45, 45, 45)
stroke.Thickness = 1

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 0, 18)
label.Position = UDim2.new(0, 0, 0, 3)
label.BackgroundTransparency = 1
label.Text = "Made by Eddie's Hub"
label.TextColor3 = Color3.fromRGB(120, 120, 120)
label.TextSize = 11
label.Font = Enum.Font.GothamMedium
label.Parent = main

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -20, 0, 22)
btn.Position = UDim2.new(0, 10, 0, 23)
btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
btn.BorderSizePixel = 0
btn.Text = "Shoot Keybind: [ none ]"
btn.TextColor3 = Color3.fromRGB(200, 200, 200)
btn.TextSize = 12
btn.Font = Enum.Font.GothamMedium
btn.Parent = main
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", btn).Color = Color3.fromRGB(50, 50, 50)

local alwaysBtn = Instance.new("TextButton")
alwaysBtn.Size = UDim2.new(1, -20, 0, 22)
alwaysBtn.Position = UDim2.new(0, 10, 0, 50)
alwaysBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
alwaysBtn.BorderSizePixel = 0
alwaysBtn.Text = "Always On: OFF"
alwaysBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
alwaysBtn.TextSize = 12
alwaysBtn.Font = Enum.Font.GothamMedium
alwaysBtn.Parent = main
Instance.new("UICorner", alwaysBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", alwaysBtn).Color = Color3.fromRGB(50, 50, 50)

local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(1, -20, 0, 22)
espBtn.Position = UDim2.new(0, 10, 0, 77)
espBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
espBtn.BorderSizePixel = 0
espBtn.Text = "ESP: OFF"
espBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
espBtn.TextSize = 12
espBtn.Font = Enum.Font.GothamMedium
espBtn.Parent = main
Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", espBtn).Color = Color3.fromRGB(50, 50, 50)

local headLabel = Instance.new("TextLabel")
headLabel.Size = UDim2.new(0, 90, 0, 22)
headLabel.Position = UDim2.new(0, 10, 0, 106)
headLabel.BackgroundTransparency = 1
headLabel.Text = "Head Scale:"
headLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
headLabel.TextSize = 12
headLabel.Font = Enum.Font.GothamMedium
headLabel.TextXAlignment = Enum.TextXAlignment.Left
headLabel.Parent = main

local headBox = Instance.new("TextBox")
headBox.Size = UDim2.new(0, 100, 0, 22)
headBox.Position = UDim2.new(0, 110, 0, 106)
headBox.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
headBox.BorderSizePixel = 0
headBox.Text = "1"
headBox.PlaceholderText = "1"
headBox.TextColor3 = Color3.fromRGB(200, 200, 200)
headBox.TextSize = 12
headBox.Font = Enum.Font.GothamMedium
headBox.ClearTextOnFocus = false
headBox.Parent = main
Instance.new("UICorner", headBox).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", headBox).Color = Color3.fromRGB(50, 50, 50)

local friendLabel = Instance.new("TextLabel")
friendLabel.Size = UDim2.new(1, -20, 0, 18)
friendLabel.Position = UDim2.new(0, 10, 0, 135)
friendLabel.BackgroundTransparency = 1
friendLabel.Text = "Friends / Whitelist"
friendLabel.TextColor3 = Color3.fromRGB(120, 180, 255)
friendLabel.TextSize = 11
friendLabel.Font = Enum.Font.GothamMedium
friendLabel.TextXAlignment = Enum.TextXAlignment.Left
friendLabel.Parent = main

local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(1, -20, 0, 22)
nameBox.Position = UDim2.new(0, 10, 0, 155)
nameBox.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
nameBox.BorderSizePixel = 0
nameBox.Text = ""
nameBox.PlaceholderText = "Username / DisplayName"
nameBox.TextColor3 = Color3.fromRGB(200, 200, 200)
nameBox.TextSize = 12
nameBox.Font = Enum.Font.GothamMedium
nameBox.ClearTextOnFocus = false
nameBox.Parent = main
Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", nameBox).Color = Color3.fromRGB(50, 50, 50)

local addBtn = Instance.new("TextButton")
addBtn.Size = UDim2.new(0.48, -5, 0, 22)
addBtn.Position = UDim2.new(0, 10, 0, 183)
addBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
addBtn.BorderSizePixel = 0
addBtn.Text = "Add"
addBtn.TextColor3 = Color3.fromRGB(100, 220, 100)
addBtn.TextSize = 12
addBtn.Font = Enum.Font.GothamMedium
addBtn.Parent = main
Instance.new("UICorner", addBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", addBtn).Color = Color3.fromRGB(50, 50, 50)

local removeBtn = Instance.new("TextButton")
removeBtn.Size = UDim2.new(0.48, -5, 0, 22)
removeBtn.Position = UDim2.new(0.52, 5, 0, 183)
removeBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
removeBtn.BorderSizePixel = 0
removeBtn.Text = "Remove"
removeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
removeBtn.TextSize = 12
removeBtn.Font = Enum.Font.GothamMedium
removeBtn.Parent = main
Instance.new("UICorner", removeBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", removeBtn).Color = Color3.fromRGB(50, 50, 50)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 18)
statusLabel.Position = UDim2.new(0, 10, 0, 210)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Whitelisted: 0"
statusLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = main

local function updateStatus()
	local count = 0
	for _ in pairs(whitelist) do count += 1 end
	statusLabel.Text = "Whitelisted: " .. count
end

local function isFriendOrWhitelisted(plr)
	if not plr or plr == lp then return false end

	local nameLower = string.lower(plr.Name)
	local displayLower = string.lower(plr.DisplayName)
	if whitelist[nameLower] or whitelist[displayLower] then
		return true
	end

	local success, isFriend = pcall(function()
		return lp:IsFriendsWith(plr.UserId)
	end)
	if success and isFriend then
		return true
	end

	return false
end

local function isLookingAtEnemy()
	local unitRay = Camera:ScreenPointToRay(mouse.X, mouse.Y)
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {lp.Character}
	params.FilterType = Enum.RaycastFilterType.Exclude

	local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, params)
	if not result then return false end

	local model = result.Instance:FindFirstAncestorOfClass("Model")
	if not model then return false end

	local humanoid = model:FindFirstChildOfClass("Humanoid")
	if not humanoid then return false end
	local targetPlayer = Players:GetPlayerFromCharacter(model)
	if targetPlayer then		if isFriendOrWhitelisted(targetPlayer) then
			return false
		end
		return true
	end

	return true
end

local function startSimulate()
	if isSimulating then return end
	isSimulating = true
	mouse1press()
end

local function stopSimulate()
	if not isSimulating then return end
	isSimulating = false
	mouse1release()
end

local function getOrStoreOriginal(head)
	if not originalHeadSizes[head] then
		originalHeadSizes[head] = head.Size
	end
	return originalHeadSizes[head]
end

local function applyHeadScale(head, plr)
	if not head or not head:IsA("BasePart") then return end
	if plr and isFriendOrWhitelisted(plr) then
		local orig = getOrStoreOriginal(head)
		head.Size = orig
		return
	end
	local orig = getOrStoreOriginal(head)
	head.Size = orig * headMult
end

local function scaleAllHeads()
	for _, plr in ipairs(Players:GetPlayers()) do
		local char = plr.Character
		if char then
			local head = char:FindFirstChild("Head")
			if head then applyHeadScale(head, plr) end
		end
	end

	for _, model in ipairs(workspace:GetDescendants()) do
		if model:IsA("Model") and model:FindFirstChildOfClass("Humanoid") then
			local isPlayerChar = false
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr.Character == model then
					isPlayerChar = true
					break
				end
			end
			if not isPlayerChar then
				local head = model:FindFirstChild("Head")
				if head then applyHeadScale(head, nil) end
			end
		end
	end
end

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		task.wait(0.3)
		local head = char:FindFirstChild("Head")
		if head then applyHeadScale(head, plr) end
	end)
end)

for _, plr in ipairs(Players:GetPlayers()) do
	plr.CharacterAdded:Connect(function(char)
		task.wait(0.3)
		local head = char:FindFirstChild("Head")
		if head then applyHeadScale(head, plr) end
	end)
end

local function createPlayerHighlight(plr)
	if highlights[plr] then
		highlights[plr]:Destroy()
		highlights[plr] = nil
	end

	local char = plr.Character
	if not char then return end

	local isFriend = isFriendOrWhitelisted(plr)

	local hl = Instance.new("Highlight")
	hl.Name = "ESP_Highlight"
	hl.Adornee = char
	hl.FillTransparency = 0.6
	hl.OutlineTransparency = 0
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

	if isFriend then
		hl.FillColor = Color3.fromRGB(80, 140, 255)
		hl.OutlineColor = Color3.fromRGB(180, 220, 255)
	else
		hl.FillColor = Color3.fromRGB(255, 80, 80)
		hl.OutlineColor = Color3.fromRGB(255, 255, 255)
	end

	hl.Parent = char
	highlights[plr] = hl
end

local function createNpcHighlight(model)
	if npcHighlights[model] then
		npcHighlights[model]:Destroy()
		npcHighlights[model] = nil
	end

	if not model or not model.Parent then return end

	local hl = Instance.new("Highlight")
	hl.Name = "ESP_NPC_Highlight"
	hl.Adornee = model
	hl.FillColor = Color3.fromRGB(255, 80, 80)
	hl.OutlineColor = Color3.fromRGB(255, 255, 255)
	hl.FillTransparency = 0.6
	hl.OutlineTransparency = 0
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent = model

	npcHighlights[model] = hl
end

local function removePlayerHighlight(plr)
	if highlights[plr] then
		highlights[plr]:Destroy()
		highlights[plr] = nil
	end
end

local function clearAllNPCHighlights()
	for model, hl in pairs(npcHighlights) do
		if hl then hl:Destroy() end
	end
	table.clear(npcHighlights)
end

local function refreshESP()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= lp then
			if espEnabled then
				createPlayerHighlight(plr)
			else
				removePlayerHighlight(plr)
			end
		end
	end

	if not espEnabled then
		clearAllNPCHighlights()
		return
	end

	local currentNPCs = {}

	for _, model in ipairs(workspace:GetDescendants()) do
		if model:IsA("Model") and model:FindFirstChildOfClass("Humanoid") then
			local isPlayer = false
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr.Character == model then
					isPlayer = true
					break
				end
			end

			if not isPlayer then
				currentNPCs[model] = true
				if not npcHighlights[model] then
					createNpcHighlight(model)
				end
			end
		end
	end

	for model, hl in pairs(npcHighlights) do
		if not currentNPCs[model] or not model.Parent then
			if hl then hl:Destroy() end
			npcHighlights[model] = nil
		end
	end
end

espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
	espBtn.TextColor3 = espEnabled and Color3.fromRGB(100, 220, 100) or Color3.fromRGB(200, 200, 200)
	refreshESP()
end)

Players.PlayerAdded:Connect(function(plr)
	if plr == lp then return end
	plr.CharacterAdded:Connect(function()
		task.wait(0.4)
		if espEnabled then
			createPlayerHighlight(plr)
		end
	end)
end)

for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= lp then
		plr.CharacterAdded:Connect(function()
			task.wait(0.4)
			if espEnabled then
				createPlayerHighlight(plr)
			end
		end)
	end
end

Players.PlayerRemoving:Connect(function(plr)
	removePlayerHighlight(plr)
end)

task.spawn(function()
	while true do
		task.wait(1.5)
		if espEnabled then
			refreshESP()
		end
		if headMult ~= 1 then
			scaleAllHeads()
		end
	end
end)

addBtn.MouseButton1Click:Connect(function()
	local text = string.lower(string.gsub(nameBox.Text, "%s+", ""))
	if text == "" then return end

	whitelist[text] = true
	nameBox.Text = ""
	updateStatus()

	for _, plr in ipairs(Players:GetPlayers()) do
		if string.lower(plr.Name) == text or string.lower(plr.DisplayName) == text then
			if espEnabled then createPlayerHighlight(plr) end
			local head = plr.Character and plr.Character:FindFirstChild("Head")
			if head then applyHeadScale(head, plr) end
		end
	end
end)

removeBtn.MouseButton1Click:Connect(function()
	local text = string.lower(string.gsub(nameBox.Text, "%s+", ""))
	if text == "" then return end

	whitelist[text] = nil
	nameBox.Text = ""
	updateStatus()

	for _, plr in ipairs(Players:GetPlayers()) do
		if string.lower(plr.Name) == text or string.lower(plr.DisplayName) == text then
			if espEnabled then createPlayerHighlight(plr) end
			local head = plr.Character and plr.Character:FindFirstChild("Head")
			if head then applyHeadScale(head, plr) end
		end
	end
end)

alwaysBtn.MouseButton1Click:Connect(function()
	alwaysOn = not alwaysOn
	alwaysBtn.Text = alwaysOn and "Always On: ON" or "Always On: OFF"
	alwaysBtn.TextColor3 = alwaysOn and Color3.fromRGB(100, 220, 100) or Color3.fromRGB(200, 200, 200)
	if not alwaysOn then
		stopSimulate()
	end
end)

headBox.FocusLost:Connect(function()
	local num = tonumber(headBox.Text)
	if num and num > 0 then
		headMult = num
		headBox.Text = tostring(num)
		scaleAllHeads()
	else
		headBox.Text = tostring(headMult)
	end
end)

local inputConn = nil

btn.MouseButton1Click:Connect(function()
	if listening then return end
	listening = true
	btn.Text = "Shoot Keybind: [ press a button ]"
	btn.TextColor3 = Color3.fromRGB(255, 200, 50)

	if inputConn then inputConn:Disconnect() end

	inputConn = UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end

		if input.UserInputType == Enum.UserInputType.Keyboard
			or input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.MouseButton2
			or input.UserInputType == Enum.UserInputType.MouseButton3
		then
			shootKey = input.UserInputType ~= Enum.UserInputType.Keyboard
				and input.UserInputType
				or input.KeyCode

			listening = false
			local name = input.UserInputType == Enum.UserInputType.Keyboard
				and tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
				or tostring(input.UserInputType):gsub("Enum.UserInputType.", "")

			btn.Text = "Shoot Keybind: [ " .. name .. " ]"
			btn.TextColor3 = Color3.fromRGB(100, 220, 100)
			inputConn:Disconnect()
		end
	end)
end)

RunService.RenderStepped:Connect(function()
	local shouldShoot = false

	if alwaysOn then
		shouldShoot = isLookingAtEnemy()
	elseif shootKey then
		local held = false
		if typeof(shootKey) == "EnumItem" and shootKey.EnumType == Enum.KeyCode then
			held = UserInputService:IsKeyDown(shootKey)
		elseif shootKey == Enum.UserInputType.MouseButton1 then
			held = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
		elseif shootKey == Enum.UserInputType.MouseButton2 then
			held = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
		elseif shootKey == Enum.UserInputType.MouseButton3 then
			held = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton3)
		end
		shouldShoot = held and isLookingAtEnemy()
	end

	if shouldShoot then
		startSimulate()
	else
		stopSimulate()
	end
end)

updateStatus()
