function PlotMarketData(aData, aYLabel)
% PlotMarketData


myInputErrId = 'PlotMarketData:InputErr';
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

    
