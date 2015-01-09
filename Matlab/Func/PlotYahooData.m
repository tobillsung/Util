function PlotYahooData(aData, aYLabel)
% PlotYahooData
% 
% Inputs
%   aData: Data from GetYahooData
%   aYLabel: Cell array containing {'Open', 'High', 'Low', 'Close', 'Volume', 'AdjClose'}
%            Default: AdjClose
% Outputs
%   Plot
%
% Example
%   myData = GetYahooData('SPY', '10/01/2014', '1/7/2015');
%   PlotYahooData(myData);

%% aData
myInputErrId = 'PlotYahooData:InputErr';
myInputErrMsg = 'aData should be the output from GetYahooData';
try
    myTickers = fieldnames(aData);
catch
    error(myInputErrId, myInputErrMsg);
end
    
for i = 1 : numel(myTickers)
    assert(isequal(get(aData.(myTickers{i}), 'VarNames'), ...
        {'Date', 'Open', 'High', 'Low', 'Close', 'Volume', 'AdjClose', 'MatDate'}), ...
        [myInputErrId, myInputErrMsg]);
end

%% aYLabel
myAvailYLabel = {'Open', 'High', 'Low', 'Close', 'Volume', 'AdjClose'};
if ~ exist('aYLabel', 'var')
    aYLabel = 'AdjClose';
end
if ~ iscell(aYLabel)
    aYLabel = {aYLabel};
end

%% Plot for each ticker
for i = 1 : numel(myTickers)
    for j = 1 : numel(aYLabel)
        assert(any(strcmpi(aYLabel{j}, myAvailYLabel)), ... 
            sprintf('%s is not recognizable as ylabel', aYLabel{j}));
        
        myDataPerTicker = aData.(myTickers{i});
        [myDataSize, ~] = size(myDataPerTicker);
        figure;
        stairs((1 : myDataSize), myDataPerTicker.(aYLabel{j}));
        
        %datetick('x', 'keeplimits'); % I don't like them adding non-business days
        
        % Only showing max 6 ticks
        myXTickSize = max(floor(myDataSize / 6), 1);
        % Tick has the first and the last
        myXTick = (1 : myXTickSize : myDataSize);
        if myDataSize - myXTick(end) >= 3
            myXTick = [myXTick, myDataSize]; %#okay<AGROW>
        end
        set(gca, 'xtick', myXTick, 'xticklabel', ...
            cellfun(@(x) x(1 : 5), cellstr(myDataPerTicker(myXTick, 'Date')), 'uniformoutput', false));
      
        ylabel(aYLabel{j});
        set(gca, 'ygrid', 'on', 'yminorgrid', 'on');
    end
end
    
    

    
