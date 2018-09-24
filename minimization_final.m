function [m,m0,fval]=minimization_final(V_i_model,V_i_measured,n_fibers,subject,X_j,Y_j,a)
% input:    V_i_model, which is a function that estimates the RMS's with an
%           unknown muscle fiber acitvation m_j.  
%           V_i_measured, which contains the measured RMS's of a subject. 
%           n_fibers, the number of fibers j simulated in V_i_model.
%           [X_j,Y_j] are coordinates of the simulated muscle fibers j.
%           a defines the peakheight for the convolution function that
%           contributes to the minimization.
% output:   m represents the reconstructed activation. m0 is the used
%           (random) initial condition for the minimization. fval is the value of the
%           error function at the found m and represents the quality of estimation.

%% Setup functions for optimisation
  g =[0 0 0 0;
      0 a a 0;
      0 a a 0;
      0 0 0 0];                                                             %Function to convolute with (What is influence of shape in the solution?)

f = @(m_j) 0.999*sum((V_i_model(m_j)-V_i_measured().^2)) + 0.001 * 1/(sum(sum(conv2(g,reshape(m_j,size(X_j)))))); %Objective function that has to be minimized

%% setup m0 initial condition
m0 = rand(n_fibers,1);                                                      % Initial guess is random between 0 and 1
crit = sqrt(X_j.^2+Y_j.^2);                                                 % Distance from center arm
crit=crit(:);
m0(crit>=(subject.r*0.90))=0;                                               % initial guess that all units closest to the skin are 0 (fat layer)

%% Optimization

options = optimoptions('fmincon','Display','iter','Algorithm','sqp','maxFunctionEvaluations',10000000,'MaxIterations',10000,'UseParallel',1);%'CheckGradients',true);
A = []; 
b = [];
Aeq = double(diag(crit>=(subject.r*0.90)));                                 %Constrain that all units closest to the skin are 0 (fat layer)
beq = zeros(n_fibers,1);                                                    %Constrain that all units closest to the skin are 0 (fat layer)
lb = 0*ones(n_fibers,1);
ub = [];                                     

[m,fval]=fmincon(f,m0,A,b,Aeq,beq,lb,ub,[],options);
end