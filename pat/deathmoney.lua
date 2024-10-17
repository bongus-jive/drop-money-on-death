function build(_, config, parameters)
  config.timeToLive = math.huge
  local money = root.itemConfig("money")
  return sb.jsonMerge(money.config, config), money.parameters
end
