function UnitTest(aFunName)

if isa(aFunName, 'function_handle')
    aFunName = func2str(aFunName);
end


str = mlintmex('-calls', which(aFunName));
[~, ~, ~, ~, myDetail] = regexp(str,'([NS])\d* (\d+) (\d+) (\w+)\n');
Logger.debug('test!!!!');
for i = 1 : numel(myDetail)
    if numel(myDetail{i}) == 4 && regexp(myDetail{i}{4}, '^test')
        myFun = str2func([aFunName, '.', myDetail{i}{4}]);
        myFlag = myFun();
         
        myLink = sprintf('<a href="matlab: matlab.desktop.editor.openAndGoToFunction(''%s'', ''%s'');">Go</a>', ...
            which(aFunName), myDetail{i}{4});
        
        if myFlag
            Logger.test(sprintf('%s.%s <%s>', aFunName, myDetail{i}{4}, 'PASS'), myLink);
        else
            Logger.test(sprintf('%s.%s <%s>', aFunName, myDetail{i}{4}, 'FAIL'), myLink);
        end
    end
end

end

