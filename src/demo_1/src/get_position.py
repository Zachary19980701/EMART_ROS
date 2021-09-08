#!/usr/bin/env python


import math
import rospy
from std_msgs.msg import String
import numpy as np
from nav_msgs.msg import Odometry
import sys

class Get_pose():
    def __init__(self):
        rospy.init_node('locate' , anonymous=True)
        rospy.Subscriber = rospy.Subscriber("/odom" , Odometry ,self.position_callback)
        rospy.spin()

    def position_callback(self , msg):
        position_data = ""
        x = msg.pose.pose.position.x
        y = msg.pose.pose.position.y
        position_data = str(x) + "," + str(y)
        rospy.loginfo(position_data)



if __name__ == '__main__':
    try: 
        Get_pose()

    except:
        rospy.loginfo("wrong")