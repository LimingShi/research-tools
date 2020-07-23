% This program bring all the figures to the front
% Liming Shi 2017-11-22 in Aalborg, Denmark
% How to use it? --> click-Home-set Path-Add Folder (crate/use a customized folder
% for all of your customized functions)-put this program inside it.
% The ploting sequence is from left to right and low to high. After the
% screen is filled, ploting starts from high to low but still left to right.
function bff()
% undockfig('all');
undockfig('all');
handle_set = findobj('Type', 'Figure');
handle_set_num=[];
for cnt=1:length(handle_set)
    handle_set_num=[handle_set_num handle_set(cnt).Number];
end
handle_set_num=sort(handle_set_num);
row_num=4;
row_cnt_temp=1;

x_len=560/(6/5);
y_len=420/(6/5);
x_position=0;
y_position=0;
% Pix_SS = get(0,'screensize');
Pix_SS=get(0, 'MonitorPositions');
if ~(length(handle_set_num)==2)
    if size(Pix_SS,1)==1
        for count=1:length(handle_set_num)
            set(0, 'CurrentFigure', handle_set_num(count));
            if ~ismac && count ==1
                y_position=50;
            else
                row_num=3;
            end
            if count ==1
                x_len=Pix_SS(3)/row_num;
                y_len=x_len/4*3;
            end
            set(handle_set_num(count),'Position',[x_position,y_position,x_len,y_len]);
            %     format_plot_ls;
            if (x_position+x_len<Pix_SS(3))&& row_cnt_temp<=row_num-1
                x_position=x_position+(x_len-1/15*x_len);
                row_cnt_temp=row_cnt_temp+1;
            else
                row_cnt_temp=1;
                x_position=0;
                if y_position==0 || y_position+2*y_len<Pix_SS(4)
                    y_position=y_position+y_len;
                else
                    y_position=y_position-y_len/2;
                end
            end
            
        end
        for count=1:length(handle_set_num)
            figure(handle_set_num(count));
        end
    else
        Pix_SS=Pix_SS(2,:);
        for count=1:length(handle_set_num)
            set(0, 'CurrentFigure', handle_set_num(count));
            if ~ismac && count ==1
                y_position=50;
            end
            if count==1
                x_position=Pix_SS(1);
                x_position_init=Pix_SS(1);
                y_position=Pix_SS(2);
                y_position_init=Pix_SS(2);
                x_len=Pix_SS(3)/row_num;
                y_len=x_len/4*3;
            end
            set(handle_set_num(count),'Position',[x_position,y_position,x_len,y_len]);
            %     format_plot_ls;
            if (x_position+x_len<Pix_SS(3)+x_position_init)&& row_cnt_temp<=row_num-1
                x_position=x_position+(x_len-1/15*x_len);
                row_cnt_temp=row_cnt_temp+1;
            else
                row_cnt_temp=1;
                x_position=x_position_init;
                if y_position==y_position_init || y_position+1.5*y_len<Pix_SS(4)+y_position_init
                    y_position=y_position+y_len;
                else
                    y_position=y_position-y_len/2;
                end
            end
            
        end
        for count=1:length(handle_set_num)
            figure(handle_set_num(count));
        end
    end
else
      if size(Pix_SS,1)==1
        for count=1:length(handle_set_num)
            set(0, 'CurrentFigure', handle_set_num(count));
            if ~ismac && count ==1
                y_position=50;
            end
            if count==1
                x_position=Pix_SS(1);
                x_position_init=Pix_SS(1);
                y_position=Pix_SS(2);
                y_position_init=Pix_SS(2);
                x_len=Pix_SS(3);
                y_len=Pix_SS(4)/2;
            end
            set(handle_set_num(count),'Position',[x_position,y_position,x_len,y_len]);
            %     format_plot_ls;
            if (x_position+x_len<Pix_SS(3)+x_position_init)&& row_cnt_temp<=row_num-1
                x_position=x_position+(x_len-1/15*x_len);
                row_cnt_temp=row_cnt_temp+1;
            else
                row_cnt_temp=1;
                x_position=x_position_init;
                if y_position==y_position_init || y_position+1.5*y_len<Pix_SS(4)+y_position_init
                    y_position=y_position+y_len;
                else
                    y_position=y_position-y_len/2;
                end
            end
            
        end
        for count=1:length(handle_set_num)
            figure(handle_set_num(count));
        end
    else
        Pix_SS=Pix_SS(2,:);
        for count=1:length(handle_set_num)
            set(0, 'CurrentFigure', handle_set_num(count));
            if ~ismac && count ==1
                y_position=50;
            end
            if count==1
                x_position=Pix_SS(1);
                x_position_init=Pix_SS(1);
                y_position=Pix_SS(2);
                y_position_init=Pix_SS(2);
                x_len=Pix_SS(3);
                y_len=Pix_SS(4)/2;
            end
            set(handle_set_num(count),'Position',[x_position,y_position,x_len,y_len]);
            %     format_plot_ls;
            if (x_position+x_len<Pix_SS(3)+x_position_init)&& row_cnt_temp<=row_num-1
                x_position=x_position+(x_len-1/15*x_len);
                row_cnt_temp=row_cnt_temp+1;
            else
                row_cnt_temp=1;
                x_position=x_position_init;
                if y_position==y_position_init || y_position+1.5*y_len<Pix_SS(4)+y_position_init
                    y_position=y_position+y_len;
                else
                    y_position=y_position-y_len/2;
                end
            end
            
        end
        for count=1:length(handle_set_num)
            figure(handle_set_num(count));
        end
    end
end

% gcf
% figure2(gcf)
return

function undockfig(fig)
% Copyright 2008 The MathWorks, Inc.
% Programmatically undock one or all open figures.
% 
% SYNTAX:
% undockfig
%    Undocks the current figure
%
% undockfig(fig)
%    Undocks figure with handle FIG, and brings it to the front.
%
% undockfig('all')
%    Undocks all open figures
%
% Written by Brett Shoelson, PhD
% brett.shoelson@mathworks.com
% 01/01/08

% Revision 1
% 01/03/08: Providing default behavior when no input argument is provided
% (operates on current figure).

if nargin == 0
    fig = gcf;
end
if ischar(fig) && strcmpi(fig,'all')
    fig = findall(0,'type','figure');
end
for ii = 1:numel(fig)
    set(fig(ii),'windowstyle','modal');
    set(fig(ii),'windowstyle','normal');
end
if numel(fig) == 1
    figure(fig);
end
return

% function FigHandle = figure2(varargin)
% MP = get(0, 'MonitorPositions');
% if size(MP, 1) == 1  % Single monitor
%   FigH = figure(varargin{:});
% else                 % Multiple monitors
%   % Catch creation of figure with disabled visibility: 
%   indexVisible = find(strncmpi(varargin(1:2:end), 'Vis', 3));
%   if isempty(indexVisible)
%     paramVisible = varargin(indexVisible(end) + 1);
%   else
%     paramVisible = get(0, 'DefaultFigureVisible');
%   end
%   %
%   posShift = MP(2, 1:2);
%   FigH     = figure(varargin{:}, 'Visible', 'off');
%   set(FigH, 'Units', 'pixels');
%   pos      = get(FigH, 'Position');
%   set(FigH, 'Position', [pos(1:2) + Shift, pos(3:4)], ...
%             'Visible, paramVisible');
% end
% if nargout ~= 0
%   FigHandle = FigH;
% end
% return

