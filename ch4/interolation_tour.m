addpath('C:\Users\johan\Documents\Documents\School\EDA_course\9781498776066_eda_toolbox_v3\EDA Toolbox V3')

load oronsay;
x=oronsay;


%Set up he vector of indices to the columns spanning 
%the starting and target planes

T1 = [2 3];
T2 = [9 10];
intour(oronsay, T1,T2)

