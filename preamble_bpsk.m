function [preamble] = preamble_bpsk(length)
% preamble_generate() 
% input : length: a scaler value, desired length of preamble.
% output: preamble: preamble bits
preamble = zeros(length, 1);
LFSR_bits=ones(8,1);
% TODO:
for i = 1: length

    new=mod(sum(LFSR_bits([4 5 6 8])),2);
    preamble(i)=LFSR_bits(end);
    LFSR_bits(2:end) = LFSR_bits(1:end-1);
    LFSR_bits(1) = new ;
    
end
preamble=preamble*2-1;
end


