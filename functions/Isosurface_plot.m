function Isosurface_plot(H,K,L,M,isovalue,c_val) 

[H_3D,K_3D,L_3D]=meshgrid(K,H,L);

Font=16;


L_3D_c=L_3D(H<=c_val & H>=-c_val,K<=c_val & K>=-c_val,L<=c_val & L>=-c_val);
K_3D_c=K_3D(H<=c_val & H>=-c_val,K<=c_val & K>=-c_val,L<=c_val & L>=-c_val);
H_3D_c=H_3D(H<=c_val & H>=-c_val,K<=c_val & K>=-c_val,L<=c_val & L>=-c_val);
Ms_c=M(H<=c_val & H>=-c_val,K<=c_val & K>=-c_val,L<=c_val & L>=-c_val);

figure
colormap magma
Ms = smooth3(Ms_c);


hiso = patch(isosurface(H_3D_c,K_3D_c,L_3D_c,Ms,isovalue),...
   'FaceColor',[1,.75,.65],...
   'EdgeColor','none');
   isonormals(H_3D_c,K_3D_c,L_3D_c,Ms,hiso)
   
   
hcap = patch(isocaps(H_3D_c,K_3D_c,L_3D_c,Ms,isovalue),...
   'FaceColor','interp',...
   'EdgeColor','none');   
   
 
axis tight 

lightangle(45,30);
lighting gouraud
hcap.AmbientStrength = 0.6;
hiso.SpecularColorReflectance = 0;
hiso.SpecularExponent = 50;
view(37,21)
daspect([1,1,1])
set(gcf,'color','w')
set(gca,'TickDir','out');
xlabel('H [r.l.u.]');ylabel('K [r.l.u.]');zlabel('L [r.l.u.]')
ax=gca;ax.FontSize=Font;ax.Box='on';


            set(gca,'CLim',[0 3e2],'DataAspectRatio',[1 1 1],'LineWidth',2,'TickDir','out',...
                'TickLength',[0.015 0.015]);


end