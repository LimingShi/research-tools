function [freq_inx,freq_value]=freq2bins(freq_range,nfft,fs)
% method 1
% freq=[(1:nfft/2+1)-1]/(nfft/2)*fs/2;
% method 2
freq=linspace(0,fs,nfft+1);
freq=freq(1:nfft/2+1);
inx1=find(freq>=min(freq_range),1,'first');
inx2=find(freq<=max(freq_range),1,'last');
freq_inx=inx1:inx2;
freq_value=freq(freq_inx);
end