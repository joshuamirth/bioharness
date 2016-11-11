function ProcessExcel()
% Process all of the Excel files in a selected directory.
%   WARNING: this file depends upon the signal processing toolbox. It will
%   only run on Windows computers. It assumes all files in a given folder
%   are .xlsx files. And it assumes all Excel files have exactly eight
%   sheets.
%   TODO: remove the assumption that all files are xlsx.
% Get the data folder:
data_dir = uigetdir;
dirListing = dir(data_dir);
%Get all Excel files in data folder:
for d = 1:length(dirListing) 
    if ~dirListing(d).isdir 
        fileName = fullfile(folder,dirListing(d).name); % use full path because the folder may not be the active path 
        % Check to make sure we only work with Excel files
        [~,name,excel_check] = fileparts(fileName);
        if strcmp(excel_check,'.xlsx')
            disp('Reading file:');
            disp(fileName);
            for i = 3:8         % WARNING: this is a huge assumption. If a file does not have 8 sheets this will break!
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
            data = [times,acc_v,acc_l,acc_s];
            % Save the downsampled data to a .mat file.
            name = strcat(name,'mat');
            save(name,data);
        end
    end
end


%folder = '/Users/joshua/Documents/MATLAB/bioharness'; 



% get the names of all files. dirListing is a struct array. 
%dirListing = dir *.xlsx;
%disp(dirListing);

% loop through the files and open. Note that dir also lists the directories, so you have to check for them. 


% open your file here 