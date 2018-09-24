function [data_filt_notch] = emg_filtering_jeanine(data, fs)

% Input : data contains EMG data of a single channels
%         fs is sampling frequency of the measured signal.
% Output: data_filt_notched is the filtered EMG data


[bh, ah] = butter(4, 10/(fs/2), 'high'); %Highpass filter: Butterworth, 4th order, 10Hz
[bl, al] = butter(4, 200/(fs/2), 'low'); %Lowpass filter: Butterworth, 4th order, 200Hz
[bs,as] = butter(4,[45/(fs/2) 55/(fs/2)],'stop'); %Notch filter: 50Hz 

for i = 1:size(data,1) %filter data for each individual channel 1 - 120
    dummy(i,:) = filtfilt(bh,ah, data(i,:)); % highpass filtered data
    data_filt(i,:) = filtfilt(bl,al, dummy(i,:)); % high- and lowpass filtered data. Ready to use
    data_filt_notch(i,:) = filtfilt(bs,as, data_filt(i,:)); % high- and low- and notch filtered data. Use this filtered data when there is too much noise from the powerline interference
end