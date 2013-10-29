function WindowList = WindowTileSimple(ImageSizeX,ImageSizeY,NumWindowsX,NumWindowsY,Margins)
%% FinalList: each row is a window: StartX EndX StartY EndY

NumPixelsX = ImageSizeX - 2 * Margins;
NumPixelsY = ImageSizeY - 2 * Margins;
WindowWidth = floor(NumPixelsX / NumWindowsX);
WindowHeight = floor(NumPixelsY / NumWindowsY);

WindowList = zeros(NumWindowsX*NumWindowsY,4);
winindx = 1;
Xstart = Margins + 1;
for ii = 1:NumWindowsX
    Ystart = Margins + 1;
    for jj = 1:NumWindowsY
        WindowList(winindx,1) = Xstart;
        if( ii == NumWindowsX )
            WindowList(winindx,2) = ImageSizeX - Margins;
        else
            WindowList(winindx,2) = Xstart + WindowWidth;
        end
        WindowList(winindx,3) = Ystart;
        if( jj == NumWindowsY )
            WindowList(winindx,4) = ImageSizeY - Margins;
        else
            WindowList(winindx,4) = Ystart + WindowHeight;
        end
        winindx = winindx + 1;
        Ystart = Ystart +  WindowHeight;
    end
    Xstart = Xstart +  WindowWidth;
end
