%% Main.m
% This script provides the workflow for reconstructing muscle activations
% in a cross sectional arm model. It uses a model that extimates the RMS of
% surface EMG with known intensities and locations of activations based on
% the conductional properties of tissue. A minimization algorithm is used to 
% reverse estimate the insities and locations with measured EMG around the arm. 
% The conduction model is based on previous work of Nakajima et al (2014).
% 
% get_Vi_model.m        : Builds subject specific conductional model
% get_Vi_measured.m     :     
% minimization.m        :
clear all; close all; clc;

%% Define input data
% Subject specific parameters

subject.n_elec = 10;                                                        % number of electrodes around the forearm
subject.ied = 20;                                                           % mm interelectrode distance
subject.n_ied = 3;                                                          % number of inter electrode distance(ied) used for activity reconstruction
subject.cf = subject.n_elec*subject.ied;                                    % circumference of arm (for simplicity a multiple of the IED)
subject.r = subject.cf/(2*pi);                                              % radius of arm

% EMG data used for recontruction, See section convert and cut data
 EMGfilename='data\EMG_subject1_extension_ring.mat';                         % Select EMG data (matfile)
 row = 4;                                                                   % Select row number you want to use for recontruction (row 1-4 available in used grid) 
        
%% Create conduction model

[V_i_model,n_fibers,X_j,Y_j] = get_Vi_model_final(subject);            

%%  process EMG data (filtering and bipolar differences)
    
[V_i_measured] = get_Vi_measured_final(EMGfilename,subject,row);   
V_i_measured = V_i_measured(:);                        

%% Simulate activation (only for validation)
% [TEST] = simulate_activation(X_j,Y_j,[.1 .1 .1],[1 2 3]);
% V_i_measured = V_i_model(TEST(:));

%% Minimization

[m,m0,fval] = minimization_final(V_i_model,V_i_measured,n_fibers,subject,X_j,Y_j,.1);

%% Visualize result

[V_i_model,n_fibers,X_j,Y_j] = get_Vi_model_final(subject);            
m=reshape(m,size(X_j));
figure(1)
surf(X_j,Y_j,(m))
colorbar
view(2)
