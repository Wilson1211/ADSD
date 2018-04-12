n = 19 ; % Filter Length
k = (n-1)/2; % k = 9
m = k+2; % Local Maximum points = 11
edge = 0.4; % bandband edge
fs = 2500;
ts =0.38; % Transition starts
te = 0.42; % Transition ends
ws = 0.6;
wp = 1;
delta = 1/fs;
s = [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.43 0.45 0.5];  % Location of extremas & Initial Guess
resolution = 10^-3;
axis = 0:resolution:0.5;
axis1 = 0:resolution:edge;  % passband time axix
axis2 = edge+resolution:resolution:0.5;     % stopband time axis
 
E1 = 10000; %initial error
E0 = 0; 
Hv = zeros(m,1);
 
A = ones(m,m);
Hd = [ones(1,length(axis1)), zeros(1,length(axis2))]; % Ideal LPF
Wf = [wp*ones(1,length(axis1)), ws*ones(1,length(axis2))]; % W(F)
Tf = [ones(1,length(0:resolution:ts)) zeros(1,length(ts+resolution:resolution:te-resolution)) ones(1,length(te:resolution:0.5))];
% excluding error in transition band

for o=1:20 % if not converge, break at 10 iteration  
    %%%%  砞﹚ step2  square matrix
%%%%%%%%% own commit
    j=0:k;
    A=cos(2*pi*(s')*j);     % 硂柑 s 碞琌 量竡 Fe
    %%%%  干 W ê︽
    A = [A,zeros(m,1)];
%%%%%%%%%
    for j=1:m
        if(s(j)<=ts)
            A(j,m) = 1/wp*(-1)^(j-1);
        else
            A(j,m) = 1/ws*(-1)^(j-1);
        end   
    end

    %A = [A,[(-1).^[0:k+1]./Wf(s)]']
    
    %%%%  砞﹚
    for j = 1:m
        if(s(j)<=edge)     
            Hv(j,1) = 1;
        else
            Hv(j,1) = 0;
        end
    end 
    %%%%  硂柑 a 碞单量竡 s
    a = inv(A)*Hv;
    snew = a(1:k+1);
    Rf = zeros(1,length(axis));
    %%%% step 3
%%%%%%%% own commit
 
    i=0:k;
    Rf = sum( a(1:k+1).*cos(2*pi*(i)'*axis) );

%%%%%%%%
    errf = (Rf - Hd).*Wf.*Tf;
    %%%%  step 4
    [c,d] =  findpeaks(abs(errf));
    
    %%%%  step 5
    E0 = max(abs(errf));
    if length(d)-2 <= m
        s = zeros(1,m); %%%% s is the max position
        s(1:length(d)) =  (d-1)*resolution;
        for i=1:m
            if ( s(i)==ts || s(i) == te)
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
    if i<l+1  % see if ts is extrema
        if  abs(errf(ts/resolution+1))>abs(errf(ts/resolution))
            s(i) = ts; i = i+1;
        end 
    end
    if i<l+1  % see if te is extrema
        if  abs(errf(te/resolution+1))>abs(errf(te/resolution+2))
            s(i) = te; i = i+1;
        end 
    end
    
    s = sort(s);        
    if E1-E0 > delta || E1-E0 < 0 % continue iteration
       fprintf(1,'---------------------------------------------------------------------------------------------\n');
       fprintf(1,'Iter= %d, E0=%3.4f, E1-E0=%3.5f\n', o, E0, E1-E0);
       E1 = E0;
    else
       fprintf(1,'---------------------------------------------------------------------------------------------\n');
       fprintf(1,'Iter= %d, E0=%3.4f, E1-E0=%3.5f\n', o, E0, E1-E0);
        break 
    end
end

h = zeros(1,n);
%%%%    own commit
h(k+1:-1:1) = snew(1:k+1)/2;
h(k+1:2*k+1) = snew(1:k+1)/2;
%%%%

% Plot
figure
plot(axis,Rf,'-b')
title('Frequency Response  Rf');
xlabel('Frequency(f/fs)')
hold on
plot(axis,Hd,'-r') 
figure
stem(0:n-1,h);
title('impulse response  h[n]');
xlabel('n')
