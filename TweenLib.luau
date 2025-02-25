-- Provides advanced functions to tween GUIs and other elements.
-- 
-- ForbiddenJ

local TweenService = game:GetService("TweenService")

local TweenLib = {}

function TweenLib.TweenObject(element, tweenInfo, properties, tweenName, callback)
	assert(typeof(element) == "Instance", "Argument 1 must be an Instance")
	assert(typeof(tweenInfo) == "TweenInfo", "Argument 2 must be a TweenInfo")
	assert(typeof(properties) == "table" and getmetatable(properties) == nil, "Argument 3 must be a dictionary of properties")
	assert(typeof(tweenName) == "string" or tweenName == nil, "Argument 4 must be a string or nil")
	assert(typeof(callback) == "function" or callback == nil, "Argument 5 must be a function or nil")
	tweenName = tweenName or "Tween"
	
	-- Get rid of any old tween here.
	TweenLib.StopTween(element, tweenName)
	
	-- Create a new tween and play it.
	local tween = TweenService:Create(element, tweenInfo, properties)
	tween.Completed:Connect(function(...)
		tween:Destroy()
	end)
	if typeof(callback) == "function" then
		tween.Completed:Connect(callback)
	end
	
	tween.Name = tweenName
	tween.Parent = element
	tween:Play()
	
	return tween
end

function TweenLib.StopTween(element, tweenName)
	assert(typeof(element) == "Instance", "Param 1 must be an Instance.")
	assert(typeof(tweenName) == "string" or tweenName == nil, "Param 2 must be a string or nil.")
	tweenName = tweenName or "Tween"
	
	for i, item in ipairs(element:GetChildren()) do
		if item.Name == tweenName and item:IsA("Tween") then
			item:Cancel()
			item:Destroy()
		end
	end
end

function TweenLib.TweenGuiTransform(element, endSize, endPosition, easingDirection, easingStyle, duration, callback)
	return TweenLib.TweenObject(
		element,
		TweenInfo.new(duration, easingStyle, easingDirection),
		{Size = endSize, Position = endPosition},
		"GuiTween",
		callback)
end

function TweenLib.StopGuiTween(element)
	return TweenLib.StopTween(element, "GuiTween")
end

return TweenLib
