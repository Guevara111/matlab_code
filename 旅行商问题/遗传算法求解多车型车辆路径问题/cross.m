function [A,B]=cross(A,B)
A_1=A;
B_1=B;
r=randperm(length(A));
c=min(r(1,1:2));
d=max(r(1,1:2));
for i=c:d
    A(i)=0;
end
B_1(ismember(B_1,A))=[];
A(1,c:d)=B_1;
for i=c:d
    B(i)=0;
end
A_1(ismember(A_1,B))=[];
B(1,c:d)=A_1;
end