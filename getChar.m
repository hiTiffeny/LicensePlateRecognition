function [Code]=getChar()
liccode=char(['���ղش��ʸӹ��ڻ�����������ɶ�³������������������ԥ������' 'A':'Z' '0':'9']);
SubBw2=zeros(40,20);
l=1;
for I=1:7
      ii=int2str(I);
      t=imread([ii,'.jpg']);
      SegBw2=imresize(t,[40 20],'nearest');
      SegBw2=im2bw(SegBw2);
        if l==1                 %��һλ����ʶ��
            kmin=1;
            kmax=31;
        elseif l==2             %�ڶ�λ A~Z ��ĸʶ��
            kmin=32;
            kmax=57;
        else l >= 3               %����λ�Ժ�����ĸ������ʶ��
            kmin=32;
            kmax=67;
        
        end
        
        for k2=kmin:kmax
            fname=strcat('�ַ�ģ��\',liccode(k2),'.jpg');
            SamBw2 = imread(fname);
            SamBw2=im2bw(SamBw2);
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
