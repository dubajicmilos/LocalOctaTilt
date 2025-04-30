function [S,H,K,L]=local_symmetrized_fun(name,phase,par)

G=import_hkl_v2(name); %Function that imports structure factors from the txt file. Txt file is generated from Single Crystal software. 

dq=0.05; % Q spacing in r.l.u of the 3D reciprocal lattice grid, adjust if finer resolution is needed
Q_size=5.5; %max(abs(Q)) of the grid

symmetry='2/m'; % Choose between -1 (for just applying inversion symmetry) and 2/m (for two fold rotation)
% If the symmetry of the reciprocal space is known a priori this saves
% computational time, given the high symmetry of the diffuse scattering
% even in the average tetragonal phase it is save to use 2/m point group

delta1=par(1); %Out-of-plane broadening (see eq. S4 in the SI)
delta2=par(2); %In-plane broadening (see eq. S4 in the SI)
C=par(3); % Equivalent to B in eq. S4 in the SI
bgr=par(4); % Equivalent to C in eq. S4 in the SI
deltag=par(5); % Equivalent to sigma_bgr in eq. S4 in the SI



sigma=0.0125/sqrt(2); % Assumed to be the resolution of the Bragg peaks


endH=Q_size;
endK=Q_size;
endL=Q_size;

TM_I=[[0.5 -0.5 0]; [0.5 0.5 0] ;[0 0 0.5]]; % Transformation matrix from  I4/mcm to Pm-3m

Rz = [0, -1, 0;
      1, 0, 0;
      0, 0, 1];

TM_abc=eye(3,3)*0.5*Rz; % Transformation matrix from  pseudocubic P4/mbm to Pm-3m, if P4/mbm structure factors are given in tetragonal notation use appropriate transforamtion matrix



if strcmp(phase,'I4/mcm')
    hkl_org=transform_hkl_no_inv(G,TM_I,eye(3,3));
end

if strcmp(phase,'P4/mbm')
    hkl_org=transform_hkl_no_inv(G,TM_abc,eye(3,3));
end



hkl_org(hkl_org(:,4)==0,:)=[];


H=-endH:dq:endH;
K=-endK:dq:endK;K=K';
L=-endL:dq:endL;


M=sparse(length(K),length(H),length(L));
Mg=gpuArray(M); %Move data to GPU

           
[H_3D,K_3D,L_3D]=meshgrid(K,H,L);

L_3Dg=gpuArray(L_3D);
K_3Dg=gpuArray(K_3D);
H_3Dg=gpuArray(H_3D);


sigmaL=sigma;
sigmaK=sigma;
sigmaH=sigma;

deltaH=delta2;
deltaK=delta2;
deltaL=delta1;
%%

hkl_org_g=gpuArray(hkl_org);
    
for i=1:size(hkl_org_g,1)
    
    if strcmp(symmetry,'-1')
        
        if (hkl_org_g(i,1) >= 0 && hkl_org_g(i,2) >= 0 && hkl_org_g(i,3) >= 0)  || ...
                (hkl_org_g(i,1) <= 0 && hkl_org_g(i,2) >= 0 && hkl_org_g(i,3) >= 0) || ...
                (hkl_org_g(i,1) >= 0 && hkl_org_g(i,2) <= 0 && hkl_org_g(i,3) >= 0) || ...
                (hkl_org_g(i,1) <= 0 && hkl_org_g(i,2) <= 0 && hkl_org_g(i,3) >= 0)        % Compute the term for the original coordinates
            
            M1g = computeTerm(L_3Dg, K_3Dg, H_3Dg, hkl_org_g, i, sigmaL, sigmaK, sigmaH, deltaL, deltaK, deltaH);
            
            M1g_inverted=inversion_3D_matrix(M1g);
            
            Mg = Mg + M1g + M1g_inverted;
            
        end
        
    end
    
    
    if strcmp(symmetry, '2/m')
        % Check if the point falls within the selected 2 octants
        if (hkl_org_g(i,1) >= 0 && hkl_org_g(i,2) >= 0 && hkl_org_g(i,3) >= 0) || ...
                (hkl_org_g(i,1) <= 0 && hkl_org_g(i,2) >= 0 && hkl_org_g(i,3) >= 0)
            
            % Compute the term for the selected octants
            M1g = computeTerm(L_3Dg, K_3Dg, H_3Dg, hkl_org_g, i, sigmaL, sigmaK, sigmaH, deltaL, deltaK, deltaH);
            
            % Apply two-fold rotation (180°) along the z-axis 
            M1g_rotated = flip(flip(M1g, 1), 2);  % Rotate by 180 degrees around the z-axis            
            % Apply mirror symmetry across the y-plane
            M1g_mirror_z = M1g(:, :, end:-1:1);  % Mirror across the XY-plane by flipping along the Z-axis            
            % Apply mirror symmetry to the rotated octants
            M1g_rotated_mirror_z = M1g_rotated(:, :, end:-1:1);  % Mirror the rotated octant across the XY-plane            
            % Accumulate the results
            Mg = Mg + M1g + M1g_rotated + M1g_mirror_z + M1g_rotated_mirror_z;
        end
        
    end
    
end

M=gather(Mg);

Mr = imrotate3(M,180,[1 0 -1],'nearest','crop'); %Mr = imrotate3(M,90,[0 1 0],'nearest','crop');
Mr1 = imrotate3(M,180,[0 1 -1],'nearest','crop'); %Mr1 = imrotate3(M,90,[1 0 0],'nearest','crop');


S=1*M+1*Mr+Mr1; % We need to sum all three twin local structure components


%S=M; %This line can be used if we want to simulate diffuse pattern if only
%1 twin is present

S=C*S+bgr*exp(-((L_3D-0).^2./(2*(deltag)^2)+(K_3D-0).^2./(2*(deltag)^2)+(H_3D-0).^2./(2*(deltag)^2)));


function M1g = computeTerm(L_3Dg, K_3Dg, H_3Dg, hkl_org_g, i, sigmaL, sigmaK, sigmaH, deltaL, deltaK, deltaH)


            
Gauss_3D_max_1 = @(L, K, H, hkl, i, sigmaL, sigmaK, sigmaH) ...
                hkl(i,4)^2 * exp(-((L - hkl(i,3)).^2 / (2 * sigmaL^2) + ...
                (K - hkl(i,2)).^2 / (2 * sigmaK^2) + ...
                (H - hkl(i,1)).^2 / (2 * sigmaH^2)));          


funct_global=Gauss_3D_max_1;
funct_local=Gauss_3D_max_1;


if (mod(hkl_org_g(i,1),1)==0 && mod(hkl_org_g(i,2),1)==0 && mod(hkl_org_g(i,3),1)==0)
    %M1g = 0.6e-3*funct_global(L_3Dg, K_3Dg, H_3Dg, hkl_org_g, i, sigmaL, sigmaK, sigmaH);
    
    % Adjust the coeficient here to match the coefficient A from the paper
    % Depening of the fitting method this coefficient may or may not be
    % relevant. If fitting is done simultaniosly in e.g. HK0 and HK1.5 then
    % it is relevant, if only in HK1.5 then it is not. 

    M1g = 1*funct_global(L_3Dg, K_3Dg, H_3Dg, hkl_org_g, i, sigmaL, sigmaK, sigmaH);

else

    M1g = 1*funct_local(L_3Dg, K_3Dg, H_3Dg, hkl_org_g, i, deltaL, deltaK, deltaH);
end
end

function Mf=inversion_3D_matrix(M)
Mf = M(end:-1:1, end:-1:1, end:-1:1); 
end


end
