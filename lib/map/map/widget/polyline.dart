import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/plugin_api.dart';

import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:latlong2/latlong.dart';

class AriMapPolylineLayer extends StatelessWidget {
  AriMapPolylineLayer({
    Key? key,
    required this.layerKey,
    required this.polylines,
  }) : super(key: key);

  final Key layerKey;

  final Map<ValueKey<String>, AriMapPolyline> polylines;

  final ValueNotifier<int> rebuild = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    final mapState = FlutterMapState.maybeOf(context);
    if (mapState == null) {
      assert(false, 'No FlutterMapState found');
    }

    final polylineBloc = context.read<AriMapBloc>();

    Map<ValueKey<String>, AriMapPolyline> currentPolylines = polylines;

    return BlocListener<AriMapBloc, AriMapState>(
      bloc: polylineBloc,
      listener: (context, state) {
        if (state is CreatePolylineState && state.layerKey == layerKey) {
          currentPolylines[state.polyline.key] = state.polyline;
          rebuild.value += 1;
        } else if (state is SelectdPolylineState &&
            state.polyline.layerkey == layerKey) {
          rebuild.value += 1; // 修改 ValueNotifier 的值
        }
      },
      child: ValueListenableBuilder<int>(
        valueListenable: rebuild,
        builder: (context, rebuild, child) {
          return Stack(
            children: buildPolylines(currentPolylines)
                .map((e) => _Polyline(
                      polyline: e,
                      mapState: mapState!,
                    ))
                .toList(),
          );
        },
      ),
    );
  }

  List<AriMapPolyline> buildPolylines(
      Map<ValueKey<String>, AriMapPolyline> polylines) {
    List<AriMapPolyline> polylineWidgets = [];
    polylines.forEach(
      (key, polyline) {
        polylineWidgets.add(polyline);
      },
    );
    sortList(polylineWidgets);

    return polylineWidgets;
  }
}

class _Polyline extends StatefulWidget {
  _Polyline({
    Key? key,
    required this.polyline,
    required this.mapState,
  }) : super(key: key);

  final AriMapPolyline polyline;

  final ValueNotifier<int> rebuild = ValueNotifier(0);

  final FlutterMapState mapState;

  @override
  _PolylineState createState() => _PolylineState();
}

class _PolylineState extends State<_Polyline> with TickerProviderStateMixin {
  late AriMapPolyline polyline;

  late final AnimationController controller;

  bool isRendering = true;

  late int renderHashCode;

  late int renderPointsHashCode;
  @override
  void initState() {
    super.initState();
    polyline = widget.polyline;
    renderPointsHashCode = widget.polyline.renderPointsHashCode;
    renderHashCode = widget.polyline.renderHashCode;

    controller = AnimationController(
      duration: Duration(milliseconds: polyline.polylinePaintTime),
      vsync:
          this, // Usually 'this' refers to a State object that is a TickerProvider
    );
    controller.addListener(() {
      // 根据progress来计算当前应该显示到哪个点
      // 更新animatedPoints
      if (controller.isCompleted) {
        isRendering = false;
        setState(() {
          // 更新逻辑
        });
      } else {
        setState(() {
          // 更新逻辑
        });
      }
    });
    startAnimation(0);
  }

  // 解决当上层AriMapPolylineLayer里的polylines顺序改变后,
  // 因为polyline缓存数据,导致_Polyline和AriMapPolylineLayer对应的polyline不一致的问题
  @override
  void didUpdateWidget(covariant _Polyline oldWidget) {
    super.didUpdateWidget(oldWidget);
    polyline = widget.polyline;
  }

  @override
  Widget build(BuildContext context) {
    final polylineBloc = context.read<AriMapBloc>();

    if (renderHashCode != polyline.renderHashCode) {
      renderHashCode = polyline.renderHashCode;
      isRendering = true;
    }

    return BlocListener<AriMapBloc, AriMapState>(
      bloc: polylineBloc,
      listener: (context, state) {
        if (state is UpdatePolylineState &&
            state.polyline.key == widget.polyline.key) {
          // 判断是否是points的更新,如果是执行动画
          if (state.polyline.renderPointsHashCode != renderPointsHashCode) {
            isRendering = true;
            bool diff = false;
            double progress;

            // 判断已有的点是否有变化,如果有变化全量更新
            for (var i = 0; i < polyline.points.length; i++) {
              if (diffLatlng(polyline.points[i], state.polyline.points[i])) {
                diff = true;
                break;
              }
            }
            if (!diff) {
              if (polyline.points.length < state.polyline.points.length) {
                progress =
                    polyline.points.length / state.polyline.points.length;
              } else {
                progress =
                    state.polyline.points.length / polyline.points.length;
              }
            } else {
              progress = 0;
            }

            renderPointsHashCode = state.polyline.renderPointsHashCode;
            polyline = state.polyline;

            startAnimation(progress);
          } else {
            setState(() {});
          }
        }
      },
      child: AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget? child) {
          Polyline paintPolyline = polyline.selected
              ? converToPolylineWithSelected(polyline)
              : converToPolyline(polyline);
          return CustomPaint(
            painter: AriMapPolylinePainter(
                paintPolyline, widget.mapState, controller.value, isRendering),
            size: Size(widget.mapState.size.x, widget.mapState.size.y),
          );
        },
      ),
    );
  }

  // 在需要开始动画的地方
  void startAnimation(double progress) {
    controller.forward(from: progress);
  }
}

class AriMapPolylinePainter extends CustomPainter {
  AriMapPolylinePainter(
    this.polyline,
    this.map,
    this.renderProgress,
    this.isRendering,
  )   : bounds = map.bounds,
        assert(renderProgress >= 0 && renderProgress <= 1);

  final Polyline polyline;

  final FlutterMapState map;
  final LatLngBounds bounds;

  final double renderProgress;

  final bool isRendering;

  int get hash {
    _hash ??= polyline.renderHashCode;
    return _hash!;
  }

  int? _hash;

  List<Offset> getOffsets(List<LatLng> points) {
    return List.generate(points.length, (index) {
      return getOffset(points[index]);
    }, growable: false);
  }

  Offset getOffset(LatLng point) {
    return map.getOffsetFromOrigin(point);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    var path = ui.Path();
    var borderPath = ui.Path();
    var filterPath = ui.Path();
    var paint = Paint();
    bool needsLayerSaving = false;

    Paint? borderPaint;
    Paint? filterPaint;
    int? lastHash;

    void drawPaths() {
      final hasBorder = borderPaint != null && filterPaint != null;
      if (hasBorder) {
        if (needsLayerSaving) {
          canvas.saveLayer(rect, Paint());
        }

        canvas.drawPath(borderPath, borderPaint!);
        borderPath = ui.Path();
        borderPaint = null;

        if (needsLayerSaving) {
          canvas.drawPath(filterPath, filterPaint!);
          filterPath = ui.Path();
          filterPaint = null;

          canvas.restore();
        }
      }

      canvas.drawPath(path, paint);
      path = ui.Path();
      paint = Paint();
    }

    // 使用 renderProgress 来计算应该画多少点
    final animationValue = renderProgress * (polyline.points.length - 1);
    final int count = animationValue.toInt();
    final List<LatLng> animatedPoints = polyline.points.sublist(0, count + 1);
    if (count < polyline.points.length - 1) {
      final double startLat = polyline.points[count].latitude;
      final double startLng = polyline.points[count].longitude;
      final double endLat = polyline.points[count + 1].latitude;
      final double endLng = polyline.points[count + 1].longitude;

      // 根据动画进度值计算当前的点
      final double currentLat =
          startLat + (endLat - startLat) * (animationValue - count);

      final double currentLng =
          startLng + (endLng - startLng) * (animationValue - count);

      animatedPoints.add(LatLng(currentLat, currentLng));
    }
    final offsets = getOffsets(animatedPoints);
    if (offsets.isEmpty) {
      return;
    }

    final hash = polyline.renderHashCode;
    if (needsLayerSaving || (lastHash != null && lastHash != hash)) {
      drawPaths();
    }
    lastHash = hash;
    needsLayerSaving = polyline.color.opacity < 1.0 ||
        (polyline.gradientColors?.any((c) => c.opacity < 1.0) ?? false);

    late final double strokeWidth;
    if (polyline.useStrokeWidthInMeter) {
      final firstPoint = polyline.points.first;
      final firstOffset = offsets.first;
      final r = const Distance().offset(
        firstPoint,
        polyline.strokeWidth,
        180,
      );
      final delta = firstOffset - getOffset(r);

      strokeWidth = delta.distance;
    } else {
      strokeWidth = polyline.strokeWidth;
    }

    final isDotted = polyline.isDotted;
    paint = Paint()
      ..strokeWidth = strokeWidth
      ..strokeCap = polyline.strokeCap
      ..strokeJoin = polyline.strokeJoin
      ..style = isDotted ? PaintingStyle.fill : PaintingStyle.stroke
      ..blendMode = BlendMode.srcOver;

    if (polyline.gradientColors == null) {
      paint.color = polyline.color;
    } else {
      polyline.gradientColors!.isNotEmpty
          ? paint.shader = _paintGradient(polyline, offsets)
          : paint.color = polyline.color;
    }

    if (polyline.borderColor != null && polyline.borderStrokeWidth > 0.0) {
      // Outlined lines are drawn by drawing a thicker path underneath, then
      // stenciling the middle (in case the line fill is transparent), and
      // finally drawing the line fill.
      borderPaint = Paint()
        ..color = polyline.borderColor ?? const Color(0x00000000)
        ..strokeWidth = strokeWidth + polyline.borderStrokeWidth
        ..strokeCap = polyline.strokeCap
        ..strokeJoin = polyline.strokeJoin
        ..style = isDotted ? PaintingStyle.fill : PaintingStyle.stroke
        ..blendMode = BlendMode.srcOver;

      filterPaint = Paint()
        ..color = polyline.borderColor!.withAlpha(255)
        ..strokeWidth = strokeWidth
        ..strokeCap = polyline.strokeCap
        ..strokeJoin = polyline.strokeJoin
        ..style = isDotted ? PaintingStyle.fill : PaintingStyle.stroke
        ..blendMode = BlendMode.dstOut;
    }

    final radius = paint.strokeWidth / 2;
    final borderRadius = (borderPaint?.strokeWidth ?? 0) / 2;

    if (isDotted) {
      final spacing = strokeWidth * 1.5;
      if (borderPaint != null && filterPaint != null) {
        _paintDottedLine(borderPath, offsets, borderRadius, spacing);
        _paintDottedLine(filterPath, offsets, radius, spacing);
      }
      _paintDottedLine(path, offsets, radius, spacing);
    } else {
      if (borderPaint != null && filterPaint != null) {
        _paintLine(borderPath, offsets);
        _paintLine(filterPath, offsets);
      }
      _paintLine(path, offsets);
    }

    drawPaths();
  }

  void _paintDottedLine(
      ui.Path path, List<Offset> offsets, double radius, double stepLength) {
    var startDistance = 0.0;
    for (var i = 0; i < offsets.length - 1; i++) {
      final o0 = offsets[i];
      final o1 = offsets[i + 1];
      final totalDistance = (o0 - o1).distance;
      var distance = startDistance;
      while (distance < totalDistance) {
        final f1 = distance / totalDistance;
        final f0 = 1.0 - f1;
        final offset = Offset(o0.dx * f0 + o1.dx * f1, o0.dy * f0 + o1.dy * f1);
        path.addOval(Rect.fromCircle(center: offset, radius: radius));
        distance += stepLength;
      }
      startDistance = distance < totalDistance
          ? stepLength - (totalDistance - distance)
          : distance - totalDistance;
    }
    path.addOval(Rect.fromCircle(center: offsets.last, radius: radius));
  }

  void _paintLine(ui.Path path, List<Offset> offsets) {
    if (offsets.isEmpty) {
      return;
    }
    path.addPolygon(offsets, false);
  }

  ui.Gradient _paintGradient(Polyline polyline, List<Offset> offsets) =>
      ui.Gradient.linear(offsets.first, offsets.last, polyline.gradientColors!,
          _getColorsStop(polyline));

  List<double>? _getColorsStop(Polyline polyline) =>
      (polyline.colorsStop != null &&
              polyline.colorsStop!.length == polyline.gradientColors!.length)
          ? polyline.colorsStop
          : _calculateColorsStop(polyline);

  List<double> _calculateColorsStop(Polyline polyline) {
    final colorsStopInterval = 1.0 / polyline.gradientColors!.length;
    return polyline.gradientColors!
        .map((gradientColor) =>
            polyline.gradientColors!.indexOf(gradientColor) *
            colorsStopInterval)
        .toList();
  }

  @override
  bool shouldRepaint(AriMapPolylinePainter oldDelegate) {
    bool render =
        oldDelegate.bounds != bounds || oldDelegate.hash != hash || isRendering;
    return render;
  }
}

Polyline converToPolyline(AriMapPolyline polyline) {
  return Polyline(
    points: polyline.points,
    strokeWidth: polyline.strokeWidth,
    color: polyline.color,
    borderColor: polyline.borderColor,
    borderStrokeWidth: polyline.borderStrokeWidth,
    useStrokeWidthInMeter: polyline.useStrokeWidthInMeter,
  );
}

Polyline converToPolylineWithSelected(AriMapPolyline polyline) {
  return Polyline(
    points: polyline.points,
    strokeWidth: polyline.selectedStrokeWidth,
    color: polyline.selectedColor,
    borderColor: polyline.selectedBorderColor,
    borderStrokeWidth: polyline.selectedBorderStrokeWidth,
    useStrokeWidthInMeter: polyline.useStrokeWidthInMeter,
  );
}
