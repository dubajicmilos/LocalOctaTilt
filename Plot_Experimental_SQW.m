clearvars
clc
close all
addpath(genpath(pwd));

%%
save_name = 'P21_1_MAPbBr3_300K.mat';
load(save_name,'Int_total','z_total','hmin','hmax','kmin','kmax','lmin','lmax');

%%
Int_total_t=Int_total./z_total; Int_total_t(isnan(Int_total_t))=0;

n_steps=size(Int_total_t);
qh=linspace(hmin,hmax,n_steps(1));
qk=linspace(kmin,kmax,n_steps(2));
ql=linspace(lmin,lmax,n_steps(3));

%% 1.5KL
n = 1.5; % q value along the integration axis
dlq=0.025; % half of the integration size


[dp,xp,yp,zp]=slice_cube(Int_total_t,qh,qk,ql,[-dlq dlq]+n,[kmin kmax],[lmin lmax],[1 0 0]);
dp_bgr=dp-mean(min(dp));


figure()
plots.Colormap(yp,xp,(dp/max(max(dp)))')
uf.SCXRD.details_paper(uf.SCXRD.gborder)
set(gca,'CLim',[0 1])

figure()
plots.Colormap(yp,xp,(dp_bgr/max(max(dp_bgr)))')
uf.SCXRD.details_paper(uf.SCXRD.gborder)
set(gca,'CLim',[0 1])

%% H1.5L
[dp,xp,yp,zp]=slice_cube(Int_total_t,qh,qk,ql,[hmin hmax],[-dlq dlq]+n,[lmin lmax],[0 1 0]);

dp_bgr=dp-mean(min(dp));


figure()
plots.Colormap(yp,xp,(dp/max(max(dp)))')
uf.SCXRD.details_paper(uf.SCXRD.gborder)
set(gca,'CLim',[0 1])

figure()
plots.Colormap(yp,xp,(dp_bgr/max(max(dp_bgr)))')
uf.SCXRD.details_paper(uf.SCXRD.gborder)
set(gca,'CLim',[0 1])

%% HK1.5
[dp_target,xp,yp,zp]=slice_cube(Int_total_t,qh,qk,ql,[hmin hmax],[kmin kmax],[-dlq dlq]+n,[0 0 1]);
dp_bgr=dp_target-mean(min(dp_target));


figure()
plots.Colormap(yp,xp,(dp_target/max(max(dp_target)))')
uf.SCXRD.details_paper(uf.SCXRD.gborder)
set(gca,'CLim',[0 1])

figure()
plots.Colormap(yp,xp,(dp_bgr/max(max(dp_bgr)))')
uf.SCXRD.details_paper(uf.SCXRD.gborder)
set(gca,'CLim',[0 1])
%% QEDS plots
n = 1.5; % q value along the integration axis
dlq=0.025; % half of the integration size

% figure(103)
% clf, dime(20,20)
[dp1,xp,yp,zp]=slice_cube(Int_total_t,qh,qk,ql,[hmin hmax],[kmin kmax],[-dlq dlq]+n,[0 0 1]);

[dp2,xp,yp,zp]=slice_cube(Int_total_t,qh,qk,ql,[hmin hmax],[kmin kmax],[-dlq dlq]+(n+0.2),[0 0 1]);
% TDS is estimated to be at HK1.5+0.2 plane, so this has to be extracted
% for pure QEDS

dp=dp1-0.7*dp2; % We use emphirical factor that multiplies HK1.7 plane to make sure we don't get negative values after subtraction
dp_bgr=dp-mean(min(dp));


dp2_bgr=dp2-mean(min(dp2));

figure()
Colormap(yp,xp,(dp2_bgr/max(max(dp2_bgr)))')
uf.SCXRD.details_paper(uf.SCXRD.gborder)
set(gca,'CLim',[0 1])

figure()
Colormap(yp,xp,(dp/max(max(dp)))')
uf.SCXRD.details_paper(uf.SCXRD.gborder)
set(gca,'CLim',[0 1])

figure()
Colormap(yp,xp,(dp_bgr/max(max(dp_bgr)))')
uf.SCXRD.details_paper(uf.SCXRD.gborder)
set(gca,'CLim',[0 1])
%%
