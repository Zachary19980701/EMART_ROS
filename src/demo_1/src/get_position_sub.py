#!/usr/bin/env python
'''get_position ROS Node'''
import math
import rospy
from std_msgs.msg import String
import numpy as np
from nav_msgs.msg import Odometry
import sys


def callback(msg):
    '''get_position Callback Function'''
    pub = rospy.Publisher('fuzzy_position', String, queue_size=10)
    position_data = ""
    x = msg.pose.pose.position.x
    y = msg.pose.pose.position.y
    z = msg.pose.pose.position.z
    ox = msg.pose.pose.oritation.x
    oy = msg.pose.pose.oritation.y
    oz = msg.pose.pose.oritation.z
    ow = msg.pose.pose.oritation.w
    
    #数据坐标精度降低，减少运算量
    x = round(x)
    y = round(y)
    z = round(z)
    ox = round(ox)
    oy = round(oy)
    oz = round(oz)
    ow = round(ow) 

    position_data = str(x) + "," + str(y) + "," + str(z)
    rospy.loginfo(position_data)
    pub.publish(position_data)

def listener():
    '''get_position Subscriber'''
    # In ROS, nodes are uniquely named. If two nodes with the same
    # node are launched, the previous one is kicked off. The
    # anonymous=True flag means that rospy will choose a unique
    # name for our 'listener' node so that multiple listeners can
    # run simultaneously.
    rospy.init_node('get_position', anonymous=True)

    rospy.Subscriber("/odom" , Odometry , callback)

    # spin() simply keeps python from exiting until this node is stopped
    rospy.spin()

if __name__ == '__main__':
    listener()
