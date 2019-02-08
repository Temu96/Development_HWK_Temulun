%% HWK2 - Question 2

n = 1000;
eta = 1.5;
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
gm = [ -0.147 -0.293 -0.073;...
       -0.370 -0.739 -0.185;...
        0.141 0.282 0.071;...
        0.131 0.262 0.066;...
        0.090 0.180 0.045;...
        0.058 0.116 0.029;...
        0.036 0.072 0.018;...
        0.036 0.072 0.018;...
        0.036 0.072 0.018;...
        0.002 0.004 0.001;...
       -0.033 -0.066 -0.017;...
       -0.082 -0.164 -0.041];
%No seasonal shock
gm2 = ones(12,3);

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

%------------------------------------------------------------------------
%PART A: positive correlation between seasonal components of labor supply
%and consumption

%Consumption at age t, season m for household i
 c_middle = zeros(t,m,n);
 c_high = zeros(t,m,n);
 c_low = zeros(t,m,n);

 for i = 1:n
     for j = 1:m
         for k = 1:t
            c_middle(k,j,i) = z(1,i)*(exp(-sigma_epsilon/2))*exp(gm(j,1))*epsilon(k,i)*exp(-sigma_v(j,1))*v(j,k,1);
            c_high(k,j,i) = z(1,i)*(exp(-sigma_epsilon/2))*exp(gm(j,2))*epsilon(k,i)*exp(-sigma_v(j,2))*v(j,k,2);
            c_low(k,j,i) = z(1,i)*(exp(-sigma_epsilon/2))*exp(gm(j,3))*epsilon(k,i)*exp(-sigma_v(j,3))*v(j,k,3);
         end
     end
 end


%----------------------------------------------------------------
% Labor supply at age t, season m for household i

% The deterministic seasonal and the stochastic seasonal components
% of labor supply that are highly positively correlated with those of
% consumption.
% Then I assume they are exactly equal. The correlation is 1.
% The nonseasonal stochastic component epsilon for each household i is
% uncorrelated for labor and consumption at the moment. Thus I draw a new
% omega for labor.

 sigma_omega = 0.2;
 lomega = randn(t,n) * sqrt(omega_epsilon);
 omega = exp(lomega);
 
 h_middle = zeros(t,m,n);
 h_high = zeros(t,m,n);
 h_low = zeros(t,m,n);

 for i = 1:n
     for j = 1:m
         for k = 1:t
            h_middle(k,j,i) = z(1,i)*(exp(-sigma_omega/2))*exp(gm(j,1))*omega(k,i)*exp(-sigma_v(j,1))*v(j,k,1);
            h_high(k,j,i) = z(1,i)*(exp(-sigma_omega/2))*exp(gm(j,2))*omega(k,i)*exp(-sigma_v(j,2))*v(j,k,2);
            h_low(k,j,i) = z(1,i)*(exp(-sigma_omega/2))*exp(gm(j,3))*omega(k,i)*exp(-sigma_v(j,3))*v(j,k,3);
         end
     end
 end

 %Rescale labor to make some sense (labor per month cannot be 0.xx, too
 %low)
 h_middle = h_middle*(28.5 * 30/7);
 h_high = h_high*(28.5 * 30/7);
 h_low = h_low*(28.5 * 30/7);
 
 
%-------------------------------------------------------------
% Utility
% Need kappa & nu

 nu = 1;
% According to Bick.et al.(2018)
 phi = 1;
 theta = 0.3224;
 c_bar = 892;
% FOC: h = ((1-theta)/((c/y - c_bar/y)*kappa))^(phi/(1+phi)) = 28.5 * 30/7
% For poor countries c/y - c_bar/y is between 0.1 and 0.5 (Fig. B1 in 
% online appendix), I take 0.3 as an approximate value.
 kappa = ((1-theta)/0.3)/(28.5 * 30/7);
 
 wm6 = lifeutil(m,t,c_middle,h_middle,kappa, nu, beta);
 wh6 = lifeutil(m,t,c_high,h_high,kappa, nu, beta);
 wl6 = lifeutil(m,t,c_low,h_low,kappa, nu, beta);
 
 %-------------------------------------------------------------------
 % Consumption with no seasonal shock
 
 c_middle7 = zeros(t,m,n);
 c_high7 = zeros(t,m,n);
 c_low7 = zeros(t,m,n);

 for i = 1:n
     for j = 1:m
         for k = 1:t
            c_middle7(k,j,i) = z(1,i)*(exp(-sigma_epsilon/2))*(exp(gm2(j,1)))* epsilon(k,i);
            c_high7(k,j,i) = z(1,i)*(exp(-sigma_epsilon/2))*(exp(gm2(j,2)))* epsilon(k,i);
            c_low7(k,j,i) = z(1,i)*(exp(-sigma_epsilon/2))*(exp(gm2(j,3)))* epsilon(k,i);
         end
     end
 end
 
 wm7 = lifeutil(m,t,c_middle7,h_middle,kappa, nu, beta);
 wh7 = lifeutil(m,t,c_high7,h_high,kappa, nu, beta);
 wl7 = lifeutil(m,t,c_low7,h_low,kappa, nu, beta); 

 % Welfare gain / loss
 beta_m = zeros(m,1);
 beta_t = zeros(t,1);
 
  for j = 1: m
    beta_m(j) = beta^(j-1);
 end
 for k = 1:t
     beta_t(k) = beta^(12*k);
 end
 
 g_middle_c_pos = exp((wm7 - wm6)/(sum(beta_m)*sum(beta_t))) - 1;
 g_high_c_pos = exp((wh7 - wh6)/(sum(beta_m)*sum(beta_t))) - 1;
 g_low_c_pos = exp((wl7 - wl6)/(sum(beta_m)*sum(beta_t))) - 1;
 
%-----------------------------------------------------------------
% Labor with no seasonal shock
 h_middle8 = zeros(t,m,n);
 h_high8 = zeros(t,m,n);
 h_low8 = zeros(t,m,n);

 for i = 1:n
     for j = 1:m
         for k = 1:t
            h_middle8(k,j,i) = z(1,i)*(exp(-sigma_omega/2))*exp(gm2(j,1))*omega(k,i);
            h_high8(k,j,i) = z(1,i)*(exp(-sigma_omega/2))*exp(gm2(j,2))*omega(k,i);
            h_low8(k,j,i) = z(1,i)*(exp(-sigma_omega/2))*exp(gm2(j,3))*omega(k,i);
         end
     end
 end

 h_middle8 = h_middle8*(28.5 * 30/7);
 h_high8 = h_high8*(28.5 * 30/7);
 h_low8 = h_low8*(28.5 * 30/7); 
 
 wm8 = lifeutil(m,t,c_middle,h_middle8,kappa, nu, beta);
 wh8 = lifeutil(m,t,c_high,h_high8,kappa, nu, beta);
 wl8 = lifeutil(m,t,c_low,h_low8,kappa, nu, beta);

 % Welfare gain / loss
 g_middle_l_pos = (wm8./wm6).^(1/(1+1/nu)) - 1;
 g_high_l_pos = (wh8./wh6).^(1/(1+1/nu)) - 1;
 g_low_l_pos = (wl8./wl6).^(1/(1+1/nu)) - 1;


%-----------------------------------------------------------------------
%PART B: negative correlation between seasonal components of labor supply
%and consumption 
 
% Labor supply at age t, season m for household i

% The deterministic seasonal and the stochastic seasonal components
% of labor supply that are highly NEGATIVELY correlated with those of
% consumption.
% Then I assume they are exactly OPPOSITE. The correlation is -1.

 h_middle = zeros(t,m,n);
 h_high = zeros(t,m,n);
 h_low = zeros(t,m,n);

 for i = 1:n
     for j = 1:m
         for k = 1:t
            h_middle(k,j,i) = z(1,i)*(exp(-sigma_omega/2))*exp(-gm(j,1))*omega(k,i)*exp(-sigma_v(j,1))*(-v(j,k,1));
            h_high(k,j,i) = z(1,i)*(exp(-sigma_omega/2))*exp(-gm(j,2))*omega(k,i)*exp(-sigma_v(j,2))*(-v(j,k,2));
            h_low(k,j,i) = z(1,i)*(exp(-sigma_omega/2))*exp(-gm(j,3))*omega(k,i)*exp(-sigma_v(j,3))*(-v(j,k,3));
         end
     end
 end
 
 h_middle = h_middle*(28.5 * 30/7);
 h_high = h_high*(28.5 * 30/7);
 h_low = h_low*(28.5 * 30/7);
 
%-------------------------------------------------------------
% Utility

 wm9 = lifeutil(m,t,c_middle,h_middle,kappa, nu, beta);
 wh9 = lifeutil(m,t,c_high,h_high,kappa, nu, beta);
 wl9 = lifeutil(m,t,c_low,h_low,kappa, nu, beta);
 
 %-------------------------------------------------------------------
 % Consumption with no seasonal shock
 
 c_middle10 = zeros(t,m,n);
 c_high10 = zeros(t,m,n);
 c_low10 = zeros(t,m,n);

 for i = 1:n
     for j = 1:m
         for k = 1:t
            c_middle10(k,j,i) = z(1,i)*(exp(-sigma_epsilon/2))*(exp(gm2(j,1)))* epsilon(k,i);
            c_high10(k,j,i) = z(1,i)*(exp(-sigma_epsilon/2))*(exp(gm2(j,2)))* epsilon(k,i);
            c_low10(k,j,i) = z(1,i)*(exp(-sigma_epsilon/2))*(exp(gm2(j,3)))* epsilon(k,i);
         end
     end
 end
 
 wm10 = lifeutil(m,t,c_middle10,h_middle,kappa, nu, beta);
 wh10 = lifeutil(m,t,c_high10,h_high,kappa, nu, beta);
 wl10 = lifeutil(m,t,c_low10,h_low,kappa, nu, beta); 

% Welfare gain / loss

 g_middle_c_neg = exp((wm10 - wm9)/(sum(beta_m)*sum(beta_t))) - 1;
 g_high_c_neg = exp((wh10 - wh9)/(sum(beta_m)*sum(beta_t))) - 1;
 g_low_c_neg = exp((wl10 - wl9)/(sum(beta_m)*sum(beta_t))) - 1;


%-----------------------------------------------------------------
% Labor with no seasonal shock
 h_middle11 = zeros(t,m,n);
 h_high11 = zeros(t,m,n);
 h_low11 = zeros(t,m,n);

 for i = 1:n
     for j = 1:m
         for k = 1:t
            h_middle11(k,j,i) = z(1,i)*(exp(-sigma_omega/2))*exp(gm2(j,1))*omega(k,i);
            h_high11(k,j,i) = z(1,i)*(exp(-sigma_omega/2))*exp(gm2(j,2))*omega(k,i);
            h_low11(k,j,i) = z(1,i)*(exp(-sigma_omega/2))*exp(gm2(j,3))*omega(k,i);
         end
     end
 end

 h_middle11 = h_middle11*(28.5 * 30/7);
 h_high11 = h_high11*(28.5 * 30/7);
 h_low11 = h_low11*(28.5 * 30/7);
 
 wm11 = lifeutil(m,t,c_middle,h_middle11,kappa, nu, beta);
 wh11 = lifeutil(m,t,c_high,h_high11,kappa, nu, beta);
 wl11 = lifeutil(m,t,c_low,h_low11,kappa, nu, beta);

 % Welfare gain / loss
 g_middle_l_neg = (wm11./wm9).^(1/(1+1/nu)) - 1; 
 g_high_l_neg = (wh11./wh9).^(1/(1+1/nu)) - 1; 
 g_low_l_neg = (wl11./wl9).^(1/(1+1/nu)) - 1; 
 
 %% PART C: epsilon and omega are now correlated.
 % 
 % sigma_epsilon = 0.2 and sigma_omega = 0.2
 % Then covariance has to be in between [-0.2,0.2]
 % I assume the covariance to be 0.05
 
 gamma = [0.2 0.05; 0.05 0.2];
 mu = [0,0];
 lr = mvnrnd(mu, gamma,t*n);
 r = exp(lr);
 epsilon = reshape(r(:,1),t,n);
 omega = reshape(r(:,2),t,n);
 
 %Consumption at age t, season m for household i
 c_middle = zeros(t,m,n);
 c_high = zeros(t,m,n);
 c_low = zeros(t,m,n);

 for i = 1:n
     for j = 1:m
         for k = 1:t
            c_middle(k,j,i) = z(1,i)*(exp(-sigma_epsilon/2))*exp(gm(j,1))*epsilon(k,i)*exp(-sigma_v(j,1))*v(j,k,1);
            c_high(k,j,i) = z(1,i)*(exp(-sigma_epsilon/2))*exp(gm(j,2))*epsilon(k,i)*exp(-sigma_v(j,2))*v(j,k,2);
            c_low(k,j,i) = z(1,i)*(exp(-sigma_epsilon/2))*exp(gm(j,3))*epsilon(k,i)*exp(-sigma_v(j,3))*v(j,k,3);
         end
     end
 end


%----------------------------------------------------------------
% REDO PART A: 
% Labor supply at age t, season m for household i
 
 h_middle = zeros(t,m,n);
 h_high = zeros(t,m,n);
 h_low = zeros(t,m,n);

 for i = 1:n
     for j = 1:m
         for k = 1:t
            h_middle(k,j,i) = z(1,i)*(exp(-sigma_omega/2))*exp(gm(j,1))*omega(k,i)*exp(-sigma_v(j,1))*v(j,k,1);
            h_high(k,j,i) = z(1,i)*(exp(-sigma_omega/2))*exp(gm(j,2))*omega(k,i)*exp(-sigma_v(j,2))*v(j,k,2);
            h_low(k,j,i) = z(1,i)*(exp(-sigma_omega/2))*exp(gm(j,3))*omega(k,i)*exp(-sigma_v(j,3))*v(j,k,3);
         end
     end
 end

 %Rescale labor to make some sense (labor per month cannot be 0.xx, too
 %low)
 h_middle = h_middle*(28.5 * 30/7);
 h_high = h_high*(28.5 * 30/7);
 h_low = h_low*(28.5 * 30/7);
 
 
%-------------------------------------------------------------
% Utility
 
 wm12 = lifeutil(m,t,c_middle,h_middle,kappa, nu, beta);
 wh12 = lifeutil(m,t,c_high,h_high,kappa, nu, beta);
 wl12 = lifeutil(m,t,c_low,h_low,kappa, nu, beta);
 
 %-------------------------------------------------------------------
 % Consumption with no seasonal shock
 
 c_middle13 = zeros(t,m,n);
 c_high13 = zeros(t,m,n);
 c_low13 = zeros(t,m,n);

 for i = 1:n
     for j = 1:m
         for k = 1:t
            c_middle13(k,j,i) = z(1,i)*(exp(-sigma_epsilon/2))*(exp(gm2(j,1)))* epsilon(k,i);
            c_high13(k,j,i) = z(1,i)*(exp(-sigma_epsilon/2))*(exp(gm2(j,2)))* epsilon(k,i);
            c_low13(k,j,i) = z(1,i)*(exp(-sigma_epsilon/2))*(exp(gm2(j,3)))* epsilon(k,i);
         end
     end
 end
 
 wm13 = lifeutil(m,t,c_middle13,h_middle,kappa, nu, beta);
 wh13 = lifeutil(m,t,c_high13,h_high,kappa, nu, beta);
 wl13 = lifeutil(m,t,c_low13,h_low,kappa, nu, beta); 

 % Welfare gain / loss
 beta_m = zeros(m,1);
 beta_t = zeros(t,1);
 
  for j = 1: m
    beta_m(j) = beta^(j-1);
 end
 for k = 1:t
     beta_t(k) = beta^(12*k);
 end
 
 g_middle_c_pos2 = exp((wm13 - wm12)/(sum(beta_m)*sum(beta_t))) - 1;
 g_high_c_pos2 = exp((wh13 - wh12)/(sum(beta_m)*sum(beta_t))) - 1;
 g_low_c_pos2 = exp((wl13 - wl12)/(sum(beta_m)*sum(beta_t))) - 1;
 
%-----------------------------------------------------------------
% Labor with no seasonal shock
 h_middle14 = zeros(t,m,n);
 h_high14 = zeros(t,m,n);
 h_low14 = zeros(t,m,n);

 for i = 1:n
     for j = 1:m
         for k = 1:t
            h_middle14(k,j,i) = z(1,i)*(exp(-sigma_omega/2))*exp(gm2(j,1))*omega(k,i);
            h_high14(k,j,i) = z(1,i)*(exp(-sigma_omega/2))*exp(gm2(j,2))*omega(k,i);
            h_low14(k,j,i) = z(1,i)*(exp(-sigma_omega/2))*exp(gm2(j,3))*omega(k,i);
         end
     end
 end

 h_middle14 = h_middle14*(28.5 * 30/7);
 h_high14 = h_high14*(28.5 * 30/7);
 h_low14 = h_low14*(28.5 * 30/7); 
 
 wm14 = lifeutil(m,t,c_middle,h_middle14,kappa, nu, beta);
 wh14 = lifeutil(m,t,c_high,h_high14,kappa, nu, beta);
 wl14 = lifeutil(m,t,c_low,h_low14,kappa, nu, beta);

 % Welfare gain / loss
 g_middle_l_pos2 = (wm14./wm12).^(1/(1+1/nu)) - 1;
 g_high_l_pos2 = (wh14./wh12).^(1/(1+1/nu)) - 1;
 g_low_l_pos2 = (wl14./wl12).^(1/(1+1/nu)) - 1;

 
%-----------------------------------------------------------------------
% REDO PART B: negative correlation between seasonal components of labor supply
% and consumption 
 
% Labor supply at age t, season m for household i

% The deterministic seasonal and the stochastic seasonal components
% of labor supply that are highly NEGATIVELY correlated with those of
% consumption.
% Then I assume they are exactly OPPOSITE. The correlation is -1.

 h_middle = zeros(t,m,n);
 h_high = zeros(t,m,n);
 h_low = zeros(t,m,n);

 for i = 1:n
     for j = 1:m
         for k = 1:t
            h_middle(k,j,i) = z(1,i)*(exp(-sigma_omega/2))*exp(-gm(j,1))*omega(k,i)*exp(-sigma_v(j,1))*(-v(j,k,1));
            h_high(k,j,i) = z(1,i)*(exp(-sigma_omega/2))*exp(-gm(j,2))*omega(k,i)*exp(-sigma_v(j,2))*(-v(j,k,2));
            h_low(k,j,i) = z(1,i)*(exp(-sigma_omega/2))*exp(-gm(j,3))*omega(k,i)*exp(-sigma_v(j,3))*(-v(j,k,3));
         end
     end
 end
 
 h_middle = h_middle*(28.5 * 30/7);
 h_high = h_high*(28.5 * 30/7);
 h_low = h_low*(28.5 * 30/7);
 
%-------------------------------------------------------------
% Utility

 wm15 = lifeutil(m,t,c_middle,h_middle,kappa, nu, beta);
 wh15 = lifeutil(m,t,c_high,h_high,kappa, nu, beta);
 wl15 = lifeutil(m,t,c_low,h_low,kappa, nu, beta);
 
 %-------------------------------------------------------------------
 % Consumption with no seasonal shock
 
 c_middle16 = zeros(t,m,n);
 c_high16 = zeros(t,m,n);
 c_low16 = zeros(t,m,n);

 for i = 1:n
     for j = 1:m
         for k = 1:t
            c_middle16(k,j,i) = z(1,i)*(exp(-sigma_epsilon/2))*(exp(gm2(j,1)))* epsilon(k,i);
            c_high16(k,j,i) = z(1,i)*(exp(-sigma_epsilon/2))*(exp(gm2(j,2)))* epsilon(k,i);
            c_low16(k,j,i) = z(1,i)*(exp(-sigma_epsilon/2))*(exp(gm2(j,3)))* epsilon(k,i);
         end
     end
 end
 
 wm16 = lifeutil(m,t,c_middle16,h_middle,kappa, nu, beta);
 wh16 = lifeutil(m,t,c_high16,h_high,kappa, nu, beta);
 wl16 = lifeutil(m,t,c_low16,h_low,kappa, nu, beta); 

% Welfare gain / loss

 g_middle_c_neg2 = exp((wm16 - wm15)/(sum(beta_m)*sum(beta_t))) - 1;
 g_high_c_neg2 = exp((wh16 - wh15)/(sum(beta_m)*sum(beta_t))) - 1;
 g_low_c_neg2 = exp((wl16 - wl15)/(sum(beta_m)*sum(beta_t))) - 1;


%-----------------------------------------------------------------
% Labor with no seasonal shock
 h_middle17 = zeros(t,m,n);
 h_high17 = zeros(t,m,n);
 h_low17 = zeros(t,m,n);

 for i = 1:n
     for j = 1:m
         for k = 1:t
            h_middle17(k,j,i) = z(1,i)*(exp(-sigma_omega/2))*exp(gm2(j,1))*omega(k,i);
            h_high17(k,j,i) = z(1,i)*(exp(-sigma_omega/2))*exp(gm2(j,2))*omega(k,i);
            h_low17(k,j,i) = z(1,i)*(exp(-sigma_omega/2))*exp(gm2(j,3))*omega(k,i);
         end
     end
 end

 h_middle17 = h_middle17*(28.5 * 30/7);
 h_high17 = h_high17*(28.5 * 30/7);
 h_low17 = h_low17*(28.5 * 30/7);
 
 wm17 = lifeutil(m,t,c_middle,h_middle17,kappa, nu, beta);
 wh17 = lifeutil(m,t,c_high,h_high17,kappa, nu, beta);
 wl17 = lifeutil(m,t,c_low,h_low17,kappa, nu, beta);

 % Welfare gain / loss
 g_middle_l_neg2 = (wm17./wm15).^(1/(1+1/nu)) - 1; 
 g_high_l_neg2 = (wh17./wh15).^(1/(1+1/nu)) - 1; 
 g_low_l_neg2 = (wl17./wl15).^(1/(1+1/nu)) - 1; 
 
 %% SUMMARY
 
figure(5)
histogram(g_low_l_pos,'Normalization','probability');
hold on 
histogram(g_middle_l_pos,'Normalization','probability');
histogram(g_high_l_pos,'Normalization','probability');
legend('Low deterministic component','Middle deterministic component','High deterministic component')
title(['Distribution of welfare gain'])
hold off

figure(6)
histogram(g_low_l_neg,'Normalization','probability');
hold on 
histogram(g_middle_l_neg,'Normalization','probability');
histogram(g_high_l_neg,'Normalization','probability');
legend('Low deterministic component','Middle deterministic component','High deterministic component')
title(['Distribution of welfare gain'])
hold off
 

figure(7)
histogram(g_low_l_pos2,'Normalization','probability');
hold on 
histogram(g_middle_l_pos2,'Normalization','probability');
histogram(g_high_l_pos2,'Normalization','probability');
legend('Low deterministic component','Middle deterministic component','High deterministic component')
title(['Distribution of welfare gain'])
hold off

figure(8)
histogram(g_low_l_neg2,'Normalization','probability');
hold on 
histogram(g_middle_l_neg2,'Normalization','probability');
histogram(g_high_l_neg2,'Normalization','probability');
legend('Low deterministic component','Middle deterministic component','High deterministic component')
title(['Distribution of welfare gain'])
hold off