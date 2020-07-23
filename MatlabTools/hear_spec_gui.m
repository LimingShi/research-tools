function hear_spec_gui4(input,fs)
% input:
% x --> audiofile [it works with or without suffix, e.g. fa or fa.wav]
% usage 
% or
%      [x,fs]=audioread('fa.wav');
%      hear_spec_gui(x,fs)
% Written by Liming Shi on 17.03.2020 in Aalborg University
% Contact: ls@create.aau.dk
% 
% x=audioread('fa.wav');
% x=repmat(x,1,4);
% fs=8000;
if nargin==0;
    x=randn(80000,2);
    x=filter(1,[1 -.99],x);
    fs=8000;
end

if nargin==1;
    for ii=1:length(input)
        [x,fs]=audioread(x{ii});
%         x=filter(1,[1 -.99],x);
        fs=8000;
    end
end
if nargin==2;
    x=input;
end
x=x./max(abs(x));

sig_len=size(x,1);

yvec=1:10:fs/2;
xvec=ones(size(yvec));

warning off;
total_figure_len=900;
total_figure_hight=600;
f=figure('Visible','off','Position',[0,0,total_figure_len,total_figure_hight],'Units','normalized','Toolbar','figure','numbertitle','on','Visible','on');%,'PaperSize',[20,13]
% hold on;
bottom_hight=50;
top_hight=50;
figure_hight=(total_figure_hight-bottom_hight)/size(x,2)-top_hight;
figure_len=total_figure_len-100;
y_axis_cor=bottom_hight;
norm_y_len=1/size(x,2);
for ii=1:size(x,2);   
    ha{size(x,2)-ii+1}=axes('Units','Pixels','Position',[70,y_axis_cor,figure_len,figure_hight],'Units','normalized','FontUnits','normalized','Layer','top','visible','on');
    y_axis_cor=y_axis_cor+figure_hight+top_hight;
    plot_spec(x(:,end-ii+1),[],[],fs);
    if ii~=1
        xlabel('');
        set(gca,'xtick',[])
        set(gca,'xticklabel',[])
    end
    hold on;
    
    Line_handle{size(x,2)-ii+1}=plot(0*xvec,yvec,'r','LineWidth',2);
    data=x(:,end-ii+1);
    hhh{size(x,2)-ii+1}=audioplayer(data,fs);
    
    button_len=(figure_len-300)/2;
    ButtonHandle1{size(x,2)-ii+1} = uicontrol('Style', 'PushButton', ...
        'String', 'pause/resume/start','Units','Pixels','Position',[total_figure_len/2-button_len,y_axis_cor-top_hight,button_len,top_hight-20], ...
        'Callback', @pause_player);
    
    
    ButtonHandle2{size(x,2)-ii+1}= uicontrol('Style', 'PushButton', ...
        'String', 'SelectSegment','Units','Pixels','Position',[total_figure_len/2-button_len+button_len,y_axis_cor-top_hight,button_len,top_hight-20], ...
        'Callback', @select_segment);
    
    
%         ButtonHandle1{size(x,2)-ii+1} = uicontrol('Style', 'PushButton', ...
%         'String', 'pause/resume/start','Units','normalized','Position',[.2,ii*norm_y_len,.3,.05], ...
%         'Callback', @pause_player);
%     
%     
%     ButtonHandle2{size(x,2)-ii+1}= uicontrol('Style', 'PushButton', ...
%         'String', 'SelectSegment','Units','normalized','Position',[0.5,0.92,.3,.05], ...
%         'Callback', @select_segment);
    
end
% ha2=axes('Units','Pixels','Position',[70,50,800,150],'Units','normalized','FontUnits','normalized','Layer','top','visible','on'); 
% ha3=axes('Units','Pixels','Position',[70,390,800,75],'Units','normalized','FontUnits','normalized','Layer','top','visible','on'); 
% ha5=axes('Units','Pixels','Position',[70,485,800,75],'Units','normalized','FontUnits','normalized','Layer','top','visible','on'); 
% ha4=axes('Units','Pixels','Position',[70,220,800,150],'Units','normalized','FontUnits','normalized','Layer','top','visible','on'); 

set(f,'ToolBar', 'none');
set(f,'MenuBar', 'none');
set(f,'Name','Listening Spectrogram')  % Assign the GUI a name to appear in the window title.
movegui(f,'center')     % Move the GUI to the center of the screen.
set(f,'Visible','on');	% Make the GUI visible.





hold on;

global statuschange;
global off_set;
statuschange=1;


% figure(f);
% ButtonHandle = uicontrol('Style', 'PushButton', ...
%     'String', 'pause/resume/start','Units','normalized','Position',[.2,.92,.3,.05], ...
%     'Callback', @pause_player);

% ButtonHandle2 = uicontrol('Style', 'PushButton', ...
%     'String', 'SelectSegment','Units','normalized','Position',[0.5,0.92,.3,.05], ...
%     'Callback', @select_segment);
play(hhh{1});
off_set=0;
try
    while hhh{1}.CurrentSample<=hhh{1}.TotalSamples
        if strcmp(hhh{1}.Running,'off')
            break;

        else
            pause(0.01)
            Line_handle{1}.XData=(hhh{1}.CurrentSample+off_set)/fs*xvec;
        end
        
    end
catch
%     disp('hearing experience is over');
end

statuschange=0;


    function pause_player(~,~)
        %         avalue=1;
        %         tocvalue=toc;
        %         pause(hhh{1});
        %% which button
        for iijjkk=1:length(ButtonHandle1)
            if ButtonHandle1{iijjkk}.Value==1;
                break;
            end
            
        end
        button_trigger=iijjkk;
        
        
        if mod(statuschange,2)==1
            pause(hhh{button_trigger});
            statuschange=statuschange+1;
        else
            resume(hhh{button_trigger});
            statuschange=statuschange+1;
            %         hhh{1}.CurrentSample
            try
                while hhh{button_trigger}.CurrentSample<=hhh{button_trigger}.TotalSamples
                   
                    pause(0.01);
                    Line_handle{button_trigger}.XData=(hhh{button_trigger}.CurrentSample+off_set)/fs*xvec;
                    
                    if hhh{button_trigger}.CurrentSample==1 && strcmp(hhh{button_trigger}.Running,'off')
                        break;
                    end
                    %             end
                    
                end
            catch
%                 disp('hearing experience is over');
            end
            
            statuschange=0;
        end
        %         avalue=1;
    end

    function select_segment(~,~)
        for iijjkk=1:length(ButtonHandle2)
            if ButtonHandle2{iijjkk}.Value==1;
                break;
            end
            
        end
        button_trigger=iijjkk;
        
        pause(hhh{iijjkk});
        [x_axis,~]=ginput(2);
        data_inx=floor(x_axis*fs);
        hhh{iijjkk}=audioplayer(x(data_inx(1):data_inx(2),iijjkk),fs);
        off_set=data_inx(1);
        play(hhh{iijjkk});
        try
            while hhh{iijjkk}.CurrentSample<=hhh{iijjkk}.TotalSamples                               
                pause(0.01)
                Line_handle{iijjkk}.XData=(hhh{iijjkk}.CurrentSample+off_set)/fs*xvec;
                
                if hhh{iijjkk}.CurrentSample==1 && strcmp(hhh{iijjkk}.Running,'off')
                    break;
                end
                %             end
                
            end
        catch
%             disp('hearing experience is over');
        end
        
    end

end

function [signal,fs]=plot_spec(sreal,freq_range,Time_range,fs,N)
% plot spectrum of a real signal
% input:
% sreal --> real signal or audiofile [it works with or without suffix, e.g. fa or fa.wav]
audio_format_set={'.wav','.au','.flac','.ogg','.aiff', '.aif','aifc','.mp3','.m4a', '.mp4','.WAV'};
if nargin==1
    if isstr(sreal)
        dot_logic_value=false;
        for cnt=1:length(sreal)
            if strcmp(sreal(cnt),'.');
                dot_logic_value=true;
                index_dot=cnt;
            end
        end
        if dot_logic_value
            last_str=sreal(index_dot:end);
        else
            last_str=[];
        end
        logic_value=false;
        for cnt=1:length(audio_format_set)
            if strcmp(last_str,audio_format_set{cnt})
                logic_value=true;
            end
        end
        if logic_value
            [signal,fs]=audioread(sreal);
        else
            for cnt=1:length(audio_format_set)
                file_name_temp=strcat(sreal,audio_format_set{cnt});
                try
                    [signal,fs]=audioread(file_name_temp);
                catch
                    
                end
            end
        end
        if size(signal,2)>1
            signal=signal(:,1);
        end
        N=round(fs*30/1000/2)*2;
        freq_range=[0,fs/2];
        Time_range=[0,length(signal)/fs];
    else
        signal=sreal;
        fs=8000;
        N=round(fs*30/1000/2)*2;
        freq_range=[0,fs/2];
        Time_range=[0,length(signal)/fs];
    end
else
    if nargin==2
        if isstr(sreal)
            dot_logic_value=false;
            for cnt=1:length(sreal)
                if strcmp(sreal(cnt),'.');
                    dot_logic_value=true;
                    index_dot=cnt;
                end
            end
            if dot_logic_value
                last_str=sreal(index_dot:end);
            else
                last_str=[];
            end
            logic_value=false;
            for cnt=1:length(audio_format_set)
                if strcmp(last_str,audio_format_set{cnt})
                    logic_value=true;
                end
            end
            if logic_value
                [signal,fs]=audioread(sreal);
            else
                for cnt=1:length(audio_format_set)
                    file_name_temp=strcat(sreal,audio_format_set{cnt});
                    try
                        [signal,fs]=audioread(file_name_temp);
                    catch
                        
                    end
                end
            end
            if size(signal,2)>1
                signal=signal(:,1);
            end
            N=round(fs*30/1000/2)*2;
            Time_range=[0,length(signal)/fs];
        else
            signal=sreal;
            fs=8000;
            N=round(fs*30/1000/2)*2;
            Time_range=[0,length(signal)/fs];
        end
    end
    if nargin==3
        if isstr(sreal)
            dot_logic_value=false;
            for cnt=1:length(sreal)
                if strcmp(sreal(cnt),'.');
                    dot_logic_value=true;
                    index_dot=cnt;
                end
            end
            if dot_logic_value
                last_str=sreal(index_dot:end);
            else
                last_str=[];
            end
            logic_value=false;
            for cnt=1:length(audio_format_set)
                if strcmp(last_str,audio_format_set{cnt})
                    logic_value=true;
                end
            end
            if logic_value
                [signal,fs]=audioread(sreal);
            else
                for cnt=1:length(audio_format_set)
                    file_name_temp=strcat(sreal,audio_format_set{cnt});
                    try
                        [signal,fs]=audioread(file_name_temp);
                    catch
                        
                    end
                end
            end
            if size(signal,2)>1
                signal=signal(:,1);
            end
            N=round(fs*30/1000/2)*2;
        else
            signal=sreal;
            fs=8000;
            N=round(fs*30/1000/2)*2;
        end
    end
end
if nargin==4
    if isempty(freq_range)
        freq_range=[0,fs/2];
    end
    if isempty(Time_range)
        Time_range= [0,length(sreal)/fs];
    end
    signal=sreal;
    N=round(fs*30/1000/2)*2;
end
if nargin==5
    
    if isempty(freq_range)
        freq_range=[0,fs/2];
    end
    if isempty(Time_range)
        Time_range= [0,length(sreal)/fs];
    end
    signal=sreal;
end
%     signal=signal+noise_var_cal(mean(signal.^2),inf)*randn(size(signal));
window=hanning(N,'p');
window=sqrt(window);
% NOVERLAP=round(75*N/100);
time_increment=10; %% 10 ms
NOVERLAP=N-round(time_increment*fs/1000/2)*2;
NFFT=4*2^(nextpow2(N));
nSegments = floor((length(signal)+N/2-N)/(N-NOVERLAP))+1;
signal=[zeros(N/2,1);signal(:)];

Y = buffer(signal,N,NOVERLAP,'nodelay') ;
Y=Y(:,1:nSegments);
S=fft(Y.*window,NFFT);
S=S(1:NFFT/2+1,:);

tax=0:time_increment/1000:(nSegments-1)*time_increment/1000;
fax=linspace(0,fs/2,NFFT/2+1)';


% [S,fax,tti] = spectrogram(signal,window,NOVERLAP,NFFT,fs);


S=S/max(max(abs(S)));

HANDLE_F=imagesc(tax,fax,20*log10(abs(S))); axis xy;
axis_vaule=axis;
% axis([axis_vaule(1),axis_vaule(2),axis_vaule(3:end)]);
% colorbar;
z=caxis;
%     caxis([z(2)-100,z(2)]);
caxis([z(2)-100,z(2)]);
xlabel('Time [s]');
ylabel('Frequency [Hz]')
ylim(freq_range);
% xlim(Time_range);
%     colormap(flipud(pink(256)));
%     colormap(flipud(gray(256)));
% format_plot;
end
