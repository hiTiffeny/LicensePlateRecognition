close all;
num = 1;
I=imread('car1.jpg');  
figure(1),imshow(I);title('原图')  
I1=rgb2gray(I);%功能是将真彩色图像转换为灰度图像，即灰度化处理  
figure(2),subplot(1,2,1),imshow(I1);title('灰度图');  
figure(2),subplot(1,2,2),imhist(I1);title('灰度图直方图');  
I2=edge(I1,'Prewitt',0.15,'both');  
%功能是采用I作为它的输入，并返回一个与I相同大小的二值化图像BW，在函数检测到边缘的地方为1，其他地方为0  
figure(3),imshow(I2);title(' Prewitt算子边缘检测')  
se=[1;1;1];  
I3=imerode(I2,se);%腐蚀  
figure(4),imshow(I3);title('腐蚀后图像');  
se=strel('rectangle',[25,25]);  
I4=imclose(I3,se);  
figure(5),imshow(I4);title('平滑图像的轮廓');  
I5=bwareaopen(I4,2000);%作用是删除二值图像BW中面积小于2000的对象  


figure(6),imshow(I5);title('从对象中移除小对象');  
[y,x,z]=size(I5);  
myI=double(I5);%double类型  
tic  %tic用来保存当前时间，而后使用toc来记录程序完成时间  
 Blue_y=zeros(y,1);%zeros功能是返回一个m×n×p×...的double类零矩阵  
 for i=1:y  
    for j=1:x  
             if(myI(i,j,1)==1)   
    
                Blue_y(i,1)= Blue_y(i,1)+1;%蓝色像素点统计   
            end    
     end         
 end  
 [temp MaxY]=max(Blue_y);%Y方向车牌区域确定  
 PY1=MaxY;  
 while ((Blue_y(PY1,1)>=5)&&(PY1>1))  
        PY1=PY1-1;  
 end      
 PY2=MaxY;  
 while ((Blue_y(PY2,1)>=5)&&(PY2<y))  
        PY2=PY2+1;  
 end  
 IY=I(PY1-2:PY2+2,:,:);  
 
 %%%%%% X方向 %%%%%%%%%  
 Blue_x=zeros(1,x);%进一步确定x方向的车牌区域  
 for j=1:x  
     for i=PY1:PY2  
            if(myI(i,j,1)==1)  
                Blue_x(1,j)= Blue_x(1,j)+1;                 
            end    
     end         
 end  
    
 PX1=1;  
 while ((Blue_x(1,PX1)<3)&&(PX1<x))  
       PX1=PX1+1;  
 end      
 PX2=x;  
 while ((Blue_x(1,PX2)<3)&&(PX2>PX1))  
        PX2=PX2-1;  
 end  
 PX1=PX1-1;%对车牌区域的校正  
 PX2=PX2+5;  
  dw=I(PY1-2:PY2+2,PX1:PX2,:);  
 t=toc;   
figure(7),subplot(1,2,1),imshow(IY),title('行方向合理区域');  
figure(7),subplot(1,2,2),imshow(dw),title('定位剪切后的彩色车牌图像')  
imwrite(dw,'dw.jpg');  
a=imread('dw.jpg');  


figure(8),subplot(3,2,1),imshow(a);title('倾斜调整前');
rotateP = rotatePicture(a);
figure(8),subplot(3,2,2),imshow(rotateP);title('倾斜调整后');  
b = location(rotateP,1);
figure(8),subplot(3,2,3),imshow(b);title('精确定位后');  

b=rgb2gray(b);%功能是将真彩色图像转换为灰度图像，即灰度化处理  
imwrite(b,'1.车牌灰度图像.jpg');  
figure(9);subplot(3,2,1),imshow(b),title('1.车牌灰度图像')  

g_max=double(max(max(b)));  
g_min=double(min(min(b)));  
T=round(g_max-(g_max-g_min)/3); % T 为二值化的阈值   向最近的方向取整  
[m,n]=size(b);  
d=(double(b)>=T);  % d:二值图像  
imwrite(d,'2.车牌二值图像.jpg');  
figure(9);subplot(3,2,2),imshow(d),title('2.车牌二值图像')  
figure(9),subplot(3,2,3),imshow(d),title('3.均值滤波前')  
  
% 均值滤波处理  
h=fspecial('average',3);  
d=im2bw(round(filter2(h,d)));%filter2(B,X),B为滤波器.X为要滤波的数据,这里将B放在X上,一个一个移动进行模板滤波.   
imwrite(d,'4.均值滤波后.jpg');  
figure(9),subplot(3,2,4),imshow(d),title('4.均值滤波后')  
se=eye(2);%产生m×n的单位矩阵  
[m,n]=size(d);  
if bwarea(d)/m/n>=0.365 %bwarea是计算二值图像中对象的总面积的函数  
    d=imerode(d,se);%腐蚀  
elseif bwarea(d)/m/n<=0.235  
    d=imdilate(d,se);%膨胀  
end  
imwrite(d,'5.膨胀或腐蚀处理后.jpg');  
figure(9),subplot(3,2,5),imshow(d),title('5.膨胀或腐蚀处理后')  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% 寻找连续有文字的块，若长度大于某阈值，则认为该块有两个字符组成，需要分割  
character_im = LicPlateSeg(d);
if size(character_im, 2) == 1
    disp('字符分割失败');
else
    figure(10), % 显示字符分割结果
    subplot(1,7,1), imshow(character_im{1});
    subplot(1,7,2), imshow(character_im{2});
    subplot(1,7,3), imshow(character_im{3});
    subplot(1,7,4), imshow(character_im{4});
    subplot(1,7,5), imshow(character_im{5});
    subplot(1,7,6), imshow(character_im{6});
    subplot(1,7,7), imshow(character_im{7});
    imwrite(imresize(character_im{1},[40 20],'nearest'),'1.jpg');
    imwrite(imresize(character_im{2},[40 20],'nearest'),'2.jpg');
    imwrite(imresize(character_im{3},[40 20],'nearest'),'3.jpg');
    imwrite(imresize(character_im{4},[40 20],'nearest'),'4.jpg');
    imwrite(imresize(character_im{5},[40 20],'nearest'),'5.jpg');
    imwrite(imresize(character_im{6},[40 20],'nearest'),'6.jpg');
    imwrite(imresize(character_im{7},[40 20],'nearest'),'7.jpg');
    Code = getChar();
    figure(11),
    imshow(dw),
    title (['车牌号码为:',Code]);
end




