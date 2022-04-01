from typing import Any
import cv2 as cv
import numpy as np


class Robot:
    def __init__(self):
        self.x = -1
        self.y = -1
        self.theta = -1
        self.reduis_size = 15
        self.color = (0, 0, 255)
        self.thickness = -1
        self.border = 3
        self.border_color = (0, 0, 0)

    def draw(self, test_map: Any):
        test_map_rgb = cv.cvtColor(test_map, cv.COLOR_GRAY2RGB)
        cv.circle(test_map_rgb, (self.x, self.y), self.reduis_size, self.color, self.thickness)
        cv.circle(test_map_rgb, (self.x, self.y), self.reduis_size, self.border_color, self.border)
        cv.line(test_map_rgb, (self.x, self.y), self.move(self.reduis_size * 2), self.border_color, 2)
        return test_map_rgb

    def  move(self, step: int):
        x_new = self.x + step * np.cos(self.theta * np.pi / 180)
        y_new = self.y + step * np.sin(self.theta * np.pi / 180)
        return int(x_new), int(y_new)

    def check_robot_collision(self, test_map: Any, pose_x_test: int, pose_y_test: int):
        if (pose_x_test - self.x) ** 2 + (pose_y_test - self.y) ** 2 <= self.reduis_size ** 2:
            return None
        return pose_x_test, pose_y_test

    def allowed_points(test_map: Any):
        for x in range(0, len(test_map[0])):
            for y in range(0, len(test_map)):
                pose = robot.check_robot_collision(test_map, x, y)
                if pose is not None:
                    print(x, y)
                    



 

class Problem1:
    def __init__():
        pass
    def solve(robot: Robot, test_map: Any):
        test_map_with_robot = robot.draw(test_map)


if __name__ == "__main__":
    test_map = cv.imread('Assignment_04_Grid_Map.png', cv.IMREAD_GRAYSCALE)
    robot = Robot()
    robot.x, robot.y, robot.theta =  510, 182, 180
    test_map_with_robot = robot.draw(test_map)
    cv.imshow('map', test_map_with_robot)
    cv.waitKey(0)

    # if check_robot_position(map_image, robot_pose):
    #     z = assignment_4_1(np.array(map_image), robot_pose, opening_angle=250, angle_step=2)
    #     position = assignment_4_2(map_image, z, opening_angle=250, angle_step=2)
    #     print()
    #     cv.destroyAllWindows()
    # else:
    #     print("The robot inside the wall !")