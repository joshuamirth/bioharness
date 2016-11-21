function [downsampled] = naiveDownsample( data, sample_rate )
% Data should be a Nx1 vector of numbers, sample_rate should be the 
% frequency of the downsampling. For example, sample_rate = 100 will take
% every 100th entry in the data.

% Determine how many entries there are in the data mod sample_rate.
l = length(data);
extra_entries = mod(l,sample_rate);
l = l - extra_entries;
down_l = l/sample_rate;


if extra_entries == 0
    downsampled = zeros(down_l,1);
    for i = 0:down_l - 1
        downsampled(i+1) = data(i*sample_rate + 1);
    end
else
    downsampled = zeros(down_l + 1,1);
    for i = 0:down_l
        downsampled(i+1) = data(i*sample_rate + 1);
    end
end

end