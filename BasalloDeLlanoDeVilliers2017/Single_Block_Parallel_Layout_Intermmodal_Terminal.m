clear all
close all
clc
path(path,'C:\BasalloDeLlanoDeVilliers2017\Single_Block_Intermodal_Terminal');


% PARALLEL LAYOUT OF AN INTERMODAL TERMINAL
% =========================================================================
% This scripts computes the optimal layout of an intermidal terminal with 
% a signle container block parallel to rail tracks. In order to solve an
% specific instance of the problem you must adjust the values of the
% parameters if required.


% PARAMETERS (Adjust this values if required)
% ==========
Tt = 0.18;       % Travel Time per meter of the yard machine [sec/m]
Rt = 270;        % Rehandling time per container [sec/TEU]
a = 1.4;         % Maximum allowable area of the container yard [m^2]
gamma = 300;     % Required length of the rail tracks [m]
f = 91;          % Arrival rate of containers [TEUs/day]
tau = 3;         % Residence time of containers [days]
u = 0.8;         % Utilization factor
Hmax = 4;        % Maximum allowable height for a block [TEUs]
e = 2.6;         % Width of a TEU required for a ground slot [m]
l = 6.25;        % Length of a TEU required for a ground slot [m]
v = 22.5;          % Width of the working aisle [m]
Beta = 0.5;      % Relative importance of trains/barges related operations
                 % with respect to truck operations

tic
a = a*10000;

% OPTIMIZATION PROCEDURE
% ======================
Results = [];
L = floor( gamma/l );
if L < 1
    fprintf('The problem is infeasible.\n\n');
else
    
    for H = 1:Hmax;
        W = ceil(f*tau/(L*H*u));
        
        % Check for feasibility
        if gamma*(v + W*e) > a || W < 1
            Cycle_Time = inf;
            Results = cat(1, Results, [L, W, H, Cycle_Time]);
        else
            % Compute the expected distance
            Truck_Dist = (L^2 - 1)*l/(3*L);
            Train_Dist = 2*( v + (L^2 - 1)*l/(3*L) );
            
            % Compute the expected number of rehandles
            [R, Hbar] = Expected_Rehandles(W, L, H, f, tau);
            
            % Compute the cycle time
            ts = 2.01*Hbar^2 - 6.95*Hbar + 17.02;
            Cycle_Time = 0.5*(Rt*R + ts) + Beta*Tt*Train_Dist + (1 - Beta)*Tt*Truck_Dist;
            
            Results = cat(1, Results, [L, W, H, Cycle_Time]);
        end
    end
end

Time = toc;

% PRINTING OF RESULTS
% ===================
if isempty(Results)
    fprintf('The problem is infeasible.\n\n');
else
    if min(Results(:,end)) == inf
        fprintf('Running time');
        Time
        fprintf('The problem is infeasible.\n\n');
    else
        fprintf('Running time');
        Time
        
        load Res_SBPaIT
        fprintf('Results for the decision variables');
        [Res num2cell(round(Results(Results(:,end) <= min(Results(:,end)),:)'))]
        Results = Results(find(Results(:,end) <= min(Results(:,end)),1),:);
        
        L = Results(1);
        W = Results(2);
        H = Results(3);
        A = v + W*e;
        B = gamma;
        fprintf('Percentage of used area');
        round((A*B/a)*1000)/10
        fprintf('Percentage of excess in volume');
        round(((L*H*W - f*tau/u)/(f*tau/u))*1000)/10
        fprintf('Percentage of loss of length');
        100 - round((L*l/gamma)*1000)/10
        
    end
end

