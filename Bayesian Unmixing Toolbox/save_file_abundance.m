function save_file_abundance(obj,event)

global geo_method booleen plot_state handles Nmc Nbi data FileName R

global M_est T_MMSE A_est handles  

disp('save_file_abundance')

%%% Error test
if isempty(A_est)
disp('Error while attempting to save')
return
end



[filename, pathname] = uiputfile('*.txt', 'Save unmixing coefficients as');

if (filename == 0) %dans le cas o� l'on d�cide d'annuler la s�lection
    
    return;
    
else

[r c]=size(A_est);

%ouvre un fichier ou le cr��
fid = fopen([pathname filename],'w');
%�crit dans ce fichier, fid est sa reference pour matlab
i=1;
j=1;

while i<=r
    while j<c
        fprintf(fid,'%f\t',A_est(i,j));
        j=j+1;
    end
    fprintf(fid,'%f\n',A_est(i,j));
    i=i+1;
    j=1;
end

fclose(fid);        %on ferme le fichier

%% LOG
filename=filename(1,1:(end-4));
log=[int2str(R) 'sources unmixed ' 'realized with ' int2str(Nmc) ' iterations via ' geo_method ' with ' int2str(Nbi) ' burn-in points.']
%ouvre un fichier ou le cr��
fid = fopen([pathname filename '_log.txt'],'w');
%�crit dans ce fichier, fid est sa reference pour matlab
fprintf(fid,log);
fclose(fid);        %on ferme le fichier


    
disp([filename ' saved'])
end
end