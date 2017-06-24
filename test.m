clear; close all;


%% Test 'initialize' function
X = rand(300,2);   %Sample data points
[f,H,D] = initialize(X);

%% Test 'anomaly_score' function
threshold = 2;
p = [1.5,1.5;
     0.5 0.7;
     1.4 0.6;
     0.7 1.7];
%  p = rand(1,2);
[score,class] = anomaly_score(f,H,D,p,threshold)

%% Test 'update_density' function
tic
p = [0.6 0.9];
update_density(f,X,D,p);
toc