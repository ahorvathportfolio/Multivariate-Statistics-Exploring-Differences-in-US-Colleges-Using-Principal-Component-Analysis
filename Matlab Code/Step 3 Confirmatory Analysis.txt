% Multivariate Analysis Project Confirmatory Analysis- Horvath & Lee
% Step 3: Confirmatory Analysis

% Import the Confirmatory_subsetting.mat file created in Step 1.
alpha = 0.05
% Mardia's Test for MVN
[H stats] = mardiatest(C,alpha)

%     Hs: 1
%     Ps: 0
%     Ms: 1.3763e+03
%    CVs: 255.6018
%    Hsc: 1
%    Psc: 0
%    Msc: 1.4133e+03
%     Hk: 1
%     Pk: 0
%    Mk: 22.4482
%   CVk: 1.6449

% The Marida's test statistic for multivariate skewness (corrected for
% small samples) is 1.4133e+03 and the Mardia's test statistic for
% multivariate kurtosis is 22.4482. The corresponding p-values are given to
% be approximately 0. Therefore, we reject Ho : X ~ MVN.

% Remaining tests require us to have the labels for each categorical
% variable. Here we are turning them to numeric:

% Load in Sample College Data Quantitative.xlsx and Sample College Data 
% Categorical.xlsx
Quant_vars = SampleCollegeDataQuantitative % As numeric matrix
Categ_vars = SampleCollegeDataCategorical % As string array

% Adjust this
confind 
%3     6     7     8     9    11    12    16    17    18    19    22    23    25    28    29    31    32    33    34    35    39    40    41    42
%44    46    47    48    49    50    52    54    55    56    57    58    60    61    62    63    64    65    66    69    70    71    72    74    75
%76    77    78    79    80    82    84    86    89    90    91    92    93    94    95    97    98    99   100   101   102   104   105   108   110
%111   113   114   115   116   118   119   120   123   126   127   128   130   131   132   133   134   135   137   141   142   143   144   146   147
%148   149   151   152   153   154   158   160   161   162   164   166   167   168   173   174   177   179   181   182   184   185   186   187   189
%190   191   192   194   195   196   197

%3 is the first for me, 197 is the last for me.
% Row 1
%58         660         640       36190       21186        2123        2123          87          11          80
% Row 132
%73         570         590       15880        5163        5605        5365          76          16          58

Quant_vars(3,:)
Quant_vars(197,:) % Everything matches. No weird things going on.

%% Now we need to get the labels

% clabels_num_loc for the location variable.
for i=1:length(clabels)
    if clabels(i)== "City"
        clabels_num_loc(i)=1
    elseif clabels(i)== "Suburb"
        clabels_num_loc(i)=2
    elseif clabels(i)== "Town"
        clabels_num_loc(i)=3
    else clabels(i)== "Rural"
        clabels_num_loc(i)=4
    end
end


clabels_state = Categ_vars(confind,2)'

% clabels_num_state for state
for i=1:length(clabels_state)
    if clabels_state(i)== "Delaware"
        clabels_num_state(i)=1
    elseif clabels_state(i)== "District of Columbia"
        clabels_num_state(i)=2
    elseif clabels_state(i)== "Maryland"
        clabels_num_state(i)=3
    elseif clabels_state(i)== "Pennsylvania"
        clabels_num_state(i)=4
    elseif clabels_state(i)== "Virginia"
        clabels_num_state(i)=5
    elseif clabels_state(i)== "West Virginia"
        clabels_num_state(i)=6
    end
end


% clabels_num_type for the private vs public variable.
clabels_type = Categ_vars(confind,4)'

for i=1:length(clabels_type)
    if clabels_type(i)== "Private"
        clabels_num_type(i)=1
    elseif clabels_type(i)== "Public"
        clabels_num_type(i)=2
    end
end

clabels_num_loc;
clabels_num_state;
clabels_num_type;

%% Testing for Equality of Covariance Matrices
% function [C, Large_crit, Perm_crit]=EqualCovtest(X1,X2,alpha,B)

% PUBLIC VS PRIVATE
X1 = C(clabels_num_type==1,:) % Private
size(X1) % 82    10
X2 = C(clabels_num_type==2,:) % Public
size(X2) % 50    10

head(C, 6) % This should include one observation which is public (the last one)
%58         660         640       36190       21186        2123        2123          87          11          80
%66         620         540       11782        5937         274         262          63          13          33
%54         600         600       34150       20566        3932        2211          76          13          61
%54         520         530       24480       14225         901         877          58          10          39
%81         580         560       18260       10629         870         628          71          12          45
%72         540         560        8082        5431       10159        9256          80          21          58

head(X1, 6) % Yes it looks like the 6th observation is different.
%58         660         640       36190       21186        2123        2123          87          11          80
%66         620         540       11782        5937         274         262          63          13          33
%54         600         600       34150       20566        3932        2211          76          13          61
%54         520         530       24480       14225         901         877          58          10          39
%81         580         560       18260       10629         870         628          71          12          45
%49         510         493       19980       11405         763         763          56          10          35

C(7,:) % It is the next observation in C. Okay so everything looks okay.
%49         510         493       19980       11405         763         763          56          10          35

head(X2,1)
%72         540         560        8082        5431       10159        9256          80          21          58


head(C, 14) % Only the 6th row is a public institution. All others are private
head(X1, 13) % Yes, this looks identical but that 6th row was removed. Okay we 
% are good to go! We now have an X1 and X2 dataset of the
% different groups Private and Public from the confirmatory dataset.

alpha = 0.05
B = 1000
[C, Large_crit, Perm_crit]=EqualCovtest(X1,X2,alpha,B)

% According to the textbook on page 311, Box's chi squared approximation
% works well if nl (sample size of the l-th population) exceeds 20 and if p
% and g do not exceed 5.

% Here our sample sizes are n1 = 82, n2 = 50, p = 10, and g = 2 groups total.
% So the only issue is that p is 10, not 5 or less. 

% Output:
%C =
%
%  347.8662
%
%
%Large_crit =
%
%   73.3115
%
%
%Perm_crit =
%
%  147.5236 this will change a little every time we run it

% Using Box's Test for Equality of Covariance Matrices, at significance 
% level alpha, reject Ho if C > chisquared (p(p+1)(g-1)/2  (alpha)

% C > Large_crit here. So reject Ho. The covariance matrix structures are
% different. We do not have to test any others. We just need one of these
% to fail.

%%% NOW CLOSE MATLAB, RELOAD CONFIRMATORY DATASET + QUANITATIVE +
%%% CATEGORICAL DATASETS, RUN THROUGH THE CODE BUT DO NOT RUN X1 AND X2
%%% FROM BEFORE. CREATE X1 AND X2 HERE. I DONT KNOW WHY IT IS DOING THIS, BUT I
%%% KEEP GETTING THE FOLLOWING ERROR IF I DO NOT CLOSE MATLAB WHEN CREATING 
%%% X1 AND X2:

% "The logical indices in position 1 contain a true value outside of the
% array bounds."

% LOCATION
% Cities and suburbs had larger variances at a glance than towns and rural
% areas. So let's start with City vs Town, if Ho not rejected, do City vs
% Rural, etc.
C(clabels_num_loc==1,:) % City
C(clabels_num_loc==2,:) % Suburb
C(clabels_num_loc==3,:) % Town
C(clabels_num_loc==4,:) % Rural


X1 = C(clabels_num_loc==1,:) % City
size(X1) % 48    10
X2 = C(clabels_num_loc==2,:) % Suburb
size(X2) %42    10
X3 = C(clabels_num_loc==3,:) % Town
size(X3) % 31    10
X4 = C(clabels_num_loc==4,:) % Rural
size(X4) % 11    10


alpha = 0.05
B = 1000
[C, Large_crit, Perm_crit]=EqualCovtest(X1,X3,alpha,B)

%C =
%
%  201.2750
%
%
%Large_crit =
%
%   73.3115
%
%
%Perm_crit =
%
%  122.8188

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All combinations
% City Suburb, City Town, City Rural
% Suburb Town, Suburb Rural
% Town Rural

[C, Large_crit, Perm_crit]=EqualCovtest(X1,X2,alpha,B) % City Suburb
%C =
%
%  162.9632
%
%
%Large_crit =
%
%   73.3115
%
%
%Perm_crit =
%
%  122.8510
%C > Perm_crit. Reject.

[C, Large_crit, Perm_crit]=EqualCovtest(X1,X3,alpha,B) % City Town
%C =
%
%  201.2750
%
%
%Large_crit =
%
%   73.3115
%
%
%Perm_crit =
%
%  122.6257
%C > Perm_crit. Reject.

[C, Large_crit, Perm_crit]=EqualCovtest(X1,X4,alpha,B) % City Rural
%C =
%
% 110.6009
%
%
%Large_crit =
%
%   73.3115
%
%
%Perm_crit =
%
%  130.2541
% C is not > Perm_crit. Fail to Reject.

[C, Large_crit, Perm_crit]=EqualCovtest(X2,X3,alpha,B) % Suburb Town
%C =
%
%  124.4155
%
%
%Large_crit =
%
%   73.3115
%
%
%Perm_crit =
%
%  123.2502
% This one is tricky!!!
% Perm_crit is really close to C, and when we run it a bunch of times it
% goes above and below C. Since on border I would say fail to reject?
% Use Perm_crit = 126.0680 in paper. It's around 126 a lot.

[C, Large_crit, Perm_crit]=EqualCovtest(X2,X4,alpha,B) % Suburb Rural
%C =
%
%   93.1654
%
%
%Large_crit =
%
%   73.3115
%
%
%Perm_crit =
%
%  137.2264
% C is not > Perm_crit. Fail to Reject.


[C, Large_crit, Perm_crit]=EqualCovtest(X3,X4,alpha,B) % Town Rural
%C =
%
%   90.5961
%
%
%Large_crit =
%
%   73.3115
%
%
%Perm_crit =
%
%  121.5793
% C is not > Perm_crit. Fail to Reject.

%%%%%%%%%%%%%%%%%%
%%% Conclusion %%%
%%%%%%%%%%%%%%%%%%
% Only reject for City Suburb, and City Town
% Sometimes City Rural is reject but not always.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Here our sample sizes are n1 = 48, n2 = 31, p = 10, and g = 2 groups total.
% So the only issue is that p is 10, not 5 or less.

% C > Large_crit here. So reject Ho. The covariance matrix structures are
% different. We do not have to test any others. We just need one of these
% to fail.

%%% CLOSE MATLAB AND DO THE SAME THING AGAIN
sum(clabels_num_state==1) % 3 Delaware
sum(clabels_num_state==2) % 5 DC
sum(clabels_num_state==3) % 18 Maryland
sum(clabels_num_state==4) % 67 Pennsylvania
sum(clabels_num_state==5) % 29 Virginia
sum(clabels_num_state==6) % 10 West Virginia

%%%%%%
X1 = C(clabels_num_state==4,:) % Pennsylvania
size(X1) % 67    10
X2 = C(clabels_num_state==5,:) % Virginia i.e. use the 2 largest states
size(X2) % 29    10

alpha = 0.05
B = 1000
[C, Large_crit, Perm_crit]=EqualCovtest(X1,X2,alpha,B)

%C =
%
%  118.3530
%
%
%Large_crit =
%
%   73.3115
%
%
%Perm_crit =
%
%  135.6276
%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All combinations
% X1 X2, X1 X3, X1 X4, X1 X5, X1 X6
% X2 X3, X2 X4, X2 X5, X2 X6
% X3 X4, X3 X5, X3 X6
% X4 X5, X4 X6
% X5 X6

X1 = C(clabels_num_state==1,:) % Delaware
size(X1) % 3    10
X2 = C(clabels_num_state==2,:) % DC
size(X2) % 5    10
X3 = C(clabels_num_state==3,:) % Maryland
size(X3) % 18    10
X4 = C(clabels_num_state==4,:) % Pennsylvania
size(X4) % 67    10
X5 = C(clabels_num_state==5,:) % Virgina
size(X5) % 29    10
X6 = C(clabels_num_state==6,:) % West Virgina
size(X6) % 10    10

alpha = 0.05
B = 1000
% The following few lines with no output will produce
% errors. This is due to issues brought about because 
% of the small sample size. This will be briefly discussed 
% after all of these lines of code. 
[C, Large_crit, Perm_crit]=EqualCovtest(X1,X2,alpha,B)
[C, Large_crit, Perm_crit]=EqualCovtest(X1,X3,alpha,B)
[C, Large_crit, Perm_crit]=EqualCovtest(X1,X4,alpha,B)
[C, Large_crit, Perm_crit]=EqualCovtest(X1,X5,alpha,B)
[C, Large_crit, Perm_crit]=EqualCovtest(X1,X6,alpha,B)

[C, Large_crit, Perm_crit]=EqualCovtest(X2,X3,alpha,B)
[C, Large_crit, Perm_crit]=EqualCovtest(X2,X4,alpha,B)
[C, Large_crit, Perm_crit]=EqualCovtest(X2,X5,alpha,B)
[C, Large_crit, Perm_crit]=EqualCovtest(X2,X6,alpha,B)

[C, Large_crit, Perm_crit]=EqualCovtest(X3,X4,alpha,B)
%C =
%
%  145.4437
%
%
%Large_crit =
%
%   73.3115
%
%
%Perm_crit =
%
%  132.0675
% Reject Ho

[C, Large_crit, Perm_crit]=EqualCovtest(X3,X5,alpha,B)
%C =
%
%  107.2746
%
%
%Large_crit =
%
%   73.3115
%
%
%Perm_crit =
%
%  117.6178
% Fail to reject Ho

[C, Large_crit, Perm_crit]=EqualCovtest(X3,X6,alpha,B)

[C, Large_crit, Perm_crit]=EqualCovtest(X4,X5,alpha,B)
%C =
%
%  118.3530
%
%
%Large_crit =
%
%   73.3115
%
%
%Perm_crit =
%
%  133.5351
% Fail to reject Ho

[C, Large_crit, Perm_crit]=EqualCovtest(X4,X6,alpha,B)

[C, Large_crit, Perm_crit]=EqualCovtest(X4,X6,alpha,B)

% X1, X2, and X6 causing errors:
%Error using prctile
%Invalid data type. First argument must an array of real values.

%Error in quantile (line 65)
%y = prctile(x,100.*p,varargin{:});

%Error in EqualCovtest (line 62)
%Perm_crit=quantile(Cp,1-alpha);
X1;
size(X1); % 3x10
X2;
size(X2); % 5x10
X6;
size(X6) % 10x10
% Next smallest is X3 which is 18x10. It is the small sample size
% that is causing the errors. In location categorical variable the smallest
% was Rural which was 11X10 and that worked. Can't have size <= 10x10.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Here our sample sizes are n1 = 67, n2 = 29, p = 10, and g = 2 groups total.
% So the only issue is that p is 10, not 5 or less.

% C > Large_crit here. But not using Perm_crit. So before we reject Ho let's 
% check using the 3rd largest group (Maryland). 

X1 = C(clabels_num_state==4,:) % Pennsylvania
size(X1) % 67    10
X2 = C(clabels_num_state==3,:) % Maryland i.e. use the 2 largest states
size(X2) % 18    10

alpha = 0.05
B = 1000
[C, Large_crit, Perm_crit]=EqualCovtest(X1,X2,alpha,B)

%C =
%
%  145.4437
%
%
%Large_crit =
%
%   73.3115
%
%
%Perm_crit =
%
%  132.4595

% Now C > Large_crit here and Perm_crit. So reject Ho. The covariance matrix structures are
% different. We do not have to test any others. We just need one of these
% to fail.

%% Comparing Mean Vectors from Two Populations
% We have a large sample size for both private (82) and public (50). 
% n1 - p = 72 and n2 - p = 40 so still plenty large.
% But as we have already established, sigma1 != sigma2. Also we do not have 
% MVN data. Therefore, we do the following:

X1 = C(clabels_num_type==1,:) % Private
size(X1) % 82    10
X2 = C(clabels_num_type==2,:) % Public
size(X2) % 50    10
alpha = 0.05
B = 1000
d = 0 % d is the delta_0 on page 14 of the lecture notes (and is set = 0 on 
% page 293 of the textbook)
% d = [0 0 0 0 0 0 0 0 0 0]' does the same thing in the code
[T2pool, T2, Pool_crit, Unpool_crit, Large_crit, Perm_crit, Boot_crit]=TwoSampleT2test(X1,X2,d,alpha,B)

% We can reject Ho if T2 > Large_crit
% i.e. (T2)^2 > chi squared (alpha)

% Output:
%T2pool =
%
%  506.6722
%
%
%T2 =
%
%  662.2719
%
%
%Pool_crit =
%
%   20.5184
%
%
%Unpool_crit =
%
%   22.4356
%
%
%Large_crit =
%
%   18.3070
%
%
%Perm_crit =
%
%   21.3263
%
%
%Boot_crit =
%
%   23.2099


% T2 = 662.2719
% Large_crit = 18.3070
% T2 > Large_crit, therefore, at alpha = 0.05 level, we reject the null
% hypothesis and can conlude that the mean vectors of the Public and
% Private institutions are different.

%% Confidence Intervals
% In either case, you want to check whether 0 is included in the intervals 
% so you can see which marginal means led to rejection of Ho.

% Bonferonni:
X1 = C(clabels_num_type==1,:) % Private
size(X1) % 82    10
X2 = C(clabels_num_type==2,:) % Public
size(X2) % 50    10

Xb1=mean(X1)'
S1=cov(X1)

Xb2=mean(X2)'
S2=cov(X2)

% i = 1
estimate1 = Xb1(1) - Xb2(1)
moe1 = 1.96*(0.05/2*10)*sqrt(S1(1,1)/82 + S2(1,1)/50)
estimate1-moe1 % -9.1740
estimate1+moe1 % -6.1470
% Reject Ho

% i = 2
estimate2 = Xb1(2) - Xb2(2);
moe2 = 1.96*(0.05/2*10)*sqrt(S1(2,2)/82 + S2(2,2)/50);
estimate2-moe2 % 33.6915
estimate2+moe2 % 44.9934
% Reject Ho

% i = 3
estimate3 = Xb1(3) - Xb2(3);
moe3 = 1.96*(0.05/2*10)*sqrt(S1(3,3)/82 + S2(3,3)/50);
estimate3-moe3 % 19.6987
estimate3+moe3 % 31.3325
% Reject Ho

% i = 4
estimate4 = Xb1(4) - Xb2(4);
moe4 = 1.96*(0.05/2*10)*sqrt(S1(4,4)/82 + S2(4,4)/50);
estimate4-moe4 % 1.8956e+04
estimate4+moe4 % 1.9954e+04
% Reject Ho

% i = 5
estimate5 = Xb1(5) - Xb2(5);
moe5 = 1.96*(0.05/2*10)*sqrt(S1(5,5)/82 + S2(5,5)/50);
estimate5-moe5 % 1.0369e+04
estimate5+moe5 % 1.1092e+04
% Reject Ho

% i = 6
estimate6 = Xb1(6) - Xb2(6);
moe6 = 1.96*(0.05/2*10)*sqrt(S1(6,6)/82 + S2(6,6)/50);
estimate6-moe6 % -6.6366e+03
estimate6+moe6 % -5.0503e+03
% Reject Ho

% i = 7
estimate7 = Xb1(7) - Xb2(7);
moe7 = 1.96*(0.05/2*10)*sqrt(S1(7,7)/82 + S2(7,7)/50);
estimate7-moe7 % -6.0626e+03
estimate7+moe7 % -4.8733e+03
% Reject Ho

% i = 8
estimate8 = Xb1(8) - Xb2(8);
moe8 = 1.96*(0.05/2*10)*sqrt(S1(8,8)/82 + S2(8,8)/50);
estimate8-moe8 % -0.6996
estimate8+moe8 % 1.0781
% FAIL TO REJECT Ho. Only one so far!

% i = 9
estimate9 = Xb1(9) - Xb2(9);
moe9 = 1.96*(0.05/2*10)*sqrt(S1(9,9)/82 + S2(9,9)/50);
estimate9-moe9 % -5.7125
estimate9+moe9 % -5.2241
% Reject Ho

% i = 10
estimate10 = Xb1(10) - Xb2(10);
moe10 = 1.96*(0.05/2*10)*sqrt(S1(10,10)/82 + S2(10,10)/50);
estimate10-moe10 % 5.0906
estimate10+moe10 % 8.4665
% Reject Ho