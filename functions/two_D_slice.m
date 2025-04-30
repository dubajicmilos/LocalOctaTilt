        function [X,Y,Z]=two_D_slice(plane,S,H,K,L,log_mode,plot_mode) % Finds the slice of 2D data with X and Y coordinates at coordinate value=value and integrates in the range=range
            import uf.SCXRD
            tol=0.001;
            if strcmp(plane(1),'H') && strcmp(plane(2),'K')
                
                L_slice=str2double(plane(3:end));
                indices = find(abs(L - L_slice) < tol);
                Slice=(S(:,indices,:));
                Slice1=reshape(Slice,length(K),length(H));
                
                label_names=[{'K [rlu]'},{'H [rlu]'}];
                
                X=K;Y=H;Z=Slice1;
                
                
            end
            
            
            %(H0.5L) condition
            if strcmp(plane(1),'H') && not(strcmp(plane(2),'K'))
                
                K_slice=str2double(plane(2:end-1));
                indices = find(abs(K - K_slice) < tol);
                
                Slice=(S(indices,:,:));
                Slice1=reshape(Slice,length(L),length(H));
                label_names=[{'L [rlu]'},{'H [rlu]'}];
                X=L;Y=H;Z=Slice1;
            end
            
            %(0KL) condition
            if not(strcmp(plane(1),'H')) && not(strcmp(plane(1),'K')) && not(strcmp(plane(1),'L'))
                
                H_slice=str2double(plane(1:end-2));
                indices = find(abs(H - H_slice) < tol);
                
                Slice1=(S(:,:,indices));
                
                label_names=[{'K [rlu]'},{'L [rlu]'}];
                
                X=K;Y=L;Z=Slice1;
            end
            
            if strcmp(log_mode,'log')
                
                Z=log(Z);
                
            end
            
            if strcmp(plot_mode,'on')
                
                figure
                w.xlabel=label_names(1);w.ylabel=label_names(2);w.zlabel='Intensity';
                %                w.title=[ num2str(H_slice) 'KL' ];
                w.title=[];
                plots.Colormap(X,Y,Z',w)
                uf.SCXRD.details_paper(uf.SCXRD.gborder)
            end
            
            
            
        end