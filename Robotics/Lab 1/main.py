from typing import Any
import cv2 as cv
import numpy as np
from datetime import datetime


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
        self.z = []

    def sense_destance(self, pose_x_test: int, pose_y_test: int, robot: Robot):
        return np.sqrt((pose_x_test - robot.x) ** 2 + (pose_y_test - robot.y) ** 2)
    
    def move_ray(self, step: int, x: float, y: float, angle: int):
        return x + step * np.cos(angle * np.pi / 180), y + step * np.sin(angle * np.pi / 180)
    
    def check_ray_collision(self, test_map: Any, pose_x_test: int, pose_y_test: int):
        if pose_y_test >= len(test_map) or pose_y_test < 0 or pose_x_test >= len(test_map[0]) or pose_x_test < 0 or test_map[int(pose_y_test) - 1][int(pose_x_test) - 1] == 0 or test_map[int(pose_y_test)][int(pose_x_test)] == 0 or test_map[int(pose_y_test) + 1][int(pose_x_test) + 1] == 0:
            return True
        return False

    def measurements_draw_rays(self, robot: Robot, test_map: Any, file: Any):
        start = robot.theta - int(self.sensor_angle / 2)
        end = robot.theta + int(self.sensor_angle / 2)
        file.write('\n\t\t\tmeasurements\n rayX, rayY, raylength, RayAngle \n')
        for angle in range(start, end + 1, self.sensor_resolution):
            new_x, new_y = robot.x, robot.y
            while (self.check_ray_collision(test_map, new_x, new_y)) is False and self.sense_destance(new_x, new_y, robot) <= self.max_range:
                new_x, new_y = self.move_ray(1, new_x, new_y, angle)
            cv.line(test_map, (robot.x, robot.y), (int(new_x), int(new_y)), 200, 2)
            destance = -1
            if self.sense_destance(new_x, new_y, robot) >= self.max_range:
                self.z.append(1200)
                destance = 1200
            else:
                self.z.append(self.sense_destance(new_x, new_y, robot) * 4)
                destance = self.z[-1]
            file.write(str(new_x) + ', ' + str(new_y) + ', ' + str(destance) + ', ' + str(angle) + '\n')            
        return test_map

class Problem1:
    def __init__(self, file: Any):
        self.outfile = file
    def solve(self, robot: Robot, test_map: Any, sensor: Sensor):
        file.write('RobotX, RobotY, RobotAngle\n')
        file.write(str(robot.x) + ', ' + str(robot.y) + ', ' + str(robot.theta) + '\n')
        test_map_with_robot_and_rays = sensor.measurements_draw_rays(robot, test_map, file)
        test_map_with_robot_and_rays = robot.draw(test_map_with_robot_and_rays)
        file.close()
        _ = cv.imwrite('likelihood_field.png', test_map_with_robot_and_rays)


class Proplem2():
    def __init__(self, test_map: Any):
        self.likelihood_field = cv.GaussianBlur(255 - test_map, (5, 5), 4)
        self.propbability_map = np.zeros(shape=(len(test_map), len(test_map[0])))


    def solve(self, test_map: Any, robot: Robot, sensor: Sensor):
        _ = cv.imwrite('likelihood_field.png', self.likelihood_field)
        for y in range(0, self.likelihood_field.shape[0]):
            for x in range(0, self.likelihood_field.shape[1]):
                for angle in range(0, 360):
                    start = robot.theta - int(sensor.sensor_angle / 2)
                    end = robot.theta + int(sensor.sensor_angle / 2)
                    index = 0
                    prop = 1
                    for rayAngle in range(start, end + 1, sensor.sensor_resolution):
                        end_x, end_y = sensor.move_ray(sensor.z[index] / 4, x, y, rayAngle + angle)
                        if sensor.z[index] >= 1200:
                            continue
                        if (end_y >= len(self.likelihood_field) or end_x >= len(self.likelihood_field[0]) or end_y < 0 or end_x < 0) == False:
                            prop *= self.likelihood_field[int(end_y)][int(end_x)]
                        else:
                            prop *= 0.01
                        index += 1
                    self.propbability_map[y][x] = max(self.propbability_map[y][x], prop)
        maximum = max(map(max, self.propbability_map))
        position = -1, -1
        x = cv.imwrite('prob_map.png', self.propbability_map) 
        if maximum > 0: 
            self.propbability_map = [[(x / maximum) * 255 for x in y] for y in self.propbability_map]
            for y in range(len(self.propbability_map)):
                for x in range(len(self.propbability_map[0])):
                    if self.propbability_map[y][x] == 255:
                        position = x, y 
        robot.x = position[0]
        robot.y = position[1]
        map_with_robot = robot.draw(test_map)
        x = cv.imwrite('robot_pose.png', map_with_robot)


if __name__ == "__main__":
    now = datetime.now()
    test_map = cv.imread('Assignment_04_Grid_Map.png', cv.IMREAD_GRAYSCALE)
    file = open("output.txt", "w")
    robot = Robot()
    robot.x, robot.y, robot.theta =  370, 182, 180
    sensor = Sensor()
    problem1 = Problem1(file)
    problem1.solve(robot, test_map, sensor)
    test_map = cv.imread('Assignment_04_Grid_Map.png', cv.IMREAD_GRAYSCALE)
    problem2 = Proplem2(test_map)
    problem2.solve(test_map, robot, sensor)
    print(datetime.now() - now)