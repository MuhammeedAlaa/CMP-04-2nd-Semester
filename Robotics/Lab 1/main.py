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
        cv.line(test_map_rgb, (self.x, self.y), self.move(self.reduis_size * 2, self.theta, self.x, self.y), self.border_color, 2)
        return test_map_rgb

    def  move(self, step: int, angle: int, start_x: int, start_y: int):
        x_new = start_x + step * np.cos(angle * np.pi / 180)
        y_new = start_y + step * np.sin(angle * np.pi / 180)
        return int(x_new), int(y_new)
    
    def check_robot_collision(self, test_map: Any, pose_x_test: int, pose_y_test: int):
        boundary = int(self.size / 2)
        for i in range(self.x - boundary, self.x + boundary):
            for j in range(self.y - boundary, self.y - boundary):
                if j >= len(test_map) or i >= len(test_map[0]) or test_map[j][i] == 0:
                    return None
        return pose_x_test, pose_y_test

    def allowed_points(self, test_map: Any):
        for x in range(0, len(test_map[0])):
            for y in range(0, len(test_map)):
                pose = self.check_robot_collision(test_map, x, y)
                if pose is not None:
                    print(x, y)

class Sensor:
    def __init__(self):
        self.sensor_angle = 250
        self.sensor_resolution = 2
        self.max_range = 1200 / 4

    def sense_destance(self, pose_x_test: int, pose_y_test: int, robot: Robot):
        return np.sqrt((pose_x_test - robot.x) ** 2 + (pose_y_test - robot.y) ** 2)
    
    def move_ray(self, step: int, x: float, y: float, angle: int):
        return x + step * np.cos(angle * np.pi / 180), y + step * np.sin(angle * np.pi / 180)
    
    def check_ray_collision(self, test_map: Any, pose_x_test: int, pose_y_test: int):
        if pose_y_test >= len(test_map) or pose_y_test < 0 or pose_x_test >= len(test_map[0]) or pose_x_test < 0 or test_map[int(pose_y_test) - 1][int(pose_x_test) - 1] == 0 or test_map[int(pose_y_test)][int(pose_x_test)] == 0 or test_map[int(pose_y_test) + 1][int(pose_x_test) + 1] == 0:
            return True
        return False

    def measurements_draw_rays(self, robot: Robot, test_map: Any):
        z = []
        start = robot.theta - int(self.sensor_angle / 2)
        end = robot.theta + int(self.sensor_angle / 2)
        for angle in range(start, end, self.sensor_resolution):
            new_x, new_y = robot.x, robot.y
            while (self.check_ray_collision(test_map, new_x, new_y)) is False and self.sense_destance(new_x, new_y, robot) <= self.max_range:
                new_x, new_y = self.move_ray(1, new_x, new_y, angle)
            cv.line(test_map, (robot.x, robot.y), (int(new_x), int(new_y)), 200, 2)
            z.append(self.sense_destance(new_x, new_y, robot) * 4)            
        return z, test_map

class Problem1:
    def __init__(self):
        pass
    def solve(self, robot: Robot, test_map: Any, sensor: Sensor):
        z, test_map_with_robot_and_rays = sensor.measurements_draw_rays(robot, test_map)
        test_map_with_robot_and_rays = robot.draw(test_map_with_robot_and_rays)
        print(z)
        cv.imshow('map', test_map_with_robot_and_rays)
        cv.waitKey(0)


if __name__ == "__main__":
    test_map = cv.imread('Assignment_04_Grid_Map.png', cv.IMREAD_GRAYSCALE)
    robot = Robot()
    robot.x, robot.y, robot.theta =  370, 182, 180
    sensor = Sensor()
    problem1 = Problem1()
    problem1.solve(robot, test_map, sensor)