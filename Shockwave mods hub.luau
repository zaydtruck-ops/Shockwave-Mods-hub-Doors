local modes = loadstring(game:HttpGet("https://raw.githubusercontent.com/zaydtruck-ops/Shockwave-Mods-hub-Doors/refs/heads/main/Modes.luau"))()
local items = loadstring(game:HttpGet("https://raw.githubusercontent.com/zaydtruck-ops/Shockwave-Mods-hub-Doors/refs/heads/main/Items.luau"))()
local entities = loadstring(game:HttpGet("https://raw.githubusercontent.com/zaydtruck-ops/Shockwave-Mods-hub-Doors/refs/heads/main/Entities.luau"))()

local HubGUI = game:GetObjects("rbxassetid://115142199580495")[1]
HubGUI.Parent = game.Players.LocalPlayer.PlayerGui
local Assets = HubGUI.Assets

--Creating categories and buttons

local Categories = {
	"Modes",
	"Items",
	"Entities",
	"Old modes",
	"Hotel + modes",
	"Custom siderooms",
	"Old custom siderooms",
	"Old items"
}

local function OpenMinimizeHub()
    HubGUI.Main.Visible = not HubGUI.Main.Visible
end

local function CloseHub()
    OpenMinimizeHub()
    task.wait()
    HubGUI:Destroy()
end

local function CreateCategory(CategoryName)
	local CategoryFrame = Assets.Category:Clone()

	CategoryFrame.Visible = true

	CategoryFrame.Parent = HubGUI.Main.ScrollingFrame
	CategoryFrame.Name = CategoryName
end

local function CreateScriptButton(ButtonName, ButtonImage, ButtonScript, Category)
	local Button = Assets.Mod_button:Clone()
	Button.Parent = Category
	Button.Name = ButtonName

    local PlaceHolderImages = {"rbxassetid://74482276668429", "rbxassetid://83654215259533", "rbxassetid://100603387731826", "rbxassetid://94480546010758"}
    task.spawn(function()
        if ButtonImage == "rbxassetid://" then
            local RandomImage = PlaceHolderImages[math.random(1, #PlaceHolderImages)]
            Button.Image = RandomImage
        else
            Button.Image = ButtonImage
        end
    end)
    Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Button.BackgroundTransparency = 0.5

	Button.TextLabel.Text = ButtonName

	Button.Visible = true
	
	Button.MouseButton1Click:Connect(function()
		loadstring(ButtonScript)()
	end)
end

local function GetCategory(Category)
	local CategoryInstance = HubGUI.Main.ScrollingFrame[Category]
	
	return CategoryInstance
end

for i, Category in ipairs(Categories) do
	CreateCategory(Category)
	task.wait()
end

--Switching categories with the buttons at the left
local function SwitchCategory(Category)
	for i, CategoryFrame in ipairs(HubGUI.Main.ScrollingFrame:GetChildren()) do
		if CategoryFrame:IsA("Frame") then
			CategoryFrame.Visible = false
		end
	end
	
	HubGUI.Main.ScrollingFrame[Category].Visible = true
end

for i, CategoryButton in ipairs(HubGUI.Main.CategoryButtons:GetChildren()) do
	if CategoryButton:IsA("TextButton") then
		CategoryButton.MouseButton1Click:Connect(function()
			local Category = CategoryButton.Text
			
			SwitchCategory(Category)
		end)
	end
end

SwitchCategory("Modes")

for i=1, #modes do
	local mode = modes[i]
	CreateScriptButton(mode.ModName, mode.Image, mode.ModScript, GetCategory("Modes"))
end
for i=1, #entities do
	local entity = entities[i]
	CreateScriptButton(entity.ModName, entity.Image, entity.ModScript, GetCategory("Entities"))
end
for i=1, #items do
	local item = items[i]
	CreateScriptButton(item.ModName, item.Image, item.ModScript, GetCategory("Items"))
end

for i=1, 2 do
    OpenMinimizeHub()
    task.wait()
end

--Opening/Minimizing/Closing hub
HubGUI.OpenHub.MouseButton1Click:Connect(function()
    OpenMinimizeHub()
end)
HubGUI.Main.CanvasGroup.TextLabel.MinimizeButton.MouseButton1Click:Connect(function()
    OpenMinimizeHub()
end)
HubGUI.Main.CanvasGroup.TextLabel.CloseButton.MouseButton1Click:Connect(function()
    CloseHub()
end)