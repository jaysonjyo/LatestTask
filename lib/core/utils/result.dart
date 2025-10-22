/// Simple functional result wrapper
class Result<L, R> {
  final L? _left;
  final R? _right;

  bool get isLeft => _left != null;
  bool get isRight => _right != null;

  L get left => _left as L;
  R get right => _right as R;

  Result._(this._left, this._right);

  static Result<L, R> ok<L, R>(R value) => Result._(null, value);
  static Result<L, R> err<L, R>(L value) => Result._(value, null);
}
