function [ W, e, r ] = lms( v, s, m, alpha, e_limit)
%LMS Implementation of LMS algorythim for 2 input ADALINE
    % v - input noise
    % s - input pure signal
    % m - contanimating noise
    % alpha - learning rate
    % e_limit - epoc limit for acceptable error
    
    i = size(s,2); % length of input vector
    W=[0 0];
    e=zeros(1,i);
    a=zeros(1,i);
    r=zeros(1,i);

    for k = 1:i
        % Handle special case k = 1
        if (k == 1)
            a(k) = W*[v(1) 0]';
        else
            a(k) = W*[v(k) v(k-1)]'; % Reconstructed noise to remove
        end

        e(k) = m(k)-a(k); % Error between actual noise and filter output
        r(k) = s(k) + e(k); % Reconstructed signal

        % Handle special case k = 1
        if (k == 1)
            W = W + 2*alpha*e(k)*[v(k) 0]; % update weight
        else
            W = W + 2*alpha*e(k)*[v(k) v(k-1)]; % update weight
        end
    end
end

