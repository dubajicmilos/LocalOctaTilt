clearvars
clc
close all
addpath(genpath(pwd));
path_SF='Structure_Factor_Files';

%% MAPbBr3

filename='MAPbBr3_I4_mcm.txt';

name = fullfile(pwd, path_SF, filename);


phase='I4/mcm';

Plane='1.5KL';

plot_log_mode='lin';
plot_on_mode='on';

%%
simulation_function=@(a,b,c) local_symmetrized_fun(a,b,c);

par=[0.256412516	0.078330761	0.021337638	15.22830278	1.024027567]; %MAPbBr3 DESY 300K

[S,H,K,L]=simulation_function(name,phase,par);
[X,Y,Z]=two_D_slice(Plane,S,H,K,L,plot_log_mode,plot_on_mode);

figure()
Colormap(X,Y,(Z/max(max(Z)))')
set(gca,'CLim',[0 1])


%% Plot isosurface

par=[0.256412516	0.078330761	0.021337638	0	1.024027567]; %MAPbBr3 DESY 300K

[S,H,K,L]=simulation_function(name,phase,par);

isovalue=6;
c_val=1.75;

Isosurface_plot(H,K,L,S,isovalue,c_val) 

%% FAPbBr3

filename='FAPbBr3_P4_mbm_pseudocubic.txt';

phase='P4/mbm';
name = fullfile(pwd, path_SF, filename);

par=[0.11428078	0.075591433	0.000539108	1.135693401	100.0685359]; %We remove background for a cleaner isosurface


[S,H,K,L]=simulation_function(name,phase,par);
[X,Y,Z]=two_D_slice(Plane,S,H,K,L,plot_log_mode,plot_on_mode);

figure()
Colormap(X,Y,(Z/max(max(Z)))')
set(gca,'CLim',[0 1])



%% Plot isosurface

par=[0.11428078	0.075591433	0.000539108	0	100.0685359]; %We remove background for a cleaner isosurface

[S,H,K,L]=simulation_function(name,phase,par);

isovalue=1.5;
c_val=1.75;

Isosurface_plot(H,K,L,S,isovalue,c_val) 