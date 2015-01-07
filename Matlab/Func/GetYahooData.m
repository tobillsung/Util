function theData = GetYahooData(aTickers, aSDate, aEDate)

if ischar(aTickers)
    aTickers = {aTickers};
end

if numel(aTickers) ~= numel(unique(aTickers))
    warning('Tickers are not unique');
    aTickers = unique(aTickers);
end

myURL = 'http://ichart.finance.yahoo.com/table.csv?s=';

[mySYear, mySMon, mySDay] = datevec(aSDate);
[myEYear, myEMon, myEDay] = datevec(aEDate);

myURL2 = ['&a=' num2str(mySMon-1, '%02u') ...
    '&b=' num2str(mySDay) ...
    '&c=' num2str(mySYear) ...
    '&d=' num2str(myEMon-1, '%02u') ...
    '&e=' num2str(myEDay) ...
    '&f=' num2str(myEYear) '&g=d&ignore=.csv'];

%% 2. Load Data in a loop
for i = 1 : numel(aTickers)
    try
        myDataStr = urlread([myURL, aTickers{i}, myURL2]);
    catch
        % Special behaviour if str cannot be found: this means that no
        % price info was returned.  Error and say which asset is invalid:
        error('getYahooDailyData:invalidTicker', ...
            ['No data returned for ticker ''' aTickers{i} ...
            '''. Is this a valid symbol? Do you have an internet connection?'])
    end
    myText = textscan(myDataStr, '%s%f%f%f%f%f%f', 'HeaderLines', 1, 'Delimiter', ',');
    
    myDataset = dataset(myText{1}, myText{2}, myText{3}, myText{4}, myText{5}, myText{6}, myText{7}, ...
        'VarNames', {'Date', 'Open', 'High', 'Low', 'Close', 'Volume', 'AdjClose'});
    
    myDataset.Date = datestr(myDataset.Date, 'mm/dd/yyyy');
    myDataset.MatDate = datenum(myDataset.Date, 'mm/dd/yyyy');
    myDataset = flipud(myDataset);
    theData.(genvarname(aTickers{i})) = myDataset;    
end

end

