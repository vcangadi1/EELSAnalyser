function [X,y] = generate_gauss_classes(m,S,P,N)

[l,c] = size(m);
x=[];
y=[];
for j=1:c,
    %Generating the [p(j)*N] vectors from each distribution
    t=mvnrnd(m(:,j),S(:,:,j),fix(P(j)*N));
    % The total number of points may be slightly less than N
    % due to the fix operator
    X=[X t];
    y=[y ones(1,fix(P(j)*N))*j];
end