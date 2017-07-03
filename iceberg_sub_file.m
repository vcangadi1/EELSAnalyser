
load('EELS.mat');

NMap = stem_map_back_sub(EELS,13,28,28,40,'pow');

save('result.mat');