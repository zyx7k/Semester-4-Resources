function [decodedSignal] = decoder(inPhaseLineDecodedSignal, quadratureLineDecodedSignal)

    N = length(inPhaseLineDecodedSignal);
    decodedSignal = ones(1, 2*N);

    for k = 1 : N
        bit1 = inPhaseLineDecodedSignal(k);
        bit2 = quadratureLineDecodedSignal(k);

        if(bit1 == 1 && bit2 == 1)
            ak = 0;
            bk = 0;
        elseif(bit1== -1 && bit2==1)
            ak = 1;
            bk = 0;
        elseif(bit1== 1 && bit2== -1)
            ak = 0;
            bk = 1;
        else
            ak = 1;
            bk = 1;
        end
        decodedSignal(2*k-1) = ak;
        decodedSignal(2*k) = bk;
    end
         
end

