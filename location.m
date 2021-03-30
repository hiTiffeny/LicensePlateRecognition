%图像的精确定位
function [pictureOut] = location(pictureIn,num)
    % 去除上、下边框以及铆钉
    pictureGray1 = rgb2gray(pictureIn);
    [mY1, nY1] = size(pictureGray1);
    yresult = sum(abs(diff(pictureGray1)), 2);%1为列， 2为行
    yresult = imfilter(yresult, fspecial('average', 6));
    %计算上界坐标
    yTemp1 = yresult(10 : ceil(mY1/4), 1);
    [~, ymin] = max(yTemp1);
    %计算下界坐标
    yTemp2 = yresult(ceil(mY1/4) : (mY1 - 1), 1);
    [~, ymax] = max(yTemp2);
    ymax = ymax + ceil(mY1/4);
    pictureCutY =  imcrop(pictureIn, [1, ymin+5, nY1 , (ymax - ymin)]);
    
    % 去除左、右边框
    pictureGray2 = rgb2gray(pictureCutY);
    [mX, nX] = size(pictureGray2);
    xdiff = zeros(mX, nX-1);
    for i = 1:mX
        xdiff(i, :) = abs(diff(pictureGray2(i, :)));            %计算各列之间的差值并累加
        xresult = sum(xdiff, 1);
    end
    xresult = imfilter(xresult, fspecial('average', 6));
    %计算左界坐标
    xTemp1 = xresult( 1, 1 : ceil(nX/5));
    [~, xmin] = max(xTemp1);
    %计算右界坐标
    xTemp2 = xresult( 1, ceil(4*nX/5):(nX - 1));
    [~, xmax] = max(xTemp2);
    xmax = xmax + ceil(4*nX/5);
    if num==1
        pictureOut =  imcrop(pictureCutY, [xmin, 1,  (xmax - xmin) , mX]);
    else
        pictureOut =  imcrop(pictureCutY, [xmin, 1,  nX , mX]);
end