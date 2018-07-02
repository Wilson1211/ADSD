function result = SSIM(A,B,c1,c2)
    %A=im2double(imread('sun_fw.png'));
    %m = [0.299 0.587 0.114;-0.169 -0.331 0.5;0.5 -0.419 -0.081];
    L=255;
    [a b c] = size(A);
    A1 = zeros(a,b,c);
    A1(:,:,1) = 0.299*A(:,:,1)+0.587*A(:,:,2)+0.114*A(:,:,3);    %Y
    A1(:,:,2) = -0.169*A(:,:,1)-0.331*A(:,:,2)+0.5*A(:,:,3);     %Cb
    A1(:,:,3) = 0.5*A(:,:,1)-0.419*A(:,:,2)-0.081*A(:,:,3);      %Cr
    [a b c] = size(B);
    B1 = zeros(a,b,c);
    B1(:,:,1) = 0.299*B(:,:,1)+0.587*B(:,:,2)+0.114*B(:,:,3);    %Y
    B1(:,:,2) = -0.169*B(:,:,1)-0.331*B(:,:,2)+0.5*B(:,:,3);     %Cb
    B1(:,:,3) = 0.5*B(:,:,1)-0.419*B(:,:,2)-0.081*B(:,:,3);      %Cr
    mean_a = 0.5*A1(:,:,1)+0.25*A1(:,:,2)+0.25*A1(:,:,3);
    mean_a  = mean(mean(mean_a));
    mean_b = 0.5*B1(:,:,1)+0.25*B1(:,:,2)+0.25*B1(:,:,3);
    mean_b = mean(mean(mean_b));
    sigma_a_squr = sum(sum((A1(:,:,1)+A1(:,:,2)+A1(:,:,3)-3*mean_a).^2)) / a*b*c;
    
    sigma_b_squr = sum(sum((B1(:,:,1)+B1(:,:,2)+B1(:,:,3)-3*mean_b).^2)) / a*b*c;
    
    %cov_a_b
    cov_a_b = sum(sum( (A1(:,:,1)-mean_a).*(B1(:,:,1)-mean_b)+(A1(:,:,2)-mean_a).*(B1(:,:,2)-mean_b)+(A1(:,:,3)-mean_a).*(B1(:,:,3)-mean_b) ))/(a*b*c)
    %result = (2*mean_a*mean_b+c1*L)*(2*cov_a_b+c2*L)/( (sigma_a_squr+sigma_b_squr+c1*L)*(sigma_a_squr+sigma_b_squr+c2*L) );
    r1 = (2*mean(mean(mean_a))*mean(mean(mean_b))+c1*L)*(2*cov_a_b+c2*L);
    r2 = (sigma_a_squr+sigma_b_squr+c1*L)*(sigma_a_squr+sigma_b_squr+c2*L)
    result = r1/r2;
end