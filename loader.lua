local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local delfile = delfile or function(file)
	writefile(file, '')
end

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/Loqrp/radiumforroblox/'..readfile('radiumclient/profiles/commit.txt')..'/'..select(1, path:gsub('radiumclient/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('loader') then continue end
		if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.')) == 1 then
			delfile(file)
		end
	end
end

for _, folder in {'radiumclient', 'radiumclient/games', 'radiumclient/profiles', 'radiumclient/assets', 'radiumclient/libraries', 'radiumclient/guis'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end

if not shared.VapeDeveloper then
	local _, subbed = pcall(function() 
		return game:HttpGet('https://github.com/Loqrp/radiumforroblox') 
	end)
	local commit = subbed:find('currentOid')
	commit = commit and subbed:sub(commit + 13, commit + 52) or nil
	commit = commit and #commit == 40 and commit or 'main'
	if commit == 'main' or (isfile('radiumclient/profiles/commit.txt') and readfile('radiumclient/profiles/commit.txt') or '') ~= commit then
		wipeFolder('radiumclient')
		wipeFolder('radiumclient/games')
		wipeFolder('radiumclient/guis')
		wipeFolder('radiumclient/libraries')
	end
	writefile('radiumclient/profiles/commit.txt', commit)
end

return loadstring(downloadFile('radiumclient/main.lua'), 'main')()