#!/usr/bin/env lua
-- Fri Mar  6 08:57:35 2020

local color = { 
    NONE="\27[0m",
    BLACK="\27[0;30m",
    L_BLACK="\27[1;30m",
    RED="\27[0;31m",
    L_RED="\27[1;31m",
    GREEN="\27[0;32m",
    L_GREEN="\27[1;32m",
    BROWN="\27[0;33m",
    YELLOW="\27[1;33m",
    BLUE="\27[0;34m",
    L_BLUE="\27[1;34m",
    PURPLE="\27[0;35m",
    L_PURPLE="\27[1;35m",
    CYAN="\27[0;36m",
    L_CYAN="\27[1;36m",
    GRAY="\27[0;37m",
    WHITE="\27[1;37m",
    BOLD="\27[1m",
    UNDERLINE="\27[4m",
    BLINK="\27[5m",
    REVERSE="\27[7m",
    HIDE="\27[8m",
    CLEAR="\27[2J",
    CLRLINE="\r\27[K",
}



local json = require "json"
function json_2_table(json_string)
    return json.decode(json_string)
end

function table_2_json(tab)
    return json.encode(tab)
end


function add_json()
    --local fd = io.open("./data.txt")
    local fd = io.open("/root/lua/socket/ff/data.txt")
    local string_json = fd:read("*all")
    fd:close()
     local r_t = json_2_table(string_json)   
     

     local c_count=0
     local d_count=0
     local e_count=0
     local f_count=0

     local add_con = ",+"
     local add_tab = ",\t"

     print(color.BROWN)
     print("时间地点,\t累计确诊,\t累计死亡,\t累计治愈,\t新增确诊")

     print(color.BLUE)
     local table_len = #r_t.data - 1

    ---------------------
     local i = 0
     local hb_date ={}
     local confirm ={}
     local dead ={}
     local heal ={}
    ---------------------

    local max_x=0
    local max_y=0

     for k,v in pairs(r_t.data) do
         --时间地点
         local a =v.date..v.country..v.province..add_tab

         --累计确诊
         c_count = tonumber(v.confirm) - c_count
         --local y_confirm = c_count / 10
         local y_confirm = c_count * 10
         local c =v.confirm..",+"..c_count..add_tab
         c_count = tonumber(v.confirm)


        -------------------
         local name = v.date..add_con..(y_confirm / 10)
         local x = i * 100 
         max_x = max_x < x and x or max_x
         max_y = max_y < y_confirm and y_confirm or max_y
         table.insert(confirm,{x=x,y=y_confirm,name=name})
        ---------------------



        --累计死亡
         d_count = tonumber(v.dead ) - d_count
         --local y_dead = d_count / 10
         local y_dead = d_count * 10
         d_count = add_con .. d_count
         local d = v.dead..d_count..add_tab
         d_count = tonumber(v.dead )


         
        ---------------------
         name = v.date..add_con..(y_dead / 10)
         max_x = max_x < x and x or max_x
         max_y = max_y < y_dead and y_dead or max_y
         table.insert(dead,{x=x,y=y_dead,name=name})
        ---------------------
        
         --累计治愈
         e_count = tonumber(v.heal) - e_count
         local y_heal = e_count / 10
         e_count = add_con .. e_count
         local e = v.heal..e_count..add_tab
         e_count = tonumber(v.heal)


        ---------------------
         name = v.date..add_con..(y_heal * 10)
         max_x = max_x < x and x or max_x
         max_y = max_y < y_heal and y_heal or max_y
         table.insert(heal,{x=x,y=y_heal,name=name})
         i = i + 1
        ---------------------

        --累计确诊
         f_count = tonumber(v.confirm_add) - f_count
         f_count = f_count > 0 and  add_con .. f_count or ","..f_count
         local f = v.confirm_add..f_count
         f_count = tonumber(v.confirm_add)


         print(a..c..d..e..f)
     end

     print("时间地点,\t累计确诊,\t累计死亡,\t累计治愈,\t新增确诊")

    ---------------------
    hb_date.confirm = confirm
    hb_date.dead = dead
    hb_date.heal = heal
    ---------------------
    

     return hb_date,max_x,max_y
end



function sleep_lua(n)
    require("socket")
    socket.select(nil, nil, n)
end



function random_int(int_end)
    sleep_lua(1)
    --在本项目中如果sleep_lua参数越小画出来的图越不乱
    math.randomseed(os.time())
    if int_end then 
        return math.random(int_end)
    end
    
    return math.random()
end


function get_random_pos(w,h,max)
    local table_pos ={}
    for i=1,max  do
        local x = random_int(w)
        local y = random_int(h)
        --print(i,x,y)

        table.insert(table_pos,{x=x,y=y})
    end
    
    return table_pos
end



function get_color(im,color_string)
    --[[
    白色：rgb(255,255,255) --WHITE
    黑色：rgb(0,0,0)  --BLACK
    红色：rgb(255,0,0)  --RED
    绿色：rgb(0,255,0)  --GREEN
    蓝色：rgb(0,0,255)  --blue
    青色：rgb(0,255,255) --qin
    紫色：rgb(255,0,255) -- PURPLE
    --]]
    
    local tab_col_all ={
        white = {r=255,g=255,b=255},
        black = {r=0,g=0,b=0},
        red = {r=255,g=0,b=0},
        green = {r=0,g=255,b=0},
        blue = {r=0,g=0,b=255},
        qin = {r=0,g=255,b=255},
        purple = {r=255,g=0,b=255},
    }

    local tab_col = tab_col_all[color_string] or tab_col_all.white
    --local tab_col = tab_col_all["red"] 

    local r = tab_col.r or 255
    local g = tab_col.g or 255
    local b = tab_col.b or 255
    print(color.RED,r,g,b,color.RED)
    return  im:colorAllocate(r, g, b)
    --return  {r, g, b}
end


function draw_string(im,tab_string)
    --to do
    local x = tab_string.x or 0
    local y = tab_string.y or 0
    local stringmark = tab_string.string or "hello"
    --local white = tab_string.color or  im:colorAllocate(255, 255, 255)
    local white = tab_string.color or im:colorAllocate(255, 255, 255)
    local ptsizee = tab_string.ptsizee or 9
    local angle = tab_string.angle or 1
    local font_chinese = "/usr/share/fonts/truetype/wqy/wqy-microhei.ttc"
    im:string(font_chinese, x, y, stringmark, white,ptsizee,angle)
end


function draw_line(im,table_pos,color_256)
    --to do
    if not im then
        print("im fail !!!")
        return nil
    end

    if not next(table_pos) then 
        print("table is nil !!!")
        return nil
    end

   for i=1,#table_pos  do
       
       local tab_pos_cur = table_pos[i]

       local tab_pos_old = i == 1 and tab_pos_cur  or   table_pos[ i - 1 ]

       local x1= tab_pos_old.x
       local y1= tab_pos_old.y
       local x2= tab_pos_cur.x
       local y2= tab_pos_cur.y
       local name = tab_pos_cur.name or nil
        
       print(color.YELLOW,x1,y1,x2,y2,color.WHITE)

       im:line(x1,y1,x2,y2,color_256)
       im:line(x2,0,x2,y2, get_color(im2,"blue") )
       local tab_string={
            x=x2,
            y=y2,
            string = name or x2.."___"..y2,
            color = get_color(im,"white")
       }
        draw_string(im,tab_string)
   end

end



local gd = require("gd")

out_file = arg[0].."__output.png"

xo,yo = 5000*1.5,2000*2
local hb_date,max_x,max_y = add_json()
print("max_x,max_y",max_x,max_y)

xo=max_x
yo=max_y
im2 = gd.createTrueColor(xo, yo)
white = im2:colorAllocate(255, 255, 255)
--table_pos=get_random_pos(xo,yo,10)
--draw_line(im2,table_pos,white)

local color_confirm = get_color(im2,"white")
local color_dead  = get_color(im2,"red")
local color_heal  = get_color(im2,"green")



local table_pos_confirm = hb_date.confirm
local table_pos_dead = hb_date.dead
local table_pos_heal = hb_date.heal

draw_line(im2,table_pos_confirm,color_confirm)
draw_line(im2,table_pos_dead,color_dead)
draw_line(im2,table_pos_heal,color_heal)

local readme ={
    x=xo/2,
    y= yo/2,
    string = [[
            每日新增
            白折线表示确诊
            红折线表示死亡
            绿折线表示治愈
    ]],
    ptsizee = 20
    
}
draw_string(im2,readme)


im2:png(out_file)




print("---------done--------",os.date( " %Y%m%d%H,%M" ))



