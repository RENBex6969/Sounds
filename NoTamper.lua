local hf1, hf
local NoTamper = {
  ["hf"] = clonefunction(hookfunction),
  ["wf"] = clonefunction(writefile),
  ["rf"] = clonefunction(readfile),
  ["mf"] = clonefunction(makefolder),
  ["NoReadFile"] = {
    ""
  }
  ["NoWriteFile"] = {
    ""
  },
  ["NoDelFolder"] = {
    
  }
}

local NT = {
  ["addNoRead"] = function(path)
    table.insert(NoTamper.NoReadFile, path)
  end,
  ["addNoWrite"] = function(path)
    table.insert(NoTamper.NoWriteFile, path)
  end
  ["addDelFolder"] = function(path)
    table.insert(NoTamper.NoDelFolder, path)
  end
}

local function isNoReadTamper(path)
  for _, value in ipairs(NoTamper.NoReadFile) do
    if value == path then
      return true
    end
  end
  return false
end

local function isNoWriteTamper(path)
  for _, value in ipairs(NoTamper.NoWriteFile) do
    if value == path then
      return true
    end
  end
  return false
end

local function isNoDelFolder(path)
  for _, value in ipairs(NoTamper.NoDelFolder) do
    if value == path then
      return true
    end
  end
  return false
end

hf1 = NoTamper.hf(readfile, newcclosure(function(path)
  if path == "NoTamper.lua" then
    NoTamper.wf("blank.txt","")
    return hf1("blank.txt")
  else
    if isNoReadTamper(path) == true then
      NoTamper.wf("blank.txt","")
      return hf1("blank.txt")
    end
  end
  return hf1(path)
end))

hf2 = NoTamper.hf(writefile, newcclosure(function(path, data)
  if path == "NoTamper.lua" then
    NoTamper.wf("blank.txt","")
    return hf2("blank.txt","Attempt to modify NoTamper.lua")
  else
    if isNoWriteTamper(path) == true then
      NoTamper.wf("blank.txt","")
      return hf2("blank.txt","Attempt to modify " .. path)
    end
  end
  return hf2(path, data)
end))

hf3 = NoTamper.hf(delfolder, newcclosure(function(path)
  if isNoDelFolder(path) == true then
    NoTamper.mf("blank")
    return hf3("blank")
  end
  return hf3(path)
end))

return NT
