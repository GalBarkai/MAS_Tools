function fcn_FormationPlot(xVec,A,n,varargin)
% FCN_FORMATIONPLOT takes in a an adjacency matrix, a 2n x m coordinate
%                   matrix and the number of agents 'n' and plots the
%                   trajectories of the agents in the x-y plane. The
%                   adjacency matrix is used to draw initial and final
%                   formations, drawing edges between neighboring nodes.
%                   Additonal arguments can be used by string-value pairs,
%                   for example fcn_FormationPlot(xVec,A,n,'Grid','On')
%                   will draw grids to the plot, while 'Off' would not.
%
%  'Grid'           draws axes and a grid. Possible values are 'On' and
%                   'Off', default is on.
%
%  'MidFormations'  draws additonal formations besides start and end. Takes
%                   values of 'Yes' and 'No', default is 'No'. Must be
%                   accompanied by 'Index'.
%
%   'Index'         a vector of the relevant indicies in xVec, for which to
%                   draw formations at intermediate points.

% Parse input
defaultGrid = 'On';
expectedGrid = {'On','Off'};
expectedFormations = {'Yes','No'};
defaultMid='No';
defaultMidIndex=0;

p=inputParser;
validPosMat = @(x) isnumeric(x) && ismatrix(x);
addRequired(p,'xVec',validPosMat);
addRequired(p,'A',validPosMat);
addRequired(p,'n',@isscalar);
addParameter(p,'Grid',defaultGrid,@(x)any(validatestring(x,expectedGrid)));
addParameter(p,'MidFormations',defaultMid,@(x)any(validatestring(x,expectedFormations)));
addParameter(p,'Index',defaultMidIndex,@isnumeric);
parse(p,xVec,A,n,varargin{:});
    neighborMat=p.Results.A;
    num=p.Results.n;
    xVec=p.Results.xVec;
    Grid=p.Results.Grid;
    MidFormations=p.Results.MidFormations;
    Ind=p.Results.Index;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
graycolor=[0.5 0.5 0.5];
markersize=14;
textsize=10;
finalcolor=[0 0 1]*0.8;
%
figure;
hold on; box on; axis equal
switch Grid
    case 'On'
        fontsize=10;
        set(gca, 'fontSize', fontsize)
        set(get(gca, 'xlabel'), 'String', 'x', 'fontSize', fontsize);
        set(get(gca, 'ylabel'), 'String', 'y', 'fontSize', fontsize);
        grid on;
    case 'Off'
        set(gca, 'xtick', [])
        set(gca, 'ytick', [])
        boxcolor=0.7*ones(1,3);
        set(gca, 'xcolor', boxcolor)
        set(gca, 'ycolor', boxcolor)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot agent trajectory
for i=1:num
    xi_all=xVec(:,2*i-1);
    yi_all=xVec(:,2*i);
    plot(xi_all, yi_all, '--', 'color', graycolor);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot initial formation
for i=1:num
    for j=i+1:num
        if neighborMat(i,j)==1
            pi=xVec(1,2*i-1:2*i)';
            pj=xVec(1,2*j-1:2*j)';
            line([pi(1),pj(1)], [pi(2),pj(2)], 'linewidth', 2, 'color', graycolor);
        end
    end
end
for i=1:num
    xi_init=xVec(1,2*i-1);
    yi_init=xVec(1,2*i);
    plot(xi_init, yi_init, 'o', 'MarkerEdgeColor', graycolor, 'MarkerFaceColor', graycolor, 'markersize', 7)
end

% Mark initial locations
for i=1:num
    xi_init=xVec(1,2*i-1);
    yi_init=xVec(1,2*i);
    plot(xi_init, yi_init, 'o', ...
        'MarkerSize', markersize,...
        'linewidth', 2,...
        'MarkerEdgeColor', graycolor,...
        'markerFaceColor', 'white');
    text(xi_init, yi_init, num2str(i),...
        'color', graycolor, 'FontSize', textsize, 'horizontalAlignment', 'center', 'FontName', 'times');
end

% Plot final formation
for i=1:num
    for j=i+1:num
        if neighborMat(i,j)==1
            pi=xVec(end,2*i-1:2*i)';
            pj=xVec(end,2*j-1:2*j)';
            line([pi(1),pj(1)], [pi(2),pj(2)], 'linewidth', 2, 'color', finalcolor);
        end
    end
end

% Mark final locations
for i=1:num
    xi_init=xVec(end,2*i-1);
    yi_init=xVec(end,2*i);
        plot(xi_init, yi_init, 'o', ...
        'MarkerSize', markersize,...
        'linewidth', 2,...
        'MarkerEdgeColor', finalcolor,...
        'markerFaceColor', [1 1 1]);
    text(xi_init, yi_init, num2str(i),...
        'color', finalcolor, 'FontSize', textsize, 'horizontalAlignment', 'center', 'FontName', 'times');
end
% intermediate formation
switch MidFormations
    case 'Yes'
        for k=1:length(Ind)
            for i=1:num
                for j=i+1:num
                    if neighborMat(i,j)==1
                        pi=xVec(Ind(k),2*i-1:2*i)';
                        pj=xVec(Ind(k),2*j-1:2*j)';
                        line([pi(1),pj(1)], [pi(2),pj(2)], 'linewidth', 1, 'color', rand(1,3));
                    end
                end
            end
        end
    case 'No'
        %
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set limit
xlim=get(gca, 'xlim');
ylim=get(gca, 'ylim');
delta=0.2;
xlim=xlim+[-delta,delta];
ylim=ylim+[-delta,delta];
set(gca, 'xlim', xlim, 'ylim', ylim);
end
