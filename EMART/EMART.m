clear all;
clc;

%����ART�����ʼ��
%��������
train_data = xlsread('train_data');
data_length = size(train_data , 1);
data_num = size(train_data , 2);
%��ʼ���������
N = 100; %�������һ������
ART_node_num = 1; %��ʼ����Ԫ��
weight = ones(ART_node_num , data_length ) / N; %����������Ȩ��
threshold = 0.8; %ART������ֵ

%EM�����ʼ��
t = 0.1; %ʱ��˥��ϵ�� 
em_ART_t = [ 0.4  ; 0.5 ; 0.6 ; 0.7 ; 0.8 ; 0.9 ; 1.0];
em_train_data = ones(1 , 7) ; %����7���¼��Ķ��ڼ���
em_data_length = size(em_train_data , 1); %�龰������������ݳ�ʼ��
em_data_num = size(em_train_data , 2);
N = 100;
EMART_node_num = 1;
em_num = ones(em_data_length , EMART_node_num) / N; %�龰�������ֵ
em_threshold = 0.5 ;
EM_ART_activation = ones(1 , 7);  
%ART���翪ʼ����
for i = 1:data_num
    ART_node = zeros(ART_node_num , 1); %����������Ԫ���飬������м������
    for n = 1:ART_node_num
        %��������Ȩ�غ� node ��������Ԫ
        
        ART_fuzzy_and_temp(n , :) = weight(n , :)  * train_data(: , i)    ;
        
        ART_fuzzy_and = sum(sum(abs(min(ART_fuzzy_and_temp))));
        ART_t(n , 1) = sum(1 * ART_fuzzy_and / (1 + abs(sum(sum(weight)))));
        
        
    end
    
    [~ , node] = max(ART_t); %��������
        if ART_node(node , 1) == 1
            ART_t(node , 1) = -n;
        end
        [~ , node] = max(ART_t);
        ART_node(node , 1) = 1; %�����
        %ģ��ƥ��
        %ģ��ƥ����� m
        m = ART_fuzzy_and / sum(train_data(:,i)) ;
        weight_activate = weight(node , :);
        if(m >= threshold)
            weight(node , :) = ART_learn(train_data(: , i) , weight_activate);
            fprintf('����%d���ڵ�%d��\n',i,node);
            flag = 0 ; %ARTģ�͸��±��λ
        else
            flag = 1; %ģ����Ҫ����
        end
    %ARTģ�͸���
    if(flag == 1)
        %fprintf('����%d���ڵ�%d��\n',i,ART_node_num);
        ART_node_num = ART_node_num + 1;
        fprintf('����%d���ڵ�%d��\n',i,ART_node_num);
        weight = [weight ; train_data(: , i).'];
    end
    
    %emART���¼
    em_train_data_temp = em_train_data(: , 2:6);
    em_train_data(: , 1:5) = em_train_data_temp;
    em_train_data(: , 6) = node ;
    em_train_data = em_train_data  .* em_ART_t.' ; %�龰�����ʱ��˥������
    
    %EMART������
    %EM_ART_node = zeros(EMART_node_num , 1);
    %EM_ART_activation = em_train_data .* em_num;  %�����
    % mis ��� ��ӦԪ��֮������֮��
    a = [];
    for n_1 = 1:EMART_node_num
       na = sum(sum(EM_ART_activation(n_1 , :) ));
       nb = sum(em_train_data);
       mis_temp = na / nb;
       %mis_tmep = sum(sum(mis_temp));
       a = [a ;mis_temp];
    end
        [em_threshold_temp , em_node] = max(a);
        if(em_threshold_temp > em_threshold)
           EM_ART_activation(em_node , :) = em_train_data;
           fprintf('����%d���ڵ�%d����\n',i,em_node);
           em_flag = 0;
        else
        em_flag = 1;
        end
        
        if(em_flag == 1)
            fprintf('����%d���ڵ�%d����\n',i,EMART_node_num);
            EMART_node_num = EMART_node_num + 1;
            EM_ART_activation = [EM_ART_activation ; em_train_data];
        end
    end
