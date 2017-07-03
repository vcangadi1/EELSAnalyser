function prof = profile_extract(I,Rotation_Angle)

RI = imrotate(I,Rotation_Angle);

Pro_X = ones(1,size(RI,1));
for i = 1:size(RI,1),
    Pro_X(i) = sum(squeeze(RI(i,:))>0);
end
Pro_X(Pro_X<=0)=1;

prof = sum(RI,2)./Pro_X';