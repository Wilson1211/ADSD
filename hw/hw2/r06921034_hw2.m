k=100;
N = 2*k+1;
F = [0:1/N:1];
H = zeros(size(F));
H((0 < F) & (F < 0.5)) = -1j;
H((0.5 < F) & (F < 1)) = 1j;
%H2 = [];

h = ifft(H);
x = -1:2/N:1;
[a b] = size(h);
h2 = [h((b/2+1):b) h(1:b/2)];
%plot(x,h2,'r');
stem(x,h2);
H2= fft(h2);
%hold on;
%plot(x,h,'b');
figure;
%plot(F,imag(H),'r');
%hold on;
%E = exp(-1j*2*pi*(linspace(-b/2,b/2,b))'*F);
%E = exp(-1j*2*pi*(linspace(0,b,b))'*F);
R = zeros(size(F));
for k1=1:N+1
    for k2 = -b/2:1:(b/2-1)
        R(k1) = R(k1)+h2(k2+b/2+1)*exp(-2j*pi*F(k1)*k2);
    end
end
%size(E)
%R = h2*E;
%plot(F,R1,'b');
plot(F,H2,'r');
%R2 = h*E;
%plot(F,R2,'y');