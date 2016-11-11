function [clusters] = AccelerationCEVA( data )
% Does a clustered exposure variation analysis on acceleration data from a
% Bioharness. Note that ProcessExcel must have been run first to create
% appropriate data.
% See here for a discussion of CEVA: 
% http://bmcmedresmethodol.biomedcentral.com/articles/10.1186/1471-2288-13-54

% Set the cutoffs for neutral, moderate, and severe exposure.
neutral_cutoff = 1;
moderate_cutoff = 2;

% Set the cutoffs for short, medium, and long time duration.
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
type = 0;
count = 0;
previous_type = 0;

for i = 1:length(data)
   % Test to see which category this data point fits in.
   if data(i) < neutral_cutoff
      type = 1;
   else if data(i) < moderate_cutoff
      type = 2;
   else
      type = 3;
   end
   % If the category did not change, increment the current run..
   if type = previous_type
      count = count + 1;
   % If the category changed, add the previous run to a bin
   %  and start a new run.
   else
      if previous_type = 1
         if count <= short
            neutral_short = neutral_short + 1;
         elseif count <= medium
            neutral_medium = neutral_medium + 1;
         else
            neutral_long = neutral_long + 1;
         end
      elseif previous_type = 2
         if count <= short
            moderate_short = moderate_short + 1;
         elseif count <= medium
            moderate_medium = moderate_medium + 1;
         else
            moderate_long = moderate_long + 1;
         end
      elseif previous_type = 3
         if count <= short
            severe_short = severe_short + 1;
         elseif count <= medium
            severe_medium = severe_medium + 1;
         else
            severe_long = severe_long + 1;
         end
      % Reset the counter
       count = 1;
   end
   % Update previous type
   previous_type = type;
end

clusters = [neutral_short, neutral_medium, neutral_long, moderate_short, moderate_medium, moderate_long, severe_short, severe_medium, severe_long];

end
