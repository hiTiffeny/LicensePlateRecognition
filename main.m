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
 IY=I(PY1:PY2,:,:);  
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
 PX2=PX2+1;  
  dw=I(PY1:PY2-8,PX1:PX2,:);  
 t=toc;   
figure(7),subplot(1,2,1),imshow(IY),title('行方向合理区域');  
figure(7),subplot(1,2,2),imshow(dw),title('定位剪切后的彩色车牌图像')  
imwrite(dw,'dw.jpg');  
a=imread('dw.jpg');  
b=rgb2gray(a);%功能是将真彩色图像转换为灰度图像，即灰度化处理  
imwrite(b,'1.车牌灰度图像.jpg');  
figure(8);subplot(3,2,1),imshow(b),title('1.车牌灰度图像')  
g_max=double(max(max(b)));  
g_min=double(min(min(b)));  
T=round(g_max-(g_max-g_min)/3); % T 为二值化的阈值   向最近的方向取整  
[m,n]=size(b);  
d=(double(b)>=T);  % d:二值图像  
imwrite(d,'2.车牌二值图像.jpg');  
figure(8);subplot(3,2,2),imshow(d),title('2.车牌二值图像')  
figure(8),subplot(3,2,3),imshow(d),title('3.均值滤波前')  
  
% 均值滤波处理  
h=fspecial('average',3);  
d=im2bw(round(filter2(h,d)));%filter2(B,X),B为滤波器.X为要滤波的数据,这里将B放在X上,一个一个移动进行模板滤波.   
imwrite(d,'4.均值滤波后.jpg');  
figure(8),subplot(3,2,4),imshow(d),title('4.均值滤波后')  
se=eye(2);%产生m×n的单位矩阵  
[m,n]=size(d);  
if bwarea(d)/m/n>=0.365 %bwarea是计算二值图像中对象的总面积的函数  
    d=imerode(d,se);%腐蚀  
elseif bwarea(d)/m/n<=0.235  
    d=imdilate(d,se);%膨胀  
end  
imwrite(d,'5.膨胀或腐蚀处理后.jpg');  
figure(8),subplot(3,2,5),imshow(d),title('5.膨胀或腐蚀处理后')  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% 寻找连续有文字的块，若长度大于某阈值，则认为该块有两个字符组成，需要分割  
d=qiege(d);  
[m,n]=size(d);  
figure,subplot(2,1,1),imshow(d),title(n)  
k1=1;k2=1;s=sum(d);j=1;  
while j~=n  
    while s(j)==0  
        j=j+1;  
    end  
    k1=j;  
    while s(j)~=0 && j<=n-1  
        j=j+1;  
    end  
    k2=j-1;  
    if k2-k1>=round(n/6.5)  
        [val,num]=min(sum(d(:,[k1+5:k2-5])));  
        d(:,k1+num+5)=0;  % 分割  
    end  
end  
% 再切割  
d=qiege(d);  
% 切割出 7 个字符  
y1=10;y2=0.25;flag=0;word1=[];  
while flag==0  
    [m,n]=size(d);  
    left=1;wide=0;  
    while sum(d(:,wide+1))~=0  
        wide=wide+1;  
    end  
    if wide<y1   % 认为是左侧干扰  
        d(:,[1:wide])=0;  
        d=qiege(d);  
    else  
        temp=qiege(imcrop(d,[1 1 wide m]));  
        [m,n]=size(temp);  
        all=sum(sum(temp));  
        two_thirds=sum(sum(temp([round(m/3):2*round(m/3)],:)));  
        if two_thirds/all>y2  
            flag=1;word1=temp;   % WORD 1  
        end  
        d(:,[1:wide])=0;d=qiege(d);  
    end  
end  
% 分割出第二个字符  
[word2,d]=getword(d);  
% 分割出第三个字符  
[word3,d]=getword(d);  
% 分割出第四个字符  
[word4,d]=getword(d);  
% 分割出第五个字符  
[word5,d]=getword(d);  
% 分割出第六个字符  
[word6,d]=getword(d);  
% 分割出第七个字符  
[word7,d]=getword(d);  
subplot(5,7,1),imshow(word1),title('1');  
subplot(5,7,2),imshow(word2),title('2');  
subplot(5,7,3),imshow(word3),title('3');  
subplot(5,7,4),imshow(word4),title('4');  
subplot(5,7,5),imshow(word5),title('5');  
subplot(5,7,6),imshow(word6),title('6');  
subplot(5,7,7),imshow(word7),title('7');  
[m,n]=size(word1);  
  
% 归一化大小为 40*20  
word1=imresize(word1,[40 20]);  
word2=imresize(word2,[40 20]);  
word3=imresize(word3,[40 20]);  
word4=imresize(word4,[40 20]);  
word5=imresize(word5,[40 20]);  
word6=imresize(word6,[40 20]);  
word7=imresize(word7,[40 20]);  
  
subplot(5,7,15),imshow(word1),title('1');  
subplot(5,7,16),imshow(word2),title('2');  
subplot(5,7,17),imshow(word3),title('3');  
subplot(5,7,18),imshow(word4),title('4');  
subplot(5,7,19),imshow(word5),title('5');  
subplot(5,7,20),imshow(word6),title('6');  
subplot(5,7,21),imshow(word7),title('7');  
imwrite(word1,'1.jpg');  
imwrite(word2,'2.jpg');  
imwrite(word3,'3.jpg');  
imwrite(word4,'4.jpg');  
imwrite(word5,'5.jpg');  
imwrite(word6,'6.jpg');  
imwrite(word7,'7.jpg');  
  
liccode=char(['0':'9' 'A':'Z' '京宁沪苏陕']);   
%建立自动识别字符代码表  1~10 数字  11~36  字母   37~41汉字  
SubBw2=zeros(40,20);%生成一个40*20大小的零矩阵  
l=1;  
for I=1:7  
      ii=int2str(I);%整形数据转字符串类型  
     t=imread([ii,'.jpg']);  
      SegBw2=imresize(t,[40 20],'nearest');%缩放处理  
        if l==1                 %第一位汉字识别  
            kmin=37;  
            kmax=41;  
        elseif l==2             %第二位 A~Z 字母识别  
            kmin=11;  
            kmax=36;  
        else l>=3               %第三位以后是字母或数字识别  
            kmin=1;  
            kmax=36;  
          
        end  
          
        for k2=kmin:kmax  
            fname=strcat('样本库\',liccode(k2),'.jpg');  
            SamBw2 = imread(fname);  
            for  i=1:40  
                for j=1:20  
                    SubBw2(i,j)=SegBw2(i,j)-SamBw2(i,j);  
                end  
            end  
           % 以上相当于两幅图相减得到第三幅图  
            Dmax=0;  
            for k1=1:40  
                for l1=1:20  
                    if  ( SubBw2(k1,l1) > 0 || SubBw2(k1,l1) <0 )  
                        Dmax=Dmax+1;  
                    end  
                end  
            end  
            Error(k2)=Dmax;  
        end  
        Error1=Error(kmin:kmax);  
        MinError=min(Error1);  
        findc=find(Error1==MinError);  
        Code(l*2-1)=liccode(findc(1)+kmin-1);  
        Code(l*2)=' ';  
        l=l+1;  
end  
figure(10),imshow(dw),title (['车牌号码:', Code],'Color','b'); 