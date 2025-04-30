function Colormap(Xaxis,Yaxis,M,varargin) %(Xaxis-array(n x 1),Yaxis-array(1 x m),M-array(n x m)),optional arguments: 1) struct with fields (xlabel,ylabel,zlabel,title), 2) font,3) limits as {[xmin xmax],[cbarmin cbarx]]}
%Plots 2D colormap(jet)of a M matrix with Xaxis,Yaxis axes. 
%call it with plots.Colormap()
if nargin<=4
    Font=14;
else
    Font=varargin{2};
end

% figure
[X,Y] = meshgrid(Yaxis',Xaxis');

% Uncoment to turn on Interpolation

% n=7;
% m=4;
% Yaxi=linspace(min(Yaxis),max(Yaxis),m*length(Yaxis));
% Xaxi=linspace(min(Xaxis),max(Xaxis),n*length(Xaxis));
% [Xi,Yi] = meshgrid(Yaxi',Xaxi');
% M=interp2(X,Y,M,Xi,Yi);
% surf(Yi,Xi,M,'edgecolor', 'none','facecolor','flat')


 %s1=surf(Y,X,M,'edgecolor', 'none','facecolor','flat');
 s1=surf(Y,X,M,'edgecolor', 'none','facecolor','interp');


% Activate this to make all 0s transparent (i.e transparent background)

% AlphaD=M;
% AlphaD(M~=0)=1;
% set(s1, 'AlphaData', AlphaD);
% s1.FaceAlpha = 'flat';



% addons.putvar(s1)

view(2);
colorbar
%colormap jet; % For special COLORMAPS (jet parula viridis cividis inferno magma plasma twilight gray )   refer to https://de.mathworks.com/matlabcentral/fileexchange/62729-matplotlib-perceptually-uniform-colormaps
colormap magma
% colormap(addons.redblue)       % For redblue colormap use the command
ylim([min(Yaxis) max(Yaxis)])
xlim([min(Xaxis) max(Xaxis)])
set(gca,'FontSize',Font)
set(gcf,'color','w')
set(gca,'TickDir','out','XMinorTick','on');
% set(gcf, 'Renderer', 'opengl')

if nargin>3
    
    xlabel(varargin{1}.xlabel,'FontSize',Font);
    ylabel(varargin{1}.ylabel,'FontSize',Font);
    zlabel(varargin{1}.zlabel,'FontSize',Font);
    title(varargin{1}.title);
end

if nargin>5
    tmp1=varargin{3};
    xlim(gca,tmp1{1})
    set(gca,'CLim',tmp1{2})
end

end