function [V_im_squared]=get_Vi_measured_final(EMGfilename,subject,rownumber)

% Input : EMGfilename is the name of the mat file containing the EMG data
%         in a NXM matrix with N channels and M samples
%         subject is a struct containing the subject specific parameters.
%         See main.m
%         rownumber is the number of row of electrodes from which the
%         reconstruction is made. 
% Output: V_im_squared is a vector containing the squared RMS values for the bipolar EMG
%         differences measurements.  

%% notate fs used in EMG measurements.
fs=2048;

%% Load the matfile with data
load(EMGfilename)

%% Select the required row and correct for units. (uV-->mV)
rows=fieldnames(EMG); 
EMG_reconstruct=EMG.(rows{rownumber})(1:subject.n_elec,:)/1000;                 

%% filter data with low pass filter (200hz) high pass filter (4 Hz) and a notch filter (50Hz)
for i=1:subject.n_elec
    [EMG_filt(i,:)] = emg_filtering_jeanine(EMG_reconstruct(i,:),fs);
end

%% EMG bipolar differences

for i=1:subject.n_ied
    EMG_diff(:,:,i)=EMG_difference(EMG_filt,i,subject.n_elec);
end

figure
for i = 1:subject.n_elec
    plot(EMG_diff(i,:,1)-i);
    hold all
end
xlabel ('sample')
ylabel (' bipolar diffrences of EMG (mV)')
%% 

V_im_squared=rms((EMG_diff),2).^2;
