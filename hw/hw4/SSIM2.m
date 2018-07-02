function result = SSIM(A,B,c1,c2)
    blkSize = 8;
    [w,h] = size(A);
    nBlkX = fix(w/blkSize);
    nBlkY = fix(h/blkSize);
    A = reshape(A, [blkSize nBlkY w]);
    A = permute(A, [1 3 2]);
    image1 = reshape(A, [(blkSize*blkSize) (nBlkX*nBlkY)]);
    
    [w,h] = size(B);
    nBlkX = fix(w/blkSize);
    nBlkY = fix(h/blkSize);
    B = reshape(B, [blkSize nBlkY w]);
    B = permute(B, [1 3 2]);
    image2 = reshape(B, [(blkSize*blkSize) (nBlkX*nBlkY)]);
    
    assert(isequal(size(image1), size(image2)));
	%image1 = ImageBlock2Col(image1, 8);
	%image2 = ImageBlock2Col(image2, 8);
	uX = mean(image1);
    cc = size(uX)
	uY = mean(image2);
	vX = var(image1, 1);
	vY = var(image2, 1);
	uXuY = uX.*uY;
	covXY = mean(image1.*image2) - uXuY;
	result = mean(((2*uXuY+c1).*(2*covXY+c2)) ./ ((uX.*uX+uY.*uY+c1).*(vX+vY+c2)));
end