function result = SSIM(A,B,c1,c2)
	%image1 = ImageBlock2Col(image1, 8);
	%image2 = ImageBlock2Col(image2, 8);
	uX = mean(A);
    cc = size(uX)
	uY = mean(B);
	vX = var(A,1);
	vY = var(B,1);
	uXuY = uX.*uY;
	covXY = mean(A.*B) - uXuY;
	result = mean(((2*uXuY+c1).*(2*covXY+c2)) ./ ((mean(A).*mean(A)+mean(B).*mean(B)+c1).*(vX+vY+c2)));
end