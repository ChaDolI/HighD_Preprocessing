# highD preprocessing

## Author  : Cha Jong Hyun, Master`s course in Ajou University Autonomous Control Laboratory
## Contact : chadoli@ajou.ac.kr

highD is a German Drone dataset with trajectory information on German highway.  
You can access the dataset with non-commercial use by sending a request to "https://www.highd-dataset.com/"  
Also you can get highD tools at "https://github.com/RobertKrajewski/highD-dataset"  

highD dataset format is as follows("https://www.highd-dataset.com/format")

## Data format
##### 1. Recording meta infromation (XX_recordingMeta.csv)

|Name|Description|[Unit]|
|-|-|-|
|id|The id of the recording. Every recording has a unique id|[-]|
|frameRate|The frame rate which was used to record the video|[hz]|
|locationId|The id of the recording location. In total six different locations exist in the dataset|[-]|
|speedLimit|The speed limit of the driving lanes. In all recordings, the speed limit is the same for every driving lane|[m/s]|
|month|The month the recording was done|[-]|
|weekDay|The week day the recording was done|[-]|
|startTime|The start time at which the recording was done|[hh:mm]|
|duration|The duration of the recording|[s]|
|totalDrivenDistance|The total driven distance of all tracked vehicles|[m]|
|totalDrivenTime|The total driven time of all tracked vehicles|[s]|
|numVehicles|The number of vehicles tracked including cars and trucks|[-]|
|numCars|The number of cars tracked|[-]|
|numTrucks|The number of trucks tracked|[-]
|upperLaneMarkings|The y positions of the upper lane markings. The positions are separated by a ";"|[m]|
|lowerLaneMarkings|The y positions of the lower lane markings. The positions are separated by a ";"|[m]|


##### 2. Track Meta Information (XX_tracksMeta.csv)

|Name|Description|[Unit]|
|-|-|-|
|id|The id of the track. The ids are assigned in ascending order|[-]|
|width|The width of the post-processed bounding box of the vehicle. This corresponds to the length of the vehicle|[m]|
|height|The height of the post-processed bounding box of the vehicle. This corresponds to the width of the vehicle|[m]|
|initialFrame|The initial frame in which the vehicle track starts|[-]|
|finalFrame|The frame in which the track of the vehicle ends|[-]|
|numFrames|The total lifetime of the track as number of frames|[-]|
|class|The vehicle class of the tracked vehicle (Car or Truck)|[-]|
|drivingDirection|The driving direction of the vehicle. Either 1 for the left direction (upper lanes) or 2 for the right direction (lower lanes)|[-]|
|traveledDistance|The distance covered by the track|[m]|
|minXVelocity|The minimal velocity in driving direction|[m/s]|
|maxXVelocity|The maximal velocity in driving direction|[m/s]|
|meanXVelocity| The mean velocity in driving direction|[m/s]|
|minDHW| The minimal Distance Headway (DHW). This value is set to -1, if no preceding vehicle exists|[m]|
|minTHW| The minimal Time Headway (THW). This value is set to -1, if no preceding vehicle exists|[s]|
|minTTC| The minimal Time-to-Collision (TTC). This value is set to -1, if no preceding vehicle or valid TTC exists|[s]|
|numLaneChanges| Number of lane changes detected by changing lane id|[-]|

3. Tracks (XX_tracks.csv)

|Name|Description|[Unit]|
|-|-|-|
|frame|The current frame|[-]|
|id|The track's id|[-]|
|x|The x position of the upper left corner of the vehicle's bounding box|[m]|
|y|The y position of the upper left corner of the vehicle's bounding box|[m]|
|width|The width of the bounding box of the vehicle|[m]|
|height|The height of the bounding box of the vehicle|[m]|
|xVelocity|The longitudinal velocity in the image coordinate system|[m/s]|
|yVelocity|The lateral velocity in the image coordinate system|[m/s]|
|xAcceleration|The longitudinal acceleration in the image coordinate system|[m/s]|
|yAcceleration|The lateral acceleration in the image coordinate system|[m/s]|
|frontSightDistance|The distance to the end of the recorded highway section in driving direction from the vehicle's center|[m]|
|backSightDistance|The distance to the end of the recorded highway section in the opposite driving direction from the vehicle's center|[m]|
|dhw|The Distance Headway. This value is set to 0, if no preceding vehicle exists|[m]|
|thw|The Time Headway. This value is set to 0, if no preceding vehicle exists|[s]|
|ttc|The Time-to-Collision. This value is set to 0, if no preceding vehicle or valid TTC exists|[s]|
|precedingXVelocity|The longitudinal velocity of the preceding in the image coordinate system. This value is set to 0, if no preceding vehicle exists|[-]|
|precedingId|The id of the preceding vehicle in the same lane. This value is set to 0, if no preceding vehicle exists|[-]|
|followingId|The id of the following vehicle in the same lane. This value is set to 0, if no following vehicle exists|[-]|
|leftPrecedingId|The id of the preceding vehicle on the adjacent lane on the left in the direction of travel. This value is set to 0, if no such a vehicle exists|[-]|
|leftAlongsideId|The id of the adjacent vehicle on the adjacent lane on the left in the direction of travel. In order for a vehicle to be adjacent and not e.g. preceding, the vehicles must overlap in the longitudinal direction. This value is set to 0, if no such a vehicle exists|[-]|
|leftFollowingId|The id of the following vehicle on the adjacent lane on the left in the direction of travel. This value is set to 0, if no such a vehicle exists|[-]|
|rightPrecedingId|The id of the preceding vehicle on the adjacent lane on the right in the direction of travel. This value is set to 0, if no such a vehicle exists.|[-]|
|rightAlsongsideId|The id of the adjacent vehicle on the adjacent lane on the right in the direction of travel. In order for a vehicle to be adjacent and not e.g. preceding, the vehicles must overlap in the longitudinal direction. This value is set to 0, if no such a vehicle exists|[-]|
|rightFollowingId|The id of the following vehicle on the adjacent lane on the right in the direction of travel. This value is set to 0, if no such a vehicle exists|[-]|
|laneId|The IDs start at 1 and are assigned in ascending order. Since the Lane ids are derived from the positions of the lane markings, the first and last ids typically do not describe any useable lanes. For details, see the definition of the coordinate system|[-]|

4. Coordinate system  
The Coordinate system of highD dataset is global coordinate system based on upper left corner of the image coordinate system
![image](https://user-images.githubusercontent.com/71547238/153812787-10e72b02-3dc4-4aaf-8f49-8f82d1e966cf.png)  
(Source : "https://www.highd-dataset.com/format")


## Adding yaw
As you can see in the dataformat above, there is no yaw or heading angle data of vehicle.  
Assuming yaw is equal to the angle of the velocity vector, we can calculate the yaw of the vehicle using x and y velocity data.
![image](https://user-images.githubusercontent.com/71547238/154073909-ab3adb1c-cbb5-41a4-b245-3a889be4f92a.png)


##### yaw = arctan(yvelocity/xvelocity)

## Get center point of vehicle
x,y position is not the center point of the vehicle in highD data, it`s the top left corner point of the vehicle.  
You have to add the length, height of the vehicle to the x and y position.  
![image](https://user-images.githubusercontent.com/71547238/154074260-134cfe73-b850-40f6-99d0-38c13209c474.png)


##### Center_point_x = x + length/2  
##### Center_point_y = y + length/2
