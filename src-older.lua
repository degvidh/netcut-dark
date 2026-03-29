-- // Services
local CoreGui = game:GetService('CoreGui')
local TweenService = game:GetService('TweenService')
local UserInputService = game:GetService('UserInputService')
local RunService = game:GetService('RunService')
local TextService = game:GetService('TextService')
local Players = game:GetService('Players')
local HttpService = game:GetService('HttpService')
local RenderStepped = game:GetService('RunService').RenderStepped
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
RunService.RenderStepped:Connect(function()
	Camera = workspace.CurrentCamera
end)

-- // Variables
local Viewport = workspace.CurrentCamera.ViewportSize
local Build = "admin_test"
local Utility = {}
local Library = {}
local Connections = {}

-- // Global tables?
_G.WindowDraggable = true
local GUI
local KeyBinds

-- // Colors
local textcolor1 = Color3.fromRGB(134, 134, 134);
local textcolor2 = Color3.fromRGB(164, 163, 166);

-- // Functions
function Utility:GetTextBounds(Text, Font, Size)
	local params = Instance.new("GetTextBoundsParams")
	params.Text = Text
	params.Font = Font
	params.Size = Size
	params.Width = 0
	local Bounds = TextService:GetTextBoundsAsync(params)
	return Bounds.X, Bounds.Y
end;

function Utility:RandomString(length)
	local characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local randomString = ""
	local charCount = string.len(characters)

	for i = 1, length do
		local randomIndex = math.random(1, charCount)
		randomString = randomString .. string.sub(characters, randomIndex, randomIndex)
	end

	return randomString
end;

function Utility:ValidateOptions(defaults, options)
	for i, v in pairs(defaults) do
		if options[i] == nil then
			options[i] = v
		end
	end;
	return options
end;

function Utility:IsNumber(x)
	
	return (typeof(x) == "number") and x 
	
end

function Utility:MakeFrameDraggable(Object)
	local dragInput       = nil
	local dragStart       = nil
	local startPos 	      = nil
	local Dragging        = false
	local preparingToDrag = false


	local function update(input)
		local delta = input.Position - dragStart
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)

		TweenService:Create(Object, TweenInfo.new(0.050), {
			Position = position
		}):Play()

		return position
	end


	Object.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			preparingToDrag = true
			_G.WindowDraggable = if Object.Name == "mainframe" then true else _G.WindowDraggable

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End and (Dragging or preparingToDrag) then
					Dragging = false
					preparingToDrag = false
					_G.WindowDraggable = if Object.Name == "mainframe" then false else _G.WindowDraggable
				end
			end)
		end
	end)

	Object.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if Object.Parent == nil then
			return
		end
		if preparingToDrag and _G.WindowDraggable then
			preparingToDrag = false
			Dragging    = true
			dragStart = input.Position
			startPos = Object.Position
		end
		if input == dragInput and Dragging then
			update(input)
		end
	end)
end

function Utility:isNearZero(value, threshold)
	return math.abs(value) < threshold
end

function Utility:IsMouseOver(Frame)
	local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize

	if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X
		and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then

		return true;
	end
end

-- // Library 
function Library:New(options)

	options = Utility:ValidateOptions({
		Name = Utility:RandomString(30)
	}, options or {})

	GUI = {
		CurrentTab = nil,
		KeyBindInUse = nil
	}

	-- keybind frame

	do

		KeyBinds = {};

		-- StarterGui.Folder.keybinds
		KeyBinds["1"] = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"));
		KeyBinds["1"]["IgnoreGuiInset"] = true;
		KeyBinds["1"]["ScreenInsets"] = Enum.ScreenInsets.DeviceSafeInsets;
		KeyBinds["1"]["Name"] = [[keybinds]];
		KeyBinds["1"]["Enabled"] = false

		-- StarterGui.Folder.keybinds.mainframe
		KeyBinds["2"] = Instance.new("Frame", KeyBinds["1"]);
		KeyBinds["2"]["Active"] = true;
		KeyBinds["2"]["BackgroundColor3"] = Color3.fromRGB(13, 13, 13);
		KeyBinds["2"]["Size"] = UDim2.new(0, 182, 0, 20);
		KeyBinds["2"]["BorderColor3"] = Color3.fromRGB(70, 70, 70);
		KeyBinds["2"]["Position"] = UDim2.new(0, 25, 0, 328);
		KeyBinds["2"]["Name"] = [[mainframe]];

		Utility:MakeFrameDraggable(KeyBinds["2"])


		-- StarterGui.Folder.keybinds.mainframe.rightframeoutline1
		KeyBinds["3"] = Instance.new("Frame", KeyBinds["2"]);
		KeyBinds["3"]["BackgroundColor3"] = Color3.fromRGB(13, 13, 13);
		KeyBinds["3"]["Size"] = UDim2.new(1, -2, 1, -2);
		KeyBinds["3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		KeyBinds["3"]["Position"] = UDim2.new(0, 1, 0, 1);
		KeyBinds["3"]["Name"] = [[rightframeoutline1]];

		-- StarterGui.Folder.keybinds.mainframe.rightframeoutline1.leftmagicframe1
		KeyBinds["4"] = Instance.new("Frame", KeyBinds["3"]);
		KeyBinds["4"]["ZIndex"] = 2;
		KeyBinds["4"]["BorderSizePixel"] = 0;
		KeyBinds["4"]["BackgroundColor3"] = Color3.fromRGB(134, 134, 134);
		KeyBinds["4"]["Size"] = UDim2.new(1, 2, 0, 1);
		KeyBinds["4"]["BorderColor3"] = Color3.fromRGB(51, 51, 51);
		KeyBinds["4"]["Position"] = UDim2.new(0, -1, 0, -1);
		KeyBinds["4"]["Name"] = [[leftmagicframe1]];

		-- StarterGui.Folder.keybinds.mainframe.rightframeoutline1.leftframename1
		KeyBinds["5"] = Instance.new("TextLabel", KeyBinds["3"]);
		KeyBinds["5"]["TextStrokeTransparency"] = 0;
		KeyBinds["5"]["ZIndex"] = 2;
		KeyBinds["5"]["BorderSizePixel"] = 0;
		KeyBinds["5"]["FontFace"] = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
		KeyBinds["5"]["TextSize"] = 13;
		KeyBinds["5"]["TextColor3"] = Color3.fromRGB(134, 134, 134);
		KeyBinds["5"]["Size"] = UDim2.new(1, 0, 0, 18);
		KeyBinds["5"]["Active"] = true;
		KeyBinds["5"]["Text"] = [[KeyBinds]];
		KeyBinds["5"]["Name"] = [[leftframename1]];
		KeyBinds["5"]["BackgroundTransparency"] = 1;

		-- StarterGui.Folder.keybinds.mainframe.Frame
		KeyBinds["6"] = Instance.new("Frame", KeyBinds["2"]);
		KeyBinds["6"]["BackgroundColor3"] = Color3.fromRGB(13, 13, 13);
		KeyBinds["6"]["BorderMode"] = Enum.BorderMode.Inset;
		KeyBinds["6"]["BackgroundTransparency"] = 0.8999999761581421;
		KeyBinds["6"]["Size"] = UDim2.new(1, 0, 4, 0);
		KeyBinds["6"]["BorderColor3"] = Color3.fromRGB(70, 70, 70);
		KeyBinds["6"]["Position"] = UDim2.new(0, 0, 1, 0);

		-- StarterGui.Folder.keybinds.mainframe.Frame.UIListLayout
		KeyBinds["7"] = Instance.new("UIListLayout", KeyBinds["6"]);
		KeyBinds["7"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

	end

	-- main frame

	do 

		-- Screen Gui
		GUI["1"] = Instance.new("ScreenGui", RunService:IsStudio() and game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") or CoreGui);
		GUI["1"]["IgnoreGuiInset"] = true;
		GUI["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Global;
		GUI["1"]["ScreenInsets"] = Enum.ScreenInsets.DeviceSafeInsets;
		GUI["1"]["Name"] = options.Name;

		-- StarterGui.DevAmpliedChat.mainframe1
		GUI["2"] = Instance.new("Frame", GUI["1"]);
		GUI["2"]["Active"] = true;
		GUI["2"]["BorderSizePixel"] = 0;
		GUI["2"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["2"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
		GUI["2"]["Size"] = UDim2.new(0, 516, 0, 562);
		GUI["2"]["Selectable"] = true;
		GUI["2"]["Position"] = UDim2.new(0.5,0,0.5,0);
		GUI["2"]["Name"] = [[mainframe]];
		Utility:MakeFrameDraggable(GUI["2"])

		-- StarterGui.DevAmpliedChat.mainframe1.main
		GUI["3"] = Instance.new("Frame", GUI["2"]);
		GUI["3"]["Active"] = true;
		GUI["3"]["BackgroundColor3"] = Color3.fromRGB(13, 13, 13);
		GUI["3"]["Size"] = UDim2.new(1, -4, 1, -4);
		GUI["3"]["BorderColor3"] = Color3.fromRGB(134, 134, 134);
		GUI["3"]["Position"] = UDim2.new(0, 2, 0, 2);
		GUI["3"]["Name"] = [[main]];

		-- StarterGui.DevAmpliedChat.mainframe1.main.frame1outline
		GUI["4"] = Instance.new("Frame", GUI["3"]);
		GUI["4"]["Active"] = true;
		GUI["4"]["BackgroundColor3"] = Color3.fromRGB(13, 13, 13);
		GUI["4"]["Size"] = UDim2.new(1, -16, 1, -35);
		GUI["4"]["BorderColor3"] = Color3.fromRGB(51, 51, 51);
		GUI["4"]["Position"] = UDim2.new(0, 8, 0, 26);
		GUI["4"]["Name"] = [[frameoutline]];

		-- StarterGui.DevAmpliedChat.mainframe1.main.frame1outline.frame1
		GUI["5"] = Instance.new("Frame", GUI["4"]);
		GUI["5"]["Active"] = true;
		GUI["5"]["BackgroundColor3"] = Color3.fromRGB(13, 13, 13);
		GUI["5"]["Size"] = UDim2.new(1, -2, 1, -2);
		GUI["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["5"]["Position"] = UDim2.new(0, 1, 0, 1);
		GUI["5"]["Name"] = [[frame]];

		-- StarterGui.DevAmpliedChat.mainframe1.netcut1
		GUI["105"] = Instance.new("TextLabel", GUI["2"]);
		GUI["105"]["TextStrokeTransparency"] = 0;
		GUI["105"]["ZIndex"] = 2;
		GUI["105"]["BorderSizePixel"] = 0;
		GUI["105"]["TextXAlignment"] = Enum.TextXAlignment.Left;
		GUI["105"]["FontFace"] = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
		GUI["105"]["TextSize"] = 13;
		GUI["105"]["TextColor3"] = textcolor2;
		GUI["105"]["Active"] = true;
		GUI["105"]["Text"] = ("net.cut|"..Build.."|"..LocalPlayer.Name)
		GUI["105"]["Name"] = [[netcut]];
		GUI["105"]["BackgroundTransparency"] = 1;
		GUI["105"]["Position"] = UDim2.new(0.02, 0,0.03, 0);

	end

	-- notification frame

	do 

		-- StarterGui.DevAmpliedChat.notifyer
		GUI["106"] = Instance.new("Frame", GUI["1"]);
		GUI["106"]["Active"] = true;
		GUI["106"]["ZIndex"] = 0;
		GUI["106"]["BorderSizePixel"] = 0;
		GUI["106"]["BackgroundColor3"] = Color3.fromRGB(51, 51, 51);
		GUI["106"]["BackgroundTransparency"] = 0.8;
		GUI["106"]["Size"] = UDim2.new(0, 500, 0, 200);
		GUI["106"]["Selectable"] = true;
		GUI["106"]["BorderColor3"] = Color3.fromRGB(13, 13, 13);
		GUI["106"]["Position"] = UDim2.new(0, 19, 0, 46);
		GUI["106"]["Name"] = [[notifyer]];
		Utility:MakeFrameDraggable(GUI["106"])

		-- StarterGui.DevAmpliedChat.notifyer.uilistlayout
		GUI["107"] = Instance.new("UIListLayout", GUI["106"]);
		GUI["107"]["Name"] = [[uilistlayout]];
		GUI["107"]["Padding"] = UDim.new(0, 4);
		GUI["107"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

	end

	-- container frames

	do 

		-- StarterGui.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabbuttons
		GUI["6"] = Instance.new("Frame", GUI["5"]);
		GUI["6"]["Active"] = true;
		GUI["6"]["BorderSizePixel"] = 0;
		GUI["6"]["BackgroundColor3"] = Color3.fromRGB(13, 13, 13);
		GUI["6"]["Size"] = UDim2.new(1, -16, 0, 21);
		GUI["6"]["BorderColor3"] = Color3.fromRGB(51, 51, 51);
		GUI["6"]["Position"] = UDim2.new(0, 8, 0, 8);
		GUI["6"]["Name"] = [[tabbuttons]];

		-- StarterGui.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabbuttons.uilistlayout
		GUI["7"] = Instance.new("UIListLayout", GUI["6"]);
		GUI["7"]["FillDirection"] = Enum.FillDirection.Horizontal;
		GUI["7"]["Name"] = [[uilistlayout]];
		GUI["7"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


		-- StarterGui.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes
		GUI["20"] = Instance.new("Frame", GUI["5"]);
		GUI["20"]["BackgroundColor3"] = Color3.fromRGB(13, 13, 13);
		GUI["20"]["Size"] = UDim2.new(1, -16, 1, -38);
		GUI["20"]["BorderColor3"] = Color3.fromRGB(51, 51, 51);
		GUI["20"]["Position"] = UDim2.new(0, 8, 0, 30);
		GUI["20"]["Name"] = [[tabframes]];

	end

	function GUI:CreatTab(options)

		options = Utility:ValidateOptions({
			Name = "No name"
		}, options or {})

		local TAB = {
			Active = false,
			Hover = false
		}

		-- tab button

		do

			local x , y = Utility:GetTextBounds(options.Name,Font.new("rbxasset://fonts/families/Inconsolata.json"),13)

			-- StarterTab.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabbuttons.tab1button
			TAB["8"] = Instance.new("Frame", GUI["6"]);
			TAB["8"]["BackgroundColor3"] = Color3.fromRGB(13, 13, 13);
			TAB["8"]["Size"] = UDim2.new(0, x+10, 1, 0);
			TAB["8"]["BorderColor3"] = Color3.fromRGB(51, 51, 51);
			TAB["8"]["Position"] = UDim2.new(0, 8, 0, 8);
			TAB["8"]["Name"] = "tabbutton";

			-- StarterTab.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabbuttons.tab1button.tab1name
			TAB["a"] = Instance.new("TextLabel", TAB["8"]);
			TAB["a"]["TextStrokeTransparency"] = 0;
			TAB["a"]["ZIndex"] = 2;
			TAB["a"]["BorderSizePixel"] = 0;
			TAB["a"]["FontFace"] = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			TAB["a"]["TextSize"] = 13;
			TAB["a"]["TextColor3"] = textcolor1;
			TAB["a"]["Size"] = UDim2.new(1, 0, 1, -1);
			TAB["a"]["Active"] = true;
			TAB["a"]["Text"] = options.Name
			TAB["a"]["Name"] = [[tabname]];
			TAB["a"]["BackgroundTransparency"] = 1;

			-- StarterTab.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabbuttons.tab1button.tab1magicframe
			TAB["b"] = Instance.new("Frame", TAB["8"]);
			TAB["b"]["ZIndex"] = 2;
			TAB["b"]["BorderSizePixel"] = 0;
			TAB["b"]["BackgroundColor3"] = Color3.fromRGB(13, 13, 13);
			TAB["b"]["BackgroundTransparency"] = 1;
			TAB["b"]["Size"] = UDim2.new(1, -1, 0, 1);
			TAB["b"]["BorderColor3"] = Color3.fromRGB(13, 13, 13);
			TAB["b"]["Position"] = UDim2.new(0, 0, 1, 0);
			TAB["b"]["Name"] = [[tabmagicframe]];

		end

		-- frame containers

		do 

			-- StarterTAB.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab1frames
			TAB["21"] = Instance.new("Frame", GUI["20"]);
			TAB["21"]["BackgroundColor3"] = Color3.fromRGB(13, 13, 13);
			TAB["21"]["BackgroundTransparency"] = 1;
			TAB["21"]["Size"] = UDim2.new(1, 0, 1, 0);
			TAB["21"]["BorderColor3"] = Color3.fromRGB(51, 51, 51);
			TAB["21"]["Visible"] = false;
			TAB["21"]["Name"] = [[tabframes]];

			-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab6frames.gradient
			TAB["140"] = Instance.new("Frame", TAB["21"]);
			TAB["140"]["BorderSizePixel"] = 0;
			TAB["140"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			TAB["140"]["Size"] = UDim2.new(1, 0, 0, 15);
			TAB["140"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			TAB["140"]["Name"] = [[gradient]];

			-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab6frames.gradient.UIGradient
			TAB["141"] = Instance.new("UIGradient", TAB["140"]);
			TAB["141"]["Transparency"] = NumberSequence.new{NumberSequenceKeypoint.new(0.000, 0),NumberSequenceKeypoint.new(0.800, 1),NumberSequenceKeypoint.new(1.000, 1)};
			TAB["141"]["Rotation"] = 90;
			TAB["141"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(13, 13, 13)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(13, 13, 13))};

			-- StarterTAB.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab1frames.ScrollingFrame
			TAB["22"] = Instance.new("ScrollingFrame", TAB["21"]);
			TAB["22"]["Active"] = true;
			TAB["22"]["ScrollingDirection"] = Enum.ScrollingDirection.Y;
			TAB["22"]["BorderSizePixel"] = 0;
			TAB["22"]["CanvasSize"] = UDim2.new(0, 0, 0, 4);
			TAB["22"]["ScrollBarImageTransparency"] = 1;
			TAB["22"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			TAB["22"]["BackgroundTransparency"] = 1;
			TAB["22"]["Size"] = UDim2.new(1, 6, 1, 0);
			TAB["22"]["ScrollBarImageColor3"] = Color3.fromRGB(134, 134, 134);
			TAB["22"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;

			-- StarterTAB.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab1frames.ScrollingFrame.frameleft
			TAB["23"] = Instance.new("Frame", TAB["22"]);
			TAB["23"]["BackgroundColor3"] = Color3.fromRGB(134, 134, 134);
			TAB["23"]["BackgroundTransparency"] = 1;
			TAB["23"]["Size"] = UDim2.new(0, 225, 0, 800);
			TAB["23"]["BorderColor3"] = Color3.fromRGB(51, 51, 51);
			TAB["23"]["Position"] = UDim2.new(0, 10, 0, 8);
			TAB["23"]["Name"] = [[frameleft]];
			TAB["23"]["AutomaticSize"] = Enum.AutomaticSize.Y;

			-- StarterTAB.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab1frames.ScrollingFrame.frameleft.frameleftuilist
			TAB["24"] = Instance.new("UIListLayout", TAB["23"]);
			TAB["24"]["Name"] = [[frameleftuilist]];
			TAB["24"]["Padding"] = UDim.new(0, 8);
			TAB["24"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


			-- StarterTAB.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab1frames.ScrollingFrame.frameright
			TAB["2d"] = Instance.new("Frame", TAB["22"]);
			TAB["2d"]["BackgroundColor3"] = Color3.fromRGB(134, 134, 134);
			TAB["2d"]["BackgroundTransparency"] = 1;
			TAB["2d"]["Size"] = UDim2.new(0, 225, 0, 800);
			TAB["2d"]["BorderColor3"] = Color3.fromRGB(51, 51, 51);
			TAB["2d"]["Position"] = UDim2.new(0, 245, 0, 8);
			TAB["2d"]["Name"] = [[frameright]];
			TAB["2d"]["AutomaticSize"] = Enum.AutomaticSize.Y;

			-- StarterTAB.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab1frames.ScrollingFrame.frameright.framerightuilist
			TAB["2e"] = Instance.new("UIListLayout", TAB["2d"]);
			TAB["2e"]["Name"] = [[framerightuilist]];
			TAB["2e"]["Padding"] = UDim.new(0, 8);
			TAB["2e"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


		end

		-- meethods

		function TAB:Activate()
			if not TAB.Active then
				if GUI.CurrentTab ~= nil then
					GUI.CurrentTab:Deactivate()
				end

				TAB.Active = true 
				TAB["b"]["BackgroundTransparency"] = 0
				TAB["a"]["TextColor3"] = textcolor2;
				GUI.CurrentTab = TAB

				TAB["21"]["Visible"] = true;
			end
		end

		function TAB:Deactivate()
			if TAB.Active then
				TAB.Active = false
				TAB.Hover = false
				TAB["b"]["BackgroundTransparency"] = 1
				TAB["a"]["TextColor3"] = textcolor1;
				TAB["21"]["Visible"] = false;
			end
		end

		-- logic

		do

			TAB["8"].InputBegan:Connect(function(input, gpe)
				if gpe then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 and Utility:IsMouseOver(TAB["8"]) then
					TAB:Activate()
				end
			end)

			if GUI.CurrentTab == nil then
				TAB:Activate()
			end

		end

		-- create frame

		function TAB:CreateFrame(options)

			options = Utility:ValidateOptions({
				Name = "No name",
				Side = "No side",
				SizeY = 200,
			}, options or {})

			local FRAME = {
				Active = false,
				Hover = false,
				Closed = false
			}

			-- side

			do

				if options.Side == "left" then
					FRAME["25"] = Instance.new("Frame", TAB["23"]);
					FRAME["25"]["Name"] = [[leftframe]];
				else
					FRAME["25"] = Instance.new("Frame", TAB["2d"]);
					FRAME["25"]["Name"] = [[rightframe]];
				end

			end

			-- the frame it self :3

			do

				-- StarterTAB.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab1frames.ScrollingFrame.frameleft.leftframe1
				--TAB["25"] = Instance.new("Frame", TAB["23"]);
				FRAME["25"]["BackgroundColor3"] = Color3.fromRGB(13, 13, 13);
				FRAME["25"]["Size"] = UDim2.new(1, 0, 0, options.SizeY);
				FRAME["25"]["BorderColor3"] = Color3.fromRGB(51, 51, 51);
				FRAME["25"]["Position"] = UDim2.new(0, 10, 0, 8);
				FRAME["25"]["ClipsDescendants"] = false

				-- StarterTAB.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab1frames.ScrollingFrame.frameleft.leftframe1.leftframeoutline1
				FRAME["26"] = Instance.new("Frame", FRAME["25"]);
				FRAME["26"]["BackgroundColor3"] = Color3.fromRGB(13, 13, 13);
				FRAME["26"]["Size"] = UDim2.new(1, -2, 1, -2);
				FRAME["26"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				FRAME["26"]["Position"] = UDim2.new(0, 1, 0, 1);
				FRAME["26"]["Name"] = [[frameoutline]];

				-- StarterTAB.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab1frames.ScrollingFrame.frameleft.leftframe1.leftframeoutline1.leftmagicframe1
				FRAME["27"] = Instance.new("Frame", FRAME["26"]);
				FRAME["27"]["BorderSizePixel"] = 0;
				FRAME["27"]["BackgroundColor3"] = Color3.fromRGB(134, 134, 134);
				FRAME["27"]["Size"] = UDim2.new(1, 2, 0, 1);
				FRAME["27"]["BorderColor3"] = Color3.fromRGB(51, 51, 51);
				FRAME["27"]["Position"] = UDim2.new(0, -1, 0, -1);
				FRAME["27"]["Name"] = [[magicframe]];

				-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.FRAMEframes.FRAME6frames.ScrollingFrame.frameleft.leftframe1.leftframeoutline1.leftutilitesframe1
				FRAME["83"] = Instance.new("Frame", FRAME["26"] );
				FRAME["83"]["BorderSizePixel"] = 0;
				FRAME["83"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				FRAME["83"]["BackgroundTransparency"] = 1;
				FRAME["83"]["Size"] = UDim2.new(1, -4, 1, -20);
				FRAME["83"]["Position"] = UDim2.new(0, 4, 0, 20);
				FRAME["83"]["Name"] = [[utilitesframe1]];

				-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab6frames.ScrollingFrame.frameleft.leftframe1.leftframeoutline1.leftutilitesframe1.frameleftuilist
				FRAME["88"] = Instance.new("UIListLayout", FRAME["83"]);
				FRAME["88"]["Name"] = [[uilistframe]];
				FRAME["88"]["Padding"] = UDim.new(0, 5);
				FRAME["88"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

				-- StarterTAB.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab1frames.ScrollingFrame.frameleft.leftframe1.leftframeoutline1.leftframename1
				FRAME["28"] = Instance.new("TextLabel", FRAME["26"]);
				FRAME["28"]["TextStrokeTransparency"] = 0;
				FRAME["28"]["ZIndex"] = 2;
				FRAME["28"]["BorderSizePixel"] = 0;
				FRAME["28"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				FRAME["28"]["FontFace"] = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				FRAME["28"]["TextSize"] = 13;
				FRAME["28"]["TextColor3"] = textcolor2;
				FRAME["28"]["Size"] = UDim2.new(1, 0, 0, 18);
				FRAME["28"]["Active"] = true;
				FRAME["28"]["Text"] = options.Name;
				FRAME["28"]["Name"] = [[framename]];
				FRAME["28"]["BackgroundTransparency"] = 1;
				FRAME["28"]["Position"] = UDim2.new(0, 4, 0, 0);

				-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab6frames.ScrollingFrame.frameleft.leftframe1.leftframeoutline1.roatatingthing
				FRAME["a9"] = Instance.new("TextLabel", FRAME["26"]);
				FRAME["a9"]["TextStrokeTransparency"] = 0;
				FRAME["a9"]["ZIndex"] = 2;
				FRAME["a9"]["BorderSizePixel"] = 0;
				FRAME["a9"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				FRAME["a9"]["FontFace"] = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				FRAME["a9"]["TextSize"] = 13;
				FRAME["a9"]["TextColor3"] = textcolor2;
				FRAME["a9"]["Size"] = UDim2.new(0, 7, 0, 13);
				FRAME["a9"]["Active"] = true;
				FRAME["a9"]["Text"] = [[^]];
				FRAME["a9"]["Name"] = [[roatatingthing]];
				FRAME["a9"]["Rotation"] = -180;
				FRAME["a9"]["BackgroundTransparency"] = 1;
				FRAME["a9"]["Position"] = UDim2.new(1, -12, 0, 2);

			end

			-- logic 

			do

				local frame = FRAME["a9"]
				local sizeFrame = FRAME["25"]

				local function rotateFrame()
					local rotateGoal = -180
					if FRAME.Closed then
						rotateGoal = -90
					end

					local rotationTweenInfo = TweenInfo.new(
						0.5, -- Duration
						Enum.EasingStyle.Quint, -- Easing style
						Enum.EasingDirection.Out, -- Easing direction
						0, -- Repeat count (0 means no repeat)
						false, -- Reverses after repeating
						0 -- Delay
					)

					local rotationTween = TweenService:Create(frame, rotationTweenInfo, {Rotation = rotateGoal})
					rotationTween:Play()
				end

				local function resizeFrame()
					local sizeGoal
					if FRAME.Closed then
						sizeGoal = FRAME["28"]["Size"]
					else
						sizeGoal = UDim2.new(1, 0, 0, options.SizeY)
					end

					local sizeTweenInfo = TweenInfo.new(
						0.5, -- Duration
						Enum.EasingStyle.Quint, -- Easing style
						Enum.EasingDirection.Out, -- Easing direction
						0, -- Repeat count (0 means no repeat)
						false, -- Reverses after repeating
						0 -- Delay
					)

					local sizeTween = TweenService:Create(sizeFrame, sizeTweenInfo, {Size = sizeGoal})
					sizeTween:Play()
				end

				FRAME["a9"].InputBegan:Connect(function(input, gpe)
					if gpe then return end
					if input.UserInputType == Enum.UserInputType.MouseButton1 and Utility:IsMouseOver(FRAME["a9"]) then
						_G.WindowDraggable = false 
						FRAME.Closed = not FRAME.Closed
						FRAME["83"]["Visible"] = not FRAME["83"]["Visible"]
						rotateFrame()
						resizeFrame()
					end
				end)
			end


			function FRAME:Button(options) -- done

				options = Utility:ValidateOptions({
					Name = "No name",
					CallBack = function() print("No callback :3") end
				}, options or {})

				local Button = {
					Hover = false,
					Activated = false
				}

				-- render

				do

					-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab6frames.ScrollingFrame.frameleft.leftframe1.leftframeoutline1.leftutilitesframe1.UnloadButton
					Button["93"] = Instance.new("Frame", FRAME["83"]);
					Button["93"]["BackgroundColor3"] = Color3.fromRGB(164, 164, 164);
					Button["93"]["Size"] = UDim2.new(0, 215, 0, 25);
					Button["93"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Button["93"]["Name"] = [[Button]];

					-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab6frames.ScrollingFrame.frameleft.leftframe1.leftframeoutline1.leftutilitesframe1.UnloadButton.togglebutton
					Button["94"] = Instance.new("TextLabel", Button["93"]);
					Button["94"]["TextStrokeTransparency"] = 0;
					Button["94"]["BackgroundColor3"] = Color3.fromRGB(13, 13, 13);
					Button["94"]["FontFace"] = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					Button["94"]["Selectable"] = true;
					Button["94"]["TextSize"] = 14;
					Button["94"]["TextColor3"] = textcolor2;
					Button["94"]["Size"] = UDim2.new(1, -2, 1, -2);
					Button["94"]["Active"] = true;
					Button["94"]["BorderColor3"] = Color3.fromRGB(51, 51, 51);
					Button["94"]["Text"] = options.Name;
					Button["94"]["Name"] = [[Button]];
					Button["94"]["Position"] = UDim2.new(0, 1, 0, 1);

				end

				-- logic 

				do

					Button["94"].InputBegan:Connect(function(input, gpe)
						if gpe then return end
						if input.UserInputType == Enum.UserInputType.MouseButton1 and Utility:IsMouseOver(Button["94"]) then
							options.CallBack()
						end
					end)

				end

				return Button

			end

			function FRAME:KeyBind(options) -- done

				options = Utility:ValidateOptions({
					Name = "Not name",
					KeyBindType = "Toggle", -- Allways/Toggle/Held
					Options = "None", -- All/None							 TODO: add more options
					CallBack = function() print("No callback :3") end
				}, options or {})

				local KeyBind = {
					CheckingForKey = false,
					CurrentKeybind = "..."
				}

				local KeyBindType = {
					Toggle = false, -- Toggling
					Allways = false, -- Allways
					Held = true, -- Held?
				}

				local KeyBindSelect = {
					isRightClicked = false,
					HoverKeybind = false
				}

				-- render

				do
					-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab6frames.ScrollingFrame.frameleft.leftframe1.leftframeoutline1.leftutilitesframe1.KeybindForMenu
					KeyBind["89"] = Instance.new("TextLabel", FRAME["83"]);
					KeyBind["89"]["TextStrokeTransparency"] = 0;
					KeyBind["89"]["ZIndex"] = 2;
					KeyBind["89"]["BorderSizePixel"] = 0;
					KeyBind["89"]["TextXAlignment"] = Enum.TextXAlignment.Left;
					KeyBind["89"]["FontFace"] = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					KeyBind["89"]["TextSize"] = 13;
					KeyBind["89"]["TextColor3"] = textcolor2;
					KeyBind["89"]["Size"] = UDim2.new(1, 0, 0, 13);
					KeyBind["89"]["Active"] = true;
					KeyBind["89"]["Text"] = options.Name;
					KeyBind["89"]["Name"] = [[KeyBind]];
					KeyBind["89"]["BackgroundTransparency"] = 1;
					KeyBind["89"]["Position"] = UDim2.new(0, 4, 0, 0);

					-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab6frames.ScrollingFrame.frameleft.leftframe1.leftframeoutline1.leftutilitesframe1.KeybindForMenu.textlabel1
					KeyBind["8a"] = Instance.new("TextButton", KeyBind["89"]);
					KeyBind["8a"]["TextStrokeTransparency"] = 0;
					KeyBind["8a"]["AnchorPoint"] = Vector2.new(1,0.5)
					KeyBind["8a"]["ZIndex"] = 2;
					KeyBind["8a"]["BorderSizePixel"] = 0;
					KeyBind["8a"]["TextXAlignment"] = Enum.TextXAlignment.Right;
					KeyBind["8a"]["TextSize"] = 13;
					KeyBind["8a"]["FontFace"] = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					KeyBind["8a"]["TextColor3"] = textcolor2;
					KeyBind["8a"]["Selectable"] = false;
					KeyBind["8a"]["Name"] = [[KeyBind]];
					KeyBind["8a"]["Text"] = "[...]";
					KeyBind["8a"]["Size"] = UDim2.new(0, 25, 0, 25);
					KeyBind["8a"]["Position"] = UDim2.new(1, -6,0, 6);
					KeyBind["8a"]["BackgroundTransparency"] = 1;

				end

				-- logic for key bind type

				do

					KeyBind["8a"].MouseButton1Click:Connect(function(input)
						KeyBind.CheckingForKey = true
						KeyBind["8a"]["Text"] = "[  ]"
					end)

					UserInputService.InputBegan:Connect(function(input, processed)
						if options.Options == "All" then
							if input.UserInputType == Enum.UserInputType.MouseButton2 and Utility:IsMouseOver(KeyBind["8a"]) and processed then

								-- Keybindtype frame appear at rn used keybind

								do

									if GUI.KeyBindInUse ~= nil then
										GUI.KeyBindInUse["2"]:Destroy()
									end
									GUI.KeyBindInUse = nil
									GUI.KeyBindInUse = KeyBindSelect

								end

								KeyBindSelect.isRightClicked = true

								-- StarterGui.Folder.ScreenGui.frame
								KeyBindSelect["2"] = Instance.new("Frame", KeyBind["89"]);
								KeyBindSelect["2"]["ZIndex"] = 3;
								KeyBindSelect["2"]["BackgroundColor3"] = Color3.fromRGB(13, 13, 13);
								KeyBindSelect["2"]["ClipsDescendants"] = true;
								KeyBindSelect["2"]["Size"] = UDim2.new(0, 80, 0, 57);
								KeyBindSelect["2"]["Position"] = UDim2.new(1, -20, 0, 16);
								KeyBindSelect["2"]["BorderColor3"] = Color3.fromRGB(51, 51, 51);
								KeyBindSelect["2"]["Name"] = [[frame]];

								-- StarterGui.Folder.ScreenGui.frame.frameoutline
								KeyBindSelect["3"] = Instance.new("Frame", KeyBindSelect["2"]);
								KeyBindSelect["3"]["ZIndex"] = 3;
								KeyBindSelect["3"]["BackgroundColor3"] = Color3.fromRGB(13, 13, 13);
								KeyBindSelect["3"]["Size"] = UDim2.new(1, -2, 1, -2);
								KeyBindSelect["3"]["Position"] = UDim2.new(0, 1, 0, 1);
								KeyBindSelect["3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
								KeyBindSelect["3"]["Name"] = [[frameoutline]];

								-- StarterGui.Folder.ScreenGui.frame.frameoutline.UIListLayout
								KeyBindSelect["4"] = Instance.new("UIListLayout", KeyBindSelect["3"]);
								KeyBindSelect["4"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

								-- StarterGui.Folder.ScreenGui.frame.frameoutline.1
								KeyBindSelect["5"] = Instance.new("TextLabel", KeyBindSelect["3"]);
								KeyBindSelect["5"]["Active"] = true;
								KeyBindSelect["5"]["TextStrokeTransparency"] = 0;
								KeyBindSelect["5"]["ZIndex"] = 3;
								KeyBindSelect["5"]["BorderSizePixel"] = 0;
								KeyBindSelect["5"]["TextSize"] = 13;
								KeyBindSelect["5"]["FontFace"] = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
								KeyBindSelect["5"]["TextColor3"] = Color3.fromRGB(134, 134, 134);
								KeyBindSelect["5"]["BackgroundTransparency"] = 1;
								KeyBindSelect["5"]["Size"] = UDim2.new(1, 0, 0, 18);
								KeyBindSelect["5"]["Text"] = [[Allways]];
								KeyBindSelect["5"]["LayoutOrder"] = 5;
								KeyBindSelect["5"]["Name"] = [[1]];
								KeyBindSelect["5"]["Position"] = UDim2.new(0, 4, 0, 0);

								-- StarterGui.Folder.ScreenGui.frame.frameoutline.2
								KeyBindSelect["6"] = Instance.new("TextLabel", KeyBindSelect["3"]);
								KeyBindSelect["6"]["Active"] = true;
								KeyBindSelect["6"]["TextStrokeTransparency"] = 0;
								KeyBindSelect["6"]["ZIndex"] = 3;
								KeyBindSelect["6"]["BorderSizePixel"] = 0;
								KeyBindSelect["6"]["TextSize"] = 13;
								KeyBindSelect["6"]["FontFace"] = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
								KeyBindSelect["6"]["TextColor3"] = Color3.fromRGB(134, 134, 134);
								KeyBindSelect["6"]["BackgroundTransparency"] = 1;
								KeyBindSelect["6"]["Size"] = UDim2.new(1, 0, 0, 18);
								KeyBindSelect["6"]["Text"] = [[Toggle]];
								KeyBindSelect["6"]["LayoutOrder"] = 5;
								KeyBindSelect["6"]["Name"] = [[2]];
								KeyBindSelect["6"]["Position"] = UDim2.new(0, 4, 0, 0);

								-- StarterGui.Folder.ScreenGui.frame.frameoutline.3
								KeyBindSelect["7"] = Instance.new("TextLabel", KeyBindSelect["3"]);
								KeyBindSelect["7"]["Active"] = true;
								KeyBindSelect["7"]["TextStrokeTransparency"] = 0;
								KeyBindSelect["7"]["ZIndex"] = 3;
								KeyBindSelect["7"]["BorderSizePixel"] = 0;
								KeyBindSelect["7"]["TextSize"] = 13;
								KeyBindSelect["7"]["FontFace"] = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
								KeyBindSelect["7"]["TextColor3"] = Color3.fromRGB(134, 134, 134);
								KeyBindSelect["7"]["BackgroundTransparency"] = 1;
								KeyBindSelect["7"]["Size"] = UDim2.new(1, 0, 0, 18);
								KeyBindSelect["7"]["Text"] = [[Held]];
								KeyBindSelect["7"]["LayoutOrder"] = 5;
								KeyBindSelect["7"]["Name"] = [[3]];
								KeyBindSelect["7"]["Position"] = UDim2.new(0, 4, 0, 0);

							elseif input.UserInputType == Enum.UserInputType.MouseButton1 and KeyBindSelect.isRightClicked == true and processed then
								if Utility:IsMouseOver(KeyBindSelect["5"]) then
									options.KeyBindType = "Allways"
									KeyBindType.Allways = false
								end
								if Utility:IsMouseOver(KeyBindSelect["6"]) then
									options.KeyBindType = "Toggle"
									if KeyBindType["8"] then KeyBindType["8"]:Destroy() end
								end
								if Utility:IsMouseOver(KeyBindSelect["7"]) then
									options.KeyBindType = "Held"
									if KeyBindType["8"] then KeyBindType["8"]:Destroy() end
								end
								KeyBindSelect.isRightClicked = false
								KeyBindSelect["2"]:Destroy()
							end
						end
						if KeyBind.CheckingForKey then
							if input.KeyCode ~= Enum.KeyCode.Unknown then
								local SplitMessage = string.split(tostring(input.KeyCode), ".")
								local NewKeyNoEnum = SplitMessage[3]
								KeyBind.CurrentKeybind = tostring(NewKeyNoEnum)
								local x, y = Utility:GetTextBounds(KeyBind.CurrentKeybind,Font.new([[rbxasset://fonts/families/Inconsolata.json]]),13)
								KeyBind["8a"]["Text"] = "["..tostring(NewKeyNoEnum).."]"
								KeyBind["8a"]["Size"] = UDim2.new(0, x+25, 0, 25);
								if KeyBinds ~= nil and KeyBindType["8"] then KeyBindType["8"]["Text"] = options.Name.." - "..KeyBind.CurrentKeybind end
								KeyBind.CheckingForKey = false
							end
						elseif KeyBind.CurrentKeybind ~= nil and KeyBind.CurrentKeybind ~= "..." and (input.KeyCode == Enum.KeyCode[KeyBind.CurrentKeybind] and not processed) then -- Test
							if options.KeyBindType == "Allways" then 
								if not KeyBindType.Allways then
									KeyBindType["8"] = Instance.new("TextLabel", KeyBinds["6"]);
									KeyBindType["8"]["TextStrokeTransparency"] = 0;
									KeyBindType["8"]["ZIndex"] = 2;
									KeyBindType["8"]["BorderSizePixel"] = 0;
									KeyBindType["8"]["FontFace"] = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
									KeyBindType["8"]["TextSize"] = 13;
									KeyBindType["8"]["TextColor3"] = Color3.fromRGB(165, 164, 167);
									KeyBindType["8"]["Size"] = UDim2.new(1, 0, 0, 18);
									KeyBindType["8"]["Active"] = true;
									KeyBindType["8"]["Text"] = options.Name.." - "..KeyBind.CurrentKeybind
									KeyBindType["8"]["Name"] = [[allways]];
									KeyBindType["8"]["BackgroundTransparency"] = 1;
									KeyBindType.Allways = not KeyBindType.Allways
									options.CallBack()
								end
							elseif options.KeyBindType == "Toggle" then 
								if not KeyBindType.Toggle then
									KeyBindType["8"] = Instance.new("TextLabel", KeyBinds["6"]);
									KeyBindType["8"]["TextStrokeTransparency"] = 0;
									KeyBindType["8"]["ZIndex"] = 2;
									KeyBindType["8"]["BorderSizePixel"] = 0;
									KeyBindType["8"]["FontFace"] = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
									KeyBindType["8"]["TextSize"] = 13;
									KeyBindType["8"]["TextColor3"] = Color3.fromRGB(165, 164, 167);
									KeyBindType["8"]["Size"] = UDim2.new(1, 0, 0, 18);
									KeyBindType["8"]["Active"] = true;
									KeyBindType["8"]["Text"] = options.Name.." - "..KeyBind.CurrentKeybind
									KeyBindType["8"]["Name"] = [[toggle]];
									KeyBindType["8"]["BackgroundTransparency"] = 1;
									KeyBindType.Toggle = not KeyBindType.Toggle
									options.CallBack(KeyBindType.Toggle)
								else
									KeyBindType.Toggle = not KeyBindType.Toggle
									options.CallBack(KeyBindType.Toggle)
									--print(KeyBindUi["8"].Name)
									if KeyBindType["8"] then KeyBindType["8"]:Destroy() end
									KeyBindType["8"] = nil
								end
							elseif options.KeyBindType == "Held" then 
								KeyBindType["8"] = Instance.new("TextLabel", KeyBinds["6"]);
								KeyBindType["8"]["TextStrokeTransparency"] = 0;
								KeyBindType["8"]["ZIndex"] = 2;
								KeyBindType["8"]["BorderSizePixel"] = 0;
								KeyBindType["8"]["FontFace"] = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
								KeyBindType["8"]["TextSize"] = 13;
								KeyBindType["8"]["TextColor3"] = Color3.fromRGB(165, 164, 167);
								KeyBindType["8"]["Size"] = UDim2.new(1, 0, 0, 18);
								KeyBindType["8"]["Active"] = true;
								KeyBindType["8"]["Text"] = options.Name.." - "..KeyBind.CurrentKeybind
								KeyBindType["8"]["Name"] = [[held]];
								KeyBindType["8"]["BackgroundTransparency"] = 1;

								local Connection1
								local Connection2
								Connection1 = RunService.RenderStepped:Connect(function()
									options.CallBack(KeyBindType.Held)
								end)
								Connection2 = input.Changed:Connect(function(prop)
									if prop == "UserInputState" then
										Connection1:Disconnect()
										Connection2:Disconnect()
										--print(KeyBindUi["8"].Name)
										if KeyBindType["8"] then KeyBindType["8"]:Destroy() end
										KeyBindType["8"] = nil
										KeyBindType.Held = false
									end
								end)
							else
								warn("Vania to be pizda blyati")
							end

						end

					end)

				end

				return KeyBind ,KeyBindType, KeyBindSelect

			end

			function FRAME:Toggle(options) -- done

				options = Utility:ValidateOptions({
					Name = "No name",
					CallBack = function() print("No callback :3") end
				}, options or {})

				local Toggle = {
					Hover = false,
					State = false
				}

				-- render

				do

					-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab6frames.ScrollingFrame.frameleft.leftframe1.leftframeoutline1.leftutilitesframe1.WaterMarkButton
					Toggle["8b"] = Instance.new("Frame", FRAME["83"]);
					Toggle["8b"]["BackgroundColor3"] = Color3.fromRGB(164, 164, 164);
					Toggle["8b"]["Size"] = UDim2.new(0, 13, 0, 13);
					Toggle["8b"]["BorderColor3"] = Color3.fromRGB(51, 51, 51);
					Toggle["8b"]["Name"] = [[Toggle]];

					-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab6frames.ScrollingFrame.frameleft.leftframe1.leftframeoutline1.leftutilitesframe1.WaterMarkButton.togglebutton
					Toggle["8c"] = Instance.new("Frame", Toggle["8b"]);
					Toggle["8c"]["BackgroundColor3"] = Color3.fromRGB(13, 13, 13);
					Toggle["8c"]["Size"] = UDim2.new(1, -2, 1, -2);
					Toggle["8c"]["Name"] = [[Toggle]];
					Toggle["8c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Toggle["8c"]["Position"] = UDim2.new(0, 1, 0, 1);

					-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab6frames.ScrollingFrame.frameleft.leftframe1.leftframeoutline1.leftutilitesframe1.WaterMarkButton.TextLabel
					Toggle["8e"] = Instance.new("TextLabel", Toggle["8b"]);
					Toggle["8e"]["TextStrokeTransparency"] = 0;
					Toggle["8e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					Toggle["8e"]["TextXAlignment"] = Enum.TextXAlignment.Left;
					Toggle["8e"]["FontFace"] = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					Toggle["8e"]["TextSize"] = 14;
					Toggle["8e"]["TextColor3"] = textcolor2;
					Toggle["8e"]["Size"] = UDim2.new(0, 0, 1, 0);
					Toggle["8e"]["Text"] = options.Name;
					Toggle["8e"]["BackgroundTransparency"] = 1;
					Toggle["8e"]["Name"] = [[Toggle]];
					Toggle["8e"]["Position"] = UDim2.new(1.7999999523162842, 0, 0, 0);

				end

				-- logic 

				do

					Toggle["8c"].InputBegan:Connect(function(input, gpe)
						if gpe then return end
						if input.UserInputType == Enum.UserInputType.MouseButton1 and Utility:IsMouseOver(Toggle["8c"]) then
							Toggle.State = not Toggle.State
							if Toggle.State then
								Toggle["8c"]["BackgroundColor3"] = Color3.fromRGB(60, 60, 60)
							else
								Toggle["8c"]["BackgroundColor3"] = Color3.fromRGB(12, 12, 12)
							end
							options.CallBack(Toggle.State)
						end
					end)

				end

				return Toggle

			end

			function FRAME:Division(options) -- done

				options = Utility:ValidateOptions({
					Name = "No name"
				}, options or {})

				local Divison = {}

				-- render

				do

					-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab6frames.ScrollingFrame.frameleft.leftframe1.leftframeoutline1.leftutilitesframe1.KeyBinds
					Divison["a1"] = Instance.new("Frame", FRAME["83"]);
					Divison["a1"]["BackgroundColor3"] = Color3.fromRGB(134, 134, 134);
					Divison["a1"]["BackgroundTransparency"] = 1;
					Divison["a1"]["Size"] = UDim2.new(1, -4, 0, 13);
					Divison["a1"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Divison["a1"]["Position"] = UDim2.new(0, -1, 0, -1);
					Divison["a1"]["Name"] = [[Division]];

					-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab6frames.ScrollingFrame.frameleft.leftframe1.leftframeoutline1.leftutilitesframe1.KeyBinds.leftframename1
					Divison["a4"] = Instance.new("TextLabel", Divison["a1"]);
					Divison["a4"]["TextStrokeTransparency"] = 0;
					Divison["a4"]["ZIndex"] = 2;
					Divison["a4"]["BorderSizePixel"] = 0;
					Divison["a4"]["FontFace"] = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					Divison["a4"]["TextSize"] = 13;
					Divison["a4"]["TextColor3"] = textcolor2;
					Divison["a4"]["Size"] = UDim2.new(1, 0, 0, 0);
					Divison["a4"]["Active"] = true;
					Divison["a4"]["Text"] = options.Name;
					Divison["a4"]["Name"] = [[Division]];
					Divison["a4"]["BackgroundTransparency"] = 1;
					Divison["a4"]["Position"] = UDim2.new(0, 0, 0.5, 0);

					local x, y = Utility:GetTextBounds(options.Name,Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal),13)
					local aside = ((215-x)/2)-5

					-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab6frames.ScrollingFrame.frameleft.leftframe1.leftframeoutline1.leftutilitesframe1.KeyBinds.onesideofpartitionframe1
					Divison["a2"] = Instance.new("Frame", Divison["a1"]);
					Divison["a2"]["BackgroundColor3"] = Color3.fromRGB(134, 134, 134);
					Divison["a2"]["Size"] = UDim2.new(0, aside, 0, 1);
					Divison["a2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Divison["a2"]["Position"] = UDim2.new(0, 0, 0.5, 0);
					Divison["a2"]["Name"] = [[Division]];

					-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab6frames.ScrollingFrame.frameleft.leftframe1.leftframeoutline1.leftutilitesframe1.KeyBinds.onesideofpartitionframe2
					Divison["a3"] = Instance.new("Frame", Divison["a1"]);
					Divison["a3"]["BackgroundColor3"] = Color3.fromRGB(134, 134, 134);
					Divison["a3"]["Size"] = UDim2.new(0, aside, 0, 1);
					Divison["a3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					Divison["a3"]["Position"] = UDim2.new(1, -aside, 0.5, 0);
					Divison["a3"]["Name"] = [[Division]];

				end

				return Divison

			end

			function FRAME:TextBox(options) -- done

				options = Utility:ValidateOptions({
					Name = "No name",
					PlaceHolderText = "No placeholder text",
					CallBack = function() print("No callback :3") end
				}, options or {})

				local TextBox = {}

				-- render

				do

					-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab6frames.ScrollingFrame.frameleft.leftframe1.leftframeoutline1.leftutilitesframe1.WaterMarkText
					TextBox["9b"] = Instance.new("TextLabel", FRAME["83"]);
					TextBox["9b"]["TextStrokeTransparency"] = 0;
					TextBox["9b"]["ZIndex"] = 2;
					TextBox["9b"]["BorderSizePixel"] = 0;
					TextBox["9b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
					TextBox["9b"]["FontFace"] = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					TextBox["9b"]["TextSize"] = 13;
					TextBox["9b"]["TextColor3"] = Color3.fromRGB(164, 163, 166);
					TextBox["9b"]["Size"] = UDim2.new(1, 0, 0, 18);
					TextBox["9b"]["Active"] = true;
					TextBox["9b"]["Text"] = options.Name;
					TextBox["9b"]["Name"] = [[TextBox]];
					TextBox["9b"]["BackgroundTransparency"] = 1;
					TextBox["9b"]["Position"] = UDim2.new(0, 4, 0, 0);

					-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab6frames.ScrollingFrame.frameleft.leftframe1.leftframeoutline1.leftutilitesframe1.CustomWaterMark
					TextBox["99"] = Instance.new("Frame", FRAME["83"]);
					TextBox["99"]["BackgroundColor3"] = Color3.fromRGB(164, 164, 164);
					TextBox["99"]["Size"] = UDim2.new(0, 215, 0, 20);
					TextBox["99"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					TextBox["99"]["Name"] = [[TextBox]];

					-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab6frames.ScrollingFrame.frameleft.leftframe1.leftframeoutline1.leftutilitesframe1.CustomWaterMark.textbox
					TextBox["9a"] = Instance.new("TextBox", TextBox["99"]);
					TextBox["9a"]["TextStrokeTransparency"] = 0;
					TextBox["9a"]["PlaceholderColor3"] = Color3.fromRGB(179, 179, 179);
					TextBox["9a"]["PlaceholderText"] = options.PlaceHolderText;
					TextBox["9a"]["TextSize"] = 13;
					TextBox["9a"]["BackgroundColor3"] = Color3.fromRGB(13, 13, 13);
					TextBox["9a"]["TextColor3"] = Color3.fromRGB(164, 163, 166);
					TextBox["9a"]["FontFace"] = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					TextBox["9a"]["Size"] = UDim2.new(1, -2, 1, -2);
					TextBox["9a"]["BorderColor3"] = Color3.fromRGB(51, 51, 51);
					TextBox["9a"]["Text"] = [[]];
					TextBox["9a"]["Position"] = UDim2.new(0, 1, 0, 1);
					TextBox["9a"]["Name"] = [[TextBox]];

				end

				-- logic

				do

					TextBox["9a"].FocusLost:Connect(function()
						task.spawn(function()
							options.CallBack(TextBox["9a"].Text)
						end)
					end)

				end

				return TextBox

			end

			function FRAME:Slider(options)

				options = Utility:ValidateOptions({
					Name = "No name:",
					Default = 5,
					Min = 0,
					Max = 100,
					CallBack = function() print("No callback :3") end
				}, options or {})

				local Slider = {
					AtMommentValue = nil
				}

				-- render

				do

					-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab6frames.ScrollingFrame.frameright.rightframe3.rightframeoutline2.leftutilitesframe2.Amount
					Slider["10d"] = Instance.new("TextLabel", FRAME["83"]);
					Slider["10d"]["TextStrokeTransparency"] = 0;
					Slider["10d"]["ZIndex"] = 2;
					Slider["10d"]["BorderSizePixel"] = 0;
					Slider["10d"]["TextXAlignment"] = Enum.TextXAlignment.Left;
					Slider["10d"]["FontFace"] = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					Slider["10d"]["TextSize"] = 13;
					Slider["10d"]["TextColor3"] = Color3.fromRGB(134, 134, 134);
					Slider["10d"]["LayoutOrder"] = 1;
					Slider["10d"]["Size"] = UDim2.new(1, 0, 0, 13);
					Slider["10d"]["Active"] = true;
					Slider["10d"]["Text"] = options.Name;
					Slider["10d"]["Name"] = [[Amount]];
					Slider["10d"]["BackgroundTransparency"] = 1;
					Slider["10d"]["Position"] = UDim2.new(0, 4, 0, 0);

					-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab6frames.ScrollingFrame.frameright.rightframe3.rightframeoutline2.leftutilitesframe2.Amount.leftframename1
					Slider["10e"] = Instance.new("TextLabel", Slider["10d"]);
					Slider["10e"]["TextStrokeTransparency"] = 0;
					Slider["10e"]["ZIndex"] = 2;
					Slider["10e"]["BorderSizePixel"] = 0;
					Slider["10e"]["TextXAlignment"] = Enum.TextXAlignment.Left;
					Slider["10e"]["FontFace"] = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					Slider["10e"]["TextSize"] = 13;
					Slider["10e"]["TextColor3"] = Color3.fromRGB(134, 134, 134);
					Slider["10e"]["LayoutOrder"] = 5;
					Slider["10e"]["Active"] = true;
					Slider["10e"]["Text"] = [[-]];
					Slider["10e"]["Name"] = [[framename1]];
					Slider["10e"]["BackgroundTransparency"] = 1;
					Slider["10e"]["Position"] = UDim2.new(0.8600000143051147, 0, 0.5, 0);
					Slider["10e"]["TextXAlignment"] = "Center"
					Slider["10e"]["AnchorPoint"] = Vector2.new(0.5,0.5)
					Slider["10e"]["Size"] = UDim2.new(0, 14, 0, 14)

					-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab6frames.ScrollingFrame.frameright.rightframe3.rightframeoutline2.leftutilitesframe2.Amount.leftframename2
					Slider["10f"] = Instance.new("TextLabel", Slider["10d"]);
					Slider["10f"]["TextStrokeTransparency"] = 0;
					Slider["10f"]["ZIndex"] = 2;
					Slider["10f"]["BorderSizePixel"] = 0;
					Slider["10f"]["TextXAlignment"] = Enum.TextXAlignment.Left;
					Slider["10f"]["FontFace"] = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					Slider["10f"]["TextSize"] = 13;
					Slider["10f"]["TextColor3"] = Color3.fromRGB(134, 134, 134);
					Slider["10f"]["LayoutOrder"] = 5;
					Slider["10f"]["Active"] = true;
					Slider["10f"]["Text"] = [[+]];
					Slider["10f"]["Name"] = [[framename2]];
					Slider["10f"]["BackgroundTransparency"] = 1;
					Slider["10f"]["Position"] = UDim2.new(0.9399999976158142, 0, 0.5, 0);
					Slider["10f"]["TextXAlignment"] = "Center"
					Slider["10f"]["AnchorPoint"] = Vector2.new(0.5,0.5)
					Slider["10f"]["Size"] = UDim2.new(0, 14, 0, 14)

					-- the sldier part

					-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab6frames.ScrollingFrame.frameright.rightframe3.rightframeoutline2.leftutilitesframe2.Slider
					Slider["111"] = Instance.new("Frame", FRAME["83"]);
					Slider["111"]["BackgroundColor3"] = Color3.fromRGB(13, 13, 13);
					Slider["111"]["LayoutOrder"] = 2;
					Slider["111"]["Size"] = UDim2.new(0, 215, 0, 14);
					Slider["111"]["BorderColor3"] = Color3.fromRGB(51, 51, 51);
					Slider["111"]["Name"] = [[Slider]];

					-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab6frames.ScrollingFrame.frameright.rightframe3.rightframeoutline2.leftutilitesframe2.Slider.innerframe
					Slider["112"] = Instance.new("Frame", Slider["111"]);
					Slider["112"]["Active"] = true;
					Slider["112"]["BorderSizePixel"] = 0;
					Slider["112"]["BackgroundColor3"] = Color3.fromRGB(134, 134, 134);
					Slider["112"]["Size"] = UDim2.new(0.30000001192092896, -2, 1, -2);
					Slider["112"]["Selectable"] = true;
					Slider["112"]["BorderColor3"] = Color3.fromRGB(50, 50, 50);
					Slider["112"]["Position"] = UDim2.new(0, 1, 0, 1);
					Slider["112"]["Name"] = [[innerframe]];
					Slider["112"]["ZIndex"] = 2;

					-- StarterGui.Folder.DevAmpliedChat.mainframe1.main.frame1outline.frame1.tabframes.tab6frames.ScrollingFrame.frameright.rightframe3.rightframeoutline2.leftutilitesframe2.Slider.leftframename1
					Slider["113"] = Instance.new("TextLabel", Slider["111"]);
					Slider["113"]["TextStrokeTransparency"] = 0;
					Slider["113"]["ZIndex"] = 2;
					Slider["113"]["BorderSizePixel"] = 0;
					Slider["113"]["FontFace"] = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					Slider["113"]["TextSize"] = 13;
					Slider["113"]["TextColor3"] = Color3.fromRGB(134, 134, 134);
					Slider["113"]["LayoutOrder"] = 5;
					Slider["113"]["Active"] = true;
					Slider["113"]["Text"] = options.Default.."%";
					Slider["113"]["Name"] = [[framename1]];
					Slider["113"]["BackgroundTransparency"] = 1;
					Slider["113"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);

				end


				-- logic

				do

					local function calculation()
						local percentage = math.clamp((Mouse.X - (Slider["111"].AbsolutePosition.X-2)) / (Slider["111"].AbsoluteSize.X-2), 0, 1)
						local value = ((options.Max - options.Min) * percentage) + options.Min
						value = math.floor(value)
						return value, percentage
					end

					local function percentagecalculation(value)
						local percentage = (value - options.Min) / (options.Max - options.Min)
						percentage = math.clamp(percentage, 0, 1)
						return percentage
					end

					local function valuecalculation(percentage)
						local value = (percentage * (options.Max - options.Min)) + options.Min
						value = math.floor(value)
						return value
					end

					Slider["112"].Size = UDim2.new(percentagecalculation(options.Default),-2,1, -2)

					Slider.AtMommentValue = options.Default

					game:GetService("UserInputService").InputBegan:connect(function(input)
						local Connection1
						local Connection2
						Connection1 = RunService.RenderStepped:Connect(function()
							if input.UserInputType == Enum.UserInputType.MouseButton1 and Utility:IsMouseOver(Slider["111"]) then
								_G.WindowDraggable = false
								local value, percentage = calculation()
								Slider["112"].Size = UDim2.new(percentage,-2,1, -2)
								Slider["113"].Text = value.."%"
								Slider.AtMommentValue = value
								options.CallBack(value)
							end
						end)
						Connection2 = input.Changed:Connect(function(prop)
							if prop == "UserInputState" then
								_G.WindowDraggable = true
								Connection1:Disconnect()
								Connection2:Disconnect()
							end
						end)

						if input.UserInputType == Enum.UserInputType.MouseButton1 and Utility:IsMouseOver(Slider["10e"]) then -- the minus
							local percentage = percentagecalculation(Slider.AtMommentValue - 5)
							local value = valuecalculation(percentage)
							print(percentage)
							if Utility:isNearZero(percentage, 0.05) then
								percentage = 0  
								Slider["112"].Size = UDim2.new(percentage,0,1, -2)
							else
								Slider["112"].Size = UDim2.new(percentage,-2,1, -2)
							end
							Slider.AtMommentValue = value
							Slider["113"].Text = value.."%"
							options.CallBack(value)
						elseif input.UserInputType == Enum.UserInputType.MouseButton1 and Utility:IsMouseOver(Slider["10f"]) then -- the plus
							local percentage = percentagecalculation(Slider.AtMommentValue + 5)
							local value = valuecalculation(percentage)
							Slider.AtMommentValue = value
							Slider["112"].Size = UDim2.new(percentage,-2,1, -2)
							Slider["113"].Text = value.."%"
							options.CallBack(value)
						end

					end)


				end


			end

			function FRAME:DropDown(options) 

			end

			function FRAME:Color(options)

			end

			return FRAME

		end

		return TAB 

	end

	return GUI , KeyBinds
end

do
	-- Ui

	local main = Library:New({})

	-- Tabs

	local tab1 = main:CreatTab({
		Name = "AimBot"
	})

	local tab2 = main:CreatTab({
		Name = "RageBot"
	})

	local tab3 = main:CreatTab({
		Name = "Visuals"
	})

	local tab4 = main:CreatTab({
		Name = "Skins"
	})

	local tab5 = main:CreatTab({
		Name = "Misc"
	})

	local tab6 = main:CreatTab({
		Name = "Other"
	})


	-- tab 1 Aimbot

	local frame1 = tab1:CreateFrame({
		Name = "Aimbot",
		Side = "left",
		SizeY = 200
	})

	local frame2 = tab1:CreateFrame({
		Name = "TriggerBot",
		Side = "left",
		SizeY = 400
	})

	local frame3 = tab1:CreateFrame({
		Name = "Others",
		Side = "right",
		SizeY = 350
	})

	-- tab 2 RageBot

	local frame4 = tab2:CreateFrame({
		Name = "Ragebot",
		Side = "left",
		SizeY = 350
	})

	local frame5 = tab2:CreateFrame({
		Name = "Anti Aim",
		Side = "right",
		SizeY = 400
	})

	local frame6 = tab2:CreateFrame({
		Name = "Fake Lag",
		Side = "left",
		SizeY = 400
	})

	local frame7 = tab2:CreateFrame({
		Name = "Other",
		Side = "right",
		SizeY = 350
	})

	-- tab 3 Visuals

	local frame8 = tab3:CreateFrame({
		Name = "Player ESP",
		Side = "left",
		SizeY = 350
	})

	local frame9 = tab3:CreateFrame({
		Name = "Enemy ESP",
		Side = "left",
		SizeY = 400
	})

	local frame10 = tab3:CreateFrame({
		Name = "Other ESP",
		Side = "right",
		SizeY = 350
	})

	local frame11 = tab3:CreateFrame({
		Name = "Misc",
		Side = "right",
		SizeY = 300
	})

	-- tab 4 Skins

	local frame12 = tab4:CreateFrame({
		Name = "Gun Skins",
		Side = "left",
		SizeY = 250
	})

	local frame13 = tab4:CreateFrame({
		Name = "Gloves",
		Side = "left",
		SizeY = 300
	})

	local frame14 = tab4:CreateFrame({
		Name = "Player",
		Side = "right",
		SizeY = 400
	})


	-- tab 5 Misc

	local frame15 = tab5:CreateFrame({
		Name = "Movement",
		Side = "left",
		SizeY = 350
	})

	local frame16 = tab5:CreateFrame({
		Name = "Gun modifications",
		Side = "left",
		SizeY = 400
	})

	local frame17 = tab5:CreateFrame({
		Name = "Others",
		Side = "right",
		SizeY = 400
	})

	-- tab 6 Other

	local frame15 = tab6:CreateFrame({
		Name = "Menu",
		Side = "left",
		SizeY = 273
	})

	local frame16 = tab6:CreateFrame({
		Name = "Config",
		Side = "right",
		SizeY = 180
	})

	local frame17 = tab6:CreateFrame({
		Name = "Notify",
		Side = "left",
		SizeY = 333
	})

	local frame18 = tab6:CreateFrame({
		Name = "Other",
		Side = "right",
		SizeY = 143
	})

	-- Ui Lib Using Part

	local keybind1 = frame15:KeyBind({
		Name = "Menu",
		KeyBindType = "Toggle",
		Options = "None",
		CallBack = function()
			GUI["2"]["Visible"] = not GUI["2"]["Visible"]
		end
	})

	local buttontest1 = frame15:Button({
		Name = "Unload",
		CallBack = function()
		end
	})

	local toggle1 = frame15:Toggle({
		Name = "Force Unload",
		CallBack = function(state)
		end
	})

	local division1 = frame15:Division({
		Name = "Watermark"
	})

	local buttontest2 = frame15:Toggle({
		Name = "Watermark",
		CallBack = function()
		end
	})

	local textbox1 = frame15:TextBox({
		Name = "Custom watermark text:",
		PlaceHolderText = "fuck em jhon",
		CallBack = function(text) end
	})

	local division2 = frame15:Division({
		Name = "Keybinds"
	})

	local toggle2 = frame15:Toggle({
		Name = "Keybinds",
		CallBack = function(state)
			KeyBinds["1"]["Enabled"] = not KeyBinds["1"]["Enabled"]
		end
	})

	local toggle3 = frame15:Toggle({
		Name = "Keybind State",
		CallBack = function(state)
			if state then
			else
			end
		end
	})

	local keybind2 = frame15:KeyBind({
		Name = "Allways",
		KeyBindType = "Allways",
		Options = "All",
		CallBack = function()
			print("on")
		end
	})

	local keybind3 = frame15:KeyBind({
		Name = "Toggle",
		KeyBindType = "Toggle",
		Options = "All",
		CallBack = function(state)
			if state then
				print("on")
			else
				print("off")
			end
		end
	})

	local keybind4 = frame15:KeyBind({
		Name = "Held",
		KeyBindType = "Held",
		Options = "All",
		CallBack = function(state)
			if state then
				print("on")
				task.wait()
			end
		end
	})
		
	local slider = frame1:Slider({
		Name = "Test:",
		Default = 50,
		Min = 0,
		Max = 100,
		CallBack = function(value) print(value) end
	})


end
