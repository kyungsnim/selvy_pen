import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pencil_field/pencil_field.dart';

/// PencilFieldWithTools supports the following modes
enum _PencilToolType { pen, marker, eraser, undo, clear }

/// [PencilFieldWithTools] provides a complete input field with different
/// tools based on the raw [PencilField].
///
/// Once the user has submitted the drawing is returned via the [onSubmitted]
/// callback
class PencilFieldWithTools extends StatefulWidget {
  const PencilFieldWithTools({
    super.key,
    required this.controller,
    this.onPencilDrawingChanged,
    this.onPencilDrawingCompleted,
  });

  final PencilFieldController controller;
  final OnPencilDrawingChanged? onPencilDrawingChanged;
  final OnPencilDrawingChanged? onPencilDrawingCompleted;

  @override
  State<PencilFieldWithTools> createState() => _PencilFieldWithToolsState();
}

typedef _OnToolSelectedCallback = Function(_PencilToolType, PencilPaint);
typedef _OnPencilDrawingCompletedCallback = Function()?;

class _PencilFieldWithToolsState extends State<PencilFieldWithTools> {
  PencilPaint pencilPaint = PencilPaint(color: Colors.black, strokeWidth: 2.0);
  PencilPaint writingPaint = PencilPaint(color: Colors.black, strokeWidth: 2.0);
  PencilPaint eraserPaint = PencilPaint(color: Colors.red[200]!, strokeWidth: 2.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: const BoxDecoration(
        color: PencilFieldColors.writePadControls,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _PencilFieldTools(
              currentPaint: pencilPaint,
              currentMode: widget.controller.mode,
              onToolSelected: _onToolSelected,
              onPencilDrawingCompleted: _onPencilDrawingCompleted,
            ),
            Container(
              decoration: const BoxDecoration(
                color: PencilFieldColors.paper,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              padding: const EdgeInsets.all(8),
              height: 200, //400,
              child: PencilField(
                controller: widget.controller,
                pencilPaint: pencilPaint,
                onPencilDrawingChanged: widget.onPencilDrawingChanged,
                decoration: PencilDecoration(
                  type: PencilDecorationType.chequered,
                  backgroundColor: PencilFieldColors.paper,
                  // PencilFieldColors.paper,
                  patternColor: PencilFieldColors.paperPattern,
                  hasBorder: true,
                  spacing: 20,
                  strokeWidth: 1.5,
                  //padding: const EdgeInsets.all(10),
                ),
                pencilOnly: kReleaseMode,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onToolSelected(_PencilToolType type, PencilPaint newPaint) {
    setState(() {
      switch (type) {
        case _PencilToolType.pen:
        case _PencilToolType.marker:
          writingPaint = newPaint;
          widget.controller.setMode(PencilMode.write);
          pencilPaint = writingPaint;
          break;
        case _PencilToolType.eraser:
          widget.controller.setMode(PencilMode.erase);
          pencilPaint = eraserPaint;
          break;
        case _PencilToolType.clear:
          widget.controller.setDrawing(PencilDrawing(strokes: []));
          widget.controller.setMode(PencilMode.write);
          pencilPaint = writingPaint;
          widget.onPencilDrawingChanged?.call(widget.controller.drawing);
          break;
        case _PencilToolType.undo:
          widget.controller.undo();
          break;
      }
    });
  }

  _OnPencilDrawingCompletedCallback _onPencilDrawingCompleted() {
    widget.onPencilDrawingCompleted;
    return null;
  }
}

class _PencilFieldTools extends StatelessWidget {
  _PencilFieldTools({
    required this.currentPaint,
    required this.currentMode,
    required this.onToolSelected,
    this.onPencilDrawingCompleted,
  });

  final PencilPaint currentPaint;
  final PencilMode currentMode;
  final _OnToolSelectedCallback onToolSelected;
  final _OnPencilDrawingCompletedCallback onPencilDrawingCompleted;

  final penColors = <Color>[
    PencilFieldColors.ink,
    // PencilFieldColors.pencil,
    // PencilFieldColors.pencilYellow,
    // PencilFieldColors.pencilOrange,
    // PencilFieldColors.pencilRed,
    // PencilFieldColors.pencilPurple,
    // PencilFieldColors.pencilLightBlue,
    // PencilFieldColors.pencilLightGreen,
    // PencilFieldColors.pencilGreen,
    // PencilFieldColors.pencilBrown,
  ];

  final markerColors = <Color>[
    // PencilFieldColors.markerBlue,
    // PencilFieldColors.markerGreen,
    // PencilFieldColors.markerOrange,
    PencilFieldColors.markerYellow,
    // PencilFieldColors.markerPurple,
    // PencilFieldColors.markerRed,
  ];

  final eraserPaint = PencilPaint(
    color: PencilFieldColors.eraser,
    strokeWidth: 2.0,
  );

  @override
  Widget build(BuildContext context) {
    final pens = List<_ToolSelectorButton>.generate(
      penColors.length,
          (index) => _ToolSelectorButton(
        type: _PencilToolType.pen,
        onToolSelected: onToolSelected,
        pencilPaint: PencilPaint(
          color: penColors[index],
          strokeWidth: 3.0,
        ),
        currentPaint: currentPaint,
      ),
    );
    final markers = List<_ToolSelectorButton>.generate(
      markerColors.length,
          (index) => _ToolSelectorButton(
        type: _PencilToolType.marker,
        onToolSelected: onToolSelected,
        pencilPaint: PencilPaint(
          color: markerColors[index],
          strokeWidth: 12.0,
        ),
        currentPaint: currentPaint,
      ),
    );

    return SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ToolSelectorButton(
            type: _PencilToolType.clear,
            pencilPaint:
            PencilPaint(color: PencilFieldColors.red, strokeWidth: 1.0),
            onToolSelected: onToolSelected,
          ),
          Row(children: pens),
          Row(children: markers),
          _ToolSelectorButton(
            type: _PencilToolType.eraser,
            pencilPaint: eraserPaint,
            onToolSelected: onToolSelected,
            currentPaint: currentPaint,
          ),
          _ToolSelectorButton(
            type: _PencilToolType.undo,
            pencilPaint: eraserPaint,
            onToolSelected: onToolSelected,
          ),
          TextButton(
              onPressed: onPencilDrawingCompleted,
              child: Text("입력완료")
          )
        ],
      ),
    );
  }
}

class _ToolSelectorButton extends StatelessWidget {
  const _ToolSelectorButton({
    required this.type,
    required this.onToolSelected,
    required this.pencilPaint,
    this.currentPaint,
  });

  final _PencilToolType type;
  final _OnToolSelectedCallback onToolSelected;
  final PencilPaint pencilPaint;
  final PencilPaint? currentPaint;

  @override
  Widget build(BuildContext context) {
    late Icon icon;
    switch (type) {
      case _PencilToolType.pen:
        icon = Icon(Icons.stacked_bar_chart, color: pencilPaint.paint.color);
        break;
      case _PencilToolType.marker:
        icon = Icon(Icons.highlight, color: pencilPaint.paint.color);
        break;
      case _PencilToolType.eraser:
        icon = Icon(Icons.style_rounded, color: pencilPaint.paint.color);
        break;
      case _PencilToolType.clear:
        icon = Icon(Icons.clear, color: pencilPaint.paint.color);
        break;
      case _PencilToolType.undo:
        icon = Icon(Icons.undo, color: Colors.black);
        break;
    }

    bool isActiveTool = false;
    if (currentPaint != null) {
      if (currentPaint!.paint.color.value == pencilPaint.paint.color.value) {
        isActiveTool = true;
      }
    }
    return IconButton(
      icon: icon,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(
          isActiveTool ? Colors.white : pencilPaint.paint.color,
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          isActiveTool ? pencilPaint.paint.color : PencilFieldColors.paper,
        ),
        overlayColor: MaterialStateProperty.all<Color>(
          isActiveTool
              ? Colors.white.withAlpha(64)
              : pencilPaint.paint.color.withAlpha(64),
        ),
      ),
      onPressed: () => onToolSelected(type, pencilPaint),
    );
  }
}

class PencilFieldColors {
  PencilFieldColors._();

  static const Color ink = Color(0xFF0500FF);
  static const Color pencil = Color(0xCC3C3C3E);
  static const Color green = Color(0xFFA7DF31);
  static const Color yellow = Color(0xFFEADE00);
  static const Color orange = Color(0xFFF3983B);
  static const Color red = Color(0xFFE85476);
  static const Color blue = Color(0xFF4094CF);
  static const Color purple = Color(0xFFBB6BD9);
  static const Color markerGreen = Color(0x80A7DF31);
  static const Color markerYellow = Colors.yellowAccent;//Color(0x80EADE00);
  static const Color markerOrange = Color(0x80F3983B);
  static const Color markerRed = Color(0x80E85476);
  static const Color markerBlue = Color(0x804094CF);
  static const Color markerPurple = Color(0x80BB6BD9);

  static const Color pencilYellow = Color(0xFFCFBF1C);
  static const Color pencilOrange = Color(0xFFDB762C);
  static const Color pencilRed = Color(0xFFE93732);
  static const Color pencilPurple = Color(0xFF9E4FD1);
  static const Color pencilLightBlue = Color(0xFF83E3F7);
  static const Color pencilLightGreen = Color(0xFF7BDC44);
  static const Color pencilGreen = Color(0xFF2F661A);
  static const Color pencilBrown = Color(0xFFB68458);

  static const Color eraser = Color(0xFFEF9A9A);

  static const Color paper = Color(0xFFFFFEF4);
  static const Color transparentPaper = Color(0xFFFFFEF4); //Color(0xCCFFFEF4);
  static const Color paperPattern = Colors.black12;

  static const Color appBarColor = Color(0xFF796E84);
  static const Color writePadBackground = Color(0xFF667D8B);
  static const Color writePadControls = Colors.green; //Color(0xFFB3BDBF);
}