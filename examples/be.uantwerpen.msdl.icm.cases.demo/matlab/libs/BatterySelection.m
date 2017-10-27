function [ Ceff,m,l,w,h ] = BatterySelection( Cdes,BatteryDB )
%BATTERYSELECTION

iBat	= find([BatteryDB.C]>=Cdes,1,'first');
Ceff	= BatteryDB(iBat).C; % [Ah]
m       = BatteryDB(iBat).m; % [kg]
l       = BatteryDB(iBat).l; % [m]
w       = BatteryDB(iBat).w; % [m]
h       = BatteryDB(iBat).h; % [m]

end

