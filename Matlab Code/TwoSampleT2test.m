function [T2pool, T2, Pool_crit, Unpool_crit, Large_crit, Perm_crit, Boot_crit]=TwoSampleT2test(X1,X2,d,alpha,B)

[n1,p]=size(X1);
[n2,p]=size(X2);


% Calculates Test Statistics

Xb1=mean(X1)';
S1=cov(X1);

Xb2=mean(X2)';
S2=cov(X2);

Sp=(n1-1)/(n1+n2-2)*S1+(n2-1)/(n1+n2-2)*S2;

T2=(Xb1-Xb2-d)'*(S1/n1+S2/n2)^-1*(Xb1-Xb2-d);

T2pool=(Xb1-Xb2-d)'*((1/n1+1/n2)*Sp)^-1*(Xb1-Xb2-d);

% Classical critical values
Pool_crit=(n1+n2-2)*p/(n1+n2-p-1)*finv(1-alpha,p,n1+n2-p-1);

numa=trace((S1/n1+S2/n2)*(S1/n1+S2/n2));
numb=(trace(S1/n1+S2/n2))^2;
dena=(trace((S1/n1)^2)+(trace(S1/n1))^2)/(n1-1);
denb=(trace((S2/n2)^2)+(trace(S2/n2))^2)/(n2-1);
nu=(numa+numb)/(dena+denb);

Unpool_crit=nu*p/(nu-p+1)*finv(1-alpha,p,nu-p+1);

Large_crit=chi2inv(1-alpha,p);

% Obtains Critical Values for the Permutation and Bootstrap Tests
X=[X1;X2];
T2p=zeros(B,1);
T2b=zeros(B,1);

for ind=1:B
permind=randperm(n1+n2);

Xp1=X(permind(1:n1),:);
Xp2=X(permind((n1+1):(n1+n2)),:);

Xpb1=mean(Xp1)';
Sp1=cov(Xp1);

Xpb2=mean(Xp2)';
Sp2=cov(Xp2);


Xboot1=X1(randi(n1,n1,1),:);
Xboot2=X2(randi(n2,n2,1),:);

Xbb1=mean(Xboot1)';
Sb1=cov(Xboot1);

Xbb2=mean(Xboot2)';
Sb2=cov(Xboot2);

T2b(ind)=(Xbb1-Xbb2-(Xb1-Xb2))'*(Sb1/n1+Sb2/n2)^-1*(Xbb1-Xbb2-(Xb1-Xb2));
T2p(ind)=(Xpb1-Xpb2)'*(Sp1/n1+Sp2/n2)^-1*(Xpb1-Xpb2);

end

Perm_crit=quantile(T2p,1-alpha);
Boot_crit=quantile(T2b,1-alpha);

