function [accuary,precious,value]=resultsProcess(results10Dim,expectResults)
    %预测的输出结果为 数量*10维度
    %期望的结果为 1维，如3，5，8，0 等
    %每一组中的最大的数据，即为最后预测的结果
    %如[0.2,0.1,0.88,0.1,-0.02,...,0.2],则预测的结果为 3
    %注意，若第十位为最大值，那么预测结果为0
    [~,value]=max(results10Dim);
    value(value==10)=0;                  %预测结果
    precious = sum(value==expectResults);%正确数量
    accuary = precious/length(expectResults);%精度
end