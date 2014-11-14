NOTE: read the README in raw form to see diagram below
SANCHEZ - Systematic, As-Nominated Coffee Handling in Explicit Zones

Required installations: 
-Matlab (tested on R2014a)
-Peter Corke's robotics and vision toolbox http://www.petercorke.com/Toolbox_software.html
-Kinect Matlab SDK http://au.mathworks.com/hardware-support/kinect-windows.html
-Dynamixel Matlab SDK http://support.robotis.com/en/software/dynamixel_sdk/usb2dynamixel/usb2dxl_windows.htm


Required hardware:
3-DOF robotic arm with fourth DOF for end effector open/close control. 
Kinect for windows - mounted orthogonally above the turntable

The program runs on the specified setup, directly through matlab. all operations handled through the toplevel script control.

setup: the robotic arm is described using the Denavit Hartenberg parameters:
[0 0 0 pi/2]
[0 0 .21585 0]
[0 0 .30646 0]
the end effector features a moveable jaw for grasping objects. 

A caddy containing all condiments is located 90 degrees to the left of the robotic arm at a distance of 20cm

the turntable is positioned relative to the camera by positioning the corner of the camera's image on the specified origin. the origin is used as the point about which all other locations are determined. the base of the robot is 49.5 cm in x direction and 15 cm in the y direction from the origin




----------------------                                                                      coordinate directions
                                                                                                x
        Caddy                                                                                   <----
                                                                                                    |
----------------------                                                                              v y
                                                turntable base (lego mat)                           
                                    _________________________________________
                                   |                                         |
                                   |                                         |
                                   |                            origin       |
      robot base                   |                    ___       -+-        |
    _________                      |              /             \            |
    |       |                      |                                         |
    |       |                      |            |     turntable   |          |
    |_______|                      |                                         |
                                   |              \             /            |
                                   |                    ____                 |
                                   |                                         |
                                   |_________________________________________|
                                  
                                   
                                

   
    
    
    
    
