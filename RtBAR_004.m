
%this goes in top of script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[y,Fs] = audioread('Tyrannosaurus Rex.mp3');
disp('Ready...');

caddy = ones(3, 12);
caddyLoc = ones(3, 12, 3);

caddyLoc(:, :, 1) = [ 864 867 870 874 842 843 819 817 786 782 762 761;
                      901 907 879 881 842 846 816 819 783 779 756 748;
                      918 890 848 817 771 738 918 890 848 817 771 738 ];
    
caddyLoc(:, :, 2) = [ 312 309 294 302 290 288 290 289 289 289 302 295;
                      305 296 294 285 283 274 285 275 285 275 290 280;
                      280 268 268 249 265 271 280 268 268 249 265 271 ];

caddyLoc(:, :, 3) = [ 245 222 217 209 214 189 210 189 210 193 227 201;
                      195 169 179 152 167 140 163 138 167 138 179 148;
                      131 112 106  90 103 114 131 112 106  90 103 114 ];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%order = Lab3RandOrder(5, 0, 1);
%drinks = zeros(order{1}(), 6);

%for count = 1:size(drinks(:, 1))
%    drinks(count, :) = order{count + 1}(:);
%end

%drinks = sortrows(drinks, -6);

loadlibrary('dynamixel', 'dynamixel.h');
libfunctions('dynamixel');
DEFAULT_PORTNUM = 7;  %COM3
DEFAULT_BAUDNUM = 1;  %1Mbps

res = calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);
    
    if res == 1

        disp('Connected...');
        initialiseDynamixels();
        
        pause();

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %get vision here
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        for count = 1:size(drinks(:, 1))%size(order(2:end, 1))
            
            %cupSize, Ncoffee, Ntea, Nsugar, espresso, urgernt
            
            %coffee
            while drinks(count, 2) > 0
                
                [caddy, location] = getCondiment(caddy, 1);
                
                %MOVE AND PICK UP CONDIMENT HERE
                moveToCondimentReady(1, location);
                graspCondiment(caddyLoc, 1, location);                
                withdrawCondiment(caddyLoc, 3, location);                                
                drinks(count, 2) = drinks(count, 2) - 1;

                %drop();
            
            end
            
            %tea
            while drinks(count, 3) > 0
                
                [caddy, location] = getCondiment(caddy, 2);
                
                %MOVE AND PICK UP CONDIMENT HERE
                moveToCondimentReady(2, location);
                graspCondiment(caddyLoc, 2, location);
                withdrawCondiment(caddyLoc, 3, location);                
                drinks(count, 3) = drinks(count, 3) - 1;

                %drop();
                
            end
            
            %sugar
            while drinks(count, 4) > 0
                
                [caddy, location] = getCondiment(caddy, 3);
                
                %MOVE AND PICK UP CONDIMENT HERE
                moveToCondimentReady(3, location);
                graspCondiment(caddyLoc, 3, location);
                withdrawCondiment(caddyLoc, 3, location);                                
                drinks(count, 4) = drinks(count, 4) - 1;

                %drop();
                
            end
%            caddy(:,:)
        end

%GO TO OVER CADDY
%          q = rotAngles(0, 300, 200);
%          
%          q(1) = convertAngle(q(1));
%          q(2) = convertAngle(q(2));
%          q(3) = convertAngle(q(3));
%          
%          setGoal(2, q(2));
%          pause(0.25);
%          setGoal(3, q(3));
%          pause(0.25);
%          setGoal(1, q(1));
%          pause(0.25);

%Go TO HOVER SUGAR
         setGoal(1, 900);
         pause(0.25);
         setGoal(2, 295);
         pause(0.25);
         setGoal(3, 206);
         pause(0.25);

         setGoal(4, 1775);%jaws open

%Go TO GRAB SUGAR 
        setSpeed(2, 25);
        setSpeed(3, 25);
        setGoal(1, 883);
        pause(0.25);
        
        setGoal(4, 1990);%jaws closed
        
%withdraw sugar from caddy
         setGoal(2, 225);
         pause(0.05);
         setGoal(3, 160);
         pause(0.1);
        
%GO TO OVER CADDY
         setAxisCupReady();
         
         pause(0.25);
         jawsOpen();
         pause(0.25);
         jawsClosed();
         
%          setGoal(2, q(2));
%          pause(0.25);
%          setGoal(3, q(3));
%          pause(0.25);
%          setGoal(1, q(1));
%          pause(0.25);
         
%          q(1) = convertAngle(q(1));
%          q(2) = convertAngle(q(2));
%          q(3) = convertAngle(q(3));
         
%         setGoal(1, q(1));
%         setGoal(2, q(2));
%         setGoal(3, q(3));
%         pause(1);
%         setGoal(4, 1990);%jaws closed
%         
%         pause(1); 
%         
%         q = rotAngles(235, 132, 250);
%         
%         q(1) = convertAngle(q(1));
%         q(2) = convertAngle(q(2));
%         q(3) = convertAngle(q(3));
% 
%         setGoal(1, q(1));
%         setGoal(2, q(2));
%         setGoal(3, q(3));
%         
%         pause(0.25);
%         setGoal(4, 1775);%jaws open
%         pause(0.25);
%         setGoal(4, 1990);%jaws closed

         
%         setGoal(3, 212);        
%         setGoal(1, 350); 
%         pause(0.25);
%         setGoal(3, 85);
%         setGoal(2, 275);
%         
%         setGoal(4, 1775);%jaws open
%         pause(1.5);
%         setGoal(1, 380);
%         pause(2);
%         setGoal(4, 1990);%jaws closed
%         pause(1);
%         setGoal(2, 207);
%         setGoal(3, 150);
%         setGoal(1, 700);
%         pause(3);
%         setGoal(4, 1775);%jaws open

        
%         setSpeed(1, 350);
%         pause(0.25);
%        setGoal(4, 1990);%jaws closed
%        setGoal(1, 1000);
%        setSpeed(1, 350);
%        pause(0.05);
%        setSpeed(1, 250);
%        pause(0.05);
%        setSpeed(1, 150);
%        pause(0.05);
       
%        setGoal(2, 300);
%        setGoal(3, 512);
        
%        setSpeed(1, 100);
%        pause(0.25);

%        pause(2);
        
%         setGoal(1, 300);
%         setGoal(2, 207);
%         setGoal(3, 300);
        
% for count = 1:2
%     
%        pause(0.2);
%        sound(y, Fs);
%        setGoal(4, 1775);%jaws open
%        pause(0.35);
%        setGoal(4, 1990);%jaws closed        
% end    

%pause(0.75);
%setGoal(4, 1775);%jaws open
%pause(0.1);
%etGoal(4, 1990);%jaws closed 

homeJeeves();
        
    else
        
        disp('Failed to open USB2Dynamixel!');
        
    end
    
calllib('dynamixel','dxl_terminate');
unloadlibrary('dynamixel');