function write_fromFigure2tikzPlot(filename,float_num,varargin)
% this program can be used for extracting data from a matlab figure;
% varargin should be the labels of different data
% example:
% first, click on the figure which you want to extract line data with
% write_fromFigure2tikzPlot('test.table',6,'time','algorithm_1','algorithm_2')
% Written by Liming Shi in Aalborg University, 2017-03-13;
if nargin==0
    filename='latex_table.table';
    float_num=6;
end
if nargin==1
    float_num=6;
end
labels=varargin;
lh = findall(gca, 'type', 'line');
xc = get(lh, 'xdata');            
yc = get(lh, 'ydata'); 

if isempty(xc) && isempty(yc)
    h1=gcf;
    close(h1);
    disp('Nothing happened because you do not have a figure');
    return;
end
if ~iscell(xc)
    xc_cell{1}=xc;
    yc_cell{1}=yc;
else
    xc_cell=xc;
    yc_cell=yc;
end



if isempty(labels) || isempty(labels{1});
    labels{1}='x_arg';
    for ii=1:length(yc_cell)
        labels{ii+1}=strcat('Algorithm_',num2str(ii));
    end
end

if length(labels)~=length(yc_cell)+1;
   for ii=length(labels):length(yc_cell)
        labels{ii+1}=strcat('Algorithm_',num2str(ii));
    end
end


temp=xc_cell{1};
for ii=2:length(xc_cell)
    if(sum(temp==xc_cell{ii})==length(temp))
    else
        error('x coordinates are different');
    end
end

cell_data{1,1}=labels{1};
x_temp=xc_cell{1};
for ii=1:length(x_temp)
    cell_data{ii+1,1}=x_temp(ii);
end
for ii=1:length(yc_cell)
    cell_data{1,ii+1}=labels{ii+1};
    y_temp=yc_cell{length(yc_cell)-ii+1};
    for jj=1:length(y_temp)
        cell_data{jj+1,ii+1}=y_temp(jj);
    end
end
write_table(filename,float_num,cell_data);
return



function write_table(a,float_num,cell_data)
% Each row should be the result of different algorithms
% Each first column should be the different conditions(using numbers)
% for producing figure table

% Replace the dash('-') to the underscore ('_')
for ii=1:size(cell_data(:))
    temp=cell_data{ii};
    for jj=1:length(temp);
        if strcmp(temp(jj),'-')
            temp(jj)='_';
        end
    end
    cell_data{ii}=temp;
end
% Replace the point('.') to the _ 
for ii=1:size(cell_data,2)
    temp=cell_data{1,ii};
    for jj=1:length(temp);
        if strcmp(temp(jj),'.')
            temp(jj)='_';
        end
    end
    cell_data{1,ii}=temp;
end
fid = fopen(a, 'wt');
for ii=1:size(cell_data,1)
    for jj=1:size(cell_data,2)
        if ii==1 
            fprintf(fid,'%s\t', cell_data{ii,jj});
        else
             fprintf(fid,strcat('%.',num2str(float_num),'f\t'), cell_data{ii,jj});
        end
        if jj==size(cell_data,2)
            fprintf(fid,'\n');
        end
    end
end
fclose(fid);
return
