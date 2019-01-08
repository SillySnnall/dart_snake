import 'dart:html';

import '../bean/Position.dart';

class AiSnake {
  var startAI = false;

  /**
   * 执行AI前，将蛇头移动到（0，0）位置，蛇身横向，初始化
   */
  aiInit(List<Position> snakeList, List<Position> foodList, int foodSize,
      int snakeDirection, int gridMaxNum) {
    if (startAI) return ai(snakeList, foodList, foodSize, snakeDirection);

    var snakeHead = snakeList[0];
    var snakeBody1 = snakeList[1];

    // 初始化位置
    if (snakeHead.x == 0 &&
        snakeHead.y == 0 &&
        snakeBody1.x == foodSize &&
        snakeBody1.y == 0) {
      startAI = true;
      return KeyCode.DOWN;
    }
    // 纵向，蛇头在下
    if (snakeHead.y - foodSize == snakeBody1.y) {
      //蛇头在最下边
      if (snakeHead.y == gridMaxNum) {
        // 蛇头在最左边
        if (snakeHead.x == 0)
          return KeyCode.RIGHT;
        else
          return KeyCode.LEFT;
      } else {
        // 蛇头在最左边
        if (snakeHead.x == 0)
          return KeyCode.RIGHT;
        else
          return KeyCode.LEFT;
      }
    }
    // 纵向，蛇头在上
    if (snakeHead.y + foodSize == snakeBody1.y) {
      // 蛇头在最上边
      if (snakeHead.y == 0) {
        // 蛇头在最左边
        if (snakeHead.x == 0)
          return KeyCode.RIGHT;
        else
          return KeyCode.LEFT;
      } else {
        // 蛇头在最左边
        if (snakeHead.x == 0) {
          return KeyCode.RIGHT;
        } else {
          return KeyCode.UP;
        }
      }
    }

    // 横向，蛇头在右
    if (snakeHead.x - foodSize == snakeBody1.x) {
      // 蛇头在最上边
      if (snakeHead.y == 0) {
        return KeyCode.DOWN;
      } else {
        return KeyCode.UP;
      }
    }

    // 横向，蛇头在左
    if (snakeHead.x + foodSize == snakeBody1.x) {
      // 蛇头在最上边
      if (snakeHead.y == 0) {
        return KeyCode.LEFT;
      } else {
        return KeyCode.UP;
      }
    }
    return null;
  }

  /**
   * 偶数格子算法
   */
  int ai(List<Position> snakeList, List<Position> foodList, int foodSize,
      int snakeDirection) {
    var snakeHead = snakeList[0];

    // 最左边
    var left = Position(snakeHead.x - foodSize, snakeHead.y);
    if (snakeDirection == KeyCode.LEFT && foodList.indexOf(left) == -1) {
      return KeyCode.DOWN;
    }
    // 最左边,准备向右移动
    if (snakeDirection == KeyCode.DOWN && foodList.indexOf(left) == -1) {
      return KeyCode.RIGHT;
    }

    // 右边差一格，不在最下边
    var right = Position(snakeHead.x + foodSize + foodSize, snakeHead.y);
    var right1 = Position(snakeHead.x, snakeHead.y + foodSize);
    if (snakeDirection == KeyCode.RIGHT &&
        foodList.indexOf(right) == -1 &&
        snakeList.indexOf(right) == -1 &&
        snakeList.indexOf(right1) == -1 &&
        foodList.indexOf(right1) != -1) {
      return KeyCode.DOWN;
    }
    // 右边差一格，不在最下边,准备向左移动
    if (snakeDirection == KeyCode.DOWN &&
        foodList.indexOf(right) == -1 &&
        snakeList.indexOf(right) == -1 &&
        (snakeList.indexOf(right1) != -1 || foodList.indexOf(right1) != -1)) {
      return KeyCode.LEFT;
    }

    // 右下角
    var right2 = Position(snakeHead.x + foodSize, snakeHead.y);
    if (snakeDirection == KeyCode.RIGHT &&
        snakeList.indexOf(right2) == -1 &&
        foodList.indexOf(right2) == -1) {
      return KeyCode.UP;
    }
    // 右上角
    var up = Position(snakeHead.x, snakeHead.y - foodSize);
    if (snakeDirection == KeyCode.UP && foodList.indexOf(up) == -1) {
      return KeyCode.LEFT;
    }
    return null;
  }
}
