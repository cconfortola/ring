import 'package:flutter/material.dart';
import 'package:ring/colors.dart';
import 'package:ring/widgets/ring_button.dart';

import 'package:easy_localization/easy_localization.dart';

class RingOverlay extends StatefulWidget {
  final Function(int) onSubmit;

  RingOverlay(this.onSubmit);

  @override
  _RingOverlayState createState() => _RingOverlayState();
}

class _RingOverlayState extends State<RingOverlay> {
  var _value;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 26),
          width: double.infinity,
          decoration: BoxDecoration(
              color: RingColors.of(context).background,
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'remainingRingsTitle'.tr(),
                style: TextStyle(
                  color: RingColors.of(context).textHeading,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'remainingRings'.tr(),
                style: TextStyle(
                  color: RingColors.of(context).text,
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RingOverlaySelect(
                    '1',
                    isActive: _value == 0,
                    onPressed: () {
                      setState(() {
                        _value = 0;
                      });
                    },
                  ),
                  RingOverlaySelect(
                    '2',
                    isActive: _value == 1,
                    onPressed: () {
                      setState(() {
                        _value = 1;
                      });
                    },
                  ),
                  RingOverlaySelect(
                    '3',
                    isActive: _value == 2,
                    onPressed: () {
                      setState(() {
                        _value = 2;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RingButton(
                    'confirmButton'.tr(),
                    onPressed: () => widget.onSubmit(_value),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RingOverlaySelect extends StatelessWidget {
  final String label;
  final bool isActive;
  final Function onPressed;

  RingOverlaySelect(
    this.label, {
    this.isActive,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18),
        width: (MediaQuery.of(context).size.width - 64 - 32 - 32) / 3,
        decoration: BoxDecoration(
          color: isActive
              ? RingColors.of(context).primary
              : RingColors.of(context).backgroundAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive
                  ? RingColors.of(context).textContrast
                  : RingColors.of(context).text,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
