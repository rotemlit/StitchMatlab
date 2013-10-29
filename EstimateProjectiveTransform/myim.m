function [h,axs] = myim(varargin)


switch nargin
    case 1 
        cols = 1; rows = 1;
    case 2 
        cols = 2; rows = 1;
    case {3, 4} 
        cols = 2; rows = 2;
    case {5, 6} 
        cols = 3; rows = 2;
    otherwise        
        cols = ceil(sqrt(nargin));
        rows = ceil(nargin/cols);
        if cols < rows
            tmp = cols;
            cols = rows;
            rows = tmp;
        end
end

h=figure;
for i=1:nargin
    axs(i) = subplot(rows,cols,i);
    imagesc(varargin{i});colorbar;
    title(inputname(i));
end

% colormap gray
colormap jet

if( nargin==3 )
    set(gca,'Position',[0.35    0.1100    0.2108    0.3412]);
end 