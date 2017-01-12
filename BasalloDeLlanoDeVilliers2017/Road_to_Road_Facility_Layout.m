
clear all
close all
clc
path(path,'C:\BasalloDeLlanoDeVilliers2017\Road_Terminal');


% PARALLEL LAYOUT OF A ROAD TERMINAL
% =========================================================================
% This scripts computes the optimal layout of a road terminal with parallel 
% configuration. In order to solve an specific instance of the problem you 
% must adjust the values of the parameters required.


% PARAMETERS (Adjust this values if required)
% ==========
Tt = 0.18;       % Travel Time per meter of the yard machine [sec/m]
Rt = 270;        % Average rehandling time per container [sec/TEU]
a = 1.4;         % Maximum available area of the container yard [Ha]
f = 91;          % Arrival rate of containers [TEUs/day]
tau = 3;         % Residence time of containers [days]
u = 0.8;         % Utilization factor [%]
Hmax = 4;        % Maximum allowable height for a block [TEUs]
LmaxP = 25;      % Maximum length of a container block
e = 2.6;         % Width of a TEU required for a ground slot [m]
l = 6.25;        % Length of a TEU required for a ground slot [m]
h = 15;          % Width of the intersection aisle [m]
v = 18;          % Width of the working aisle [m]


tic
a = a*10000;

% OPTIMIZATION PROCEDURE
% ======================
Results = [];
Lmax = floor( ( (a/(2*v + e)) - 2*h )*(1/l) );
L = 1;
if Lmax < 1 % Check for feasibility
    fprintf('The problem is infeasible.\n\n');
else
    while L  <= min(Lmax, LmaxP)
        
        Nmax = floor( ( (a/(2*v + e)) - h )*(1/(h+l*L)) );
        N = 1;
        while N <= Nmax && Nmax >= 1
            
            Wmax = min(25, floor( ( a/((N+1)*h + N*L*l) - 2*v )*(1/e) ));
            W = 1;
            while W <= min(Wmax, 10) && Wmax >= 1
                
                for H = 1:Hmax
                    M = ceil((1/(L*W*H*N))*f*tau/u);
                    A = (M + 1)*v + M*W*e;
                    B = (N + 1)*h + N*L*l;
                    
                    % Check for feasibility
                    if M < 1 || A*B > a
                        Cycle_Time = inf;
                        Results = cat(1, Results, [M, N, L, W, H, Cycle_Time]);
                    else
                        
                        % Compute the expected truck related distance
                        % folder: 'Road_Terminal -> Road_Paral-Layout'
                        d = Dist_Truck_Related(M, N, L, W, l, e, v, h);
                        
                        % Compute the expected total number of rehandles
                        % (see folder: 'Road_Terminal -> Road_Paral-Layout')
                        [R, Hbar] = Exp_Rehandles_PaRT(M, N, W, L, H, f, tau);
                        
                        % Compute the cycle time
                        ts = 2.01*Hbar^2 - 6.95*Hbar + 17.02;
                        Cycle_Time = 0.5*(Rt*R + ts) + Tt*d;
                        %Cycle_Time = ts + Tt*d;
                        
                        Results = cat(1, Results, [M, N, L, W, H, Cycle_Time]);
                        
                    end
                end
                
                W = W + 1;
            end
            
            N = N + 1;
        end
        
        L = L + 1;
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
        
        load Res-PaRT
        fprintf('Results for the decision variables');
        [Res num2cell(round(Results(Results(:,end) <= min(Results(:,end)),:)'))]
        Results = Results(find(Results(:,end) <= min(Results(:,end)),1),:);
        
        M = Results(1);
        N = Results(2);
        L = Results(3);
        W = Results(4);
        H = Results(5);
        A = (M + 1)*v + M*W*e;
        B = (N + 1)*h + N*L*l;
        fprintf('Percentage of used area');
        round(((A*B)/a)*1000)/10
        %fprintf('Percentage of excess in capacity');
        %round(((L*H*W*N*M - f*tau/u)/(f*tau/u))*1000)/10
        
        %fprintf('Actual utilization factor (percentage)');
        %round((u/(1+((L*H*W*N*M - f*tau/u)/(f*tau/u))))*1000)/10
    end
end
