%ͼ��ľ�ȷ��λ
function [pictureOut] = location(pictureIn,num)
    % ȥ���ϡ��±߿��Լ�í��
    pictureGray1 = rgb2gray(pictureIn);
    [mY1, nY1] = size(pictureGray1);
    yresult = sum(abs(diff(pictureGray1)), 2);%1Ϊ�У� 2Ϊ��
    yresult = imfilter(yresult, fspecial('average', 6));
    %�����Ͻ�����
    yTemp1 = yresult(10 : ceil(mY1/4), 1);
    [~, ymin] = max(yTemp1);
    %�����½�����
    yTemp2 = yresult(ceil(mY1/4) : (mY1 - 1), 1);
    [~, ymax] = max(yTemp2);
    ymax = ymax + ceil(mY1/4);
    pictureCutY =  imcrop(pictureIn, [1, ymin+5, nY1 , (ymax - ymin)]);
    
    % ȥ�����ұ߿�
    pictureGray2 = rgb2gray(pictureCutY);
    [mX, nX] = size(pictureGray2);
    xdiff = zeros(mX, nX-1);
    for i = 1:mX
        xdiff(i, :) = abs(diff(pictureGray2(i, :)));            %�������֮��Ĳ�ֵ���ۼ�
        xresult = sum(xdiff, 1);
    end
    xresult = imfilter(xresult, fspecial('average', 6));
    %�����������
    xTemp1 = xresult( 1, 1 : ceil(nX/5));
    [~, xmin] = max(xTemp1);
    %�����ҽ�����
    xTemp2 = xresult( 1, ceil(4*nX/5):(nX - 1));
    [~, xmax] = max(xTemp2);
    xmax = xmax + ceil(4*nX/5);
    if num==1
        pictureOut =  imcrop(pictureCutY, [xmin, 1,  (xmax - xmin) , mX]);
    else
        pictureOut =  imcrop(pictureCutY, [xmin, 1,  nX , mX]);
end