#!/usr/bin/env python
#!coding=utf-8
 
import rospy
import numpy as np
from sensor_msgs.msg import Image
from cv_bridge import CvBridge, CvBridgeError
import cv2
import message_filters
from std_msgs.msg import Float64MultiArray 
from std_msgs.msg import String


#count = 0
image_save_path = "/home/zach/catkin_ws/save_image/"
buffer_image_path = "/home/zach/catkin_ws/buffer_image/"
def buffer(cv_img):
    rospy.loginfo("hello world")
    similation_tho = 0.9
    last_img = cv_img
    #未完成






def callback(data1 , data2):
    # define picture to_down' coefficient of ratio
    #scaling_factor = 0.5
    global  bridge
    cv_img = bridge.imgmsg_to_cv2(data2, "bgr8")
    timestr = "%.6f" %  data2.header.stamp.to_sec()
             #%.6f表示小数点后带有6位，可根据精确度需要修改；
    rospy.loginfo(data1.data)
    
    image_name  = timestr + ".jpg" #图像命名：时间戳.jpg
    cv2.imwrite(image_save_path + image_name , cv_img)  #保存；
    cv2.imshow("frame" , cv_img)
    cv2.waitKey(50)


 
def listener():
    rospy.init_node('image_position', anonymous=True)
 
    # make a video_object and init the video object
    global count,bridge
    bridge = CvBridge()
    position = message_filters.Subscriber('location_position' , Float64MultiArray )
    image = message_filters.Subscriber('/camera/rgb/image_raw', Image)
    image_pos = message_filters.ApproximateTimeSynchronizer([position , image] , 10 , 1 ,allow_headerless = True)
    image_pos.registerCallback(callback)
    rospy.spin()
 
if __name__ == '__main__':
    listener()