function character_image = LicPlateSeg(plate_image)

% ����������ʵ�ֳ����ַ��ָ
% �ָ�ʧ�ܣ�����1*1�հ�Ԫ����
% �ɹ��ָ���ַ����δ��ڰ�Ԫ���� character_image ��
Ibw = plate_image;
% Ibw = im2bw(I); % ��ֵ��
[a, b] = size(Ibw);
figure(10),imshow(Ibw)%,title('4.��ֵ�˲���')  
% Ibw = ones(size(bw)) - bw; %���ֺڵ�
% figure(11),imshow(Ibw)%,title('4.��ֵ�˲���')  
%% �ó������¶����Ե
h_sum = sum(Ibw,1); %�԰��ֺڵ׵ĳ�������ֱͶӰ
[r, c] = findpeaks(a - h_sum);%����: r ֵ  c ����
% r1 = [];
c1 = [];    % ��¼������� 1/5 �����ڵĲ��ȵ�
c2 = [];    % ��¼�����ұ� 1/5 �����ڵĲ��ȵ�
c3 = [];    % ��¼�����м� 3/5 �����ڵĲ��ȵ�
index = 1;
m = length(r);
for i = 1:m
    if r(i) > 0.93 * a && c(i) < b/5
        c1(index) = c(i);
        index = index + 1;
    end
end
index = 1;
for i = 1:m
    if r(i) > 0.93 * a && c(i) > 4 * b / 5
        c2(index) = c(i);
        index = index + 1;
    end
end
h = []; % 2*n ά��1�� 2�зֱ���ַ��������к�
index = 1;
for i = 1 : length(c1) - 1
    Itemp = Ibw(:,c1(i):c1(i+1)); % ���������м��ͼ��
    %��ͨ��
    [L,number] = bwlabel(Itemp);
    for j = 1:number
        [rj, ~] = find(L == j);
        if max(rj) - min(rj) > 0.4 * a % �ø߶��жϸ���ͨ���Ƿ����ַ�
            h(1,index) = min(rj);
            h(2,index) = max(rj);
            index = index + 1;
        end
    end
end

for i = 1 : length(c2) - 1
    Itemp = Ibw(:,c2(i):c2(i+1));
    %��ͨ��
    [L,number] = bwlabel(Itemp);
    for j = 1:number
        [rj, ~] = find(L == j);
        if max(rj) - min(rj) > 0.4*a % �ø߶��жϸ���ͨ���Ƿ����ַ�
            h(1,index) = min(rj);
            h(2,index) = max(rj);
            index = index + 1;
        end
    end
end

% ����ڳ�����������û�С��ҵ����ַ����ٶ��м��������
if size(h,2) < 1
    index = 1;
    m = length(r);
    for i = 1:m
        if r(i) > 0.93 * a && c(i) > b/5 && c(i) < 4*b/5
            c3(index) = c(i);
            index = index + 1;
        end
    end
    index = 1;
    for i = 1 : length(c3) - 1
        Itemp = Ibw(:,c3(i):c3(i+1));
        %��ͨ��
        [L,number] = bwlabel(Itemp);
        for j = 1:number
            [rj, ~] = find(L == j);
            if max(rj) - min(rj) > 0.4*a
                h(1,index) = min(rj);
                h(2,index) = max(rj);
                index = index + 1;
            end
        end
    end
end

a1 = min(h(1,:)); % �ַ��ϱ�Ե
a2 = max(h(2,:)); % �ַ��±�Ե
I1 = Ibw(a1:a2,:); % �õ��������¶����Ե

%% ���� ��ʴ ���ղ����� ����ĳЩ�Ͽ����ַ�
se = strel('line',6,90);
I2 = imclose(I1,se);

%% ���ַ�֮��Ŀ�϶
hh_sum = sum(I2,1); % �Աղ������ȥ�����±�Ե�ĳ�������ֱͶӰ
less5 = zeros(1,b); % ��ֱͶӰ��ֵС�� 5 �ĵط������Ϊ1
for i = 1 : b
    if hh_sum(i) <= 5
        less5(i) = 1;
    end
end

[Ll,numl] = bwlabel(less5);
myindex = zeros(1,numl); %��¼�ַ�֮��Ŀ�϶λ�ã�ȡ�е�)
for i = 1 : numl
    [~,cl] = find(Ll == i);
    myindex(1,i) = round((max(cl) + min(cl))/2);
end
myindex = [1, myindex, b];
total = 2 + numl; %�ַ���϶����

%% �ַ�����
cha{1} = [];
cha{2} = [];
cha{3} = [];
cha{4} = [];
cha{5} = [];
cha{6} = [];
cha{7} = [];
target = 7; % �ַ�����

%�������ұ��и���
mj = myindex(total -1);
nj = myindex(total);
Itemp = I2(:, mj:nj);
[Ltemp,numtemp] = bwlabel(Itemp);
if numtemp ~= 0
    for iL = 1:numtemp
        [rtemp,ctemp] = find(Ltemp == iL);
        atemp1 = min(rtemp);
        atemp2 = max(rtemp);
        btemp1 = min(ctemp);
        btemp2 = max(ctemp);
        if atemp2 - atemp1 > 0.9*size(I2,1)
            if btemp2 - btemp1 < (atemp2 - atemp1)/3
                myindex = myindex(1,1:total - 1);
                total = total - 1;
            end
        end
    end
end

% �ӳ������ұ߿�ʼ�����ú�6���ַ�
for i = 1: total - 1
    j = total - i + 1;
    mj = myindex(j-1);
    nj = myindex(j);
    Itemp = I2(:, mj:nj); % �ַ�����
    [Ltemp,numtemp] = bwlabel(Itemp);
    if numtemp == 0
        continue
    end
    for iL = 1:numtemp
        [rtemp,ctemp] = find(Ltemp == iL);
        atemp1 = min(rtemp);
        atemp2 = max(rtemp);
        if atemp2 - atemp1 > 0.9*size(I2,1)
            cha{target} = I1(:,min(ctemp)+mj-1:max(ctemp)+mj-1);
            target = target - 1;
        end
    end
    if target == 1 % �Ѿ���6���ַ�
        myindex = myindex(1,1:j-1);
        break
    end
end

% ���Ʋ����������ַ��ָ�ʧ��
if target ~= 1 
    blank{1} = [];
    character_image = blank;
    return
end

%���� ������ ������û����һ��ĺ���
Itemp = I2(:, 1:myindex(length(myindex)));
[Ltemp, ~] = bwlabel(Itemp);
for iL = 1:max(Ltemp(:,1))
    [rtemp,ctemp] = find(Ltemp == iL);
    atemp1 = min(rtemp);
    atemp2 = max(rtemp);
    if atemp2 - atemp1 < 0.5*size(I2,1)
        Ltemp = clean(Ltemp, rtemp, ctemp);
        I1 = clean(I1, rtemp, ctemp);
    end
end
[Ltemp, ~] = bwlabel(Ltemp);
judge = Ltemp(:, 1);%Itemp
[rjudge, ~] = find( judge == 1);
[rtemp,ctemp] = find(Ltemp == 1);
if length(rjudge) > 0.3*size(I2,1)
    Ltemp = clean(Ltemp, rtemp, ctemp);
end
[~, ctemp] = find(Ltemp > 0);
cha{1} = I1(:,min(ctemp):max(ctemp));

%% �ַ����� 40*20
for i = 1:7
   [a,b] = size(cha{i});
   if a > 3 * b
       tmp = round((a - b)/2);
       tmpI = cha{i};
       cha{i} = [zeros(a,tmp), tmpI, zeros(a,tmp)];
   end
   cha{i} = imresize(cha{i}, [40, 20]);
end

%% ����
character_image = cha;
end