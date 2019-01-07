import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'ai/AiSnake1.dart';
import 'bean/Position.dart';

var foodSize = 8; // 食物大小40px
var snakeColor = '#f00'; // 蛇的颜色
var snakeHeadColor = '#00f'; // 蛇头的颜色
var currentFoodColor = '#0f0'; // 当前食物颜色
var foodColor = '#fff'; // 剩下食物顔色

List<Position> snakeList = []; // 蛇的List
List<Position> foodList = []; // 食物的List

Position currentFood; // 当前食物

var snakeDirection; // 蛇的方向
var speed = 0; // 蛇的速度（单位：毫秒）

CanvasRenderingContext2D context2d; // 画布对象
Timer timer; // 计时器

var aiSnake1 = AiSnake1(); // AI

var modePlay = 0; // 玩法模式模式，0是我来玩，1是自己玩

void main() {
  // 获取2D画布对象
  CanvasElement canvas = querySelector('#canvas');
  context2d = canvas.context2D;
  initView();
  keyboardEvents();

  initData();

  startGame();
}

void initView() {
  // 开始按钮
  var resetBtn = querySelector('#reset');
  resetBtn.onClick.listen((event) {
    reset();

    initData();
    startGame();
  });
  // 我来玩
  var mePlayBtn = querySelector('#me_play');
  mePlayBtn.onClick.listen((event) {
    modePlay = 0;
    reset();

    initData();
    startGame();
  });
  // 自己玩
  var snakePlayBtn = querySelector('#snake_play');
  snakePlayBtn.onClick.listen((event) {
    modePlay = 1;
    reset();

    initData();
    startGame();
  });

  // 选择格子数
  var gridNums = document.querySelectorAll('.grid_num');
  for (ButtonElement gridNum in gridNums) {
    gridNum.onClick.listen((event) {
      foodSize =
          (context2d.canvas.width / sqrt(int.parse(gridNum.text))) as int;

      reset();

      initData();
      startGame();
    });
  }

  // 选择速度
  var speeds = document.querySelectorAll('.speed');
  for (ButtonElement speedBtn in speeds) {
    speedBtn.onClick.listen((event) {
      switch (speedBtn.text) {
        case "1档":
          speed = 0;
          break;
        case "2档":
          speed = 250;
          break;
        case "3档":
          speed = 500;
          break;
        case "4档":
          speed = 750;
          break;
        case "5档":
          speed = 1000;
          break;
      }

      reset();

      initData();
      startGame();
    });
  }
}

void initData() {
  drawGrid();
  initFoodData();
  initSnakeData();
  initCurrentFoodData();
}

/**
 * 重置游戏
 */
void reset() {
  aiSnake1.startAI = false;
  snakeDirection = null;
  currentFood = null;
  snakeList.clear();
  foodList.clear();
  timer.cancel();
  // 清空页面所有图案
  context2d.fillStyle = "#fff";
  context2d.fillRect(0, 0, context2d.canvas.width, context2d.canvas.height);
}

/**
 * 启动游戏
 */
void startGame() {
  timer = Timer.periodic(Duration(milliseconds: speed), (Timer t) {
    if (modePlay == 1) {
      var aiInit = aiSnake1.aiInit(snakeList, foodList, foodSize,
          snakeDirection, context2d.canvas.width);
      if (aiInit != null) snakeDirection = aiInit;
    }
    switch (snakeDirection) {
      case KeyCode.UP:
        makeSnakeDate(0, -foodSize);
        break;
      case KeyCode.DOWN:
        makeSnakeDate(0, foodSize);
        break;
      case KeyCode.LEFT:
        makeSnakeDate(-foodSize, 0);
        break;
      case KeyCode.RIGHT:
        makeSnakeDate(foodSize, 0);
        break;
    }
  });
}

/**
 * 初始化当前食物
 */
void initCurrentFoodData() {
  if (foodList.length == 0) return;
  var foodIndex = Random().nextInt(foodList.length);
  currentFood = Position(foodList[foodIndex].x, foodList[foodIndex].y);
  draw(currentFoodColor, currentFood);
}

/**
 * 初始化蛇的位置
 */
void initSnakeData() {
  // 蛇头位置
  var snakeHead = Position(0, 0);
  // 蛇身1位置
  var snakebody1 = Position(0, 0);
  // 蛇身2位置
  var snakebody2 = Position(0, 0);

  // 随机产生蛇头位置
  var foodIndex = Random().nextInt(foodList.length);
  var food = foodList[foodIndex];
  snakeHead.x = food.x;
  snakeHead.y = food.y;

  // 随机蛇身方向
  var snakeBodyDirection = Random().nextInt(2);
  if (snakeBodyDirection == 0) {
    // 横向蛇身
    if (food.x - foodSize - foodSize >= 0) {
      snakebody1.x = food.x - foodSize;
      snakebody1.y = food.y;
      snakebody2.x = food.x - foodSize - foodSize;
      snakebody2.y = food.y;
    } else {
      snakebody1.x = food.x + foodSize;
      snakebody1.y = food.y;
      snakebody2.x = food.x + foodSize + foodSize;
      snakebody2.y = food.y;
    }
  } else {
    // 纵向蛇身
    if (food.y - foodSize - foodSize >= 0) {
      snakebody1.x = food.x;
      snakebody1.y = food.y - foodSize;
      snakebody2.x = food.x;
      snakebody2.y = food.y - foodSize - foodSize;
    } else {
      snakebody1.x = food.x;
      snakebody1.y = food.y + foodSize;
      snakebody2.x = food.x;
      snakebody2.y = food.y + foodSize + foodSize;
    }
  }

  // 蛇头数据操作
  foodList.remove(snakeHead);
  snakeList.add(snakeHead);
  draw(snakeHeadColor, snakeHead);

  // 蛇身1数据操作
  foodList.remove(snakebody1);
  snakeList.add(snakebody1);
  draw(snakeColor, snakebody1);

  // 蛇身2数据操作
  foodList.remove(snakebody2);
  snakeList.add(snakebody2);
  draw(snakeColor, snakebody2);
}

/**
 * 键盘监听
 */
void keyboardEvents() {
  window.onKeyUp.listen((KeyboardEvent e) {
    // 判断是否有蛇
    if (snakeList.length == 0) return;
    // 键盘按键处理
    switch (e.keyCode) {
      case KeyCode.UP:
        // 判断蛇开始行走的开始方向
        if (snakeDirection == null && isRunDirection(0, -foodSize)) return;
        // 相同方向不会起效，相反方向不会起效
        if (snakeDirection == KeyCode.UP || snakeDirection == KeyCode.DOWN)
          return;
        snakeDirection = KeyCode.UP;
        break;
      case KeyCode.DOWN:
        if (snakeDirection == null && isRunDirection(0, foodSize)) return;
        if (snakeDirection == KeyCode.DOWN || snakeDirection == KeyCode.UP)
          return;
        snakeDirection = KeyCode.DOWN;
        break;
      case KeyCode.LEFT:
        if (snakeDirection == null && isRunDirection(-foodSize, 0)) return;
        if (snakeDirection == KeyCode.LEFT || snakeDirection == KeyCode.RIGHT)
          return;
        snakeDirection = KeyCode.LEFT;
        break;
      case KeyCode.RIGHT:
        if (snakeDirection == null && isRunDirection(foodSize, 0)) return;
        if (snakeDirection == KeyCode.RIGHT || snakeDirection == KeyCode.LEFT)
          return;
        snakeDirection = KeyCode.RIGHT;
        break;
    }
  });
}

/**
 * 判断蛇开始行走的开始方向
 */
bool isRunDirection(x, y) {
  var runDirection = Position(snakeList[0].x + x, snakeList[0].y + y);
  var indexOf = snakeList.indexOf(runDirection);
  if (indexOf == -1) {
    return false;
  } else {
    return true;
  }
}

/**
 * 处理蛇的移动数据
 */
void makeSnakeDate(x, y) {
  // 是否还有食物
  if (foodList.length == 0) {
    window.alert("You Win");
    reset();
    initData();
    startGame();
    return;
  }

  var oldSnake = Position(snakeList[0].x, snakeList[0].y);
  var newSnake = Position(snakeList[0].x + x, snakeList[0].y + y);

  // 判断蛇撞边，撞到自己
  if (newSnake.x < 0 ||
      newSnake.x >= context2d.canvas.width ||
      newSnake.y < 0 ||
      newSnake.y >= context2d.canvas.height ||
      foodList.indexOf(newSnake) == -1) {
    window.alert("Game Over");
    reset();
    initData();
    startGame();
    return;
  }

  // 蛇和食物的数据处理
  snakeList.insert(0, newSnake);
  foodList.remove(newSnake);

  // 将旧的蛇头变为蛇身
  draw(snakeColor, oldSnake);
  // 新蛇头
  draw(snakeHeadColor, newSnake);
  // 蛇吃食物
  if (newSnake != currentFood) {
    var removeSnake = snakeList.removeLast();
    removeSnake = Position(removeSnake.x, removeSnake.y);
    foodList.add(removeSnake);
    // 移除蛇尾
    draw(foodColor, removeSnake);
  } else {
    // 生成食物
    initCurrentFoodData();
  }
}

/**
 * 初始化食物数据
 */
void initFoodData() {
  // 在html中的canvas的width='800' height='800'，
  // 宽和高应该设置成相同的，以保证格子为正方形
  var gridNum = context2d.canvas.width / foodSize;

  var foodX = 0;
  var foodY = 0;
  for (var i = 0; i < gridNum * gridNum; i++) {
    if (i != 0 && i % gridNum == 0) {
      foodX = 0;
      foodY = foodY + foodSize;
    }
    var food = Position(foodX, foodY);
    foodList.add(food);
    foodX = foodX + foodSize;
  }
}

/**
 * 画
 */
void draw(color, grid) {
  context2d.fillStyle = color;
  context2d.fillRect(grid.x, grid.y, foodSize, foodSize);
  drawGrid();
}

/**
 * 画格子
 */
void drawGrid() {
  context2d.strokeStyle = "#ccc";

  // 画竖线
  for (var i = 0; i <= context2d.canvas.width; i += foodSize) {
    context2d.beginPath();
    context2d.moveTo(i, 0);
    context2d.lineTo(i, context2d.canvas.height);
    context2d.closePath();
    context2d.stroke();
  }
  // 画横线
  for (var j = 0; j <= context2d.canvas.height; j += foodSize) {
    context2d.beginPath();
    context2d.moveTo(0, j);
    context2d.lineTo(context2d.canvas.width, j);
    context2d.closePath();
    context2d.stroke();
  }
}
