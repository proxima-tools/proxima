function [ Peff,m,l,r ] = MotorSelection( Pdes,MotorDB )
%MOTORSELECTION

iMot	= find([MotorDB.P]>=Pdes,1,'first');
Peff	= MotorDB(iMot).P; % [kW]
m       = MotorDB(iMot).m; % [kg]
l       = MotorDB(iMot).l; % [m]
r       = MotorDB(iMot).r; % [m]

end

