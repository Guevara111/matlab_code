function [Mut_Pop]=Mutation(Cross_Pop,Pm)
Mut_Pop=Cross_Pop;
Cross_Pop_num=size(Cross_Pop,1);
for j=1:Cross_Pop_num
    A=Cross_Pop(j,:);
    A_1=A;
    n=size(A,2);
    r=rand(1,n);
    Pe=find(r<Pm);%可以引入变异概率
    sum_Pe=size(Pe,2);
    for i=1:sum_Pe
        c=A(Pe(i));
        A_1(Pe(i))=A_1(find(r==max(r)));
        A_1(find(r==max(r)))=c;
        Mut_Pop=[Mut_Pop;A_1];
    end
end

