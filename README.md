# Human Motion Analysis Programming
*Supervised by Prof. [Tung-Wu Lu](http://oemal.bme.ntu.edu.tw/professor/professorE.htm)Dept. of BioMedical Engineering, NTU*

Implemented MATLAB programs with a motion capture system and force plates for motion analysis, including motion tracking, evaluation of body balance, and derivation of joint forces and torques of the lower body.



This is the term Project of [Introduction to Robotics 2016](https://nol.ntu.edu.tw/nol/coursesearch/print_table.php?course_id=522%20U1290&class=&dpt_code=5220&ser_no=50327&semester=105-1&lang=EN) in Department of Mechanical Engineering, National Taiwan University (NTUME).

The manipulator follows the motions of a human right arm and clenches when the raising of left arm is detected.  

Positions of 20 body joints can be captured by Kinect with the function "Skeletal Tracking" in the KinectSDK and joint angles of the arm (as the angles of servo motors) thus can be determined. The command is send to the Arduino board via serial port. By utilizing [Firmata](http://www.firmata.org/wiki/Main_Page) protocol, the commands of Arduino controlling the servo motors can be programmed in C# without modifying the arduino code. 

## Setup
1. [KinectSDK64.msi](https://github.com/atosorigin/Kinect/blob/master/lib/Third%20Party/Microsoft%20Kinect%20SDK/KinectSDK64.msi)

2. [Coding4Fun Kinect Toolkit](https://c4fkinect.codeplex.com/releases/view/68333)

## Programming Environment
Language: C# (in Visual Studio)

Operating System: Win10

## Hardware
1. Kinect for Xbox (Ver. 1414)

2. Arduino Uno ( Uploaded with the sample sketchbook "ServoFirmata" in Arduino IDE )

3. Self-made LEGO Manipulator

4. Servo Motor *4
![](/image/1.jpg) 

## Interface 
Images captured by Kinect and positions of joints are displayed.
![](/image/3.gif) 

## Demo
![](/image/123.gif) 

## Reference
1. [Kinect Programming Guide](http://research.microsoft.com/en-us/um/redmond/projects/kinectsdk/docs/ProgrammingGuide_KinectSDK.pdf)

2. [MSDN Taiwan](https://www.youtube.com/user/TWDevelopGirl/search?query=kinect)

3. [C# Programming Guide by MSDN](https://msdn.microsoft.com/en-us/library/67ef8sbd.aspx)

4. [Head First C#](http://shop.oreilly.com/product/0636920027812.do)
