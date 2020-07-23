function [stft_spec,N_orig_len,N_intermediate_len]=stft_baseline_hannp(speech_signal,frame_size,overlap,nfft,window_type)
% Produce a stft spec, where each column represents frequency and row
% denotes time
% This is a standard procedure for stft, very strict recovery
if nargout<3
    error('Must be three output; The last two should be used for the istft. Moreover, stft and istft should always have the same parameters for the last 4 arguments')
end

if nargin<2
    frame_size=128;
    overlap=3/4;
    nfft=frame_size;
    window_type='hannp';
end
if nargin<3
    overlap=3/4;
    nfft=frame_size;
    window_type='hannp';
end
if nargin<4
    nfft=frame_size;
    window_type='hannp';
end
if nargin<5
    window_type='hannp';
end
speech_signal=speech_signal(:);
frame_size=round(frame_size/2)*2;
frame_shift=round(frame_size*(1-overlap));
% Normalized window
if strcmp(window_type,'hannp')
    win=feval('hann',frame_size,'periodic');
    
else
    win=feval(window_type,frame_size,1);
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
N=length(speech_signal);
nframes=ceil(N/frame_shift);
final_length=nframes*frame_shift;
% zero_prepadding and postpadding
speech_signal_padding=[zeros(frame_size-frame_shift,1);speech_signal];
speech_signal_padding=[speech_signal_padding;zeros(final_length-N,1)];
% left bound and right bound calculation
left_bound_temp=(1: frame_shift : length(speech_signal_padding) );
left_bound=left_bound_temp((1: nframes ));
right_bound_temp=frame_size : frame_shift : length(speech_signal_padding) ;
right_bound=right_bound_temp((1: nframes ));

for t = 1:nframes
    % Frequency domain STFT SYNTHESIS
    stft_spec(:,t) = fft( win.*speech_signal_padding(left_bound(t):right_bound(t)),nfft);  
%     z(left_bound(t):right_bound(t)) = z(left_bound(t):right_bound(t)) +  winh'.*real( ifft(Y_t));
end
stft_spec=stft_spec(1:nfft/2+1,:);
N_orig_len=N;
N_intermediate_len=length(speech_signal_padding);
return