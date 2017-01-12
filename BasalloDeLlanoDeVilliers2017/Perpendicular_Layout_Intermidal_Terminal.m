clear all
close all
clc
path(path,'C:\BasalloDeLlanoDeVilliers2017\Intermodal_Terminal\Intermodal_Perp-Layout');


% PERPENDICULAR LAYOUT OF AN INTERMODAL TERMINAL
% =========================================================================
% This scripts computes the optimal layout of an intermodal terminal with
% perpendicular layout. In order to solve an specific instance of the
% problem you must adjust the values of the parameters required.


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
LmaxP = 25;      % Maximum length of a container block
e = 2.6;         % Width of a TEU required for a ground slot [m]
l = 6.25;        % Length of a TEU required for a ground slot [m]
h = 15;          % Width of the intersection aisle [m]
v = 18;          % Width of the working aisle [m]
Beta = 0.5;      % Relative importance of trains/barges related operations
                 % with respect to truck operations

tic
a = a*10000;

% OPTIMIZATION PROCEDURE
% ======================
Wmax = floor( (gamma - 2*v)/e );
Results = [];
if Wmax < 1
    fprintf('The problem is infeasible.\n\n');
else
    W = 1;
    while W <= min(10, Wmax) && Wmax >= 1
        
        % Number of columns of blocks
        N = floor( ( gamma - v )/(v+W*e) );
        
        % Length of the block
        Lmax = floor( ( a/gamma - 2*h )*(1/l) );
        B = (N+1)*v + N*W*e;
        
        L = 1;
        while L <= min(LmaxP, Lmax) && Lmax >= 1 && N >= 1
            
            for H = 1:Hmax
                
                M = ceil((1/(L*W*H*N))*f*tau/u);
                A = (M+1)*h + M*L*l;
                
                % Check for feasibility
                if N < 1 || L < 1 || M < 1 || (gamma - B)/gamma > 0.05 || A*gamma >= a
                    Cycle_Time = inf;
                    Results = cat(1, Results, [1, N, L, W, H, Cycle_Time]);
                else
                    
                    % Compute the expected trains/barges related distance
                    % (see folder: 'Intermodal_Terminal -> Intermodal_Perp-Layout')
                    Train_Dist = TrainsBarges_Related_Distance(A, N, W, v, e);
                    
                    % Compute the expected truck related distance
                    Truck_Dist = Truck_Related_Distance(M, N, L, W, l, e, v, h);
                    
                    % Compute the expected number of rehandles
                    % (see folder: 'Intermodal_Terminal -> Intermodal_Perp-Layout')
                    [R, Hbar] = Exp_Rehandles_PeIT(1, N, W, L, H, f, tau);
                    
                    % Compute the cycle time
                    ts = 2.01*Hbar^2 - 6.95*Hbar + 17.02;
                    Cycle_Time = 0.5*(Rt*R + ts) + Beta*Tt*Train_Dist + (1 - Beta)*Tt*Truck_Dist;
                    
                    Results = cat(1, Results, [M, N, L, W, H, Cycle_Time]);
                end
            end
            
            L = L + 1;
        end
        
        W = W + 1;
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
        
        load Res-PeIT
        fprintf('Results for the decision variables');
        [Res num2cell(round(Results(Results(:,end) <= min(Results(:,end)),:)'))]
        Results = Results(find(Results(:,end) <= min(Results(:,end)),1),:);
        
        L = Results(3);
        M = Results(1);
        N = Results(2);
        W = Results(4);
        H = Results(5);
        A = (M+1)*h + M*L*l;
        B = (N+1)*v + N*W*e;
        fprintf('Percentage of used area');
        round((A*B/a)*1000)/10
        %round((A*gamma/a)*1000)/10
        fprintf('Percentage of excess in volume');
        round(((L*H*W*N*M - f*tau/u)/(f*tau/u))*1000)/10
        fprintf('Perentage of loss of length');
        100 - round((((N+1)*v + N*W*e)/gamma)*1000)/10
        
        fprintf('Actual utilization factor (percentage)');
        round((u/(1+((L*H*W*N*M - f*tau/u)/(f*tau/u))))*1000)/10
    end
end

