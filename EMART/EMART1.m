clear all; 
clc;
%% ��������
train_data=xlsread('train_data');                           % ART1��������Ϊ������,train_dataΪ�߸�������ÿһ��Ϊһ������
data_length=size(train_data,1);
data_num=size(train_data,2);
N=100;

%% ���������ʼ��
R_node_num=3;
weight_b=ones(data_length,R_node_num)/N;
weight_t=ones(data_length,R_node_num);
threshold_ro=0.5;

%%
%EM�����ʼ��
t = 0.1; %ʱ��˥��ϵ�� 
em_train_data_1 = ones(1 , 6) ; %����7���¼��Ķ��ڼ���
em_train_data = ones(1 , 6) ; %����7���¼��Ķ��ڼ���
em_data_length = size(em_train_data , 1); %�龰������������ݳ�ʼ��
em_data_num = size(em_train_data , 2);
N = 100;
em_node_num = 1;
em_weight_b=ones(6,em_node_num)/N;
em_weight_t=ones(6,em_node_num);
em_threshold = 0.5 ;
EM_ART_activation = ones(1 , 6);  

%% ��ʼ����ѵ��
for i=1:data_num

        R_node=zeros(R_node_num,1);                 %%ƥ��ѭ�����̱�־
            for n=1:R_node_num                          %%ƥ��ѭ������
                        %Ѱ�Ҿ�����ʤ��Ԫ
                            for j=1:R_node_num
                                net(j,1)=sum(train_data(:,i).*weight_b(:,j));
                            end
                             [~,j_max]=max(net);
                             if R_node(j_max,1)==1                  %%ѭ�������־�ж�
                                 net(j_max,1)= -n;
                             end
                              [~,j_max]=max(net);
                              R_node(j_max,1)=1;  %%ȥ����
                                      %������ʤ��Ԫͨ������Ȩ��������C�㣬�������ƶȼ���
            weight_t_active=weight_t(:,j_max);
            weight_b_active=weight_b(:,j_max);
            Similarity_N0=sum(weight_t_active.*train_data(:,i));
            Similarity_N1=sum(train_data(:,i));
            if (threshold_ro<Similarity_N0/Similarity_N1)
                [weight_t(:,j_max),weight_b(:,j_max)]=ART1_learn(train_data(:,i),weight_t_active,weight_b_active);
                fprintf('����%d���ڵ�%d��\n',i,j_max);
                flag=0;
            break;
            end
            flag=1;
            end
            %% �ж��Ƿ���Ҫ����µĽ�㣬��������
    if(flag==1)
%       ART1_updata_model()
        R_node_num=R_node_num+1;
        fprintf('����%d���ڵ�%d��\n',i,R_node_num);
        weight_b=[weight_b,train_data(:,j)];
        weight_t=[weight_t,ones(data_length,1)];
    end
%%
 %emART���¼
    em_train_data_temp = em_train_data_1(: , 2:6);
    em_train_data_1(: , 1:5) = em_train_data_temp;
    em_train_data_1(: , 6) = j_max ;
    em_train_data = em_train_data_1 /10  ; %�龰�����ʱ��˥������ .* em_ART_t.'
    
    %EMART������
    %EM_ART_node = zeros(EMART_node_num , 1);
    em_node=zeros(em_node_num,1);                 %%ƥ��ѭ�����̱�־
            for n=1:em_node_num                          %%ƥ��ѭ������
                        %Ѱ�Ҿ�����ʤ��Ԫ
                            for j=1:em_node_num
                                em_net(: , j)=sum(em_train_data * em_weight_b(:,j));
                            end
                             [~,em_max]=max(em_net);
                             if em_node(em_max,1)==1                  %%ѭ�������־�ж�
                                 em_net(em_max,1)=-n;
                             end
                              [~,em_max]=max(em_net);
                              R_node(em_max,1)=1;  %%ȥ����
                                      %������ʤ��Ԫͨ������Ȩ��������C�㣬�������ƶȼ���
            em_weight_t_active=em_weight_t(:,em_max);
            em_weight_b_active=em_weight_b(:,em_max);
            em_Similarity_N0=sum(sum(em_weight_t_active .* em_train_data));
            em_Similarity_N1=sum(em_train_data);
            b = em_Similarity_N0/em_Similarity_N1;
            if (em_threshold < b)
                %[em_weight_t(:,em_max), em_weight_b(: , em_max) ]= ART1_learn(em_train_data.' ,em_weight_t_active,em_weight_b_active);
                em_weight_t(:,em_max) = em_train_data.' .* em_weight_t_active;
                em_weight_b(: , em_max) = em_weight_t(:,em_max) ./  (0.5+sum(em_weight_t(:,em_max)));
                fprintf('����%d���ڵ�%d����\n',i,em_max);
                flag=0;
            break;
            end
            flag=1;
            end
            %% �ж��Ƿ���Ҫ����µĽ�㣬��������
    if(flag==1)
%       ART1_updata_model()
        em_node_num=em_node_num+1;
        fprintf('����%d���ڵ�%d����\n',i,em_node_num);
        em_weight_b=[em_weight_b , em_train_data.'];
        em_weight_t=[em_weight_t , ones(6,1)];
    end
    
  
end




