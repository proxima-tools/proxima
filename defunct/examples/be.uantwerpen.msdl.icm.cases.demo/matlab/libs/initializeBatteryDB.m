function BatterySelection = BatterySelection(catalogName)
BatterySelection = [];
%% Load data
dataArray = csvread(catalogName,1,0);
C.data = dataArray(:, 1); % [Ah]
w.data = dataArray(:, 2)./1000; % [m]
l.data = dataArray(:, 3)./1000; % [m]
t.data = dataArray(:, 4)./1000; % [m]
m.data = dataArray(:, 5); % [kg]

%% Create least-squares model
w.coef = [ones(size(C.data)) C.data]\w.data;
l.coef = [ones(size(C.data)) C.data]\l.data;
t.coef = [ones(size(C.data)) C.data]\t.data;
m.coef = [ones(size(C.data)) C.data]\m.data;

%% Interpolate to create a "limited" database
Cvect = 2:10:102;
for Ccur = Cvect
    BatterySelection = addOne(BatterySelection,Ccur,...
        [1 Ccur]*m.coef,...
        [1 Ccur]*w.coef,...
        [1 Ccur]*l.coef,...
        [1 Ccur]*t.coef);
end

%% Output
BatterySelection = orderByField(BatterySelection,'C');

    % Add a single battery
    function cur = addOne(cur,C,m,l,w,h)
        new.C = C;
        new.m = m;
        new.l = l;
        new.w = w;
        new.h = h;
        cur = [cur; new];
    end
    % Order according to the given field
    function res = orderByField(in,fieldName)
        fieldContent = [in.(fieldName)];
        [~,iOrdering] = sort(fieldContent);
        res = in(iOrdering);
    end

end