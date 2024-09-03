% Multivariate_Analysis_Project_Exploratory_Analysis_PCA
% Step 2: Exploratory Analysis

% Load in Exploratory_Subsetting Data File, Sample College Data Quantitative.xlsx,
% and Sample College Data Categorical.xlsx
Quant_vars = SampleCollegeDataQuantitative
Categ_vars = SampleCollegeDataCategorical

% Because "sample principal components are, in general, not invariant with
% respect to changes in scale" we decide to standardize the sample
% principal components and use the correlation matrix (R) in the PCA
% calculations. 
% As a note to check: "eigenvalues very close to zero should not be
% routinely ignored. The eigenvectors associated with these latter
% eigenvalues may point out linear dependecies in the data set that can
% cause interpretive and computational problems in a subsequent analysis"
% pg 453

%Explanatory Analysis
%expind:(fix expind; otherwise we will get different correlation matrix)
%51 106 138 172 155 27 88 1 4 107 165 193 5 170 26 171 24 159 169 129
%67 85 176 124 109 53 136 188 68 30 175 36 150 103 37 43 140 96 180 20
%15 14 163 117 81 145 73 139 59 157 156 87 121 21 183 45 2 38 83 10
%13 125 112 178 122

R=corrcoef(X)
%    1.0000   -0.6204   -0.5933   -0.3848   -0.5410   -0.2811   -0.2029   -0.4965    0.3716   -0.5095
%   -0.6204    1.0000    0.9646    0.5218    0.5777    0.4040    0.3306    0.8210   -0.3722    0.8011
%   -0.5933    0.9646    1.0000    0.5130    0.5516    0.4168    0.3371    0.8198   -0.3146    0.7716
%   -0.3848    0.5218    0.5130    1.0000    0.9049   -0.1315   -0.2295    0.4606   -0.6963    0.6336
%   -0.5410    0.5777    0.5516    0.9049    1.0000   -0.0198   -0.1244    0.4393   -0.7272    0.6335
%   -0.2811    0.4040    0.4168   -0.1315   -0.0198    1.0000    0.9805    0.4388    0.2277    0.2319
%   -0.2029    0.3306    0.3371   -0.2295   -0.1244    0.9805    1.0000    0.3949    0.3487    0.1663
%   -0.4965    0.8210    0.8198    0.4606    0.4393    0.4388    0.3949    1.0000   -0.2900    0.8019
%    0.3716   -0.3722   -0.3146   -0.6963   -0.7272    0.2277    0.3487   -0.2900    1.0000   -0.3987
%   -0.5095    0.8011    0.7716    0.6336    0.6335    0.2319    0.1663    0.8019   -0.3987    1.0000

% Ting's calculations:
%r_2,3 = 0.9646, r_2,8 = 0.8210, r_2,10 = 0.8011
%r_3,8 = 0.8198, r_3,10 = 0.7716
%r_4,5 = 0.9049
%r_5,9 = -0.7272
%r_6,7 = 0.9805 
%r_8,10 = 0.8019 

figure(1)
scatter(X(:,2),X(:,3),"filled") 
title('Correlation between x2 (SAT reading) and x3(SAT math) in the explanatory set')
xlabel('x2')
ylabel('x3')
% This makes sense. These SAT scores should be closely related.
X

scatter(X(:,2),X(:,8),"filled")
title('Correlation between x2 and x8 in the explanatory set')
xlabel('x2')
ylabel('x8')
% x2/x3 and x8 are SAT score (reading/math) and retention rate. Now that is
% interesting!!!!

figure(3)
scatter(X(:,2),X(:,10),"filled")
title('Correlation between x2 and x10 in the explanatory set')
xlabel('x2')
ylabel('x10')
% x2/x3 and x10 are the SAT scores and Graduation rate. Again, not
% completely obvious to me that these are related but correlation says they
% are.

figure(6)
scatter(X(:,4),X(:,5),"filled")
title('Correlation between x4 and x5 in the explanatory set')
xlabel('x4')
ylabel('x5')
% tuition vs financial aid. Higher tuition ==> Higher aid. Makes sense.

figure(7)
scatter(X(:,5),X(:,9),"filled")
title('Correlation between x5 and x9 in the explanatory set')
xlabel('x5')
ylabel('x9')
% FInancial aid and teacher-student ratio. Okay this one came out of no
% where. How on earth are these related!? Fascinating! Very strong negative
% correlation. So the higher the financial aid the lower the student
% teacher ratio. I mean that can make sense.
% This also pops up for r_4,9. So perhaps the higher the tuition, probably 
% the smaller the amount of students and thus giving a smaller ratio.
% Yet, there was not a strong relation between cost to attend and
% enrollment. Weird. Think about this one further later on.

% .
% .
% .
% We can go on, but let's just leave it at this.

%% PCA %%
%Standard data(using correlation matrix)
%R=corrcoef(X)
[coeffr,scorer,varyr]=pca(zscore(X))
%coeff is the same as P, but some columns may be multiplied by -1 
%score is almost equivalent to Y. score=(X-mean(X))*P; 
%vary is a vector of the variances of the PCs

% Get the cumulative proportions of variation explained
cumsum(varyr)/sum(varyr) %0.8603 with the first 3 principal components.

% Make scree plot
figure(1)
plot(varyr) %the elbow happens when we choose to have threee variables
% Maybe take 3,4, or 5.
title('Scree Plot','FontSize',16)
xlabel('\it i', 'FontSize',15')
ylabel('$\hat{\lambda_{i}}$','Interpreter','latex', "Rotation",0,'FontSize',15)


% "The number of components is taken to be the point at which the remaining
% eigenvalues are relatively small and all about the same size" pg 445.
% An elbow occurs in the plot at about i = 3. The eigenvalues after lambda
% hat 2 are all relatively small and about the same size. It therefore
% appears that three principal components effectively summarize the total
% sample variance.

% I need this xlabels_num.
for i=1:length(xlabels)
    if xlabels(i)== "City"
        xlabels_num(i)=1
    elseif xlabels(i)== "Suburb"
        xlabels_num(i)=2
    elseif xlabels(i)== "Town"
        xlabels_num(i)=3
    else xlabels(i)== "Rural"
        xlabels_num(i)=4
    end
end

figure(2)
scatter3(scorer(:,1),scorer(:,2),scorer(:,3), 40, xlabels_num, 'filled')
title('Principal Components in 3D')
xlabel('Y1')
ylabel('Y2')
zlabel('Y3')
axis equal
cb = colorbar(); 
title(cb, 'Classes')
% 1 = City, 2 = Suburb, 3 = Town, 4 = Rural

% Corresponding Scatterplots:
figure(3)
scatter(scorer(:,1),scorer(:,3),40, xlabels_num,"filled") 
title('Principal Components in 2D')
xlabel('Y1')
ylabel('Y3')
axis equal
cb = colorbar(); 
title(cb, 'Location')
grid on
% The means seem to be the same, but the dark blue variance is much larger
% than the others.

figure(4)
scatter(scorer(:,2),scorer(:,3),40, xlabels_num,"filled") 
title('Principal Components in 2D')
xlabel('Y2')
ylabel('Y3')
axis equal
cb = colorbar(); 
title(cb, 'Location')
grid on

figure(5)
scatter(scorer(:,1),scorer(:,2),40, xlabels_num,"filled") 
title('Principal Components in 2D')
xlabel('Y1')
ylabel('Y2')
axis equal
cb = colorbar(); 
title(cb, 'Location')
grid on

%% Other Categorical Variable Analysis %%
%Load in Quant_vars (numeric matrix) and Categ_vars (string array) excel files
Quant_vars = SampleCollegeDataQuantitative
Categ_vars = SampleCollegeDataCategorical

expind %51 is the first for me, 122 is the last for me. This is different 
% from Ting's file
X
% row 1:
% 85         570         580       25522       16769        4076        2925          79          14          64
% row 65:
% 85         540         560       13048        6204         801         800          74          13          36
Quant_vars(51,:)
Quant_vars(122,:)
% They both match. Good!

X_state = Quant_vars(expind,:)
xlabels_state = Categ_vars(expind,2)'

for i=1:length(xlabels_state)
    if xlabels_state(i)== "Delaware"
        xlabels_num_state(i)=1
    elseif xlabels_state(i)== "District of Columbia"
        xlabels_num_state(i)=2
    elseif xlabels_state(i)== "Maryland"
        xlabels_num_state(i)=3
    elseif xlabels_state(i)== "Pennsylvania"
        xlabels_num_state(i)=4
    elseif xlabels_state(i)== "Virginia"
        xlabels_num_state(i)=5
    elseif xlabels_state(i)== "West Virginia"
        xlabels_num_state(i)=6
    end
end

DEind=find(Categ_vars(:,1) == "Delaware") % This is not working, but if I do
xlabels_num_state % then 1 does not pop up. Delaware is not in the sample.
% What a shame.


figure(6)
scatter3(scorer(:,1),scorer(:,2),scorer(:,3), 40, xlabels_num_state, 'filled')
title('Principal Components in 3D')
xlabel('Y1')
ylabel('Y2')
zlabel('Y3')
axis equal
cb = colorbar(); 
title(cb, 'Classes')

% There may be some difference in the variance, but probably only slight if
% at all. Because a few variables are so spread out, there may be a
% difference in the means as well.

figure(7)
scatter(scorer(:,1),scorer(:,2),40, xlabels_num_state,"filled") 
title('Principal Components in 2D')
xlabel('Y1')
ylabel('Y2')
axis equal
cb = colorbar(); 
title(cb, 'State')
grid on

figure(8)
scatter(scorer(:,1),scorer(:,3),40, xlabels_num_state,"filled") 
title('Principal Components in 2D')
xlabel('Y1')
ylabel('Y3')
axis equal
cb = colorbar(); 
title(cb, 'State')
grid on

figure(9)
scatter(scorer(:,2),scorer(:,3),40, xlabels_num_state,"filled") 
title('Principal Components in 2D')
xlabel('Y2')
ylabel('Y3')
axis equal
cb = colorbar(); 
title(cb, 'State')
grid on



X_type = Quant_vars(expind,:)
xlabels_type = Categ_vars(expind,4)'

for i=1:length(xlabels_type)
    if xlabels_type(i)== "Private"
        xlabels_num_type(i)=1
    elseif xlabels_type(i)== "Public"
        xlabels_num_type(i)=2
    end
end

figure(10)
scatter3(scorer(:,1),scorer(:,2),scorer(:,3), 40, xlabels_num_type, 'filled')
title('Principal Components in 3D')
xlabel('Y1')
ylabel('Y2')
zlabel('Y3')
axis equal
cb = colorbar(); 
title(cb, 'Classes')

% There is a big difference in variation and means!!! Definitely test
% here!!!

figure(11)
scatter(scorer(:,1),scorer(:,2),40, xlabels_num_type,"filled") 
title('Principal Components in 2D')
xlabel('Y1')
ylabel('Y2')
axis equal
cb = colorbar(); 
title(cb, 'Private/Public')
grid on

figure(12)
scatter(scorer(:,1),scorer(:,3),40, xlabels_num_type,"filled") 
title('Principal Components in 2D')
xlabel('Y1')
ylabel('Y3')
axis equal
cb = colorbar(); 
title(cb, 'Private/Public')
grid on

figure(13)
scatter(scorer(:,2),scorer(:,3),40, xlabels_num_type,"filled") 
title('Principal Components in 2D')
xlabel('Y2')
ylabel('Y3')
axis equal
cb = colorbar(); 
title(cb, 'Private/Public')
grid on