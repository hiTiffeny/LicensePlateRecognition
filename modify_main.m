close all;
num = 1;
I=imread('car1.jpg');  
figure(1),imshow(I);title('ԭͼ')  
I1=rgb2gray(I);%�����ǽ����ɫͼ��ת��Ϊ�Ҷ�ͼ�񣬼��ҶȻ�����  
figure(2),subplot(1,2,1),imshow(I1);title('�Ҷ�ͼ');  
figure(2),subplot(1,2,2),imhist(I1);title('�Ҷ�ͼֱ��ͼ');  
I2=edge(I1,'Prewitt',0.15,'both');  
%�����ǲ���I��Ϊ�������룬������һ����I��ͬ��С�Ķ�ֵ��ͼ��BW���ں�����⵽��Ե�ĵط�Ϊ1�������ط�Ϊ0  
figure(3),imshow(I2);title(' Prewitt���ӱ�Ե���')  
se=[1;1;1];  
I3=imerode(I2,se);%��ʴ  
figure(4),imshow(I3);title('��ʴ��ͼ��');  
se=strel('rectangle',[25,25]);  
I4=imclose(I3,se);  
figure(5),imshow(I4);title('ƽ��ͼ�������');  
I5=bwareaopen(I4,2000);%������ɾ����ֵͼ��BW�����С��2000�Ķ���  


figure(6),imshow(I5);title('�Ӷ������Ƴ�С����');  
[y,x,z]=size(I5);  
myI=double(I5);%double����  
tic  %tic�������浱ǰʱ�䣬����ʹ��toc����¼�������ʱ��  
 Blue_y=zeros(y,1);%zeros�����Ƿ���һ��m��n��p��...��double�������  
 for i=1:y  
    for j=1:x  
             if(myI(i,j,1)==1)   
    
                Blue_y(i,1)= Blue_y(i,1)+1;%��ɫ���ص�ͳ��   
            end    
     end         
 end  
 [temp MaxY]=max(Blue_y);%Y����������ȷ��  
 PY1=MaxY;  
 while ((Blue_y(PY1,1)>=5)&&(PY1>1))  
        PY1=PY1-1;  
 end      
 PY2=MaxY;  
 while ((Blue_y(PY2,1)>=5)&&(PY2<y))  
        PY2=PY2+1;  
 end  
 IY=I(PY1-2:PY2+2,:,:);  
 
 %%%%%% X���� %%%%%%%%%  
 Blue_x=zeros(1,x);%��һ��ȷ��x����ĳ�������  
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
 PX1=PX1-1;%�Գ��������У��  
 PX2=PX2+5;  
  dw=I(PY1-2:PY2+2,PX1:PX2,:);  
 t=toc;   
figure(7),subplot(1,2,1),imshow(IY),title('�з����������');  
figure(7),subplot(1,2,2),imshow(dw),title('��λ���к�Ĳ�ɫ����ͼ��')  
imwrite(dw,'dw.jpg');  
a=imread('dw.jpg');  


figure(8),subplot(3,2,1),imshow(a);title('��б����ǰ');
rotateP = rotatePicture(a);
figure(8),subplot(3,2,2),imshow(rotateP);title('��б������');  
b = location(rotateP,1);
figure(8),subplot(3,2,3),imshow(b);title('��ȷ��λ��');  

b=rgb2gray(b);%�����ǽ����ɫͼ��ת��Ϊ�Ҷ�ͼ�񣬼��ҶȻ�����  
imwrite(b,'1.���ƻҶ�ͼ��.jpg');  
figure(9);subplot(3,2,1),imshow(b),title('1.���ƻҶ�ͼ��')  

g_max=double(max(max(b)));  
g_min=double(min(min(b)));  
T=round(g_max-(g_max-g_min)/3); % T Ϊ��ֵ������ֵ   ������ķ���ȡ��  
[m,n]=size(b);  
d=(double(b)>=T);  % d:��ֵͼ��  
imwrite(d,'2.���ƶ�ֵͼ��.jpg');  
figure(9);subplot(3,2,2),imshow(d),title('2.���ƶ�ֵͼ��')  
figure(9),subplot(3,2,3),imshow(d),title('3.��ֵ�˲�ǰ')  
  
% ��ֵ�˲�����  
h=fspecial('average',3);  
d=im2bw(round(filter2(h,d)));%filter2(B,X),BΪ�˲���.XΪҪ�˲�������,���ｫB����X��,һ��һ���ƶ�����ģ���˲�.   
imwrite(d,'4.��ֵ�˲���.jpg');  
figure(9),subplot(3,2,4),imshow(d),title('4.��ֵ�˲���')  
se=eye(2);%����m��n�ĵ�λ����  
[m,n]=size(d);  
if bwarea(d)/m/n>=0.365 %bwarea�Ǽ����ֵͼ���ж����������ĺ���  
    d=imerode(d,se);%��ʴ  
elseif bwarea(d)/m/n<=0.235  
    d=imdilate(d,se);%����  
end  
imwrite(d,'5.���ͻ�ʴ�����.jpg');  
figure(9),subplot(3,2,5),imshow(d),title('5.���ͻ�ʴ�����')  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Ѱ�����������ֵĿ飬�����ȴ���ĳ��ֵ������Ϊ�ÿ��������ַ���ɣ���Ҫ�ָ�  
character_im = LicPlateSeg(d);
if size(character_im, 2) == 1
    disp('�ַ��ָ�ʧ��');
else
    figure(10), % ��ʾ�ַ��ָ���
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
    title (['���ƺ���Ϊ:',Code]);
end




