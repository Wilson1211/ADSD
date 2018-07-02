N = 16;
A = hadamard(N);
[m n] = size(A);
for j = 2:m
    for i = j:m
        sign_chg = find(diff(sign(A(i,:))));
        [m1 n1] = size(sign_chg);
        if n1+1 == j
            break;
        end
    end
    tmp = A(j,:);
    A(n1+1,:) = A(i,:);
    A(i,:) = tmp;
end
A
r1 = [A(1,:) A(1,:) -A(1,:)]
r2 = [-A(6,:) A(6,:) A(6,:)]
r3 = [A(11,:) -A(11,:) -A(11,:)]
r = r1+r2+r3
