function status = RemovePointsBeyondFrame(Points,status0,ImageSize)

Sy = ImageSize(1);
Sx = ImageSize(2);
status = status0;

for n = 1:length(Points)
    x = Points{n}(1);
    y = Points{n}(2);
    if( x < 2 || x > Sx - 1 || y < 2 || y > Sy - 1 )
        status(n) = 0;
    end
end

