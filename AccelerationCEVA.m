function [clusters] = AccelerationCEVA( data )
% Does a clustered exposure variation analysis on acceleration data from a
% Bioharness. Note that ProcessExcel must have been run first to create
% appropriate data.
% See here for a discussion of CEVA: 
% http://bmcmedresmethodol.biomedcentral.com/articles/10.1186/1471-2288-13-54

% The clusters should be two 