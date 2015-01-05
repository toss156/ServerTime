--*********************************************
-- Desc: 获取服务器时间
-- File: ServerTime.lua
-- Author: zhouhaifeng
-- Date: 2014-12-05 09:40:58
--*********************************************

local socket = require "socket.core"

ServerTime = {}

--[[
	服务器ip地址
]]
ServerTime.server_ip = {
        "132.163.4.101",
        "132.163.4.102",
        "132.163.4.103",
        "128.138.140.44",
        "192.43.244.18",
        "131.107.1.10",
        "66.243.43.21",
        "216.200.93.8",
        "208.184.49.9",
        "207.126.98.204",
        "207.200.81.113",
        "205.188.185.33"
}

--[[
	将32位二进制数,转换成时间戳
]]
function ServerTime.nstol(str)
    assert(str and #str == 4)
    local t = {str:byte(1,-1)}
    local n = 0
    for k = 1, #t do
        n= n*256 + t[k]
    end
    n = n - 2208988800
    return n
end

--[[
	通过tcp协议去访问nstol服务器
]]
function ServerTime.gettime(ip)
    local tcp = socket.tcp()
    tcp:settimeout(10)
    tcp:connect(ip, 37)
    success, time = pcall(ServerTime.nstol, tcp:receive(4))
    tcp:close()
    return success and time or nil
end

--[[
	通过nstol,来同步系统时间
]]
function ServerTime.getServerTime()
    for _, ip in pairs(ServerTime.server_ip) do
        time = ServerTime.gettime(ip)
        if time then
        	print("localtime:" .. os.time() .. "\tservertime:" .. time)
            return time
        end
    end
end


