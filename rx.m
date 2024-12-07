function [rxbits conf] = rx(rxsignal,conf,k)
% Digital Receiver
%
%   [txsignal conf] = tx(txbits,conf,k) implements a complete causal
%   receiver in digital domain.
%
%   rxsignal    : received signal
%   conf        : configuration structure
%   k           : frame index
%
%   Outputs
%
%   rxbits      : received bits
%   conf        : configuration structure
%

% % dummy 
% rxbits = zeros(conf.nbits,1);

% Base-band shaping
time = 0:1/conf.f_s:(length(rxsignal)/conf.f_s)-1/conf.f_s;

r_dc = rxsignal .* exp(-1j*2*pi*conf.f_c*time');

r_bb = 2 * lowpass(r_dc,conf);

filtered_rx_signal = matched_filter(r_bb, conf.os_factor, conf.rx_filter_len);
% filtered_rx_signal = filtered_rx_signal(1 + conf.rx_filter_len + conf.f_s : end - conf.rx_filter_len - conf.f_s);

%Frame sync
[data_idx,~,~] = frame_sync(conf.npreamble,filtered_rx_signal, conf.os_factor); % Index of the first data symbol

% downsampling
sampled_signal = filtered_rx_signal(1+conf.rx_filter_len+conf.tx_filter_len + data_idx:conf.os_factor:end-conf.rx_filter_len - conf.tx_filter_len);
%

%Demap 
size(sampled_signal)
demapped_bits = demapper(sampled_signal);
rxbits = demapped_bits(1:conf.nbits);