%% a_template_flow_usingSVM_regress
%for regression

%%
% by faruto
%Email:patrick.lee@foxmail.com QQ:516667408 http://blog.sina.com.cn/faruto BNU
%last modified 2010.01.17
%Super Moderator @ www.ilovematlab.cn

%% ��ת����ע����
% faruto and liyang , LIBSVM-farutoUltimateVersion 
% a toolbox with implements for support vector machines based on libsvm, 2009. 
% Software available at http://www.ilovematlab.cn
% 
% Chih-Chung Chang and Chih-Jen Lin, LIBSVM : a library for
% support vector machines, 2001. Software available at
% http://www.csie.ntu.edu.tw/~cjlin/libsvm

%%
% �����ڷ���
close all;
clear;
clc;
format compact;
%%
[typ, desc, fmt] = xlsfinfo('C:\Users\Jace\Desktop\ʵϰ\SVM\libsvm-3.23\matlab\����ˮվ����_extrapolated(2h).xls');
% for s =3:4;
% for t =0:3;
load model_ɳ��(2h)_s3t0.mat
    for sheet=1:length(desc)
s=3;
t=0;
% sheet=1;
[read_data,txt,raw] = xlsread('C:\Users\Jace\Desktop\ʵϰ\SVM\libsvm-3.23\matlab\����ˮվ����_extrapolated(2h).xls',char(desc(sheet)));

    mid_time = 2520;end_time = 4380;  %2Сʱ
    lag_time = 180; %2Сʱ
%     mid_time = 840;end_time = 1460;  %6Сʱ
%     lag_time = 60; %6Сʱ

    X_WT=read_data(lag_time+1:mid_time,3);       %ˮ��
    X_TUR=read_data(lag_time+1:mid_time,7);      %�Ƕ�
%    X_cond=read_data(lag_time+1:mid_time,15);    %�絼��
%    X_Q=read_data(lag_time+1:mid_time,7);        %����
    X_pH=read_data(lag_time+1:mid_time,5);       %pH
    X_DO=read_data(1:(mid_time-lag_time),4);     %�ܽ���,ǰ15��
%    X_MN=read_data(lag_time+1:mid_time,7);       %��������
   X_NHN=read_data(lag_time+1:mid_time,9);       %����
%    X_TN=read_data(lag_time+1:mid_time,6);      %�ܵ�
    X_TP=read_data(lag_time+1:mid_time,10);       %����
%    train_x = [X_WT X_cond X_NHN X_MN X_pH X_DO];
%    train_x = [X_WT X_TUR X_cond X_DO X_MN X_NHN X_TN];
    train_x = [X_WT X_TUR X_pH X_DO X_NHN X_TP];
    train_y = read_data((lag_time+1):mid_time,4);

    XX_WT=read_data((lag_time+1):end_time,3);       %ˮ��
    XX_TUR=read_data((lag_time+1):end_time,7);      %�Ƕ�
%    XX_cond=read_data((lag_time+1):end_time,15);    %�絼��
%    XX_Q=read_data((lag_time+1):end_time,7);        %����
    XX_pH=read_data((lag_time+1):end_time,5);       %pH
    XX_DO=read_data(1:(end_time-lag_time),4);       %�ܽ���,ǰ15��
%    XX_MN=read_data((lag_time+1):end_time,7);     %��������
    XX_NHN=read_data((lag_time+1):end_time,9);      %����
%    XX_TN=read_data((lag_time+1):end_time,6);    %�ܵ�
    XX_TP=read_data((lag_time+1):end_time,10);     %����
%    test_x = [XX_WT XX_cond XX_NHN XX_MN XX_pH XX_DO];
%    test_x = [XX_WT XX_TUR XX_cond XX_DO XX_MN XX_NHN XX_TN];
    test_x = [XX_WT XX_TUR XX_pH XX_DO XX_NHN XX_TP];
    test_y = read_data((lag_time+1):end_time,4);
    %% ��һ��Ԥ����
    [train_x_scale,test_x_scale] = scaleForSVM(train_x,test_x,0,1);
    [train_y_scale,test_y_scale,ps] = scaleForSVM(train_y,test_y,0,1);
    %% predict on test set
    model = svmtrain(train_y_scale, train_x_scale, cmd); 
    [ptest,test_mse,ptest] = svmpredict(test_y_scale,test_x_scale, model);
    ptest = mapminmax('reverse',ptest',ps);
    ptest = ptest';
    %test_y
    %ptest
    %% ���ӻ�
    if(sheet == 1)
    figure;
    plot(test_y,'b');
    hold on
    plot(ptest,'--r');
    legend('original','predict');
    title('Test Set Regression Predict by SVM');
    grid on;
    print(gcf,'-djpeg','-r600',['C:\Users\Jace\Desktop\ʵϰ\SVM\libsvm-3.23\matlab\MIC_PCA\����ˮ\yearly\Figure\',...
        '2h_s',num2str(s),'_t',num2str(t)]);
    end
    %% �����ļ�
    SIMY{sheet} = [ptest];
    % simY(Sheet,1) = {SIMY};
    output = ['C:\Users\Jace\Desktop\ʵϰ\SVM\libsvm-3.23\matlab\MIC_PCA\����ˮ\yearly\',...
        '2h_s',num2str(s),'_t',num2str(t),'.xls'];
    xlswrite(output,SIMY{sheet},char(desc(sheet)));
    end
        %% ������ɢС��
    SIMY{6}=SIMY{2}+SIMY{3}+SIMY{4}+SIMY{5};
    output = ['C:\Users\Jace\Desktop\ʵϰ\SVM\libsvm-3.23\matlab\MIC_PCA\����ˮ\yearly\',...
        '2h_s',num2str(s),'_t',num2str(t),'.xls'];
    xlswrite(output,SIMY{6},'DWT');
% end
% end
