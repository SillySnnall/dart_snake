import 'package:quiver/core.dart';

/**
 * 坐标bean
 */
class Position {
  var x, y;
  Position(this.x, this.y);
  bool operator ==(o) => o is Position && o.x == x && o.y == y;
  int get hashCode => hash2(x.hashCode, y.hashCode);
}
