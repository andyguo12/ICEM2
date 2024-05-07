function [ cp ] = cpe( G )
% Characteristic parameter processor
cp(1)=mean(G);
cp(2)=std(G);
cp(3)=[cp(2)/cp(1)]*100;
cp(4)=median(G);
end

