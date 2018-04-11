%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% Design length n MinMax LP Filter %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameter
n = 19 ; % Filter Length
k = (n-1)/2; % 
m = k+2; % Local Maximum points = 11
edge = 0.4; % bandband edge
fnyq = 2500;
fs =0.2; % Transition starts
fe = 0.25; % Transition ends
ws = 0.6;
wp = 1;
delta = 1/fnyq;
s = [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.37 0.45 0.5];% Location of extremas & Initial Guess
resolution = 10^-3;
axis = 0:resolution:0.5;
axis1 = 0:resolution:edge; % passband time axix
axis2 = edge+resolution:resolution:0.5; % stopband time axis
 
E1 = 10000; %initial error
E0 = 0; 
Hv = zeros(m,1);
 
A = ones(m,m);
Hd = [ones(1,length(axis1)), zeros(1,length(axis2))]; % Ideal LPF
Wf = [wp*ones(1,length(axis1)), ws*ones(1,length(axis2))]; % W(F)
Tf = [ones(1,length(0:resolution:fs)) zeros(1,length(fs+resolution:resolution:fe-resolution)) ones(1,length(fe:resolution:0.5))];
% excluding error in transition band

for o=1:10 % if not converge, break at 10 iteration  
    %%%%  設定 step2 的 square matrix
    for i=1:k
        for j = 1:m
        A(j,i+1) = cos(2*pi*i*s(j));
        end
    end 
    for j=1:m
        if(s(j)<=fs)
            A(j,m) = 1/wp*(-1)^(j-1);
        else
            A(j,m) = 1/ws*(-1)^(j-1);
        end   
        Hv(j,1) = 1;
    end

    %%%%  設定
    for j = 1:m
        if(s(j)<=edge)
        else
            Hv(j,1) = 0;
        end
    end 
    %%%%  這裡的 a 就等於講義的 s
    a = inv(A)*Hv;
    snew = a(1:k+1);
    Rf = zeros(1,length(axis));
    %%%% step 3
    for i = 0:k
        Rf = Rf + a(i+1)*cos(2*pi*i*axis);
    end
    errf = (Rf - Hd).*Wf.*Tf;
    %%%%  step 4
    [c,d] =  findpeaks(abs(errf));
    
    %%%%  step 5
    E0 = max(abs(errf));
    if length(d)-2 <= m
        s = zeros(1,m); %%%% s is the max position
        s(1:length(d)) =  (d-1)*resolution;
        for i=1:m
            if ( s(i)==fs || s(i) == fe)
                s(i) = 0;
            end
        end
        s = sort(s);
    else
        fprintf(1,'Failed\n');
    end        
    % Testing extremas on boundary
    l = m - (length(d)-2);
    i = 1;
    if i<m+1  % see if 0 is extrema
        if abs(errf(1))>abs(errf(2))
            s(i) = 0; i = i+1;
        end
    end
    if i<l+1  % see if 0.5 is extrema
        if  abs(errf(0.5/resolution+1))>abs(errf(0.5/resolution))
            s(i) = 0.5; i = i+1;
        end 
    end
    if i<l+1  % see if fs is extrema
        if  abs(errf(fs/resolution+1))>abs(errf(fs/resolution))
            s(i) = fs; i = i+1;
        end 
    end
    if i<l+1  % see if fe is extrema
        if  abs(errf(fe/resolution+1))>abs(errf(fe/resolution+2))
            s(i) = fe; i = i+1;
        end 
    end
    
    s = sort(s);        
    if E1-E0 > delta || E1-E0 < 0 % continue iteration
       fprintf(1,'---------------------------------------------------------------------------------------------\n');
       fprintf(1,'Iteration= %d, E0=%3.4f, E1-E0=%3.5f\nContinue!\n', o, E0, E1-E0);
       E1 = E0;
    else
       fprintf(1,'---------------------------------------------------------------------------------------------\n');
       fprintf(1,'Iteration= %d, E0=%3.4f, E1-E0=%3.5f\nEnd of iteration\n', o, E0, E1-E0);
        break 
    end
end
h = zeros(1,n);
for i = 1:k+1
    h((k+1)+1-i) = snew(i)/2;
    h((k+1)-1+i) = snew(i)/2;
end
h(k+1) = h(k+1)*2; 
% Plot
figure
plot(axis,Rf,'-b')
title('Frequency Response of R(F)');
xlabel('Frequency(f/fs)')
hold on
plot(axis,Hd,'-r') 
figure
stem(0:n-1,h);
title('impulse response of h[n]');
xlabel('n')
