--in Here. Is what to be useful

function pSound(sounddata) --Single Sound by projectile
	local soundIde = world.spawnProjectile(
		"invisibleprojectile",
		mcontroller.position(),
		activeItem.ownerEntityId(),
		{0,0},
		true,
		{
			timeToLive = 0.01, 
			power = 0,
			damageType = "NoDamage",
			universalDamage = false,
			actionOnReap = {
				{
				action = "sound",
				options = { sounddata }
				}
			}, 
			processing = "?replace;F7D5D3=F7D5D300;754C23=00000000;A47844=A4784400"
		}
	)
end

function strStarts(str, start)
	return string.sub(str,1,string.len(start)) == start
end

function remStart(str, start)
	return string.sub(str,start + 1,string.len(str))
end

function pmSound(sounddata) --Multi Sound by projectile
	local actions = {}
	for i,v in pairs(sounddata) do
		if strStarts(v, "@") then
			animator.playSound(remStart(v, 1))
			table.insert(actions, 
				{
					action = "sound",
					options = { "/assetmissing.ogg" }
				}
			)
		else
			table.insert(actions, 
				{
					action = "sound",
					options = { v }
				}
			)
		end
	end
	local soundIde = world.spawnProjectile(
		"invisibleprojectile",
		mcontroller.position(),
		activeItem.ownerEntityId(),
		{0,0},
		true,
		{
			timeToLive = 1/60, 
			power = 0,
			damageType = "NoDamage",
			universalDamage = false,
			actionOnReap = actions,
			processing = "?replace;F7D5D3=F7D5D300;754C23=00000000;A47844=A4784400"
		}
	)
	return soundIde
end

function lerp(value, to, speed)
	return value + ((to - value ) / speed ) 
end

function aimFacing() --Faces depending on your mouse position
	return util.toDirection(world.distance(activeItem.ownerAimPosition(), mcontroller.position())[1])
end

function better(v1, v2)
	if math.abs(v1) > math.abs(v2) then
		return math.abs(v1)
	end
	return math.abs(v2)
end

function projectileAngle(at) --Aim angle imported from chucklefish weapons, {1 , 0} for 90deg. Uses: Projectile directions
	local aimVector = vec2.rotate({1, 0}, (at + mcontroller.rotation() * aimFacing()))
	aimVector[1] = aimVector[1] * aimFacing()
	aimVector[2] = aimVector[2]
	return aimVector
end

function copycat(var)
	if type(var) == "number" then
		return 0 + var
	end
	if type(var) == "table" then
		local newtab = {}
		for i,v in pairs(var) do
			newtab[i] = v
		end
		return newtab
	end
	return var
end
