-- // Shhit 
repeat 
	task.wait() 
until game:IsLoaded()

local Load = tick()
--local MenuName = isfile("netcut/menuname.txt") and readfile("netcut/menuname.txt") or nil
local Name = "admin_test"

--if getgenv().Util ~= nil thena
--	getgenv().Util:Unload()
--end

-- // Vars
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
local ViewportSize = Camera.ViewportSize
local CoreGui = RunService:IsStudio() and LocalPlayer:WaitForChild("PlayerGui") --or gethui()
--local request = http and http.request or http_request or request or httprequest
--local getcustomasset = getcustomasset 
--local isfolder = isfolder or is_folder
--local makefolder = makefolder or make_folder or createfolder or create_folder
RunService.RenderStepped:Connect(function()
	Camera = workspace.CurrentCamera
end)

-- // Util
local Util = {
	opened = true;
	connections = {};
	notification_main = nil;
	signal = require(script.Parent:WaitForChild("Signal"));
	watermarks = {};
	copied_clr = nil;
	friends = {};
	priority = {};
	muted = {};
	spectating = false;
	themes = {
		usual = {
			Black = Color3.fromRGB(0,0,0);
			BackGround_Color = Color3.fromRGB(12, 12, 12);
			Accent_Color = Color3.fromRGB(134, 134, 134);
			Accent_Color_1 = Color3.fromRGB(164, 164, 164);
			Base_Color = Color3.fromRGB(50, 50, 50);
			Border_Color = Color3.fromRGB(69, 69, 69);
		};
		dark_minimalistic = {
			Black = Color3.fromRGB(0, 0, 0),
			BackGround_Color = Color3.fromRGB(18, 18, 18),
			Accent_Color = Color3.fromRGB(100, 100, 100),
			Accent_Color_1 = Color3.fromRGB(150, 150, 150),
			Base_Color = Color3.fromRGB(40, 40, 40),
			Border_Color = Color3.fromRGB(60, 60, 60),
		};
		cybepunk = {
			Black = Color3.fromRGB(0, 0, 0),
			BackGround_Color = Color3.fromRGB(10, 10, 20),
			Accent_Color = Color3.fromRGB(255, 0, 128),  -- Pink
			Accent_Color_1 = Color3.fromRGB(0, 255, 255),  -- Cyan
			Base_Color = Color3.fromRGB(30, 30, 50),
			Border_Color = Color3.fromRGB(80, 80, 120),
		};
		neon = {
			Black = Color3.fromRGB(0, 0, 0),
			BackGround_Color = Color3.fromRGB(20, 20, 20),
			Accent_Color = Color3.fromRGB(0, 255, 0),  -- Green
			Accent_Color_1 = Color3.fromRGB(255, 0, 0),  -- Red
			Base_Color = Color3.fromRGB(40, 40, 40),
			Border_Color = Color3.fromRGB(255, 255, 0),  -- Yellow
		};
		pastel = {
			Black = Color3.fromRGB(0, 0, 0),
			BackGround_Color = Color3.fromRGB(240, 240, 240),
			Accent_Color = Color3.fromRGB(255, 182, 193),  -- Pink
			Accent_Color_1 = Color3.fromRGB(173, 216, 230),  -- Light Blue
			Base_Color = Color3.fromRGB(255, 255, 255),
			Border_Color = Color3.fromRGB(200, 200, 200),
		};
		monochrome = {
			Black = Color3.fromRGB(0, 0, 0),
			BackGround_Color = Color3.fromRGB(25, 25, 25),
			Accent_Color = Color3.fromRGB(150, 150, 150),
			Accent_Color_1 = Color3.fromRGB(200, 200, 200),
			Base_Color = Color3.fromRGB(50, 50, 50),
			Border_Color = Color3.fromRGB(100, 100, 100),
		};
		ocean = {
			Black = Color3.fromRGB(0, 0, 0),
			BackGround_Color = Color3.fromRGB(10, 20, 30),
			Accent_Color = Color3.fromRGB(0, 150, 200),  -- Blue
			Accent_Color_1 = Color3.fromRGB(0, 255, 255),  -- Cyan
			Base_Color = Color3.fromRGB(20, 40, 60),
			Border_Color = Color3.fromRGB(0, 100, 150),
		};
		fire = {
			Black = Color3.fromRGB(0, 0, 0),
			BackGround_Color = Color3.fromRGB(30, 10, 10),
			Accent_Color = Color3.fromRGB(255, 100, 0),  -- Orange
			Accent_Color_1 = Color3.fromRGB(255, 0, 0),  -- Red
			Base_Color = Color3.fromRGB(50, 20, 20),
			Border_Color = Color3.fromRGB(255, 50, 0),
		};
	};
}

local keyNames = {
	[Enum.KeyCode.LeftAlt] = 'LALT';
	[Enum.KeyCode.RightAlt] = 'RALT';
	[Enum.KeyCode.LeftControl] = 'LCTRL';
	[Enum.KeyCode.RightControl] = 'RCTRL';
	[Enum.KeyCode.LeftShift] = 'LSHIFT';
	[Enum.KeyCode.RightShift] = 'RSHIFT';
	[Enum.KeyCode.Underscore] = '_';
	[Enum.KeyCode.Minus] = '-';
	[Enum.KeyCode.Plus] = '+';
	[Enum.KeyCode.Period] = '.';
	[Enum.KeyCode.Slash] = '/';
	[Enum.KeyCode.BackSlash] = '\\';
	[Enum.KeyCode.Question] = '?';
	[Enum.UserInputType.MouseButton1] = 'MB1';
	[Enum.UserInputType.MouseButton2] = 'MB2';
	[Enum.UserInputType.MouseButton3] = 'MB3';
}

Util.__index = Util

-- // Signals
Util.unloadedSignal    = Util.signal.new()
Util.themeSignal       = Util.signal.new()

-- // Funcs 
function Util:GetTextBounds(Text, Font, Size)
	local params = Instance.new("GetTextBoundsParams")
	params.Text = Text
	params.Font = Font
	params.Size = Size
	params.Width = 0
	local Bounds = TextService:GetTextBoundsAsync(params)
	return Bounds.X, Bounds.Y
end;

function Util:RandomString(length)
	local characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local randomString = ""
	local charCount = string.len(characters)

	for i = 1, length do
		local randomIndex = math.random(1, charCount)
		randomString = randomString .. string.sub(characters, randomIndex, randomIndex)
	end

	return randomString
end;

function Util:MakeFrameDraggable(Object, Cutoff)
	local dragInput    = nil
	local dragStart    = nil
	local startPos = nil
	local Dragging = false
	local preparingToDrag = false


	local function update(input)
		local delta = input.Position - dragStart
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)

		TweenService:Create(Object, TweenInfo.new(0.250), {
			Position = position
		}):Play()

		return position
	end


	Object.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			preparingToDrag = true

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End and (Dragging or preparingToDrag) then
					Dragging = false
					preparingToDrag = false
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
		if preparingToDrag then
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

function Util:IsMouseOver(Frame)
	local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize

	if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X
		and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then

		return true;
	end
end

function Util:Connection(signal, func)
	local c = signal:Connect(func)
	table.insert(Util.connections, c)
	return c
end

function Util:Unload()
	Util.unloadedSignal:Fire();
	
	for _,c in next, self.connections do
		c:Disconnect()
	end
	
end

function Util:ValidateOptions(defaults, options)
	for i, v in pairs(defaults) do
		if options[i] == nil then
			options[i] = v
		end
	end;
	return options
end

function Util:Create(class, properties)

	local __meta = setmetatable({}, Util) 		 -- __meta is equal to a table {} that has Util in it
	__meta.Object = Instance.new(class)  		 -- __meta.object = to the instance of the class gave

	for i, v in next, properties do		    	 -- i = the propriety and v the value of it
		__meta.Object[i] = v			    	 -- we giving it the value
		
		if i == "BackgroundColor3" then
			Util:Connection(Util.themeSignal, function(text)
				for _,table in pairs(Util.themes) do
					for name,value in pairs(table) do
						if __meta.Object.BackgroundColor3 == value then
							__meta.Object[i] = Util.themes[text][name];
						end
					end
					
				end
			end)
		elseif i == "BorderColor3" then
			Util:Connection(Util.themeSignal, function(text)
				for _,table in pairs(Util.themes) do
					for name,value in pairs(table) do
						if __meta.Object.BorderColor3 == value then
							__meta.Object[i] = Util.themes[text][name];
						end
					end
				end
			end)
		end
		
	end

	return __meta							  	 -- we return __meta
end

-- // Methods

Util.Properties = function(self, properties)
	for i, v in next, properties do
		self.Object[i] = v
	end
end

Util.Delete = function(self)
	self.Object:Destroy()
end

Util.Clone = function(self)
	return self.Object:Clone()
end

Util.Get = function(self)
	return self.Object
end

-- // Creating 

function Util:Window(options)

	local window = {
		current = nil;
	}

	options = Util:ValidateOptions({
		Name = Util:RandomString(1000);
		Size = UDim2.fromOffset(516, 516)
	}, options or {})

	window.screengui = Util:Create("ScreenGui",{
		Name = Util:RandomString(math.random(0,1000));
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
		Parent = CoreGui
	})

	window.mainframe = Util:Create("Frame",{
		Name = Util:RandomString(math.random(0,1000));
		Active = true;
		BorderSizePixel = 0;
		BackgroundColor3 = Util.themes.usual.Black;
		AnchorPoint = Vector2.new(0.5, 0.5);
		Size = options.Size;
		Selectable = true; 
		Position = UDim2.new(0.5,0,0.5,0);
		Parent =  window.screengui:Get()
	})
	
	window.main = Util:Create("Frame",{
		Name = Util:RandomString(math.random(0,1000));
		Active = true;
		BorderSizePixel = 1;
		BackgroundColor3 = Util.themes.usual.BackGround_Color;
		Size = UDim2.new(1, -4, 1, -4);
		Selectable = true;
		BorderColor3 = Util.themes.usual.Accent_Color;
		Position = UDim2.new(0, 2, 0, 2);
		Parent =  window.mainframe:Get()
	})

	window.frameoutline = Util:Create("Frame",{
		Name = Util:RandomString(math.random(0,1000));
		Active = true;
		BorderSizePixel = 1;
		BackgroundColor3 = Util.themes.usual.BackGround_Color;
		Size = UDim2.new(1, -16, 1, -35);
		Selectable = true;
		BorderColor3 = Util.themes.usual.Base_Color;
		Position = UDim2.new(0, 8, 0, 26);
		Parent = window.main:Get()
	})

	window.frame = Util:Create("Frame",{
		Name = Util:RandomString(math.random(0,1000));
		Active = true;
		BorderSizePixel = 1;
		BackgroundColor3 = Util.themes.usual.BackGround_Color;
		Size = UDim2.new(1, -2, 1, -2);
		Selectable = true;
		BorderColor3 = Util.themes.usual.Black;
		Position = UDim2.new(0, 1, 0, 1);
		Parent = window.frameoutline:Get()
	})

	window.netcut = Util:Create("TextLabel",{
		Name = Util:RandomString(math.random(0,1000));
		TextStrokeTransparency = 0;
		Active = true;
		BorderSizePixel = 0;
		TextXAlignment = Enum.TextXAlignment.Left;
		FontFace = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
		TextSize = 13;
		TextColor3 = Util.themes.usual.Accent_Color_1;
		--BackgroundColor3 = Util.themes.usual.BackgroundColor3_1;
		Selectable = true;
		--BorderColor3 = Util.themes.usual.BackgroundColor3;
		Text = ("net.cut|"..Name.."|"..LocalPlayer.Name);
		BackgroundTransparency = 1;
		Position = UDim2.new(0.02, 0,0.03, 0);
		ZIndex = 2;
		Parent = window.mainframe:Get()
	})

	window.tabbuttons = Util:Create("Frame",{
		Name = Util:RandomString(math.random(0,1000));
		Active = true;
		BorderSizePixel = 0;
		BackgroundColor3 = Util.themes.usual.BackGround_Color;
		Size = UDim2.new(1, -16, 0, 21);
		Selectable = true;
		--BorderColor3 = Util.themes.usual.BackgroundColor3;
		Position = UDim2.new(0, 8, 0, 8);
		Parent = window.frame:Get()
	})

	window.uilistlayout = Util:Create("UIListLayout",{
		Name = Util:RandomString(math.random(0,1000));
		FillDirection = Enum.FillDirection.Horizontal;
		SortOrder = Enum.SortOrder.LayoutOrder;
		Parent = window.tabbuttons:Get()
	})

	window.tabframes = Util:Create("Frame",{
		Name = Util:RandomString(math.random(0,1000));
		Active = true;
		BorderSizePixel = 1;
		BackgroundColor3 = Util.themes.usual.BackGround_Color;
		BorderColor3 = Util.themes.usual.Base_Color;
		Size = UDim2.new(1, -16, 1, -38);
		Position = UDim2.new(0, 8, 0, 30);
		Parent = window.frame:Get()
	})
	
	function window:Notify(Text, Time)

		-- notification frame && ui list layout

		if Util.notification_main == nil then 

			local notificationframe = Util:Create("Frame",{
				Name = Util:RandomString(math.random(0,1000));
				Active = true;
				ZIndex = 0;
				BorderSizePixel = 0;
				BackgroundColor3 = Util.themes.usual.Base_Color;
				BackgroundTransparency = 0.8;
				Size = UDim2.fromOffset(500,200);
				Selectable = true;
				BorderColor3 = Util.themes.usual.BackGround_Color;
				Position = UDim2.fromOffset(19,46);
				Parent = window.screengui:Get();
			})

			Util:MakeFrameDraggable(notificationframe:Get())

			Util.notification_main = notificationframe:Get()

			local notifyeruilist = Util:Create("UIListLayout",{
				Name = Util:RandomString(math.random(0,1000));
				Parent = notificationframe:Get();
				FillDirection = "Vertical";
				HorizontalAlignment = "Left";
				Padding = UDim.new(0, 4);
				SortOrder = "LayoutOrder";
				VerticalAlignment = "Top"
			})

		end

		-- the notification

		local notificationoutline = Util:Create("Frame",{
			Name = Util:RandomString(math.random(0,1000));
			Active = true;
			ZIndex = 0;
			BorderSizePixel = 1;
			BackgroundColor3 = Util.themes.usual.Base_Color;
			BackgroundTransparency = 0;
			Size = UDim2.new(0, 0, 0, 21);
			Selectable = true;
			BorderColor3 = Util.themes.usual.BackGround_Color;
			Position = UDim2.new(0, 1, 0, 1);
			Parent = Util.notification_main;
		})

		local notifyerline = Util:Create("Frame",{
			Name = Util:RandomString(math.random(0,1000));
			Active = true;
			ZIndex = 1;
			BorderSizePixel = 0;
			BackgroundColor3 = Util.themes.usual.Accent_Color;
			BackgroundTransparency = 0;
			Size = UDim2.new(0, 3, 1, 0);
			Selectable = true;
			BorderColor3 = Util.themes.usual.Black;
			Position = UDim2.new(0, -1, 0, 0);
			Parent = notificationoutline:Get()
		})

		local notifyermain = Util:Create("Frame",{
			Name = Util:RandomString(math.random(0,1000));
			Active = true;
			ZIndex = 0;
			BorderSizePixel = 0;
			BackgroundColor3 = Util.themes.usual.BackGround_Color;
			BackgroundTransparency = 0;
			Size = UDim2.new(1, -2, 1, -2);
			Selectable = true;
			BorderColor3 = Util.themes.usual.Base_Color;
			Position = UDim2.new(0, 1, 0, 1);
			Parent = notificationoutline:Get()
		})

		local notifyertext = Util:Create("TextLabel",{
			Name = Util:RandomString(math.random(0,1000));
			TextStrokeTransparency = 0;
			ZIndex = 2;
			BorderSizePixel = 0;
			TextXAlignment = Enum.TextXAlignment.Left;
			FontFace = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			TextSize = 13;
			TextColor3 = Util.themes.usual.Accent_Color;
			--BackgroundColor3 = Util.themes.usual.BackgroundColor3_1;
			--BorderColor3 = Util.themes.usual.BackgroundColor3;
			Text = (Text);
			BackgroundTransparency = 1;
			Position = UDim2.new(0, 5, 1, -10);
			Size = UDim2.new(0, 0, 0, 0);
			Parent =  notifyermain:Get()
		})

		task.spawn(function()

			local x , y = Util:GetTextBounds(Text,Font.new("rbxasset://fonts/families/Inconsolata.json"),13)

			notificationoutline:Get():TweenSize(UDim2.new(0, x + 10, 0, 21),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,1,true)

			wait(Time)

			local text = notifyertext:Get().Text

			while #text > 0 do
				text = string.sub(text, 1, #text - 1)
				notifyertext:Get().Text = text
				wait(0.05)
			end
			notifyertext.TextTransparency = 1

			notificationoutline:Get():TweenSize(UDim2.new(0, 0, 0, 21),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,1,true)

			wait(0.9)
			notificationoutline:Delete()

		end)

	end

	function window:CreateKeyBindUi()

		local keybindsui = {
		}

		keybindsui.mainframe = Util:Create("Frame",{
			Name = Util:RandomString(math.random(0,1000));
			Active = true;
			BorderSizePixel = 1;
			BackgroundColor3 = Util.themes.usual.BackGround_Color;
			BorderColor3 = Util.themes.usual.Base_Color;
			Size = UDim2.new(0, 182, 0, 20);
			Position = UDim2.new(0, 25, 0, 328);
			Visible = false;
			Parent = window.screengui:Get()
		})

		keybindsui.frameoutline = Util:Create("Frame",{
			Name = Util:RandomString(math.random(0,1000));
			Active = true;
			BorderSizePixel = 1;
			BackgroundColor3 = Util.themes.usual.BackGround_Color;
			BorderColor3 = Util.themes.usual.Black;
			Size = UDim2.new(1, -2, 1, -2);
			Position = UDim2.new(0, 1, 0, 1);
			Parent = keybindsui.mainframe:Get()
		})

		keybindsui.magicframe = Util:Create("Frame",{
			Name = Util:RandomString(math.random(0,1000));
			Active = true;
			BorderSizePixel = 1;
			BackgroundColor3 = Util.themes.usual.Accent_Color;
			BorderColor3 = Util.themes.usual.Base_Color;
			Size = UDim2.new(1, 2, 0, 1);
			Position = UDim2.new(0, -1, 0, -1);
			Parent = keybindsui.frameoutline:Get()
		})

		keybindsui.keybindname = Util:Create("TextLabel",{
			Name = Util:RandomString(math.random(0,1000));
			TextStrokeTransparency = 0;
			Active = true;
			BorderSizePixel = 0;
			TextXAlignment = Enum.TextXAlignment.Left;
			FontFace = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			TextSize = 13;
			TextColor3 = Util.themes.usual.Accent_Color;
			--BackgroundColor3 = Util.themes.usual.BackgroundColor3_1;
			Selectable = true;
			--BorderColor3 = Util.themes.usual.BackgroundColor3;
			Text = [[KeyBinds]];
			BackgroundTransparency = 1;
			Size = UDim2.new(1, 0, 0, 18);
			ZIndex = 2;
			Parent =  keybindsui.frameoutline:Get()
		})

		keybindsui.frame = Util:Create("Frame",{
			Name = Util:RandomString(math.random(0,1000));
			Active = true;
			BorderSizePixel = 1;
			BackgroundTransparency = 0.9;
			BackgroundColor3 = Util.themes.usual.BackGround_Color;
			BorderColor3 = Util.themes.usual.Base_Color;
			Size = UDim2.new(1, 0, 4, 0);
			Position = UDim2.new(0, 0, 1, 0);
			Parent = keybindsui.mainframe:Get()
		})

		keybindsui.frameuilist = Util:Create("UIListLayout",{
			Name = Util:RandomString(math.random(0,1000));
			SortOrder = Enum.SortOrder.LayoutOrder;
			Parent = keybindsui.frame:Get()
		})
		
		Util:MakeFrameDraggable(keybindsui.mainframe:Get())

		function window:KeyBindsVisible()

			keybindsui.mainframe:Get().Visible = not keybindsui.mainframe:Get().Visible

		end

		function window:AddKeybindLabel(Text,Key)

			local label = {}

			label.keybindlabel = Util:Create("TextLabel",{
				Name = Util:RandomString(math.random(0,1000));
				TextStrokeTransparency = 0;
				ZIndex = 2;
				BorderSizePixel = 0;
				TextXAlignment = Enum.TextXAlignment.Center;
				FontFace = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				TextSize = 13;
				TextColor3 = Util.themes.usual.Accent_Color;
				BackgroundColor3 = Util.themes.usual.BackGround_Color;
				BackgroundTransparency = 1;
				BorderColor3 = Util.themes.usual.Base_Color;
				Text = Text.." - "..Key; 
				Size = UDim2.new(1, 0, 0, 18);
				Position = UDim2.new(0, 4, 0, 0);
				Parent = keybindsui.frame:Get()
			})

			function label:Delete()
				
				label.keybindlabel:Get():Destroy()

				return nil
				
			end

			return label

		end

		return keybindsui

	end

	function window:CreateWatermarkUi()
		
		local watermarkui = {}
		
		watermarkui.watermark = Util:Create("Frame",{
			Name = Util:RandomString(math.random(0,1000));
			Active = true;
			BorderSizePixel = 1;
			BackgroundColor3 = Util.themes.usual.BackGround_Color;
			BorderColor3 = Util.themes.usual.Border_Color;
			Size = UDim2.new(0, 261, 0, 21);
			Position = UDim2.new(0, 18, 0, 267);
			Visible = false;
			ZIndex = 10;
			Parent = window.screengui:Get()
		})
		
		watermarkui.insideframe = Util:Create("Frame",{
			Name = Util:RandomString(math.random(0,1000));
			Active = true;
			BorderSizePixel = 1;
			BackgroundColor3 = Util.themes.usual.BackGround_Color;
			BorderColor3 = Util.themes.usual.Black;
			Size = UDim2.new(1, -2, 1, -2);
			Position = UDim2.new(0, 1,0, 1);
			Visible = true;
			ZIndex = 10;
			Parent = watermarkui.watermark:Get()
		})
		
		watermarkui.lineframe = Util:Create("Frame",{
			Name = Util:RandomString(math.random(0,1000));
			Active = true;
			BorderSizePixel = 0;
			BackgroundColor3 = Util.themes.usual.Accent_Color;
			BorderColor3 = Util.themes.usual.Black;
			Size = UDim2.new(1, 2, 0, 1);
			Position = UDim2.new(0, -1, 0, -1);
			Visible = true;
			ZIndex = 10;
			Parent = watermarkui.insideframe:Get()
		})
		
		watermarkui.text = Util:Create("TextLabel",{
			Name = Util:RandomString(math.random(0,1000));
			TextStrokeTransparency = 0;
			Active = true;
			BorderSizePixel = 0;
			TextXAlignment = Enum.TextXAlignment.Center;
			FontFace = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			TextSize = 13;
			TextColor3 = Util.themes.usual.Accent_Color;
			--BackgroundColor3 = Util.themes.usual.BackgroundColor3_1;
			Selectable = true;
			--BorderColor3 = Util.themes.usual.BackgroundColor3;
			Text = [[net.cut | admin_test | trocindavid]];
			BackgroundTransparency = 1;
			Size = UDim2.new(1, 0, 0, 18);
			ZIndex = 10;
			Parent =  watermarkui.insideframe:Get()
		})
		
		Util:MakeFrameDraggable(watermarkui.watermark:Get())
		
		function window:WatermarkVisible()

			watermarkui.watermark:Get().Visible = not watermarkui.watermark:Get().Visible

		end
		
		function window:Update(text)
			
			watermarkui.text:Get().Text = ("net.cut | "..text[2].." | "..text[1])
			
		end
		
		return watermarkui
		
	end

	function window:CreateTab(options)

		local tab = {
			active = nil;
			instances = {
				--	abmagicframe = tabmagicframe:Get();
				--	tabname = tabname:Get();
				--	tabframe = tabframe:Get();
			}
		}

		options = Util:ValidateOptions({
			Name = Util:RandomString(1000)
		}, options or {})

		local x , y = Util:GetTextBounds(options.Name,Font.new("rbxasset://fonts/families/Inconsolata.json"),13)

		local tabbutton = Util:Create("Frame",{
			Name = Util:RandomString(math.random(0,1000));		
			Active = true;
			BorderSizePixel = 1;
			BackgroundColor3 = Util.themes.usual.BackGround_Color;
			BorderColor3 = Util.themes.usual.Base_Color;
			Size = UDim2.new(0, x+10, 1, 0);
			Selectable = true;
			Position = UDim2.fromOffset(8, 8);
			Parent =  window.tabbuttons:Get()
		})

		local tabname = Util:Create("TextLabel",{
			Name = Util:RandomString(math.random(0,1000));
			TextStrokeTransparency = 0;
			ZIndex = 2;
			BorderSizePixel = 0;
			TextXAlignment = Enum.TextXAlignment.Center;
			FontFace = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			TextSize = 13;
			TextColor3 = Util.themes.usual.Accent_Color;
			--BackgroundColor3 = Util.themes.usual.BackgroundColor3_1;
			--BorderColor3 = Util.themes.usual.BackgroundColor3;
			Text = (options.Name);
			BackgroundTransparency = 1;
			Size = UDim2.new(1, 0, 1, -1);
			Parent =  tabbutton:Get()
		})

		local tabmagicframe = Util:Create("Frame",{
			Name = Util:RandomString(math.random(0,1000));	
			ZIndex = 2;	
			Active = true;
			BorderSizePixel = 0;
			BackgroundColor3 = Util.themes.usual.BackGround_Color;
			BorderColor3 = Util.themes.usual.BackGround_Color;
			BackgroundTransparency = 1;
			AnchorPoint = Vector2.new(0, 0);
			Size = UDim2.new(1, 0, 0, 1);
			Selectable = true;
			Position = UDim2.new(0, 0, 1, 0);
			Parent =  tabbutton:Get()
		})

		local tabframe = Util:Create("Frame",{
			Name = Util:RandomString(math.random(0,1000));	
			ZIndex = 1;	
			BorderSizePixel = 1;
			BackgroundColor3 = Util.themes.usual.BackGround_Color;
			BorderColor3 = Util.themes.usual.Base_Color;
			BackgroundTransparency = 0;
			Size = UDim2.new(1, 0, 1, 0);
			Visible = false;
			Parent =  window.tabframes:Get()
		})

		local scrollingframe = Util:Create("ScrollingFrame",{
			Name = Util:RandomString(math.random(0,1000));	
			Active = true;
			ScrollingDirection = Enum.ScrollingDirection.Y;
			ZIndex = 1;	
			CanvasSize = UDim2.new(0, 0, 0, 4);
			ScrollBarImageTransparency = 1;
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			--BackgroundColor3 = Util.themes.usual.BackgroundColor3_1;
			--BorderColor3 = Util.themes.usual.BorderColor3_1;
			AutomaticCanvasSize = Enum.AutomaticSize.Y;
			ClipsDescendants = true;
			Size = UDim2.new(1, 8, 1, 0);
			Parent =  tabframe:Get()
		})

		local frameleft = Util:Create("Frame",{
			Name = Util:RandomString(math.random(0,1000));	
			ZIndex = 1;	
			BorderSizePixel = 0;
			--BackgroundColor3 = Util.themes.usual.BackgroundColor3_1;
			--BorderColor3 = Util.themes.usual.BorderColor3_1;
			BackgroundTransparency = 1;
			AutomaticSize = Enum.AutomaticSize.Y;
			Size = UDim2.new(0, 225, 0, 800);
			Position = UDim2.new(0, 10, 0, 8);
			Parent =  scrollingframe:Get()
		})

		local frameleftui = Util:Create("UIListLayout",{
			Name = Util:RandomString(math.random(0,1000));	
			Padding = UDim.new(0, 8);
			SortOrder = Enum.SortOrder.LayoutOrder;
			Parent =  frameleft:Get()
		})

		local frameright = Util:Create("Frame",{
			Name = Util:RandomString(math.random(0,1000));	
			ZIndex = 1;	
			BorderSizePixel = 0;
			--BackgroundColor3 = Util.themes.usual.BackgroundColor3_1;
			--BorderColor3 = Util.themes.usual.BorderColor3_1;
			BackgroundTransparency = 1;
			AutomaticSize = Enum.AutomaticSize.Y;
			Size = UDim2.new(0, 225, 0, 800);
			Position = UDim2.new(0, 245, 0, 8);
			Parent =  scrollingframe:Get()
		})

		local framerightui = Util:Create("UIListLayout",{
			Name = Util:RandomString(math.random(0,1000));	
			Padding = UDim.new(0, 8);
			SortOrder = Enum.SortOrder.LayoutOrder;
			Parent =  frameright:Get()
		})

		tab.instances = {
			tabmagicframe = tabmagicframe:Get();
			tabname = tabname:Get();
			tabframe = tabframe:Get();
		}

		tabbutton:Get().InputBegan:Connect(function(input, gpe)
			if gpe then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 and Util:IsMouseOver(tabbutton:Get()) then
				if not tab.active then

					--task.spawn(function() window:Notify(options.Name.." was opened", 2) end)

					if window.current ~= nil then
						window.current.active = false
						window.current.instances.tabmagicframe.BackgroundTransparency = 1
						window.current.instances.tabname.TextColor3 = Util.themes.usual.Accent_Color;
						window.current.instances.tabframe.Visible = false;
					end

					tab.active = true 
					tabmagicframe:Properties({
						BackgroundTransparency = 0;
					})
					tabname:Properties({
						TextColor3 = Util.themes.usual.Accent_Color_1;
					})
					tabframe:Properties({
						Visible = true;
					})
					window.current = tab
				end
			end
		end)

		if window.current == nil then
			tab.active = true 
			tabmagicframe:Properties({
				BackgroundTransparency = 0;
			})
			tabname:Properties({
				TextColor3 = Util.themes.usual.Accent_Color_1;
			})
			tabframe:Properties({
				Visible = true;
			})
			window.current = tab
		end

		function tab:CreateFrame(options)

			local frame = {}

			options = Util:ValidateOptions({
				Text = "No name",
				Side = nil,
				SizeY = 200
			}, options or {})

			local parentinstance 

			if options.Side:lower() == "left" then
				parentinstance = frameleft:Get()
			elseif options.Side:lower() == "right" then
				parentinstance = frameright:Get()
			end

			local sideframe = Util:Create("Frame",{
				Name = Util:RandomString(math.random(0,1000));
				Active = true;
				BorderSizePixel = 1;
				BackgroundColor3 = Util.themes.usual.BackGround_Color;
				BorderColor3 = Util.themes.usual.Base_Color;
				Size = UDim2.new(1, 0, 0, options.SizeY);
				Selectable = false; 
				Position = UDim2.fromOffset(10, 8);
				Parent =  parentinstance
			})

			local frameoutline = Util:Create("Frame",{
				Name = Util:RandomString(math.random(0,1000));
				Active = true;
				BorderSizePixel = 1;
				BackgroundColor3 = Util.themes.usual.BackGround_Color;
				BorderColor3 = Util.themes.usual.Black;
				Size = UDim2.new(1, -2, 1, -2);
				Selectable = false; 
				Position = UDim2.fromOffset(1, 1);
				Parent =  sideframe:Get()
			})

			local magicframe = Util:Create("Frame",{
				Name = Util:RandomString(math.random(0,1000));
				Active = true;
				BorderSizePixel = 0;
				BackgroundColor3 = Util.themes.usual.Accent_Color;
				--BorderColor3 = Util.themes.usual.BorderColor3_1;
				Size = UDim2.new(1, 2, 0, 1);
				Selectable = false; 
				Position = UDim2.fromOffset(-1, -1);
				Parent =  frameoutline:Get()
			})

			local utilitesframe = Util:Create("Frame",{
				Name = Util:RandomString(math.random(0,1000));
				Active = true;
				BorderSizePixel = 0;
				BackgroundTransparency = 1;
				--BackgroundColor3 = Util.themes.usual.TextColor3;
				--BorderColor3 = Util.themes.usual.BorderColor3_1;
				Size = UDim2.new(1, -4, 1, -20);
				Position = UDim2.new(0, 4, 0, 20);
				Selectable = false; 
				Parent =  frameoutline:Get()
			})

			local uilistframelist = Util:Create("UIListLayout",{
				Name = Util:RandomString(math.random(0,1000));
				Parent = utilitesframe:Get();
				Padding = UDim.new(0, 5);
				SortOrder = "LayoutOrder";
			})

			local framename = Util:Create("TextLabel",{
				Name = Util:RandomString(math.random(0,1000));
				TextStrokeTransparency = 0;
				ZIndex = 2;
				BorderSizePixel = 0;
				TextXAlignment = Enum.TextXAlignment.Left;
				FontFace = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				TextSize = 13;
				TextColor3 = Util.themes.usual.Accent_Color;
				--BackgroundColor3 = Util.themes.usual.BackgroundColor3_1;
				--BorderColor3 = Util.themes.usual.BackgroundColor3;
				Text = (options.Text);
				BackgroundTransparency = 1;
				Size = UDim2.new(1, 0, 0, 18);
				Position = UDim2.new(0, 4, 0, 0);
				Parent =  frameoutline:Get()
			})

			local roatatingthing = Util:Create("TextLabel",{
				Name = Util:RandomString(math.random(0,1000));
				TextStrokeTransparency = 0;
				ZIndex = 2;
				BorderSizePixel = 0;
				TextXAlignment = Enum.TextXAlignment.Left;
				FontFace = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				TextSize = 13;
				TextColor3 = Util.themes.usual.Accent_Color;
				--BackgroundColor3 = Util.themes.usual.BackgroundColor3_1;
				--BorderColor3 = Util.themes.usual.BackgroundColor3;
				Text = [[^]];
				BackgroundTransparency = 1;
				Size = UDim2.new(0, 7, 0, 13);
				Position = UDim2.new(1, -12, 0, 2);
				Rotation = -180;
				Parent =  frameoutline:Get()
			})

			frame.opened        =                true;
			frame.utilitesframe = utilitesframe:Get();

			roatatingthing:Get().InputBegan:Connect(function(input, gpe)
				if gpe then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 and Util:IsMouseOver(roatatingthing:Get()) and frame.opened then
					-- closing
					frame.opened = false;
					utilitesframe:Get().Visible = false;

					local TweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)

					local sizeTween = TweenService:Create(sideframe:Get(), TweenInfo, {Size = framename:Get().Size})
					sizeTween:Play()

					local rotationTween = TweenService:Create(roatatingthing:Get(), TweenInfo, {Rotation = -90})
					rotationTween:Play()


				elseif input.UserInputType == Enum.UserInputType.MouseButton1 and Util:IsMouseOver(roatatingthing:Get()) and not frame.opened then
					-- opening 
					frame.opened = true;
					utilitesframe:Get().Visible = true;

					local TweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)

					local sizeTween = TweenService:Create(sideframe:Get(), TweenInfo, {Size = UDim2.new(1, 0, 0, options.SizeY)})
					sizeTween:Play()

					local rotationTween = TweenService:Create(roatatingthing:Get(), TweenInfo, {Rotation = -180})
					rotationTween:Play()

				end
			end)

			function frame:CreateButton(options)

				local button = {}

				-- Validate the options and provide defaults
				options = Util:ValidateOptions({
					Text = "No name",
					CallBack = function() print("No callback :3") end,
				}, options or {})

				-- Create the main button frame
				button.Frame = Util:Create("Frame", {
					Name = Util:RandomString(math.random(0, 1000)),
					Active = true,
					BorderSizePixel = 1,
					BackgroundColor3 = Util.themes.usual.Accent_Color_1,
					BorderColor3 = Util.themes.usual.Black,
					Size = UDim2.new(1, -4, 0, 25),
					Selectable = false, 
					Position = UDim2.fromOffset(10, 8),
					Parent = frame.utilitesframe
				})

				-- Create the button text label inside the frame
				button.TextLabel = Util:Create("TextLabel", {
					Name = Util:RandomString(math.random(0, 1000)),
					TextStrokeTransparency = 0,
					ZIndex = 2,
					BorderSizePixel = 1,
					TextXAlignment = Enum.TextXAlignment.Center,
					FontFace = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal),
					TextSize = 14,
					TextColor3 = Util.themes.usual.Accent_Color,
					BackgroundColor3 = Util.themes.usual.BackGround_Color,
					BorderColor3 = Util.themes.usual.Base_Color,
					Text = options.Text,
					Size = UDim2.new(1, -2, 1, -2),
					Position = UDim2.fromOffset(1, 1),
					Parent = button.Frame:Get()  -- Set the parent to the frame instance
				})

				-- Add functionality for when the button is clicked
				Util:Connection(button.TextLabel:Get().InputBegan, function(input, gpe)
					if gpe then return end
					if input.UserInputType == Enum.UserInputType.MouseButton1 and Util:IsMouseOver(button.TextLabel:Get()) then
						options.CallBack()  -- Call the provided callback function
					end
				end)

				return button
			end

			function frame:CreateKeyBind(options) -- DONE TODO: Make so like you can choose to make it be like none so like no keybind yk? future me 1:49 AM July 06 2024

				--window:CreateKeyBindUi() -- we create the keybind ui idk why i made it so but it works somehow so let it be i guess lol

				local keybind = {
					checkingforkey = false;
					isrightclicked = false;
					currentkeybind = nil;
					state = {
						Toggle = false;  -- Toggling
						Allways = false; -- Allways
					};
					instances = {
						oldlabel = nil;
						--  frame = frame:Get;
						--	alwaysbutton = alwaysbutton:Get();
						--	togglebutton = togglebutton:Get();
						--	heldbutton = heldbutton:Get();
					};
				}

				options = Util:ValidateOptions({
					Text = "No name",
					KeyBindType = "Toggle", -- Allways/Toggle/Held
					Options = "None", -- All/None
					CallBack = function() print("No callback :3") end
				}, options or {})


				keybind.keybindlabel = Util:Create("TextLabel",{
					Name = Util:RandomString(math.random(0,1000));
					TextStrokeTransparency = 0;
					ZIndex = 2;
					BorderSizePixel = 0;
					TextXAlignment = Enum.TextXAlignment.Left;
					FontFace = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					TextSize = 13;
					TextColor3 = Util.themes.usual.Accent_Color;
					BackgroundColor3 = Util.themes.usual.BackGround_Color;
					BorderColor3 = Util.themes.usual.Base_Color;
					Text = (options.Text);
					Size = UDim2.new(1, 0, 0, 13);
					Position = UDim2.new(0, 4, 0, 0);
					Parent = frame.utilitesframe
				})

				keybind.keybindbutton = Util:Create("TextButton",{
					Name = Util:RandomString(math.random(0,1000));
					TextStrokeTransparency = 0;
					ZIndex = 2;
					BorderSizePixel = 0;
					TextXAlignment = Enum.TextXAlignment.Right;
					FontFace = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					TextSize = 13;
					TextColor3 = Util.themes.usual.Accent_Color;
					BackgroundColor3 = Util.themes.usual.BackGround_Color;
					BackgroundTransparency = 1;
					BorderColor3 = Util.themes.usual.Base_Color;
					Text = "[...]";
					AnchorPoint = Vector2.new(1, 0);
					Size = UDim2.new(0, 35,0, 13);
					Position = UDim2.new(1, -4, 0, 0);
					Parent = keybind.keybindlabel:Get()
				})

				Util:Connection(keybind.keybindbutton:Get().MouseButton1Click, function(input)
					if not tab.active then return end 
					keybind.checkingforkey = true
					keybind.keybindbutton:Get().Text = "[   ]"
				end)


				Util:Connection(UserInputService.InputBegan, function(input, processed)
					if not tab.active then return end 
					if keybind.checkingforkey then
						if input.KeyCode ~= Enum.KeyCode.Unknown then
							local SplitMessage = string.split(tostring(input.KeyCode), ".")
							local NewKeyNoEnum = SplitMessage[3]
							keybind.currentkeybind = tostring(NewKeyNoEnum)
							local x, y = Util:GetTextBounds("["..tostring(NewKeyNoEnum).."]",Font.new([[rbxasset://fonts/families/Inconsolata.json]]),13)
							keybind.keybindbutton:Get().Text = "["..tostring(NewKeyNoEnum).."]"
							keybind.keybindbutton:Get().Size = UDim2.new(0, x, 0, 13);
							keybind.checkingforkey = false
						end
					elseif keybind.currentkeybind ~= nil and (input.KeyCode == Enum.KeyCode[keybind.currentkeybind] and not processed) then -- Test
						if options.KeyBindType == "Allways" and not keybind.state.Allways then 

							keybind.state.Allways = not keybind.state.Allways
							options.CallBack(keybind.state.Allways)

							keybind.instances.oldlabel = window:AddKeybindLabel(options.Text,keybind.currentkeybind)

						elseif options.KeyBindType == "Toggle" then 

							keybind.state.Toggle = not keybind.state.Toggle
							options.CallBack(keybind.state.Toggle)
							if keybind.state.Toggle then 
								keybind.instances.oldlabel = window:AddKeybindLabel(options.Text,keybind.currentkeybind)
							else
								keybind.instances.oldlabel:Delete()
							end

						elseif options.KeyBindType == "Held" then 

							keybind.instances.oldlabel = window:AddKeybindLabel(options.Text,keybind.currentkeybind)

							local Connection1 = table.insert(Util.connections,Util:RandomString(math.random(0,1000)))
							local Connection2 = table.insert(Util.connections,Util:RandomString(math.random(0,1000)))

							Connection1 = RunService.RenderStepped:Connect(function()
								options.CallBack(true)
							end)

							Connection2 = input.Changed:Connect(function(prop)
								if prop == "UserInputState" then
									Connection1:Disconnect()
									Connection2:Disconnect()

									keybind.instances.oldlabel:Delete()

								end
							end)

						else
							warn("Vania to be pizda blyati")
						end

					end

					if options.Options == "All" then
						if input.UserInputType == Enum.UserInputType.MouseButton2 and Util:IsMouseOver(keybind.keybindbutton:Get()) and processed then		

							if keybind.instances.frame ~= nil then
								keybind.instances.frame:Destroy()
							end

							keybind.isrightclicked = true

							keybind.frame = Util:Create("Frame",{
								Name = Util:RandomString(math.random(0,1000));
								Active = true;
								ZIndex = 3;
								BorderSizePixel = 1;
								BackgroundColor3 = Util.themes.usual.BackGround_Color;
								BorderColor3 = Util.themes.usual.Base_Color;
								Size = UDim2.new(0, 80, 0, 57);
								Selectable = false; 
								Position = UDim2.new(1, -20, 0, 16);
								Parent =  keybind.keybindlabel:Get()
							})

							keybind.frameoutline = Util:Create("Frame",{
								Name = Util:RandomString(math.random(0,1000));
								Active = true;
								ZIndex = 3;
								BorderSizePixel = 1;
								BackgroundColor3 = Util.themes.usual.BackGround_Color;
								BorderColor3 = Util.themes.usual.Black;
								Size = UDim2.new(1, -2, 1, -2);
								Selectable = false; 
								Position = UDim2.new(0, 1, 0, 1);
								Parent =  keybind.frame:Get()
							})

							keybind.frameuilist = Util:Create("UIListLayout",{
								Name = Util:RandomString(math.random(0,1000));
								SortOrder = Enum.SortOrder.LayoutOrder;
								Parent =  keybind.frameoutline:Get()
							})

							keybind.alwaysbutton = Util:Create("TextLabel",{
								Name = Util:RandomString(math.random(0,1000));
								TextStrokeTransparency = 0;
								ZIndex = 3;
								BorderSizePixel = 0;
								TextXAlignment = Enum.TextXAlignment.Center;
								FontFace = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
								TextSize = 13;
								TextColor3 = Util.themes.usual.Accent_Color;
								--BackgroundColor3 = Util.themes.usual.BackGround_Color;
								--BorderColor3 = Util.themes.usual.Base_Color;
								BackgroundTransparency = 1;
								Text = "[Always]";
								Size = UDim2.new(1, 0, 0, 18);
								Position = UDim2.new(0, 4, 0, 0);
								Parent = keybind.frameoutline:Get()
							})


							keybind.togglebutton = Util:Create("TextLabel",{
								Name = Util:RandomString(math.random(0,1000));
								TextStrokeTransparency = 0;
								ZIndex = 3;
								BorderSizePixel = 0;
								TextXAlignment = Enum.TextXAlignment.Center;
								FontFace = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
								TextSize = 13;
								TextColor3 = Util.themes.usual.Accent_Color;
								--BackgroundColor3 = Util.themes.usual.BackGround_Color;
								--BorderColor3 = Util.themes.usual.Base_Color;
								BackgroundTransparency = 1;
								Text = "[Toggle]";
								Size = UDim2.new(1, 0, 0, 18);
								Position = UDim2.new(0, 4, 0, 0);
								Parent = keybind.frameoutline:Get()
							})

							keybind.heldbutton = Util:Create("TextLabel",{
								Name = Util:RandomString(math.random(0,1000));
								TextStrokeTransparency = 0;
								ZIndex = 3;
								BorderSizePixel = 0;
								TextXAlignment = Enum.TextXAlignment.Center;
								FontFace = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
								TextSize = 13;
								TextColor3 = Util.themes.usual.Accent_Color;
								--BackgroundColor3 = Util.themes.usual.BackGround_Color;
								--BorderColor3 = Util.themes.usual.Base_Color;
								BackgroundTransparency = 1;
								Text = "[Held]";
								Size = UDim2.new(1, 0, 0, 18);
								Position = UDim2.new(0, 4, 0, 0);
								Parent = keybind.frameoutline:Get()
							})

							keybind.instances.frame = frame:Get();
							keybind.instances.alwaysbutton = keybind.alwaysbutton:Get();
							keybind.instances.togglebutton = keybind.togglebutton:Get();
							keybind.instances.heldbutton = keybind.heldbutton:Get();

						elseif input.UserInputType == Enum.UserInputType.MouseButton1 and keybind.isrightclicked == true and processed then

							if Util:IsMouseOver(keybind.instances.alwaysbutton) then
								options.KeyBindType = "Allways"
								keybind.state.Allways = false
							elseif Util:IsMouseOver(keybind.instances.togglebutton) then
								options.KeyBindType = "Toggle"
							elseif Util:IsMouseOver(keybind.instances.heldbutton) then
								options.KeyBindType = "Held"
							end

							if keybind.instances.oldlabel then
								keybind.instances.oldlabel:Delete()
							end

							keybind.isrightclicked = false

							keybind.instances.frame:Destroy()

						end
					end

				end)

				return keybind

			end

			function frame:CreateToggle(options)

				options = Util:ValidateOptions({
					Name = "No name",
					CallBack = function() print("No callback :3") end
				}, options or {})

				local toggle = {
					Hover = false,
					State = false
				}

				-- Render the toggle components
				toggle.Frame = Util:Create("Frame", {
					Name = "Toggle",
					BackgroundColor3 = Util.themes.usual.Accent_Color_1,
					Size = UDim2.new(0, 13, 0, 13),
					BorderColor3 = Util.themes.usual.Base_Color,
					Parent = frame.utilitesframe
				})

				toggle.Button = Util:Create("Frame", {
					Name = "Toggle",
					BackgroundColor3 = Util.themes.usual.BackGround_Color,
					Size = UDim2.new(1, -2, 1, -2),
					Position = UDim2.new(0, 1, 0, 1),
					BorderColor3 = Util.themes.usual.Black,
					Parent = toggle.Frame:Get()
				})

				toggle.Label = Util:Create("TextLabel", {
					Name = "Toggle",
					BackgroundTransparency = 1,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Text = options.Text,
					TextSize = 14,
					TextColor3 = Util.themes.usual.Accent_Color;
					TextStrokeTransparency = 0,
					FontFace = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal),
					TextXAlignment = Enum.TextXAlignment.Left,
					Position = UDim2.new(1.8, 0, 0, 0),
					Size = UDim2.new(0, 0, 1, 0),
					Parent = toggle.Frame:Get()
				})

				-- Logic for toggle functionality
				local color1, color2 = Util.themes.usual.Accent_Color,Util.themes.usual.BackGround_Color
				
				Util:Connection(Util.themeSignal, function(text)
					color1, color2 = Util.themes[text].Accent_Color, Util.themes[text].BackGround_Color
				end)
				
				Util:Connection(toggle.Button:Get().InputBegan, function(input, gpe)
					if gpe then return end
					if input.UserInputType == Enum.UserInputType.MouseButton1 and Util:IsMouseOver(toggle.Button:Get()) then
						toggle.State = not toggle.State
						
						toggle.Button:Get().BackgroundColor3 = toggle.State and color1 or color2
						
						--toggle.Frame:Get().BorderColor3 = toggle.State 
						--	and  Util.themes.usual.Accent_Color
						--	or Util.themes.usual.Base_Color
						
						options.CallBack(toggle.State)
					end
				end)

				return toggle
			end

			function frame:CreateDivision(options)

				options = Util:ValidateOptions({
					Name = "No name"
				}, options or {})

				local division = {}
				
				division.x, division.y = Util:GetTextBounds(options.Text,Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal),13)
				division.aside = ((215-division.x)/2)-5


				division.divisionframe = Util:Create("Frame",{
					Name = Util:RandomString(math.random(0,1000));
					Active = true;
					BorderSizePixel = 0;
					BackgroundTransparency = 1;
					--BackgroundColor3 = Util.themes.usual.TextColor3;
					--BorderColor3 = Util.themes.usual.BorderColor3_1;
					Size = UDim2.new(1, -4, 0, 13);
					Position = UDim2.new(0, -1, 0, -1);
					Selectable = false; 
					Parent =  frame.utilitesframe
				})

				division.textlabelnmiddled = Util:Create("TextLabel",{
					Name = Util:RandomString(math.random(0,1000));
					TextStrokeTransparency = 0;
					ZIndex = 2;
					BorderSizePixel = 0;
					TextXAlignment = Enum.TextXAlignment.Center;
					FontFace = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					TextSize = 13;
					TextColor3 = Util.themes.usual.Accent_Color;
					--BackgroundColor3 = Util.themes.usual.BackgroundColor3_1;
					--BorderColor3 = Util.themes.usual.BackgroundColor3;
					Text = options.Text;
					BackgroundTransparency = 1;
					Size = UDim2.new(1, 0, 0, 0);
					Position = UDim2.new(0, 0, 0.5, 0);
					Rotation = 0;
					Parent =  division.divisionframe:Get()
				})
				
				-- Create left division line
				division.leftDivision = Util:Create("Frame", {
					Name = Util:RandomString(math.random(0,1000));
					BackgroundColor3 = Util.themes.usual.Accent_Color;
					Size = UDim2.new(0, division.aside, 0, 1);
					BorderColor3 = Color3.fromRGB(0, 0, 0);
					Position = UDim2.new(0, 0, 0.5, 0);
					Parent = division.divisionframe:Get()
				})

				-- Create right division line
				division.rightDivision = Util:Create("Frame", {
					Name = Util:RandomString(math.random(0,1000));
					BackgroundColor3 = Util.themes.usual.Accent_Color;
					Size = UDim2.new(0, division.aside, 0, 1);
					BorderColor3 = Color3.fromRGB(0, 0, 0);
					Position = UDim2.new(1, -division.aside, 0.5, 0);
					Parent = division.divisionframe:Get()
				})

				return division

			end

			function frame:CreateTextBox(options)


				options = Util:ValidateOptions({
					Text = "Text box name :";
					PlaceHolderText = "Place holder text";
					Name = "No name"
				}, options or {})

				local textbox = {}

				textbox.textboxlabel = Util:Create("TextLabel",{
					Name = Util:RandomString(math.random(0,1000));
					TextStrokeTransparency = 0;
					Active = true;
					BorderSizePixel = 0;
					TextXAlignment = Enum.TextXAlignment.Left;
					FontFace = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					TextSize = 13;
					TextColor3 = Util.themes.usual.Accent_Color;
					Selectable = true;
					Text = options.Text;
					BackgroundTransparency = 1;
					Size = UDim2.new(1, 0, 0, 18);
					ZIndex = 2;
					Parent =  frame.utilitesframe
				})
				
				textbox.textboxframe = Util:Create("Frame",{
					Name = Util:RandomString(math.random(0,1000));
					Active = true;
					BorderSizePixel = 1;
					BackgroundColor3 = Util.themes.usual.Accent_Color;
					BorderColor3 = Util.themes.usual.Black;
					Size = UDim2.new(0, 215, 0, 20);
					Position = UDim2.new(0, 0, 0, 0);
					Visible = true;
					ZIndex = 2;
					Parent = frame.utilitesframe
				})
				
				textbox.textbox = Util:Create("TextBox",{
					Name = Util:RandomString(math.random(0,1000));
					Active = true;
					BorderSizePixel = 1;
					TextXAlignment = Enum.TextXAlignment.Center;
					FontFace = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					TextSize = 14;
					TextColor3 = Util.themes.usual.Accent_Color;
					PlaceholderColor3 = Util.themes.usual.Accent_Color;
					BackgroundColor3 = Util.themes.usual.BackGround_Color;
					BorderColor3 = Util.themes.usual.Base_Color;
					Size = UDim2.new(1, -2, 1, -2);
					Position = UDim2.new(0, 1, 0, 1);
					Visible = true;
					ZIndex = 2;
					TextStrokeTransparency = 0;
					Parent = textbox.textboxframe:Get();
					ClearTextOnFocus = false;
					PlaceholderText = options.PlaceHolderText;
				})

				Util:Connection(textbox.textbox:Get().FocusLost, function(enterPressed)
					
					if enterPressed then
						
						options.CallBack(textbox.textbox:Get().Text);
						
					end
					
				end)

				return textbox

			end

			function frame:CreateList(options)


				options = Util:ValidateOptions({
				}, options or {})

				local list = {}

				list.listlabel = Util:Create("TextLabel",{
					Name = Util:RandomString(math.random(0,1000));
					TextStrokeTransparency = 0;
					Active = true;
					BorderSizePixel = 0;
					TextXAlignment = Enum.TextXAlignment.Left;
					FontFace = Font.new([[rbxasset://fonts/families/Inconsolata.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					TextSize = 13;
					TextColor3 = Util.themes.usual.Accent_Color;
					Selectable = true;
					Text = options.Text;
					BackgroundTransparency = 1;
					Size = UDim2.new(1, 0, 0, 18);
					ZIndex = 2;
					Parent =  frame.utilitesframe
				})

				list.listholderframe = Util:Create("Frame",{
					Name = Util:RandomString(math.random(0,1000));
					Active = true;
					BorderSizePixel = 1;
					BackgroundColor3 = Util.themes.usual.BackGround_Color;
					BorderColor3 = Util.themes.usual.Black;
					Size = UDim2.new(1, -4, 0, 20);
					Position = UDim2.new(0, 0, 0, 0);
					Visible = true;
					ZIndex = 2;
					Parent = frame.utilitesframe
				})
				
				list.listmainframe = Util:Create("Frame",{
					Name = Util:RandomString(math.random(0,1000));
					Active = true;
					BorderSizePixel = 1;
					BackgroundColor3 = Util.themes.usual.BackGround_Color;
					BorderColor3 = Util.themes.usual.Base_Color;
					Size = UDim2.new(1, -2, 1, -2);
					Position = UDim2.new(0, 1, 0, 1);
					Visible = true;
					ZIndex = 2;
					Parent = list.listholderframe:Get()
				})
				
				list.listmainframe = Util:Create("Frame",{
					Name = Util:RandomString(math.random(0,1000));
					Active = true;
					BorderSizePixel = 1;
					BackgroundColor3 = Util.themes.usual.BackGround_Color;
					BorderColor3 = Util.themes.usual.Base_Color;
					Size = UDim2.new(1, -2, 1, -2);
					Position = UDim2.new(0, 0.5, 1, 1-2);
					Visible = true;
					ZIndex = 2;
					Parent = list.listholderframe:Get()
				})


				return list

			end

			return frame

		end

		return tab

	end
	
	
	Util:MakeFrameDraggable(window.mainframe:Get())

	Util:Connection(Util.unloadedSignal, function()
		window.screengui:Delete()
	end)
	
	window:CreateKeyBindUi();
	window:CreateWatermarkUi();
	
	function window:MenuVisible()
		
		window.mainframe:Get().Visible = not window.mainframe:Get().Visible
		
	end
	
	return window

end

-- Ui

local window = Util:Window({Size = UDim2.fromOffset(516, 562)})

-- Tabs

local AimBot = window:CreateTab({
	Name = "AimBot"
})

local RageBot = window:CreateTab({
	Name = "RageBot"
})

local Visuals = window:CreateTab({
	Name = "Visuals"
})

local Skins = window:CreateTab({
	Name = "Skins"
})

local Misc = window:CreateTab({
	Name = "Misc"
})

local Other = window:CreateTab({
	Name = "Other"
})


-- others tab

local frame1 = Other:CreateFrame({
	Text = "Menu",
	Side = "Left",
	SizeY = 200
})

local frame2 = Other:CreateFrame({
	Text = "Menu",
	Side = "right",
	SizeY = 200
})

local keybind1 = frame1:CreateKeyBind({
	Text = "Keybind",
	KeyBindType = "Toggle", -- Allways/Toggle/Held
	Options = "None", -- All/None
	CallBack = function() 
		window:MenuVisible()
	end
})

local keybind1 = frame1:CreateKeyBind({
	Text = "Keybind",
	KeyBindType = "Toggle", -- Allways/Toggle/Held
	Options = "All", -- All/None
	CallBack = function() 
		window:MenuVisible()
	end
})

local button1 = frame1:CreateButton({
	Text = "Unload";
	CallBack = function() 
		Util:Unload()
	end;
})

local toggle1 = frame1:CreateToggle({
	Text = "Force Unload";
	CallBack = function(gibe) 
		print(gibe)
	end;
})

local division1 = frame1:CreateDivision({
	Text = "Watermark";
})

local toggle2 = frame1:CreateToggle({
	Text = "Watermark";
	CallBack = function(gibe) 
		window:WatermarkVisible()
		window:Update({
			LocalPlayer.Name,
			"dev_test"
		})
	end;
})

local textbox = frame1:CreateTextBox({
	Text = "Custom watermark text:";
	PlaceHolderText = "smth";
	CallBack = function(text) 
		Util.themeSignal:Fire(text);
	end;
})

--getgenv().Util = Util

window:Notify("Loaded the script in "..tick()-Load, 4)
window:Notify("Welcome to net.cut "..LocalPlayer.Name.."!", 2)

return Util
