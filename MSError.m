function E = MSError(SI_Original, SI_Filtered)

if(length(size(SI_Original))==3 && length(size(SI_Filtered))==3)
    if(sum(size(SI_Original) == size(SI_Filtered)) == 3)
        MS_er = sum((SI_Original - SI_Filtered).^2,3)/size(SI_Original,3);
        E = sum(MS_er(:))/length(MS_er(:));
    end
elseif(length(size(SI_Original))==2 && length(size(SI_Filtered))==2)
    if(sum(size(SI_Original) == size(SI_Filtered)) == 2)
        MS_er = sum((SI_Original - SI_Filtered).^2)/length(SI_Original);
        E = sum(MS_er(:))/length(MS_er(:));
    end
end
    