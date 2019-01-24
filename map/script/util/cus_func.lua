
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
