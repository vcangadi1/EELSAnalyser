function save_file_spectra(obj,event)

global geo_method booleen plot_state handles Nmc Nbi data FileName

global M_est T_MMSE A_est handles   

disp('save_file_spectra')

if isempty(M_est)
    disp('Error while attempting to save')
    return
end
    


[filename, pathname] = uiputfile('*.txt', 'Save spectra file as');
[r c]=size(M_est);

if (filename == 0) %dans le cas où l'on décide d'annuler la sélection
    
    return;

else
%ouvre un fichier ou le créé
fid = fopen([pathname filename],'w');
%écrit dans ce fichier, fid est sa reference pour matlab



i=1;
j=1;

while i<=r
    while j<c
        fprintf(fid,'%f\t',M_est(i,j));
        j=j+1;
    end
    fprintf(fid,'%f\n',M_est(i,j));
    i=i+1;
    j=1;
end

fclose(fid);        %on ferme le fichier


%% LOG
filename=filename(1,1:(end-4));
log=['Realized with ' int2str(Nmc) ' iterations via ' geo_method ' with ' int2str(Nbi) ' burn-in points.']
save([pathname filename '_log.txt'],'log')
%ouvre un fichier ou le créé
fid = fopen([pathname filename '_log.txt'],'w');
%écrit dans ce fichier, fid est sa reference pour matlab
fprintf(fid,log);
fclose(fid);        %on ferme le fichier


    
disp([filename ' saved'])

end
end
