classdef matrix
    
    properties
        M
        X
        Y
    end
    methods
        function obj = matrix(x,y,Mat) %(Xaxis-array(n x 1),Yaxis-array(1 x m),M-array(n x m))
            obj.X=x;
            obj.Y=y;
            obj.M=Mat;
        end
        
        function [X, Y ,M]=cutmatirx(obj,Xborder,Yborder)
            
            
            [~,itm] = min(abs(obj.X-Xborder(1)));
            [~,ith] = min(abs(obj.X-Xborder(2)));
            [~,ilm] = min(abs(obj.Y-Yborder(1)));
            [~,i1h] = min(abs(obj.Y-Yborder(2)));
            
            X=obj.X(itm:ith);
            Y=obj.Y(ilm:i1h);
            M=obj.M(itm:ith,ilm:i1h);
            
        end
        
        
        function [f,Fur]=Furrier(obj)
            
            
            Mat=obj.M;

            T=obj.Y(7)-obj.Y(6);
            tN=obj.Y(1):T:obj.Y(end);
            
         [~, ind] = unique(obj.Y); %Sometimes Helios outputs two same time points, thus this step is necessary
         obj.Y=obj.Y(ind);
        
            
            for i=1:1:size(Mat,1)
                Yc=Mat(i,1:end);
                Yc=Yc(ind);
                Yn=interp1(obj.Y,Yc,tN);
                L=length(Yn);
                P2=abs(fft(Yn/L));
                P1 = P2(1:L/2+1);
%                 P1(2:end-1) = 2*P1(2:end-1);
                f = 1/T*(0:(L/2))/L*1000;
                Fur(:,i)=P1;
            end
            
        end
        
        
        function plot_2D(obj)
            
            plots.Colormap(obj.X,obj.Y,obj.M)
            
        end
        
        
    end
    
end