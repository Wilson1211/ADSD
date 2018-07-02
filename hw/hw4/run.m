A=im2double(imread('baboon2.jpg'));
B=im2double(imread('baboon.jpg'));
%B=im2double(imread('baboon2.jpg'));
%B=im2double(imread('lena.jpg'));
result = SSIM4(A,B,0.1,0.01);
mean(result)