function MatPadded = padmat(Mat,PadSizeX,PadSizeY,val)

if( nargin < 4 )
    val = 0;
end
if( nargin < 3 )
    PadSizeY = PadSizeX;
end

[M,N] = size(Mat);
MatPadded1 = [val*ones(M,PadSizeX),Mat,val*ones(M,PadSizeX)];
MatPadded = [val*ones(PadSizeY,N+2*PadSizeX);MatPadded1;val*ones(PadSizeY,N+2*PadSizeX)];
