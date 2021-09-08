clear all;
clc;

%基础ART网络初始化
%导入数据
train_data = xlsread('train_data');
data_length = size(train_data , 1);
data_num = size(train_data , 2);
%初始化网络参数
N = 100; %神经网络归一化参数
ART_node_num = 1; %初始化神经元数
weight = ones(ART_node_num , data_length ) / N; %神经网络连接权重
threshold = 0.8; %ART网络阈值

%EM网络初始化
t = 0.1; %时间衰减系数 
em_ART_t = [ 0.4  ; 0.5 ; 0.6 ; 0.7 ; 0.8 ; 0.9 ; 1.0];
em_train_data = ones(1 , 7) ; %建立7个事件的短期记忆
em_data_length = size(em_train_data , 1); %情景记忆层输入数据初始化
em_data_num = size(em_train_data , 2);
N = 100;
EMART_node_num = 1;
em_num = ones(em_data_length , EMART_node_num) / N; %情景记忆记忆值
em_threshold = 0.5 ;
EM_ART_activation = ones(1 , 7);  
%ART网络开始计算
for i = 1:data_num
    ART_node = zeros(ART_node_num , 1); %设置网络神经元数组，方便进行激活计算
    for n = 1:ART_node_num
        %计算连接权重和 node 被激活神经元
        
        ART_fuzzy_and_temp(n , :) = weight(n , :)  * train_data(: , i)    ;
        
        ART_fuzzy_and = sum(sum(abs(min(ART_fuzzy_and_temp))));
        ART_t(n , 1) = sum(1 * ART_fuzzy_and / (1 + abs(sum(sum(weight)))));
        
        
    end
    
    [~ , node] = max(ART_t); %竞争网络
        if ART_node(node , 1) == 1
            ART_t(node , 1) = -n;
        end
        [~ , node] = max(ART_t);
        ART_node(node , 1) = 1; %激活函数
        %模板匹配
        %模板匹配参数 m
        m = ART_fuzzy_and / sum(train_data(:,i)) ;
        weight_activate = weight(node , :);
        if(m >= threshold)
            weight(node , :) = ART_learn(train_data(: , i) , weight_activate);
            fprintf('样本%d属于第%d类\n',i,node);
            flag = 0 ; %ART模型更新标记位
        else
            flag = 1; %模型需要更新
        end
    %ART模型更新
    if(flag == 1)
        %fprintf('样本%d属于第%d类\n',i,ART_node_num);
        ART_node_num = ART_node_num + 1;
        fprintf('样本%d属于第%d类\n',i,ART_node_num);
        weight = [weight ; train_data(: , i).'];
    end
    
    %emART层记录
    em_train_data_temp = em_train_data(: , 2:6);
    em_train_data(: , 1:5) = em_train_data_temp;
    em_train_data(: , 6) = node ;
    em_train_data = em_train_data  .* em_ART_t.' ; %情景记忆层时间衰减序列
    
    %EMART神经网络
    %EM_ART_node = zeros(EMART_node_num , 1);
    %EM_ART_activation = em_train_data .* em_num;  %激活函数
    % mis 误差 对应元素之间的误差之和
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
           fprintf('样本%d属于第%d序列\n',i,em_node);
           em_flag = 0;
        else
        em_flag = 1;
        end
        
        if(em_flag == 1)
            fprintf('样本%d属于第%d序列\n',i,EMART_node_num);
            EMART_node_num = EMART_node_num + 1;
            EM_ART_activation = [EM_ART_activation ; em_train_data];
        end
    end
