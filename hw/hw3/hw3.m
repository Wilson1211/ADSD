%A=im2double(imread('fireworks.jpg'));
A=im2double(imread('sun_fw.png'));
m = [0.299 0.587 0.114;-0.169 -0.331 0.5;0.5 -0.419 -0.081];
[a b c] = size(A);
B = zeros(a,b,c);
B(:,:,1) = 0.299*A(:,:,1)+0.587*A(:,:,2)+0.114*A(:,:,3);    %Y
B(:,:,2) = -0.169*A(:,:,1)-0.331*A(:,:,2)+0.5*A(:,:,3);     %Cb
B(:,:,3) = 0.5*A(:,:,1)-0.419*A(:,:,2)-0.081*A(:,:,3);      %Cr
imshow(double(A));
figure();
imshow(double(B));
% B1 B2 B3 is the 4:2:2
B1 = B(:,:,1);
B2 = B(1:2:end,:,2);
B3 = B(1:2:end,:,3);
% C1 C2 C3 is the 4:2:0
C1 = B1;
C2 = B2(:,1:2:end);
C3 = B3(:,1:2:end);
% recovery
PR1 = C1;
if mod(b,2)==1
    PR2 = zeros(size(C2,1),size(C2,2)*2-1);
    PR2(:,1:2:end) = C2;
    tmp = (C2(:,1:end-1)+C2(:,2:end))/2;
    PR2(:,2:2:end) = tmp;
else
    PR2 = zeros(size(C2,1),size(C2,2)*2);
    PR2(:,1:2:end) = C2;
    tmp = (C2(:,1:end)+[C2(:,2:end) C2(:,end)])/2;
    PR2(:,2:2:end) = tmp;
end
if mod(b,2)==1
    PR3 = zeros(size(C3,1),size(C3,2)*2-1);
    PR3(:,1:2:end) = C3;
    tmp = (C3(:,1:end-1)+C3(:,2:end))/2;
    PR3(:,2:2:end) = tmp;
else
    PR3 = zeros(size(C3,1),size(C3,2)*2);
    PR3(:,1:2:end) = C3;
    tmp = (C3(:,1:end)+[C3(:,2:end) C3(:,end)])/2;
    PR3(:,2:2:end) = tmp;
end

R1 = PR1;
if mod(b,2)==1
    R2 = zeros(size(PR2,1)*2-1,size(PR2,2));
    R2(1:2:end,:) = PR2;
    tmp = (PR2(1:end-1,:)+PR2(2:end,:))/2;
    R2(2:2:end,:) = tmp;
else
    R2 = zeros(size(PR2,1)*2,size(PR2,2));
    R2(1:2:end,:) = PR2;
    tmp = (PR2(1:end,:)+[PR2(2:end,:);PR2(end,:)])/2;
    R2(2:2:end,:) = tmp;
end
if mod(b,2)==1
    R3 = zeros(size(PR3,1)*2-1,size(PR3,2));
    R3(1:2:end,:) = PR3;
    tmp = (PR3(1:end-1,:)+PR3(2:end,:))/2;
    R3(2:2:end,:) = tmp;
else
    R3 = zeros(size(PR3,1)*2,size(PR3,2));
    R3(1:2:end,:) = PR3;
    tmp = (PR3(1:end,:)+[PR3(2:end,:);PR3(end,:)])/2;
    R3(2:2:end,:) = tmp;
end
R = zeros(size(A));
%R(:,:,1) = R1;
%R(:,:,2) = R2;
%R(:,:,3) = R3;
%figure;
%imshow(double(R));

%    1.0000   -0.0009    1.4017
%    1.0000   -0.3437   -0.7142
%    1.0000    1.7722    0.0010
R(:,:,1) = R1-0.0009*R2+1.4017*R3;
R(:,:,2) = R1-0.3437*R2-0.7142*R3;
R(:,:,3) = R1+1.7722*R2+0.001*R3;
figure;
imshow(double(R));

