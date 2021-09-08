#!/usr/bin/env python


'''get_position ROS Node'''
import math
import rospy
from std_msgs.msg import String
import numpy as np
from nav_msgs.msg import Odometry
import sys
from std_msgs.msg import Float64MultiArray 




def callback(msg):
    '''get_position Callback Function'''
    pub_lacotion = rospy.Publisher('location_position' , Float64MultiArray , queue_size=10)
    pub_time_location = rospy.Publisher('time_location' , Float64MultiArray , queue_size=10)
    

    position_data = ""
    x = msg.pose.pose.position.x
    y = msg.pose.pose.position.y
    z = msg.pose.pose.position.z
    ox = msg.pose.pose.orientation.x
    oy = msg.pose.pose.orientation.y
    oz = msg.pose.pose.orientation.z
    ow = msg.pose.pose.orientation.w
    
    
    
    '''x = ('%.3f' %x)
    y = ('%.3f' %y)
    z = ('%.3f' %z)
    ox = ('%.3f' %ox)
    oy = ('%.3f' %oy)
    oz = ('%.3f' %oz)
    ow = ('%.3f' %ow)'''
     
    info = str(x) + "_" + str(y) + "_" + str(z) + "_" + str(ox) + "_" + str(oy) + "_" + str(oz) + "_" + str(ow)
    array = [x , y , z , ox , oy , oz , ow ]
    ges_pos_str = Float64MultiArray(data = array)
    position_data = str(x) + "," + str(y) + "," + str(z) + "," + str(ox) + "," + str(oy) + "," + str(oz) + "," + str(ow)
    rospy.loginfo(position_data)
    pub_lacotion.publish(ges_pos_str)
    pub_time_location.publish(ges_pos_str)

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
