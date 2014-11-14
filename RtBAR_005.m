
%this goes in top of script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[y,Fs] = audioread('Tyrannosaurus Rex.mp3');
disp('Ready...');

caddy = ones(3, 12);
caddyLoc = ones(3, 12, 3);

caddyLoc(:, :, 1) = [ 894 897 874 874 842 843 819 817 786 786 762 761;
                      901 907 879 881 842 846 816 819 783 779 756 748;
                      918 890 848 817 771 738 918 890 848 817 771 738 ];
    
caddyLoc(:, :, 2) = [ 298 295 280 296 279 274 276 276 274 276 292 285;
                      291 281 280 271 270 260 271 261 275 261 284 272;
                      276 260 258 248 255 271 276 260 258 248 255 271 ];

caddyLoc(:, :, 3) = [ 235 214 214 209 210 185 206 189 210 190 225 204;
                      190 168 179 149 162 133 156 134 163 136 175 153;
                      141 110 104  93 100 114 141 110 104  93 100 114 ];
                  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

initialiseDynamixels();
blocking();

caddy = getItem( caddyLoc, caddy, 1 );


%caddy = getItem( caddyLoc, caddy, 1 );
for row = 1:3
    for col = 1:12

        moveToPoint(caddyLoc(row, col, 1), caddyLoc(row, col, 2), caddyLoc(row, col, 3));
        pause(0.5);

    end
    pause(3);
end

   

