function [f1, f2, f3] = tryeta(eta)

%% Question 1.1

n = 1000;
sigma_epsilon = 0.2;
sigma_u = 0.2;
t = 40;
m = 12;
beta = 0.99;
lepsilon = randn(t,n) * sqrt(sigma_epsilon);
epsilon = exp(lepsilon);
lu = randn(1,n) * sqrt(sigma_u);
u = exp(lu);
z = exp(-sigma_u/2) * u;

%Table 1: Deterministic Seasonal Component, g(m)
%Degree of seasonality
%Month  Middle High Low
%gm = [ -0.147 -0.293 -0.073;...
%       -0.370 -0.739 -0.185;...
%        0.141 0.282 0.071;...
%        0.131 0.262 0.066;...
%        0.090 0.180 0.045;...
%        0.058 0.116 0.029;...
%        0.036 0.072 0.018;...
%        0.036 0.072 0.018;...
%        0.036 0.072 0.018;...
%        0.002 0.004 0.001;...
%       -0.033 -0.066 -0.017;...
%       -0.082 -0.164 -0.041];

%MODIFICATION
%Table 1: Deterministic Seasonal Component, eg(m)
%Degree of seasonality
%Month Middle High Low
gm = [ 0.863 0.727 0.932;...
       0.691 0.381 0.845;...
       1.151 1.303 1.076;...
       1.140 1.280 1.070;...
       1.094 1.188 1.047;...
       1.060 1.119 1.030;...
       1.037 1.073 1.018;...
       1.037 1.073 1.018;...
       1.037 1.073 1.018;...
       1.002 1.004 1.001;...
       0.968 0.935 0.984;...
       0.921 0.843 0.961];

[wm1, wh1, wl1] = constantseasonal(t,m,n,z,gm,eta,beta,sigma_epsilon,epsilon);

% Removing seasonality
gm2 = ones(12,3);
[wm2, wh2, wl2] = constantseasonal(t,m,n,z,gm2,eta,beta,sigma_epsilon,epsilon);

% Removing nonseasonality
sigma_epsilon_ns = 0;
lepsilon = randn(t,n) * sqrt(sigma_epsilon_ns);
epsilon_ns = exp(lepsilon);
[wm3, wh3, wl3] = constantseasonal(t,m,n,z,gm,eta,beta,sigma_epsilon_ns,epsilon_ns);

% Welfare gain / cost
g_middle_s = (wm2./ wm1).^(1/(1-eta)) - 1;
g_high_s = (wh2./ wh1).^(1/(1-eta)) - 1;
g_low_s = (wl2./ wl1).^(1/(1-eta)) - 1;

g_middle_ns = (wm3./ wm1).^(1/(1-eta)) - 1;
g_high_ns = (wh3./ wh1).^(1/(1-eta)) - 1;
g_low_ns = (wl3./ wl1).^(1/(1-eta)) - 1;

f1=figure(1)
title('Distribution of welfare gain')

subplot(3,1,1)
histogram(g_middle_ns,'Normalization','probability');
title('Middle deterministic component')
subplot(3,1,2)
histogram(g_high_ns,'Normalization','probability');
title('High deterministic component')
subplot(3,1,3)
histogram(g_low_ns,'Normalization','probability');
title('Low deterministic component')


%% Question 1.2

% Table 2: Stochastic Seasonal Component, sigma_v
% Degree of seasonality
% Month Middle High Low
sigma_v = [ 0.085 0.171 0.043;...
            0.068 0.137 0.034;...
            0.290 0.580 0.145;...
            0.283 0.567 0.142;...
            0.273 0.546 0.137;...
            0.273 0.546 0.137;...
            0.239 0.478 0.119;...
            0.205 0.410 0.102;...
            0.188 0.376 0.094;...
            0.188 0.376 0.094;...
            0.171 0.341 0.085;...
            0.137 0.273 0.068];

lv = zeros(m,t,3);

for i = 1:3
    for j = 1:m
        lv(j,:,i) = randn(1,t) * sqrt(sigma_v(j,i));
    end    
end

v = exp(lv);

[wm4, wh4, wl4] = stochasticseasonal(t,m,n,z,gm,eta,beta,sigma_epsilon,epsilon,v,sigma_v);


% Removing nonseasonality

[wm5, wh5, wl5] = stochasticseasonal(t,m,n,z,gm,eta,beta,sigma_epsilon_ns,epsilon_ns,v,sigma_v);

g_middle_s2 = (wm2./wm4).^(1/(1-eta)) - 1;
g_high_s2 = (wh2./ wh4).^(1/(1-eta)) - 1;
g_low_s2 = (wl2./ wl4).^(1/(1-eta)) - 1;

g_middle_ns2 = (wm5./ wm4).^(1/(1-eta)) - 1;
g_high_ns2 = (wh5./ wh4).^(1/(1-eta)) - 1;
g_low_ns2 = (wl5./ wl4).^(1/(1-eta)) - 1;

f2 = figure(2)

histogram(g_low_s2,'Normalization','probability');
hold on 
histogram(g_middle_s2,'Normalization','probability');
histogram(g_high_s2,'Normalization','probability');
legend('Low deterministic component','Middle deterministic component','High deterministic component')
title(['Distribution of welfare gain','\eta = '])
hold off

f3 = figure(3)
title('Distribution of welfare gain')
subplot(3,1,1)
histogram(g_high_ns2,'Normalization','probability');
title('High deterministic component')
subplot(3,1,2)
histogram(g_middle_ns2,'Normalization','probability');
title('Middle deterministic component')
subplot(3,1,3)
histogram(g_low_ns2,'Normalization','probability');
title('Low deterministic component')

end