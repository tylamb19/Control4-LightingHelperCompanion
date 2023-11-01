EC = {}
OPC = {}

function EC.AMBIENT_LIGHT_LEVEL(tParams)
  local connectedDeviceID = C4:GetBoundProviderDevice(0,1)
  local cmdParams = {}
  cmdParams.GROUP = connectedDeviceID
  cmdParams.TARGET = tParams.TARGET
  cmdParams.LEVEL = tParams.LEVEL
  print(dump(cmdParams))
  local devs = C4:GetBoundConsumerDevices(0,2)
  for deviceID, _ in pairs(devs) do
    print("C4:SendToDevice("..deviceID..",AMBIENT_LIGHT_LEVEL,"..dump(cmdParams))
    C4:SendToDevice(deviceID, "AMBIENT_LIGHT_LEVEL", cmdParams)
  end
end

function ExecuteCommand(strCommand, tParams)
    tParams = tParams or {}
    print('ExecuteCommand: ' .. strCommand .. " " .. dump(tParams))

    if (strCommand == 'LUA_ACTION') then
        if (tParams.ACTION) then
            strCommand = tParams.ACTION
            tParams.ACTION = nil
        end
    end

    strCommand = string.gsub(strCommand, '%s+', '_')

    local success, ret

    if (EC and EC[strCommand] and type(EC[strCommand]) == 'function') then
        success, ret = pcall(EC[strCommand], tParams)
    end

    if (success == true) then
        return (ret)
    elseif (success == false) then
        print('ExecuteCommand error: ' .. ret .. " " .. strCommand)
    end
end

function dump(o)
  if type(o) == 'table' then
     local s = '{ '
     for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. dump(v) .. ','
     end
     return s .. '} '
  else
     return tostring(o)
  end
end