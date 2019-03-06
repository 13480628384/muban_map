
--循环打印 table
function print_r (lua_table, indent)

    indent = indent or 0
    for k, v in pairs(lua_table) do
        if type(k) == "string" then
            k = string.format("%q", k)
        end
        local szSuffix = ""
        if type(v) == "table" then
            szSuffix = "{"
        end
        local szPrefix = string.rep("    ", indent)
        formatting = szPrefix.."["..k.."]".." = "..szSuffix
        if type(v) == "table" then
            print(formatting)
            print_r(v, indent + 1)
            print(szPrefix.."},")
        else
            local szValue = ""
            if type(v) == "string" then
                szValue = string.format("%q", v)
            else
                szValue = tostring(v)
            end
            print(formatting..szValue..",")
        end
    end
end

--字符串是否包含 字符串 字符串 字符串
function finds(str,...)
	local flag = false
	
	for key , value in pairs{...} do
		local _, q=string.find(str, value)
		if _ then 
			flag= true
			break
		end	
	end
	return flag
end
--获取字符串 字数
function get_font_count(str)
	local count = 0
	local len = str:len()
	local a = 0
	for i=1,len do
		local s = str:sub(i,i)
		if s:byte() < 128 then

			count = count + 1
		else
			a = a + 1
			if a == 3 then
				a = 0
				count = count + 1
			end
		end
	end

	return count
end

-- 获取字符串中最长的一行
function get_max_line(str)
	--去掉颜色代码
	str = str:gsub('|[cC]%w%w%w%w%w%w%w%w(.-)|[rR]','%1'):gsub('|n','\n'):gsub('\r','\n')

	local count = 0
	local max_line

	str:gsub('([^\n]-)\n',function (line)
		if line:len() > count then
			max_line = line
			count = line:len()
		end
	end)
	
	return max_line
end 
-- 去掉颜色代码
function clean_color(str)
	str = str:gsub('|[cC]%w%w%w%w%w%w%w%w(.-)|[rR]','%1'):gsub('|n','\n'):gsub('\r','\n')
    return str
end    





