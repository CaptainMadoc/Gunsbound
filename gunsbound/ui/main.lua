require "/scripts/util.lua"
require "/scripts/vec2.lua"

enabled = false
localmessage = nil
messaged = false
ownerid = 0
position = {0,0}
data = {}
function lerp(a,b,r)
	if type(a) == "table" then
		if type(b) == "number" then
			b = {b, b}
		end
		return {a[1] + (b[1] - a[1]) * r, a[2] + (b[2] - a[2]) * r}
	end
	return a + (b - a) * r
end

function update(dt)
	localAnimator.clearDrawables()
	if animationConfig.animationParameter("entityID") and not localmessage and not messaged then
		localmessage = world.sendEntityMessage(animationConfig.animationParameter("entityID"), "isLocal")
		ownerid = animationConfig.animationParameter("entityID")
	end
	
	if enabled then
		data:update(dt)
		realUpdate(dt)
	elseif localmessage and localmessage:finished() then	
		enabled = localmessage:result()
		if enabled then
			realInit(dt)
		end
		messaged = true
	end
end

function data:update(dt)
	for i,v in pairs(self) do
		if i ~= data then
			local pull = animationConfig.animationParameter(i)
			if pull then
				self[i] = pull
			end
		end
	end
end

function realInit(dt)
	data["magazine"] = 30
	data["maxMagazine"] = 30
	data["load"] = false
	position = world.entityPosition(ownerid)
end

function realUpdate(dt)
	localAnimator.clearDrawables()
	position = lerp(position, world.entityPosition(ownerid), 0.5)
	local matt = {
		{30 / data["maxMagazine"],0,0},
		{0,1,0},
		{0,0,1}
	}
	local shift = (-0.125) * (30 / data["maxMagazine"])
	if data["load"] == "table" then
		localAnimator.addDrawable({image = "/gunsbound/ui/ammo.png", position = vec2.add(position, {0, -3}), transformation = matt, fullbright = true}, "overlay")
		shift = 0
	end
	
	for i = 1,data["magazine"] do
		localAnimator.addDrawable({image = "/gunsbound/ui/ammo.png", position = vec2.add(position, {((2.5 / data["maxMagazine"]) * i) + shift, -3.25}), transformation = matt, fullbright = true}, "overlay")
	end
end