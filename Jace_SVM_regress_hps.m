%% a_template_flow_usingSVM_regress
%for regression

%%
% by faruto
%Email:patrick.lee@foxmail.com QQ:516667408 http://blog.sina.com.cn/faruto BNU
%last modified 2010.01.17
%Super Moderator @ www.ilovematlab.cn

%% 若转载请注明：
% faruto and liyang , LIBSVM-farutoUltimateVersion 
% a toolbox with implements for support vector machines based on libsvm, 2009. 
% Software available at http://www.ilovematlab.cn
% 
% Chih-Chung Chang and Chih-Jen Lin, LIBSVM : a library for
% support vector machines, 2001. Software available at
% http://www.csie.ntu.edu.tw/~cjlin/libsvm

%%
% 仅用于泛化
close all;
clear;
clc;
format compact;
%%
[typ, desc, fmt] = xlsfinfo('C:\Users\Jace\Desktop\实习\SVM\libsvm-3.23\matlab\黄坡水站数据_extrapolated(2h).xls');
% for s =3:4;
% for t =0:3;
load model_沙河(2h)_s3t0.mat
    for sheet=1:length(desc)
s=3;
t=0;
% sheet=1;
[read_data,txt,raw] = xlsread('C:\Users\Jace\Desktop\实习\SVM\libsvm-3.23\matlab\黄坡水站数据_extrapolated(2h).xls',char(desc(sheet)));

    mid_time = 2520;end_time = 4380;  %2小时
    lag_time = 180; %2小时
%     mid_time = 840;end_time = 1460;  %6小时
%     lag_time = 60; %6小时

    X_WT=read_data(lag_time+1:mid_time,3);       %水温
    X_TUR=read_data(lag_time+1:mid_time,7);      %浊度
%    X_cond=read_data(lag_time+1:mid_time,15);    %电导率
%    X_Q=read_data(lag_time+1:mid_time,7);        %流量
    X_pH=read_data(lag_time+1:mid_time,5);       %pH
    X_DO=read_data(1:(mid_time-lag_time),4);     %溶解氧,前15天
%    X_MN=read_data(lag_time+1:mid_time,7);       %高猛酸盐
   X_NHN=read_data(lag_time+1:mid_time,9);       %氨氮
%    X_TN=read_data(lag_time+1:mid_time,6);      %总氮
    X_TP=read_data(lag_time+1:mid_time,10);       %总磷
%    train_x = [X_WT X_cond X_NHN X_MN X_pH X_DO];
%    train_x = [X_WT X_TUR X_cond X_DO X_MN X_NHN X_TN];
    train_x = [X_WT X_TUR X_pH X_DO X_NHN X_TP];
    train_y = read_data((lag_time+1):mid_time,4);

    XX_WT=read_data((lag_time+1):end_time,3);       %水温
    XX_TUR=read_data((lag_time+1):end_time,7);      %浊度
%    XX_cond=read_data((lag_time+1):end_time,15);    %电导率
%    XX_Q=read_data((lag_time+1):end_time,7);        %流量
    XX_pH=read_data((lag_time+1):end_time,5);       %pH
    XX_DO=read_data(1:(end_time-lag_time),4);       %溶解氧,前15天
%    XX_MN=read_data((lag_time+1):end_time,7);     %高猛酸盐
    XX_NHN=read_data((lag_time+1):end_time,9);      %氨氮
%    XX_TN=read_data((lag_time+1):end_time,6);    %总氮
    XX_TP=read_data((lag_time+1):end_time,10);     %总磷
%    test_x = [XX_WT XX_cond XX_NHN XX_MN XX_pH XX_DO];
%    test_x = [XX_WT XX_TUR XX_cond XX_DO XX_MN XX_NHN XX_TN];
    test_x = [XX_WT XX_TUR XX_pH XX_DO XX_NHN XX_TP];
    test_y = read_data((lag_time+1):end_time,4);
    %% 归一化预处理
    [train_x_scale,test_x_scale] = scaleForSVM(train_x,test_x,0,1);
    [train_y_scale,test_y_scale,ps] = scaleForSVM(train_y,test_y,0,1);
    %% predict on test set
    model = svmtrain(train_y_scale, train_x_scale, cmd); 
    [ptest,test_mse,ptest] = svmpredict(test_y_scale,test_x_scale, model);
    ptest = mapminmax('reverse',ptest',ps);
    ptest = ptest';
    %test_y
    %ptest
    %% 可视化
    if(sheet == 1)
    figure;
    plot(test_y,'b');
    hold on
    plot(ptest,'--r');
    legend('original','predict');
    title('Test Set Regression Predict by SVM');
    grid on;
    print(gcf,'-djpeg','-r600',['C:\Users\Jace\Desktop\实习\SVM\libsvm-3.23\matlab\MIC_PCA\黄坡水\yearly\Figure\',...
        '2h_s',num2str(s),'_t',num2str(t)]);
    end
    %% 导出文件
    SIMY{sheet} = [ptest];
    % simY(Sheet,1) = {SIMY};
    output = ['C:\Users\Jace\Desktop\实习\SVM\libsvm-3.23\matlab\MIC_PCA\黄坡水\yearly\',...
        '2h_s',num2str(s),'_t',num2str(t),'.xls'];
    xlswrite(output,SIMY{sheet},char(desc(sheet)));
    end
        %% 计算离散小波
    SIMY{6}=SIMY{2}+SIMY{3}+SIMY{4}+SIMY{5};
    output = ['C:\Users\Jace\Desktop\实习\SVM\libsvm-3.23\matlab\MIC_PCA\黄坡水\yearly\',...
        '2h_s',num2str(s),'_t',num2str(t),'.xls'];
    xlswrite(output,SIMY{6},'DWT');
% end
% end
