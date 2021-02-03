function [mPlatform, mTot, IxxTot, IyyTot, IzzTot] = MechanicalDesign(mBat,lBat,wBat,hBat,...
    mMot,lMot,rMot)

% Assumptions:
% Battery is placed at the center of the robot
    % length = y-axis, width = x-axis, height = z-axis
Bat.x = 0;
Bat.y = 0;
Bat.z = hBat/2;
Bat.m = mBat;
elements = {Bat};
% Motors are placed at opposite ends of the battery
    % parallel to the y-axis, perpendicular to the x and z-axes
Mot1.x = 0;
Mot1.y = wBat/2+lMot/2;
Mot1.z = rMot;
Mot1.m = mMot;
Mot2.x = 0;
Mot2.y = -(wBat/2+lMot/2);
Mot2.z = rMot;
Mot2.m = mMot;
elements{end+1} = Mot1;
elements{end+1} = Mot2;
% Magnets are placed next to the batteries in the x-direction
Mag1.x = lBat/2+0.087/2;
Mag1.y = 0;
Mag1.z = 0;
Mag1.m = 2.989;
Mag2.x = -(lBat/2+0.087/2);
Mag2.y = 0;
Mag2.z = 0;
Mag2.m = 2.989;
elements{end+1} = Mag1;
elements{end+1} = Mag2;
% Base is a circle,
% with a plate thickness determined by the battery and motor mass
Base.x = 0;
Base.y = 0;
Base.z = 0;
Base.rho = 7800;
Base.r = wBat/2+lMot;

mOnBase = 0;
for curEl = elements
    mOnBase = mOnBase + curEl{1}.m;
end
Base.t = 3*mOnBase/1E5; % Linear approximation of the thickness

Base.m = Base.rho * pi * Base.r^2 * Base.t;
Base.Ixx = 1/12*Base.m*(3*Base.r^2+Base.t^2);
Base.Iyy = 1/12*Base.m*(3*Base.r^2+Base.t^2);
Base.Izz = 1/2*Base.m*Base.r^2;

elements{end+1} = Base;
% Sum all elements
mTot = 0; IxxTot = Base.Ixx; IyyTot = Base.Iyy; IzzTot = Base.Izz;
for curEl = elements
    mTot = mTot + curEl{1}.m;
    IxxTot = IxxTot + curEl{1}.m*(curEl{1}.y^2+curEl{1}.z^2);
    IyyTot = IyyTot + curEl{1}.m*(curEl{1}.x^2+curEl{1}.z^2);
    IzzTot = IzzTot + curEl{1}.m*(curEl{1}.x^2+curEl{1}.y^2);
end

mPlatform = Base.m;

end