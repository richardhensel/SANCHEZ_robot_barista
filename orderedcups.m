%[order]=[N-drinks,[drink<1toN>]]
%[drink]=[CupSize,Ncoffee,Ntea,Nsugar,Nespresso,IsUrgent]
%the order has been rearranged to take the form below, as an example
%order = [4, [2,1,0,0,0,1], [2,1,0,0,0,0], [1,1,0,0,0,1], [1,1,0,0,0,0]]

%the purpose of this function is to let us know that our orders
%are going to the right cups
%large orders to large cups, medium orders to medium cups

function ordcup = orderedcups(order, cups);
numcups=size(cups,2);
Ndrinks = order(1);
ordcup = cups;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%STORE ORDERS IN EASY ACCESS MATRIX%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for j = 1:Ndrinks
    rand_order(j,:) = order(2+(j-1)*6:7+(j-1)*6)
	%extracts all the orders
	%this matrix is ordered as given, which may as well be random
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%RELATE ORDERS TO APPROPRIATE SIZED CUPS%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:numcups %using numcumps here
    %determine cup size from radius. 
    if cups(i).Radius == 4.5; 
        cup_size = 2; %cup is big
    else
        cup_size = 1; %cup is small
    end
    %attach order information to appropriate cups based on their size
    for j = 1:Ndrinks %using Ndrinks here
	%rand_order(j, 1) entry is the CupSize of the cup
        if  rand_order(j, 1) == cup_size;
		%if we are looking at an order that fits the cupsize
		%of the cup we are looking at
            %ordcup(i).CupNum = i;
            ordcup(i).CupSize = rand_order(j,1);
            ordcup(i).Ncoffee = rand_order(j,2);
            ordcup(i).Ntea = rand_order(j,3);
            ordcup(i).Nsugar = rand_order(j,4);
            ordcup(i).IsUrgent = rand_order(j,6);
            ordcup(i).IsDone = 0;
            rand_order(j, 1) = rand_order(j, 1) +2;
            cup_size = 10;
        %increase size of cup once used so it is not used again in this function
        %change cup_size to something large to ensure only the first appropriate cup
		%will be written to ordcup, i.e. avoiding over writing an order
        end
    end
    end
end


