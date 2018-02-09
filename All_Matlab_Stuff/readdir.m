function I = readdir(dirpath, search_name)


I = zeros(1024);
srcFiles = dir(strcat(dirpath,'/',search_name));
for i = 1 : length(srcFiles)
filename = strcat(dirpath,'/',srcFiles(i).name);
EELS = readEELSdata(filename);
I = I + EELS.Image;
end