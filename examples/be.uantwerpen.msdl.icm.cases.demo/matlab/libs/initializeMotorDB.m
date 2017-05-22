function MotorSelection = MotorSelection()
MotorSelection = [];
%% Settings
powerToWeight = 2; % [kW/kg] --> based on UQM PP 100
density = 50/(0.233*(0.286/2)^2*pi); % [kg/m3] --> based on UQM PP 100

%% Interpolate to create a "limited" database
Pvect = 10:10:200; % [kW]
for i = 1:length(Pvect)
    Pcur = Pvect(i);
    m = Pcur/powerToWeight;
    r = 0.286/2;
    l = m/(density*pi*r^2);
    MotorSelection = addOne(MotorSelection,Pcur,m,l,r);
end

%% Output
MotorSelection = orderByField(MotorSelection,'P');

    % Add a single battery
    function cur = addOne(cur,P,m,l,r)
        new.P = P;
        new.m = m;
        new.l = l;
        new.r = r;
        cur = [cur; new];
    end
    % Order according to the given field
    function res = orderByField(in,fieldName)
        fieldContent = [in.(fieldName)];
        [~,iOrdering] = sort(fieldContent);
        res = in(iOrdering);
    end

end