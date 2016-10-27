function ProcessExcel()
% Process all of the Excel files in a selected directory.
%   WARNING: this file depends upon the signal processing toolbox. It will
%   only run on Windows computers. And it assumes all Excel files have exactly eight
%   sheets.
%   TODO: Make sure not to reprocess files. Ask for correction factor.
c
% Get the data folder:
data_dir = uigetdir;
dirListing = dir(data_dir);
count = 0;
% Load the list of files that have already been processed. If no file exists,
%  we assume that this is the first time through the folder and create a new
%  file to keep track of the data.
try
   load file_listing.mat;     % This file should be a struct with two fields. One lists
   files_found = Files.names; % all of the files names, the other lists the correction factors.
catch                         % If the info files does not already exist, create a new one.
   for i = 1:length(dirListing)  % Find all of the Excel files.
      if ~dirListing(i).isdir
         excel_files = {excel_files,dirListing(i).name};
      end
   end
   corrections = zeros(length(excel_files);
   proccess_check = zeros(length(excel_files);
   %  Ask the user to input all of the correction factors.
   prompt = 'Enter the correction factors';
   dialog_title = 'Correction Factors';
   num_lines = length(corrections);
   default_ans = excel_files;
   x = inputdlg(prompt,dialog_title,num_lines,default_ans);
   corrections = str2num(x{:});
   %  Prompt the user to double-check their correction factors
   
   Files = struct('names','File Names','corrections',[0]);
   save(file_listing.mat,Files);
end
% Process all Excel files in data folder:
for d = 1:length(dirListing) 
    if ~dirListing(d).isdir                                 % Look at files, not subdirectories.
        fileName = fullfile(data_dir,dirListing(d).name);   % use full path because
                                                            % the folder may not be the active path. 
        % Check to make sure we only work with new Excel files
        [~,name,excel_check] = fileparts(fileName);
        if 
        if strcmp(excel_check,'.xlsx')
            count = count + 1;                  % Count the number of Excel files found.
            filesFound = {filesFound,fileName};
            disp('Reading file:');
            disp(fileName);
            for i = 3:8                         % WARNING: this is a huge assumption. 
                                                %If a file does not have 8 sheets this will break!
                times(i-2) = xlsread(fileName,i,'A:A');
                acc_v(i-2) = xlsread(fileName,i,'B:B');
                acc_l(i-2) = xlsread(fileName,i,'C:C');
                acc_s(i-2) = xlsread(fileName,i,'D:D');
            end
            disp('File read succsessfully.')
            
            % Straighten out the vectors:
            time_vec = times(:);  clear times;
            acc_v_vec = acc_v(:); clear acc_v;
            acc_l_vec = acc_l(:); clear acc_l;
            acc_s_vec = acc_s(:); clear acc_s;
            
            % Downsample the data to 1hz from 100hz
            % WARNING: this requires the signal processing toolbox!
            times = downsample(time_vec,100);
            acc_v = downsample(acc_v_vec,100);
            acc_l = downsample(acc_l_vec,100);
            acc_s = downsample(acc_s_vec,100);
            
            % Compute the Associated Posture
            theta = AccelToPosture(acc_v,acc_l,acc_s);
            
            % Save the downsampled data to a .mat file.
            data = [times,acc_v,acc_l,acc_s,theta];
            save_name = strcat(name,'.mat');
            save(save_name,data);
            
            % Bin the resulting data and save it.
            [neutral,moderate,severe,len] = PostureBin(theta);
            save(strcat(name,'_bins.mat'),'neutral','moderate','severe','len');
        end
    end
end

save('processed_files.mat',filesFound);
