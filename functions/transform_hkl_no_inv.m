        function GM=transform_hkl_no_inv(G,M_sg,M_rot)
        
        hkl_range=5.5;
            % Create a reflection list with original indexation
            GM=[G{:,2:4} G{:,end}];
            
            F1=GM(:,1:3)*M_sg*M_rot;
            
            % This becomes the reflection list for the pseudocubic cell
            GMT=[F1 G{1:size(G,1),end}];
            
            % Remove all points that are otside the index_range
            
            GMT(GMT(:,1)>hkl_range | GMT(:,1)<-hkl_range ,:)=[];
            GMT(GMT(:,2)>hkl_range | GMT(:,2)<-hkl_range ,:)=[];
            GMT(GMT(:,3)>hkl_range | GMT(:,3)<-hkl_range ,:)=[];
            
            GM=GMT;
            
            
        end