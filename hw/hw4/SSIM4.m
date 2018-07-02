function result = SSIM(A,B,c1,c2)
	result = mean(((2*mean(A).*mean(B)+c1).*(2*(mean(A.*B)-mean(A).*mean(B))+c2))./((mean(A).*mean(A)+mean(B).*mean(B)+c1).*(var(A,1)+var(B,1)+c2)));
end

