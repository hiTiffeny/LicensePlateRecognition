% 对倾斜的角度进行调整
function [pictureOut] = rotatePicture(pictureIn)
    pictureGray1 = rgb2gray(pictureIn);
    %水平方向调整
    T=affine2d([0 1 0;1 0 0;0 0 1]);
    pictureTr=imwarp(pictureGray1,T);              % 图像转置，顺时针旋转90°调整水平方向
    theta = -20 : 20;                                          %设置倾斜角度的范围
    r1 = radon(pictureTr, theta);                        %radon变换确定倾斜角
    result1 = sum(abs(diff(r1)), 1);                      %求出行倒数绝对值的累加和，最大的对应倾斜角
    rot1 = find(result1==max(result1))-21;
    pictureRo = imrotate(pictureIn, rot1);
%     figure(20), imshow(pictureRo), title('调整水平角度之后的图像');
    %竖直方向调整
    pictureGray2 = rgb2gray(pictureRo);
    r2 = radon(pictureGray2, theta);
    result2 = sum(abs(diff(r2)), 1);
    rot2 = (find(result2==max(result2))-21)/57.3;           %将数值转为角度
    if rot2>0
        T1 = affine2d([1 0 0 ; -tan(rot2) 1 0 ; size(pictureGray2, 1) * tan(rot2) 0 1]);
    else
        T1 = affine2d([1 0 0 ; tan(-rot2) 1 0 ; size(pictureGray2, 1) * tan(-rot2) 0 1]);
    end
    pictureOut = imwarp(pictureRo, T1);
%     figure(21), imshow(pictureOut), title('水平+竖直调整之后的图像');
%     close all;
end