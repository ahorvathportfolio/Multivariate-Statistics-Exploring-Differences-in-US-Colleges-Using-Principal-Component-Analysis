% Multivariate_Analysis_Project_Horvath_Lee
% Step 1: Create Exploratory and Confirmatory Datasets

% For simplicity the raw data (Sample College Data.xlsx) has been
% split into two files, one with the Quantitative variables and the
% other with the Categorical variables. These will be used in the 
% next step.

% Load the Sample College Data Quantitative.xlsx file and name it
% Quant_vars. Make sure to import it as a numeric matrix.
Quant_vars = SampleCollegeDataQuantitative

% Load the Sample College Data Categorical.xlsx file and name it
% Categ_vars. Make sure to import it as a string array.
Categ_vars = SampleCollegeDataCategorical(:,2:4)
% Note that we do not care about the university name which is why we choose
% to only use columns 2 to 4.

% The exploratory set should be no more than about 1/3 the size of full data
% set.
length(Quant_vars) % 197
length(Categ_vars) % 197
197/3 % = 65.6667
% Therefore, let's create a subset consisting of 65 observations. We will
% need to use stratified sample here. The size of each stratum should be 
% roughly proportional to the size of that group from the full data set. 
% In principle, that means that the strata would consist of:

%% Location Type Categorical Variable %%

City = sum(Categ_vars(:,2) == "City") % 71 universities have location designated
% as "City"
Suburb = sum(Categ_vars(:,2) == "Suburb") % 63
Town = sum(Categ_vars(:,2) == "Town") % 46
Rural = sum(Categ_vars(:,2) == "Rural") % 17
City + Suburb + Town + Rural % 197 as expected

(71/197)*65 % 23.4264 City needs 23
(63/197)*65 % 20.7868 Suburb needs 21
(46/197)*65 % 15.1777 Town 15
(17/197)*65 % 5.6091 Rural needs 6

% Stratified Sample of states from the full data set
% Identify the observations included in each group
Cityind=find(Categ_vars(:,2) == "City")
Suburbind=find(Categ_vars(:,2) == "Suburb")
Townind=find(Categ_vars(:,2) == "Town")
Ruralind=find(Categ_vars(:,2) == "Rural")

% Get a list of which observations to include in each data set
Citysamp=randsample(Cityind,23)'
Suburbsamp=randsample(Suburbind,21)'
Townsamp=randsample(Townind,15)'
Ruralsamp=randsample(Ruralind,6)'
expind=[Citysamp Suburbsamp Townsamp Ruralsamp]
confind=setdiff(1:197,expind)

% Extract the observations for the exploratory set and save it 
%in a new file for all future work.
X = Quant_vars(expind,:)
xlabels = Categ_vars(expind,2)'
save Exploratory_Subsetting.mat X xlabels expind

% Extract the observations for the confirmatory set and save it 
% in a new file for all future work.
C = Quant_vars(confind,:)
clabels = Categ_vars(confind,2)'
save Confirmatory_Subsetting.mat C clabels confind

% BOTH OF THESE FILES CAN BE FOUND IN THE DATA FOLDER

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% EVERYTHING BELOW THIS LINE WILL NOT BE USED %%%%%%
%%% These are other subsettings we could have done %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%% State Categorical Variable %%
DE = sum(Categ_vars(:,1) == "Delaware") % 3
DC = sum(Categ_vars(:,1) == "District of Columbia") % 7
MD = sum(Categ_vars(:,1) == "Maryland") % 22
PA = sum(Categ_vars(:,1) == "Pennsylvania") % 107
VA = sum(Categ_vars(:,1) == "Virginia") % 40
WV = sum(Categ_vars(:,1) == "West Virginia") % 18
DE+DC+MD+PA+VA+WV % = 197 as expected

(3/197)*65 % 0.9898 Delaware needs 1
(7/197)*65 % 2.3096 DC needs 3
(22/197)*65 % 7.2589 Maryland needs 7
(107/197)*65 % 35.3046 Pennsylvania needs 35
(40/197)*65 % 13.1980 Virginia need 13
(18/197)*65 % 5.9391 West Virginia needs 6
% All adds up to 65

% Stratified Sample of states from the full data set
% Identify the observations included in each group
DEind=find(Categ_vars(:,1) == "Delaware")
DCind=find(Categ_vars(:,1) == "District of Columbia")
MDind=find(Categ_vars(:,1) == "Maryland")
PAind=find(Categ_vars(:,1) == "Pennsylvania")
VAind=find(Categ_vars(:,1) == "Virginia")
WVind=find(Categ_vars(:,1) == "West Virginia")

% Get a list of which observations to include in each data set
DEsamp=randsample(DEind,1)'
DCsamp=randsample(DCind,3)'
MDsamp=randsample(MDind,7)'
PAsamp=randsample(PAind,35)'
VAsamp=randsample(VAind,13)'
WVsamp=randsample(WVind,6)'
expind=[DEsamp DCsamp MDsamp PAsamp VAsamp WVsamp]
confind=setdiff(1:197,expind)

% Extract the observations for the exploratory set and save it 
%in a new file for all future work.
X = Quant_vars(expind,:)
xlabels = Categ_vars(expind)
save Quant_varsexp_strstate.mat X xlabels expind

% Extract the observations for the confirmatory set and save it 
% in a new file for all future work.
C = Quant_vars(confind,:)
clabels = Categ_vars(confind)
save Quant_varsconf_strstate.mat C clabels confind


%% Private vs Public Categorical Variable %%
Private = sum(Categ_vars(:,3) == "Private") % 121
Public = sum(Categ_vars(:,3) == "Public") % 76
Private + Public % 197 as expected

(121/197)*65 % 39.9239 Private needs 40
(76/197)*65 % 25.0761 Public needs 25

% Stratified Sample of states from the full data set
% Identify the observations included in each group
Privateind=find(Categ_vars(:,3) == "Private")
Publicind=find(Categ_vars(:,3) == "Public")

% Get a list of which observations to include in each data set
Privatesamp=randsample(Privateind,40)'
Publicsamp=randsample(Publicind,25)'
expind2=[Privatesamp Publicsamp]
confind2=setdiff(1:197,expind2)

% Extract the observations for the exploratory set and save it 
%in a new file for all future work.
X2 = Quant_vars(expind2,:)
xlabels2 = Categ_vars(expind2,3)'
save Quant_varsexp_str_publicprivate.mat X2 xlabels2 expind2

% Extract the observations for the confirmatory set and save it 
% in a new file for all future work.
C2 = Quant_vars(confind2,:)
clabels2 = Categ_vars(confind2,3)
save Quant_varsconf_strpublicprivate.mat C2 clabels2 confind2