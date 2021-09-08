#!/usr/bin/env python

 
import rospy
import numpy as np
from sensor_msgs.msg import Image
from cv_bridge import CvBridge, CvBridgeError
import cv2
import message_filters
from std_msgs.msg import Float64MultiArray , MultiArrayLayout
from std_msgs.msg import String

image_save_path = "/home/zach/catkin_ws/save_image/"
save_data = "/home/zach/catkin_ws/save_data.txt"
now_data = "/home/zach/catkin_ws/now_data.txt"


gesture_pre = np.array([1 , 1 , 1 , 1 , 1 , 1 , 1]) 


def string_to_float(str):
    return float(str)




def callback(data1 , data2):
    
    pub_image_location = rospy.Publisher("location_image" , String  ,queue_size=10)
    pub_location_event = rospy.Publisher("location_event" , Float64MultiArray , queue_size=10)
    scaling_factor = 0.5
    cv_img = bridge.imgmsg_to_cv2(data2, "bgr8")
    timestr = "%.1f" %  data2.header.stamp.to_sec()
    x = data1.data[0]
    y = data1.data[1]
    z = data1.data[2]
    ox = data1.data[3]
    oy = data1.data[4]
    oz = data1.data[5]
    ow = data1.data[6]
    
    array = [x , y , z , ox , oy , oz , ow]
    gesture_now_str = Float64MultiArray(data = array)


    x = ("%.1f" % x)
    y = ("%.1f" % y)
    z = ("%.1f" % z)
    ox = ("%.1f" % ox)
    oy = ("%.1f" % oy)
    oz = ("%.1f" % oz)
    ow = ("%.1f" % ow)
    gesture_str = x + "_" + y + "_" + oz + "_" + ow
    
     
    
    x = string_to_float(x)
    y = string_to_float(y)
    z = string_to_float(z)
    ox = string_to_float(ox)
    oy = string_to_float(oy)
    oz = string_to_float(oz)
    ow = string_to_float(ow)
    bot_martix = np.array([x , y , z , ox , oy , oz , ow])
    
    gesture_now  = bot_martix
    #gesture_pre = gesture_pre_martix
    
    rospy.loginfo(gesture_now)
    
    '''
    if(gesture_now != gesture_pre).any():
        image_name  = gesture_str + ".jpg" # + "_" + timestr + 
        cv2.imwrite(image_save_path + image_name , cv_img)
        #cv2.imwrite("/catkin_ws/save_image/ + image_name" , cv_img)  
        rospy.loginfo("save image")
        #cv2.imshow("frame" , cv_img)
        #cv2.waitKey(10)
        pub_image_location.publish(gesture_str) # + "_" + timestr
        pub_location_event.publish(gesture_now_str)
    global gesture_pre
    gesture_pre = gesture_now
    '''
     
def listener():
    
    rospy.init_node('image_position', anonymous=True)
 
    # make a video_object and init the video object
    global bridge
    
    bridge = CvBridge()
    position = message_filters.Subscriber('location_position' , Float64MultiArray )
    image = message_filters.Subscriber('/camera/rgb/image_raw', Image)
    image_pos = message_filters.ApproximateTimeSynchronizer([position , image] , 10 , 1 ,allow_headerless = True)
    image_pos.registerCallback(callback)
    
    rospy.spin()
 
if __name__ == '__main__':
    listener()