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
 IY=I(PY1:PY2,:,:);  
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
 PX2=PX2+1;  
  dw=I(PY1:PY2-8,PX1:PX2,:);  
 t=toc;   
figure(7),subplot(1,2,1),imshow(IY),title('�з����������');  
figure(7),subplot(1,2,2),imshow(dw),title('��λ���к�Ĳ�ɫ����ͼ��')  
imwrite(dw,'dw.jpg');  
a=imread('dw.jpg');  
b=rgb2gray(a);%�����ǽ����ɫͼ��ת��Ϊ�Ҷ�ͼ�񣬼��ҶȻ�����  
imwrite(b,'1.���ƻҶ�ͼ��.jpg');  
figure(8);subplot(3,2,1),imshow(b),title('1.���ƻҶ�ͼ��')  
g_max=double(max(max(b)));  
g_min=double(min(min(b)));  
T=round(g_max-(g_max-g_min)/3); % T Ϊ��ֵ������ֵ   ������ķ���ȡ��  
[m,n]=size(b);  
d=(double(b)>=T);  % d:��ֵͼ��  
imwrite(d,'2.���ƶ�ֵͼ��.jpg');  
figure(8);subplot(3,2,2),imshow(d),title('2.���ƶ�ֵͼ��')  
figure(8),subplot(3,2,3),imshow(d),title('3.��ֵ�˲�ǰ')  
  
% ��ֵ�˲�����  
h=fspecial('average',3);  
d=im2bw(round(filter2(h,d)));%filter2(B,X),BΪ�˲���.XΪҪ�˲�������,���ｫB����X��,һ��һ���ƶ�����ģ���˲�.   
imwrite(d,'4.��ֵ�˲���.jpg');  
figure(8),subplot(3,2,4),imshow(d),title('4.��ֵ�˲���')  
se=eye(2);%����m��n�ĵ�λ����  
[m,n]=size(d);  
if bwarea(d)/m/n>=0.365 %bwarea�Ǽ����ֵͼ���ж����������ĺ���  
    d=imerode(d,se);%��ʴ  
elseif bwarea(d)/m/n<=0.235  
    d=imdilate(d,se);%����  
end  
imwrite(d,'5.���ͻ�ʴ�����.jpg');  
figure(8),subplot(3,2,5),imshow(d),title('5.���ͻ�ʴ�����')  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Ѱ�����������ֵĿ飬�����ȴ���ĳ��ֵ������Ϊ�ÿ��������ַ���ɣ���Ҫ�ָ�  
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
        d(:,k1+num+5)=0;  % �ָ�  
    end  
end  
% ���и�  
d=qiege(d);  
% �и�� 7 ���ַ�  
y1=10;y2=0.25;flag=0;word1=[];  
while flag==0  
    [m,n]=size(d);  
    left=1;wide=0;  
    while sum(d(:,wide+1))~=0  
        wide=wide+1;  
    end  
    if wide<y1   % ��Ϊ��������  
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
% �ָ���ڶ����ַ�  
[word2,d]=getword(d);  
% �ָ���������ַ�  
[word3,d]=getword(d);  
% �ָ�����ĸ��ַ�  
[word4,d]=getword(d);  
% �ָ��������ַ�  
[word5,d]=getword(d);  
% �ָ���������ַ�  
[word6,d]=getword(d);  
% �ָ�����߸��ַ�  
[word7,d]=getword(d);  
subplot(5,7,1),imshow(word1),title('1');  
subplot(5,7,2),imshow(word2),title('2');  
subplot(5,7,3),imshow(word3),title('3');  
subplot(5,7,4),imshow(word4),title('4');  
subplot(5,7,5),imshow(word5),title('5');  
subplot(5,7,6),imshow(word6),title('6');  
subplot(5,7,7),imshow(word7),title('7');  
[m,n]=size(word1);  
  
% ��һ����СΪ 40*20  
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
  
liccode=char(['0':'9' 'A':'Z' '����������']);   
%�����Զ�ʶ���ַ������  1~10 ����  11~36  ��ĸ   37~41����  
SubBw2=zeros(40,20);%����һ��40*20��С�������  
l=1;  
for I=1:7  
      ii=int2str(I);%��������ת�ַ�������  
     t=imread([ii,'.jpg']);  
      SegBw2=imresize(t,[40 20],'nearest');%���Ŵ���  
        if l==1                 %��һλ����ʶ��  
            kmin=37;  
            kmax=41;  
        elseif l==2             %�ڶ�λ A~Z ��ĸʶ��  
            kmin=11;  
            kmax=36;  
        else l>=3               %����λ�Ժ�����ĸ������ʶ��  
            kmin=1;  
            kmax=36;  
          
        end  
          
        for k2=kmin:kmax  
            fname=strcat('������\',liccode(k2),'.jpg');  
            SamBw2 = imread(fname);  
            for  i=1:40  
                for j=1:20  
                    SubBw2(i,j)=SegBw2(i,j)-SamBw2(i,j);  
                end  
            end  
           % �����൱������ͼ����õ�������ͼ  
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
figure(10),imshow(dw),title (['���ƺ���:', Code],'Color','b'); 