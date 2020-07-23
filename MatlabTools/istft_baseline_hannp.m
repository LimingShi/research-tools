function [recovered_speech]=istft_baseline_hannp(stft_spec,N_orig_len,N_intermediate_len,frame_size,overlap,nfft,window_type)
% Produce a stft spec, where each column represents frequency and row
% denotes time
if nargin<4
    frame_size=128;
    overlap=3/4;
    nfft=frame_size;
    window_type='hannp';
end
if nargin<5
    overlap=3/4;
    nfft=frame_size;
    window_type='hannp';
end
if nargin<6
    nfft=frame_size;
    window_type='hannp';
end
if nargin<7
    window_type='hannp';
end
frame_size=round(frame_size/2)*2;
frame_shift=round(frame_size*(1-overlap));
% Normalized window
if strcmp(window_type,'hannp')
    win=feval('hann',frame_size,'periodic');
     
else
     win=feval(window_type,frame_size);
end
% win=win/(sqrt(sum(win.^2)/frame_size*(frame_size/frame_shift)));
if overlap==1/2
    win=sqrt(win);
else
    if overlap==3/4
        win=sqrt(win/2);
    end
end
% Calculate the number of frames
N=N_orig_len;
nframes=ceil(N/frame_shift);
final_length=nframes*frame_shift;
% zero_prepadding and postpadding
recovered_speech=zeros(N_intermediate_len,1);
% left bound and right bound calculation
left_bound_temp=(1: frame_shift : N_intermediate_len );
left_bound=left_bound_temp((1: nframes ));
right_bound_temp=frame_size : frame_shift : N_intermediate_len ;
right_bound=right_bound_temp((1: nframes ));

for t = 1:size(stft_spec,2)
    % Frequency domain STFT SYNTHESIS
    symm_part=conj(flipud(stft_spec(2:end-1,t)));
    temp=real( ifft([stft_spec(:,t);symm_part],nfft));
    temp=temp(1:frame_size);
    recovered_speech(left_bound(t):right_bound(t)) = recovered_speech(left_bound(t):right_bound(t)) +win.*temp;
end
recovered_speech=recovered_speech(1:final_length);
recovered_speech=recovered_speech(frame_size-frame_shift+1:end);
return