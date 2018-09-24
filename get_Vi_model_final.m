function [V_i_squared, n_fibers, X_j,Y_j]=get_Vi_model_final(subject)
% input:    subject parameters containting circumference of the arm (cf) in mm, 
%           inter electrode distance (ied) in  mm, the number of electrodes 
%           around the arm, the radius of the arm (r) assuming that it is a 
%           cirkel and the number of ied's used for the model.  
% output:   V_i_squared is a NxM matrix with N the number electrodes around the arm
%           and M the number of electrode distances used to build the
%           model. It is an anonymous function for the mean square action potential 
%           depending on mean action current in every simulated muscle
%           fiber j.%           
%           n_fibers is the number of simulated muscle fibers inside the arm.
%           [X_j,Y_j] are coordinates of the muscle fibers j.
% The conduction parameters V0 and PEA are based on the work of Nakajima et
% al. (2014)
%% Locate all muscle fibers j in a grid

dx = 3;                                                                     % mm density of muscle fiber mesh

v = 0:dx:subject.r+dx;
X = [-1 * fliplr(v(2:end)) v];                                              % Create a mesh that is symmetric in (0,0)
Y = [-1 * fliplr(v(2:end)) v];
[X_j,Y_j] = meshgrid(X,Y);

figure,                                                                     % visualize muscle fibers  
hold on, 
plot(X_j,Y_j,'r.')                                                    
axis([-40 40 -40 40])
xlabel('x position (mm)')
ylabel('y position (mm)')

%% Locate the boundaries of the arm cross-section

t = 0:1/24*pi:2*pi;
plot(subject.r*sin(t),subject.r*cos(t))                                     % Visualize cirkel representing the arm

%% locate electrodes (X_elec and Y_elec)

elec_vector = (0:(2*pi)/subject.n_elec:2*pi-(2*pi)/subject.n_elec);         % Make sure order of electrodes is aligned with the placement protocol of the electrodes! 
elec_vector = elec_vector * -1 - 0.5*pi;                                    % Requires the position of the first electrode of a row (-0.5*pi), and notion of clockwise or counterclockwise placement (*-1).       
X_elec = subject.r*sin(elec_vector);                                        % X coordinates of electrodes
Y_elec = subject.r*cos(elec_vector);                                        % Y Coordinates of electrodes

plot(X_elec,Y_elec,'o','MarkerSize',15,...                                  % Visualize electrodes
    'MarkerEdgeColor','w',...
    'MarkerFaceColor','k')
title('cross section of the arm with electrodes and muscle fibers')

%% load PEA and V0 functions

load('PEA_fun.mat');                                                        % Digitizations of PEA and V0 from Nakajima et al (2014). 
load('V0_fun.mat');

%% Calculate Lij,distance between muscle fibers j and electrodes j for all electrodes and all electrode distances.

ied_vector = (1:subject.n_ied)*subject.ied;                                  % Create vector with different ied's

for j=1:subject.n_ied
    for i = 1:subject.n_elec
        L = sqrt((X_j - X_elec(i)).^2+(Y_j - Y_elec(i)).^2).^(2*PEA_fun(ied_vector(j)));  
        L_i(i,:) = L(:)';
    end
    L_ij(subject.n_elec*j - (subject.n_elec - 1):subject.n_elec*j,:) = V0_fun(ied_vector(j))^2*L_i;     % Distance L_ij for all electrodes and all electrode distances.
end

%% Calculate V_i_squared

V_i_squared = @(m_j) L_ij*m_j.^2;
n_fibers = length(X_j)^2;


    