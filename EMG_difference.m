function [data_diff] = EMG_difference(data,n_ied,n_elec)
% input: data contains EMG data (possibly filtered or normalized) in a NxM matrix with N the number of
%        channels nd M the number of samples. n_ied is the number of multiplies of
%        inter-electrode distances that needs to be used. Or in other words, which
%        electrode needs to be used for bipolar difference. n_elec is the number
%        of electrodes placed circular around the arm. 
% Output: data_diff contains the bipolar differences of the EMG signal in
%        a NxMxL matrix with N the number of electrodes, M the number of samples
%        and L the number of different inter-electrode distances used.

    data(n_elec+1:n_elec*2,:)=data(:,:);
 
    for i=1:n_elec
        data_diff(i,:)=data(i+n_ied,:)-data(i,:);
    end

end





