clear all; close all;
 
k=20;
N_fft_resolution = 1024;
N = 2*k+1;
 
% F 
F = zeros(1,N);
F(1:k+1) = 0:0.5/(k+1-1):0.5;
F(k+2:end) = -0.5:-(-0.5-0)/(k):(-0.5-0)/(k);
 
% Hd differentiation filter
Hd = 1i*2*pi*F;
 
%r[n] & h[n]
r1 = ifft(Hd);
h = zeros(1,N);
for m = 1:N
    if m<k+1
        h(m) = r1(m+k+1);
    else
        h(m) = r1(m-k);
    end
end
H = fft(h,N_fft_resolution);

% display
figure;
stem(0:N-1,h,'o');
str = sprintf('Impulse response h[n], k = %d', k);
title(str);
xlabel('n');
ylabel('h[n]');
 
figure;
stem(0:(1-0)/(N+1-1):1,[imag(Hd) imag(Hd(1))]);
str = sprintf('Frequency response Hd[n], k = %d', k);
title(str);
xlabel('F');
ylabel('Imag(Hd)');
 
figure;
stem(0:(1-0)/(N+1-1):1,[abs(Hd) abs(Hd(1))]);
str = sprintf('Frequency response Hd[n], k = %d', k);
title(str);
xlabel('F');
ylabel('Magnitude');

figure;
plot(linspace(0,1-1/N_fft_resolution,N_fft_resolution)-0.5, abs(H));
title('H(f)');
xlabel('Normalized frequency');
ylabel('Magnitude');
