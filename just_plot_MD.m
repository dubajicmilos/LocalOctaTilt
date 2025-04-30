% clearvars
% clc
% close all


addpath(genpath(pwd));

%% Load MD data

filename='MD_hk1.5_MAPbBr3_340K.hdf5';


name = fullfile(pwd, filename);

[SQ_QS, SQ_full, H, K, Energy, array3D] = loadMD_Data(name);


Hf=-5:0.05:5;
Kf=Hf;

Tot = createMatrixFromTopRight(SQ_QS); % To plot QEDS

Tot = createMatrixFromTopRight(SQ_full); % To plot full Diffuse Scattering pattern (fully energy integrated)

%%

m1=matrix(Hf,Kf,Tot'); %All data (HK1.5)

[X_exp, Y_exp ,M1c]=cutmatirx(m1,[-5 5],[-5 5]);


% Plot Experimental(MD) data
figure()
plots.Colormap(X_exp,Y_exp ,M1c')
uf.SCXRD.details_paper(uf.SCXRD.gborder)
set(gca,'CLim',[0 1])




