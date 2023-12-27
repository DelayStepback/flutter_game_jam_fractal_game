import 'dart:math';


class TerrainService{

  List<List<double>> makeTerrain(int n, double ds, Function bdry) {
    List<List<double>> d = List.generate(n, (_) => List<double>.filled(n, 0));

    int w = n - 1;
    double s = 1.0;
    while (w > 1) {
      singleDiamondSquareStep(d, w, s, bdry);

      w ~/= 2;
      s *= ds;
    }

    return d;
  }

  double fixed(
      List<List<double>> d, int i, int j, int v, List<List<int>> offsets) {
    int n = d.length;

    double res = 0;
    double k = 0;
    for (List<int> offset in offsets) {
      int p = offset[0];
      int q = offset[1];
      int pp = i + p * v;
      int qq = j + q * v;
      if (pp >= 0 && pp < n && qq >= 0 && qq < n) {
        res += d[pp][qq];
        k += 1;
      }
    }

    return res / k;
  }

  double periodic(
      List<List<double>> d, int i, int j, int v, List<List<int>> offsets) {
    int n = d.length - 1;

    double res = 0;
    for (List<int> offset in offsets) {
      int p = offset[0];
      int q = offset[1];
      res += d[(i + p * v) % n][(j + q * v) % n];
    }

    return res / 4.0;
  }

  void singleDiamondSquareStep(
      List<List<double>> d, int w, double s, Function avg) {
    int n = d.length;
    int v = w ~/ 2;

    List<List<int>> diamond = [
      [-1, -1],
      [-1, 1],
      [1, 1],
      [1, -1]
    ];
    List<List<int>> square = [
      [-1, 0],
      [0, -1],
      [1, 0],
      [0, 1]
    ];

    // Diamond Step
    for (int i = v; i < n; i += w) {
      for (int j = v; j < n; j += w) {
        d[i][j] = avg(d, i, j, v, diamond) + Random().nextDouble() * 2 * s - s;
      }
    }

    // Square Step, rows
    for (int i = v; i < n; i += w) {
      for (int j = 0; j < n; j += w) {
        d[i][j] = avg(d, i, j, v, square) + Random().nextDouble() * 2 * s - s;
      }
    }

    // Square Step, cols
    for (int i = 0; i < n; i += w) {
      for (int j = v; j < n; j += w) {
        d[i][j] = avg(d, i, j, v, square) + Random().nextDouble() * 2 * s - s;
      }
    }
  }

}