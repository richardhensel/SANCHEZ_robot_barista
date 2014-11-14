function [r_estimated,a,b] = Circle_func(P_noise)

% The noisy P is used in the following for loop to calculate the derived M
% matrix and w vector
for i = 1:length(P_noise(:,1))
     
    M(i,:) = [-2*P_noise(i,1) -2*P_noise(i,2) -1]; % Calculation of the M matrix
    w(i,1) = - P_noise(i,1)^2 -  P_noise(i,2)^2;  % Calculation of the w vector
    
end

M_plus = inv(M' * M) * M'; % Calculation of the M_plus matrix based on the expression given in the lecture

v = M_plus * w; % Calculation of the v vector based on the expression given in the assignment

r_estimated = sqrt(v(1)^2 + v(2)^2 + v(3)); % Calculation of the r based on the expression given in the assignment

a = v(1); % Definition of the a
b = v(2); % Definition of the b
end
