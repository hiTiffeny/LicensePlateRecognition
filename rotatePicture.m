% ����б�ĽǶȽ��е���
function [pictureOut] = rotatePicture(pictureIn)
    pictureGray1 = rgb2gray(pictureIn);
    %ˮƽ�������
    T=affine2d([0 1 0;1 0 0;0 0 1]);
    pictureTr=imwarp(pictureGray1,T);              % ͼ��ת�ã�˳ʱ����ת90�����ˮƽ����
    theta = -20 : 20;                                          %������б�Ƕȵķ�Χ
    r1 = radon(pictureTr, theta);                        %radon�任ȷ����б��
    result1 = sum(abs(diff(r1)), 1);                      %����е�������ֵ���ۼӺͣ����Ķ�Ӧ��б��
    rot1 = find(result1==max(result1))-21;
    pictureRo = imrotate(pictureIn, rot1);
%     figure(20), imshow(pictureRo), title('����ˮƽ�Ƕ�֮���ͼ��');
    %��ֱ�������
    pictureGray2 = rgb2gray(pictureRo);
    r2 = radon(pictureGray2, theta);
    result2 = sum(abs(diff(r2)), 1);
    rot2 = (find(result2==max(result2))-21)/57.3;           %����ֵתΪ�Ƕ�
    if rot2>0
        T1 = affine2d([1 0 0 ; -tan(rot2) 1 0 ; size(pictureGray2, 1) * tan(rot2) 0 1]);
    else
        T1 = affine2d([1 0 0 ; tan(-rot2) 1 0 ; size(pictureGray2, 1) * tan(-rot2) 0 1]);
    end
    pictureOut = imwarp(pictureRo, T1);
%     figure(21), imshow(pictureOut), title('ˮƽ+��ֱ����֮���ͼ��');
%     close all;
end