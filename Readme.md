# Lathe 3D Printer

This documentation package includes all of the instructions, materials, models, and code required to construct your own version of the University of Minnesota Medical Robotics and Devices Lab Lathe 3D printer developed by John Huss. This open source design allows a user to create 3D printed balloon catheter segments, for use in constructing robots or other cylindrical 3D printed objects.

## Links to the lab:
- [Research lab](http://dept.me.umn.edu/labs/mrd/)
- [Project motivation](http://dept.me.umn.edu/labs/mrd/Soft_Robots.shtml)

Included in this design are the files needed to recreate the complete fused filament fabrication test bench version of this printer plus the preliminary models and instructions for a fiber reinforced photopolymer extrusion version.

## System features:
The printer utilizes a horizontal lathe-style arrangement of axes to print high aspect ratio cylindrical objects more efficiently and accurately than other methods. This is achieved by using a rotating mandrel as a removable deposition surface. This mandrel can be removed after the printing is finished, leaving a hollow, highly accurate cylinder. Additionally, to ensure straightness of the mandrel two counter-rotating motors (one at each end of the long axis) are used to eliminate any torsional strain in the mandrel. The collets at both ends in which the mandrel is held can be moved along the axis to pre-strain the deposition surface to eliminate gravitational sag and any bends in the mandrel.

![Solidworks model of the printer](https://github.com/labmrd/LathePrinter/blob/master/Images/Huss%20Lathe%20Printer%20Assembly%20Render.JPG)

## Coordinates and axis definitions:
This printer operates in a polar coordinate system (R, theta, Z). Z, along the length of the cylinder, is operated by an [OpenBuilds linear actuator](https://openbuildspartstore.com/c-beam-linear-actuator-bundle) and forms the structural base of the printer. The rotational axis, theta (Y axis in the firmware), is operated by two counter-rotating stepper motors mounted to an optics positioning stage on the sliding potion of the Z axis linear carriage. The optics stage allows for fine tuning of the distance between the two theta axis motors to accommodate different length mandrels. Additionally, a third optics stage between motor mounts provides a convenient location to mount any measuring equipment or dial indicators. The final axis, R (X in firmware), is vertical and is currently entirely manual. Motion of the R axis is achieved by adjusting the head mount linear stage attaching the nozzle to the head support column. One final minor adjustment axis is available to move the print head forwards and backwards for calibration by adjusting the second dial on the head mount linear stage. This minor axis allows the user to position the head precisely over the mandrel.

![Axes](https://github.com/labmrd/LathePrinter/blob/master/Images/Huss%20Lathe%20Printer%20Assembly%20Capture%20Labeled.JPG)

## Software and slicing:
This printer accepts standard 3D printer G-code, but with some restrictions. The system will fail to print if the requested nozzle position is within R=1mm (representing the minimum R position because of the mandrel). Traditional slicers prepare 3D printer G-code by turning the CAD model into a series of 2D layers from -Z to +Z, which is not how this printer is constructed. This system requires G-code with layers ordered from -R to +R. If the user only needs single layer thickness models, they should use a commonly available feature of slicers often called "vase mode" to create single nozzle width walls. In this case, the walls are layers. To achieve thicker cylinders there are a few options. 
1. Run the print again with the manual R axis set slightly higher and adjust the extrusion rate modifier accordingly in the control console. 
2. If the user automates the R axis, slice a second cylinder model with a slightly wider radius and print that onto the first model. 
3. Generate or modify G-code using a different method such as a custom MATLAB or Python script, or process existing G-code files into one continuous file.
Slicing models for this printer is the biggest area of needed improvement and will change depending on the user's desired use case. The above methods are suggested starting points for researchers to build from.

## Firmware:
This printer uses a Duet2 Ethernet controller board and an older version of dc42's Duet Firmware package [RepRapFirmware](https://github.com/Duet3D/RepRapFirmware) has been configured for this system. The configuration file and homing files (with comments) are included in this documentation package. The specific G codes supported in this firmware package are [documented here](https://duet3d.dozuki.com/Wiki/Gcode).

## Electronics and Wiring:
The wiring for this project is standard for a 3D printer using stepper motors with a few exceptions. Only one axis requires an end-stop, Z, because R is manual, and theta is continuous. This endstop is not pictured in the CAD files but can be seen mounted to the linear actuator on the left side of the carriage in the photographs. To achieve counter-rotating mandrel motors both motors are plugged into the Z-axis motor ports on the Duet board. Duet supports two Z axis motors in parallel at the hardware level for large print beds. There are two ports connected to the same motor driver chip. To force one motor to spin in reverse of the other, reverse the pin-out of one pair of wires on the stepper motor. This will cause it to rotate the other way compared to the first motor. It does not matter which pair you swap as long as they are from the same winding. You can check for continuity between each pair of wires to know which go together before swapping. The Z axis motor ports on the board are configured in firmware to act as the rotational axis of the polar printer instead of as the Z axis.

### Wiring diagram:
![Electronics wiring diagram](https://github.com/labmrd/LathePrinter/blob/master/Images/Wiring%20Diagram.jpg)

### Dual theta stepper motor wire swap
![Stepper motor wire swap](https://github.com/labmrd/LathePrinter/blob/master/Images/Stepper%20wire%20swap.jpg)


## Hardware design:
Many components of this printer are available for purchase or can be made using other common 3D printers and machining techniques. The main structure of this system is created from aluminum extrusions, assembled using T-slot nuts, bolts, and brackets. The full Bill of Materials in included for a more detailed view of all necessary components. Most of the mounting hardware is not shown in the CAD files, so use the pictures to see how I assembled it. Feel free to make changes. See the Images folder for detailed photos of the assembly.

## Extrusion systems:
Two extrusion systems currently exist for this printer, a traditional fused filament fabrication extruder, and an experimental fiber reinforced photopolymer co-extruder. The FFF extruder is a standard Creality CR-10 extruder and hotend assembly adapted to fit onto the head column. The experimental co-extrusion fiber/photopolymer system is based on a CR-10 extruder, but highly modified with experimental 3D printed components. Once complete this second system will allow a user to create highly elastic air-tight cylinders with built-in strain-limiting fibers. These fibers can be used to modify the behavior of the cylinders when they are inflated, which is an ongoing research topic within the MRD Lab.

## Example FFF print:
A sample part is included along with instructions in video form on how to get started, from printer assembly to firmware installation, slicing and printing. This sample part is a simple one-layer thick cylindrical model.

### Getting connected if your network uses DHCP
In a university research lab setting I found it difficult to configure the printer to always use a static IP address. There are three main options, with some clearly better than others. The first and best option is to let your network manager assign this device a static IP using the MAC address listed in the config.g file (you can change this if there is a conflict). If that isn't an option you can set up your own small offline network and configure your router to assign the printer a static IP. This is how the printer is currently configured. Alternatively, you can connect directly to a computer but I found it simpler to use a router. Finally, and not recommended, you can let the printer use DHCP on the university network and interrogate the printer over USB to discover its assigned IP address. To do this connect via the USB cable and use a slicing program (I used Matter Control) that has a Terminal window. Connect using the terminal and send M552 to find out the current network settings.

### Notes on choosing your own hardware and electronics:
Many of the components for this printer were chosen primarily due to their availability in the lab already and my familiarity with them. If you want to choose different components (possibly cheaper) that is certainly an option. The full capabilities of the power supply, mainboard, and even the full accuracy of the optics components are not being used in this current form, but for a research platform it is helpful to eliminate any potential issues from incompatible or underperforming equipment. It may be possible to extract the motors, power supply, and electronics from a more inexpensive 3D printer to build this system, but I haven't tested compatibility with anything else. Possible hurdles may arise with the polar setup if a different mainboard/firmware combination doesn't support this kinematics type.
