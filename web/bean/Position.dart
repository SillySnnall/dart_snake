import 'package:quiver/core.dart';

/**
 * 坐标bean
 */
class Position {
  var x, y;
  Position(this.x, this.y);
  // 改变对象的比较方式，本来是以对象的hashCode来判断对象是否是同一个对象,
  // 改为用x的值和y的值来区分对象是否是同一个对象
  // 类似于java中重写equals方法
  bool operator ==(o) => o is Position && o.x == x && o.y == y;
  int get hashCode => hash2(x.hashCode, y.hashCode);
}