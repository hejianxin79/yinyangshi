--开发设备分辨率
DEVELOP_SCREEN_W = 1920;
DEVELOP_SCREEN_H = 1080;
--应用设备分辨率
w,h=getScreenSize();
DEVICE_SCREEN_W = 0;
DEVICE_SCREEN_H = 0;
if w > h then
    DEVICE_SCREEN_W = w;
    DEVICE_SCREEN_H = h;
else
    DEVICE_SCREEN_W = h;
    DEVICE_SCREEN_H = w;
end
nLog("设备分辨率为:"..tostring(DEVICE_SCREEN_W).."X"..tostring(DEVICE_SCREEN_H));

--计算开发设备与应用设备屏幕比例值
function screenRatio(grid)
    c = DEVELOP_SCREEN_W / DEVELOP_SCREEN_H;
    
    ys = DEVELOP_SCREEN_H / DEVICE_SCREEN_H;
    
    sr = grid / ys;
    
    sw = DEVICE_SCREEN_W / DEVICE_SCREEN_H;
    if(sw > c) then
       sw = c; 
    end
    fr = sr/c * sw;
    return fr;
end
--颜色比例转换
function colorFeatureTrans(features)
    --分割字符串
    local tstr = strSplit(features,",");
    local newColors = "";--转换完毕后的颜色特征
    for k,v in pairs(tstr) do
       local fg2 = strSplit(v,"|");
       local newc = screenRatio(fg2[1]).."|"..screenRatio(fg2[2]).."|"..fg2[3];
       if #newColors < 1 then
           newColors = newc;
        else
            newColors = newColors..","..newc;
        end
    end
    return newColors;
end

--锚点比例转换
function anchorTrans(anchor)
    relative_point = {};
    if anchor.m ~= "nil" then
        if anchor.m == 1 then
            relative_point = {0,0};
        elseif anchor.m == 2 then
            relative_point = {DEVELOP_SCREEN_W/2,0};
        elseif anchor.m == 3 then
            relative_point = {DEVELOP_SCREEN_W,0};
        elseif anchor.m == 4 then
            relative_point = {0,DEVELOP_SCREEN_H/2};
        elseif anchor.m == 5 then
            relative_point = {DEVELOP_SCREEN_W/2,DEVELOP_SCREEN_H/2};
        elseif anchor.m == 6 then
            relative_point = {DEVELOP_SCREEN_W,DEVELOP_SCREEN_H/2};
        elseif anchor.m == 7 then
            relative_point = {0,DEVELOP_SCREEN_H};
        elseif anchor.m == 8 then
            relative_point = {DEVELOP_SCREEN_W/2,DEVELOP_SCREEN_H};
        elseif anchor.m == 9 then
            relative_point = {DEVELOP_SCREEN_W,DEVELOP_SCREEN_H};
        end
        
        local spx = screenRatio(anchor[4] - relative_point[1]);
        local spy = screenRatio(anchor[5] - relative_point[2]);
        local spx2 = screenRatio(anchor[6] - relative_point[1]);
        local spy2 = screenRatio(anchor[7] - relative_point[2]);
        trans_relative_point = {};
        if anchor.m == 1 then
            trans_relative_point = {0,0};
        elseif anchor.m == 2 then
            trans_relative_point = {DEVICE_SCREEN_W/2,0};
        elseif anchor.m == 3 then
            trans_relative_point = {DEVICE_SCREEN_W,0};
        elseif anchor.m == 4 then
            trans_relative_point = {0,DEVICE_SCREEN_H/2};
        elseif anchor.m == 5 then
            trans_relative_point = {DEVICE_SCREEN_W/2,DEVICE_SCREEN_H/2};
        elseif anchor.m == 6 then
            trans_relative_point = {DEVICE_SCREEN_W,DEVICE_SCREEN_H/2};
        elseif anchor.m == 7 then
            trans_relative_point = {0,DEVICE_SCREEN_H};
        elseif anchor.m == 8 then
            trans_relative_point = {DEVICE_SCREEN_W/2,DEVICE_SCREEN_H};
        elseif anchor.m == 9 then
            trans_relative_point = {DEVICE_SCREEN_W,DEVICE_SCREEN_H};
        end
        local zspx = trans_relative_point[1] + spx;
        local zspy = trans_relative_point[2] + spy;
        local zspx2 = trans_relative_point[1] + spx2;
        local zspy2 = trans_relative_point[2] + spy2;
        anchor[4] = zspx;
        anchor[5] = zspy;
        anchor[6] = zspx2;
        anchor[7] = zspy2;
    end
end


function ScreenAdapt(t)
    for k,v in pairs(t) do
        if type(v[1]) == "string" then
            --v[1]字符串格式说明是字库类特征
        else
            --取色类特征
            v[2] = colorFeatureTrans(v[2]);  --颜色比例转换
            anchorTrans(v);  --锚点比例转换
        end
    end
end