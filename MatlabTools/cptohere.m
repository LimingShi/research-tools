function cptohere(str_file)
if ismac
%     [~,files]=system(['mdfind -name ' str_file])
    [a,b]=system(['mdfind -name ' str_file]);
else
    if isunix
        system(['locate ' str_file]);
    else
        curdir=pwd;
        eq_inx=(curdir=='\');
        final_inx=find(eq_inx,1);
        pre_str=curdir(1:final_inx-1);
        [~,homedir]=system('echo %HOMEPATH%');

        cd([pre_str homedir(1:end-1)]);
        system(['dir ' str_file ' /s /p']);
        cd(curdir);
    end
end
for ii=1:length(b)
     if isspace(b(ii)) && ~(b(ii)==' ')
         sourcepath=b(1:ii-1);
         break;
     end
     
end


cp(sourcepath,'./');
end


