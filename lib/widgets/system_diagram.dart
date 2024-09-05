import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SystemDiagram extends StatelessWidget {
  final Function(String) onComponentClick;

  const SystemDiagram({Key? key, required this.onComponentClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapDown: (TapDownDetails details) {
            final RenderBox box = context.findRenderObject() as RenderBox;
            final localPosition = box.globalToLocal(details.globalPosition);
            final relativeX = localPosition.dx / constraints.maxWidth;
            final relativeY = localPosition.dy / constraints.maxHeight;
            _handleTap(relativeX, relativeY);
          },
          child: SvgPicture.string(
            _svgContent,
            width: constraints.maxWidth,
            height: constraints.maxHeight,
          ),
        );
      },
    );
  }

  void _handleTap(double relativeX, double relativeY) {
    if (relativeY > 0.375 && relativeY < 0.625) {
      if (relativeX < 0.13) onComponentClick('n2gen');
      else if (relativeX < 0.26) onComponentClick('mfc');
      else if (relativeX < 0.54) onComponentClick('frontline_heater');
      else if (relativeX < 0.72) onComponentClick('chamber');
      else if (relativeX < 0.85) onComponentClick('backline_heater');
      else if (relativeX < 0.93) onComponentClick('pc');
      else onComponentClick('pump');
    } else if (relativeY > 0.75 && relativeY < 0.85) {
      if (relativeX > 0.365 && relativeX < 0.405) onComponentClick('v1');
      else if (relativeX > 0.445 && relativeX < 0.485) onComponentClick('v2');
    } else if (relativeY > 0.9) {
      if (relativeX > 0.35 && relativeX < 0.42) onComponentClick('h1');
      else if (relativeX > 0.43 && relativeX < 0.5) onComponentClick('h2');
    }
  }

  // SVG content as a string
  static const _svgContent = '''
<svg viewBox="0 0 1000 400" xmlns="http://www.w3.org/2000/svg">
  <g>
    <path d="M50 200 H950" stroke="#333333" stroke-width="2" fill="none"/>
    <path d="M385 200 V300 M465 200 V300 M385 340 V370 M465 340 V370" stroke="#333333" stroke-width="2" fill="none"/>
  </g>
  <g>
    <g>
      <rect x="50" y="150" width="80" height="100" fill="#ffffff"/>
      <rect x="50" y="150" width="80" height="100" fill="#3498db" fill-opacity="0.2"/>
      <text x="90" y="210" text-anchor="middle" font-size="14" fill="#333333">N2 GEN</text>
    </g>
    <g>
      <rect x="180" y="150" width="80" height="100" fill="#ffffff"/>
      <rect x="180" y="150" width="80" height="100" fill="#3498db" fill-opacity="0.2"/>
      <text x="220" y="210" text-anchor="middle" font-size="14" fill="#333333">MFC</text>
    </g>
    <g>
      <rect x="310" y="150" width="230" height="100" fill="#ffffff"/>
      <rect x="310" y="150" width="230" height="100" fill="#e74c3c" fill-opacity="0.2"/>
      <text x="425" y="210" text-anchor="middle" font-size="14" fill="#333333">Frontline Heater</text>
    </g>
    <g>
      <rect x="590" y="150" width="130" height="100" fill="#ffffff"/>
      <rect x="590" y="150" width="130" height="100" fill="#3498db" fill-opacity="0.2"/>
      <text x="655" y="210" text-anchor="middle" font-size="14" fill="#333333">CHAMBER</text>
    </g>
    <g>
      <rect x="770" y="150" width="80" height="100" fill="#ffffff"/>
      <rect x="770" y="150" width="80" height="100" fill="#e74c3c" fill-opacity="0.2"/>
      <text x="810" y="210" text-anchor="middle" font-size="14" fill="#333333">Back</text>
    </g>
    <g>
      <rect x="880" y="150" width="50" height="100" fill="#ffffff"/>
      <rect x="880" y="150" width="50" height="100" fill="#3498db" fill-opacity="0.2"/>
      <text x="905" y="210" text-anchor="middle" font-size="14" fill="#333333">PC</text>
    </g>
    <g>
      <rect x="950" y="150" width="50" height="100" fill="#ffffff"/>
      <rect x="950" y="150" width="50" height="100" fill="#3498db" fill-opacity="0.2"/>
      <text x="975" y="210" text-anchor="middle" font-size="14" fill="#333333">PU</text>
    </g>
    <g>
      <circle cx="385" cy="320" r="20" fill="#ffffff"/>
      <circle cx="385" cy="320" r="20" fill="#333333" fill-opacity="0.2"/>
      <text x="385" y="325" text-anchor="middle" font-size="12" fill="#333333">V1</text>
    </g>
    <g>
      <circle cx="465" cy="320" r="20" fill="#ffffff"/>
      <circle cx="465" cy="320" r="20" fill="#333333" fill-opacity="0.2"/>
      <text x="465" y="325" text-anchor="middle" font-size="12" fill="#333333">V2</text>
    </g>
    <g>
      <rect x="350" y="370" width="70" height="30" fill="#ffffff"/>
      <rect x="350" y="370" width="70" height="30" fill="#e74c3c" fill-opacity="0.2"/>
      <text x="385" y="390" text-anchor="middle" font-size="12" fill="#333333">H1</text>
    </g>
    <g>
      <rect x="430" y="370" width="70" height="30" fill="#ffffff"/>
      <rect x="430" y="370" width="70" height="30" fill="#e74c3c" fill-opacity="0.2"/>
      <text x="465" y="390" text-anchor="middle" font-size="12" fill="#333333">H2</text>
    </g>
  </g>
</svg>
  ''';
}