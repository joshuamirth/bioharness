function [clusters] = AccelerationCEVA( data )
% Does a clustered exposure variation analysis on acceleration data from a
% Bioharness. Note that ProcessExcel must have been run first to create
% appropriate data.
% See here for a discussion of CEVA: 
% http://bmcmedresmethodol.biomedcentral.com/articles/10.1186/1471-2288-13-54

% Set the cutoffs for neutral, moderate, and severe exposure.
neutral_cutoff = 20;
moderate_cutoff = 45;

% TODO: Set the cutoffs for short, medium, and long time duration.
short = 3;
medium = 6;

% Set up bins:
neutral_short = 0; neutral_medium = 0; neutral_long = 0;
moderate_short = 0; moderate_medium = 0; moderate_long = 0;
severe_short = 0; severe_medium = 0; severe_long = 0;

% Process the data.
% NOTE: this is being done in literally the crudest way possible because
% I know nothing about CEVA. Need consultation with stats or someone
% knowledgable to confirm that this is meaningful / reasonable.
% NOTE: This is returning the number of data points in bins of each type.
% It does not return just the number of occurrences of each bin type. I am
% not certain if one is more meaningful than the other.

bin = 0;
count = 1;
previous_bin = 0;
n = length(data);

for i = 1:n
   % Test to see which category this data point fits in.
   if data(i) < neutral_cutoff
      bin = 1;
   elseif data(i) < moderate_cutoff
      bin = 2;
   else
      bin = 3;
   end
   % If the category did not change, increment the current run..
   if bin == previous_bin
      count = count + 1;
   % If the category changed, add the previous run to a bin
   %  and start a new run.
   else
      if previous_bin == 1
         if count <= short
            neutral_short = neutral_short + count;
         elseif count <= medium
            neutral_medium = neutral_medium + count;
         else
            neutral_long = neutral_long + count;
         end
      elseif previous_bin == 2
         if count <= short
            moderate_short = moderate_short + count;
         elseif count <= medium
            moderate_medium = moderate_medium + count;
         else
            moderate_long = moderate_long + count;
         end
      elseif previous_bin == 3
         if count <= short
            severe_short = severe_short + count;
         elseif count <= medium
            severe_medium = severe_medium + count;
         else
            severe_long = severe_long + count;
         end
      end
      % Reset the counter
      count = 1;
   end
   % Update previous bin
   previous_bin = bin
end

% Finish off the last bin:
if previous_bin == 1
    if count <= short
        neutral_short = neutral_short + count;
    elseif count <= medium
        neutral_medium = neutral_medium + count;
    else
        neutral_long = neutral_long + count;
    end
elseif previous_bin == 2
    if count <= short
        moderate_short = moderate_short + count;
    elseif count <= medium
        moderate_medium = moderate_medium + count;
    else
        moderate_long = moderate_long + count;
    end
elseif previous_bin == 3
    if count <= short
        severe_short = severe_short + count;
    elseif count <= medium
        severe_medium = severe_medium + count;
    else
        severe_long = severe_long + count;
    end
end

clusters = [neutral_short, neutral_medium, neutral_long, moderate_short, moderate_medium, moderate_long, severe_short, severe_medium, severe_long];

end
