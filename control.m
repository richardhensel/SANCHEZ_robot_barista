clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Order = Lab3RandOrder(5, 0, 1);
OrderL=load('Order.mat');
Order=OrderL.Order;
order=[];
NrBig=0;
NrMed=0;
%convert order cell array into 1 x (6n+1) cell array
%where n is the number of cups in order
for i=1:size(Order,1)
    line=Order{i};
    if i~=1 
        if line(1)==2
           NrBig=NrBig+1;
        else
           NrMed=NrMed+1;
        end
    end
    order=[order,line];
end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%INITIALISATION%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Ready...');
%caddy describes the locations of each point in the loaded condiment caddy.
%an entry of 1 indicates that the location is full. once the item is
%removed, the value is changed to 0. 
caddy = ones(3, 12);

%caddyLoc contains the joint angles required of the robot arm to reach each
%location in the caddy. 
caddyLoc = ones(3, 12, 3);

caddyLoc(:, :, 1) = [ 894 897 874 874 842 843 819 817 786 786 762 761;
                      901 907 879 881 842 846 816 819 783 779 756 748;
                      918 890 848 817 771 738 918 890 848 817 771 738 ];
    
caddyLoc(:, :, 2) = [ 298 295 280 296 279 274 276 276 274 276 292 285;
                      291 281 280 271 270 260 271 261 275 261 284 272;
                      276 260 258 248 255 271 276 260 258 248 255 271 ];

caddyLoc(:, :, 3) = [ 235 216 214 209 210 185 206 189 210 190 225 204;
                      190 168 179 149 162 133 156 134 163 136 175 153;
                      141 110 104  93 100 114 141 110 104  93 100 114 ];



%TIME

%run the initial computer vision. 
%this determines the location of all cups(stored in cupsCombined structure array),
%the angular velocity at which it rotates, 
%the system time at which the cups were in the location
%the centre of rotation of the turntable.
%these outputs are expressed in units of cm, rad/s, and seconds. 
[cupsCombined,omega,rpm,t_global,x_centerMetric,y_centerMetric]=Model_parameters(NrBig,NrMed);

%combine the coordinates into a single array
center=[x_centerMetric, y_centerMetric];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%move arm to initial position near caddy
initialiseDynamixels();
blocking();

%make 'roar' sound
[y,Fs] = audioread('Tyrannosaurus Rex.mp3');
tts('roar')
sound(y,Fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%JOURNEY PLANNER%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cups=cupsCombined;
%order cups array to include information on the order required for each cup
cups = orderedcups(order, cups);
%number of drinks in order
Ndrinks = order(1);

%count number of urgent cups
urgentcups= 0;
for i = 1:Ndrinks
    if cups(i).IsUrgent;
        urgentcups = urgentcups+1;
    end
end
%enter loop to execute the order. done=1 when all cups are full. 
count=0;
done=0;
numDon=0;
while done == 0
    
    if count~=0
        %computer vision is used to update the locations of the cups after
        %each completed cup order. this ensures any de-synchronisation is
        %corrected between the model and the turntable. 
        clear cupsCombinedNew
        %a new time is taken at the point of the new location being taken. 
        [cupsCombinedNew,t_global]=ModelUpdate(NrBig,NrMed,cupsCombined,x_centerMetric,y_centerMetric, t_global);
        for j=1:size(cups,2)
            %the order data is reattached to the new cup location array. 
            cupsCombinedNew(j).CupSize = cups(j).CupSize;
            cupsCombinedNew(j).Ncoffee = cups(j).Ncoffee;
            cupsCombinedNew(j).Ntea = cups(j).Ntea;
            cupsCombinedNew(j).Nsugar = cups(j).Nsugar;
            cupsCombinedNew(j).IsUrgent = cups(j).IsUrgent;
            cupsCombinedNew(j).IsDone = cups(j).IsDone;
        end
        cups=cupsCombinedNew;
    end
    
    orderdone=0;
    i=1;
    %orderdone is 1 when all condiments are added to a single cup, this allows
    %the next cup to begin filling
    while orderdone==0
        %a cup is filled next either if the cup is urgent and not yet
        %filled, or if the cup is not urgent and all urgent cups are
        %already full. 
        if cups(i).IsUrgent && cups(i).IsDone == 0 ...
            ||cups(i).IsDone == 0 && numDon >= urgentcups;
            
            %Each condiment type is added sequentially until the cup
            %contains the prescribed order
            for q = 1:cups(i).Ncoffee;
                %picks up a condiment from the caddy, the caddy variable is
                %updated to indicate that the location is now empty. 
                caddy=getItem(caddyLoc, caddy, 1);
                %ensures that no new commands are sent until the robot arm
                %is finished its previous movement. 
                blocking();
                %Uses information stored within the model to predict the
                %location of the desired cup as it turns and to drop the
                %condiment at the appropriate time to land inside the cup. 
                release_order(cups,i,omega,  t_global, center, 1);
            end
            for q = 1:cups(i).Ntea
                caddy=getItem(caddyLoc, caddy, 3);
                blocking();
                release_order(cups,i,omega, t_global, center, 2);
            end
            for q = 1:cups(i).Nsugar
                caddy=getItem(caddyLoc, caddy, 2);
                blocking();
                release_order(cups,i,omega, t_global, center, 3);
            end
            %once each cup is filled, the information is updated to indicate
            %that it is done, and the number of cups done is also updated
            cups(i).IsDone = 1;
            numDon=numDon+1;
                
               if i==Ndrinks || cups(i).IsDone == 1
                   %allows breakout from filling each cup
                   orderdone=1;
                   tts('cup done')
               end
        end
       i=i+1; 
    end
    
	if numDon==Ndrinks
        %allows breakout from filling all cups. 
        done=1;
    end
    count=count+1;
end
%text to voice to indicate order is ready. 
tts('order ready')

