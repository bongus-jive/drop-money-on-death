local function round(n)
  return math.floor(n + 0.5)
end

local function randomVector(magnitude)
  local angle = math.pi * 2 * math.random()
  return {math.cos(angle) * magnitude, math.sin(angle) * magnitude}
end

function uninit()
  if status.resourcePositive("health") then return end

  local mode = player.mode and player.mode() or "casual"
  local modeConfig = root.assetJson("/playermodes.config")[mode]
  if not modeConfig then return end

  local percentage = modeConfig.reviveCostPercentile * (modeConfig.pat_moneyDropPercentage or 1)
  local totalCount = round(player.currency("money") * percentage)
  if totalCount <= 0 then return end
  
  local itemdrop = root.assetJson("/itemdrop.config")
  local position = mcontroller.position()
  
  local stacks = itemdrop.pat_moneyDrop.stacks
  local stackCount = totalCount // stacks
  local remainder = totalCount % stacks

  for i = 1, stacks do
    local count = stackCount
    if remainder > 0 then
      remainder = remainder - 1
      count = count + 1
    end
    if count <= 0 then break end

    local velocity = randomVector(itemdrop.throwSpeed)
    world.spawnItem(itemdrop.pat_moneyDrop.item, position, count, nil, velocity, itemdrop.throwIntangibleTime)
  end
end
