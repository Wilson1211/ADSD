%ADSD hw1
N=19;
k=(N-1)/2;
m=k+2;%local maximum point
fs=2500;%sampling freq
ts=950/fs;%transition band start
te=1050/fs;%transition band end
delta = 0.0001;
s= [ 0, 0.04, 0.08, 0.12, 0.16, 0.20, 0.24, 0.28, 0.32, 0.44, 0.5];
edge=1000/fs;

E1=10000;
E2=0;
resolution=10^-3;

axis=0:resolution:(2000/fs);
axis1=0:resolution:edge;
axis2=edge+resolution:resolution:(2000/fs);

Hd=[ones(1,length(axis1)), zeros(1,length(axis2))];     % ideal filter
W=[ones(1,length(axis1)*1,ones(1,length(axis2))*0.6];   % weighting
Tf = [ones(1,length(0:resolution:ts)) zeros(1,length(ts+resolution:resolution:te-resolution)) ones(1,length(te:resolution:0.5))];


