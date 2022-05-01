import 'package:flutter/material.dart';
import 'package:jayx_keep/constants.dart';

// ignore: must_be_immutable
class LabelSelectorDialog extends StatelessWidget {
  final double deviceWidth;
  int selectedLabel;
  final Function changeLabelCallback;
  LabelSelectorDialog(
      {Key? key,
      required this.selectedLabel,
      required this.deviceWidth,
      required this.changeLabelCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Note Label',
        style: TextStyle(fontSize: 20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ColoredLabelWidget(
                callbackFunction: changeLabelCallback,
                labelCallbackIndex: 0,
                labelColor: kLabelToColor[0]!,
                showBorder: selectedLabel == 0 ? true : false,
              ),
              ColoredLabelWidget(
                callbackFunction: changeLabelCallback,
                labelCallbackIndex: 1,
                labelColor: kLabelToColor[1]!,
                showBorder: selectedLabel == 1 ? true : false,
              ),
              ColoredLabelWidget(
                callbackFunction: changeLabelCallback,
                labelCallbackIndex: 2,
                labelColor: kLabelToColor[2]!,
                showBorder: selectedLabel == 2 ? true : false,
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ColoredLabelWidget(
                callbackFunction: changeLabelCallback,
                labelCallbackIndex: 3,
                labelColor: kLabelToColor[3]!,
                showBorder: selectedLabel == 3 ? true : false,
              ),
              ColoredLabelWidget(
                callbackFunction: changeLabelCallback,
                labelCallbackIndex: 4,
                labelColor: kLabelToColor[4]!,
                showBorder: selectedLabel == 4 ? true : false,
              ),
              ColoredLabelWidget(
                callbackFunction: changeLabelCallback,
                labelCallbackIndex: 5,
                labelColor: kLabelToColor[5]!,
                showBorder: selectedLabel == 5 ? true : false,
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ColoredLabelWidget(
                callbackFunction: changeLabelCallback,
                labelCallbackIndex: 6,
                labelColor: kLabelToColor[6]!,
                showBorder: selectedLabel == 6 ? true : false,
              ),
              ColoredLabelWidget(
                callbackFunction: changeLabelCallback,
                labelCallbackIndex: 7,
                labelColor: kLabelToColor[7]!,
                showBorder: selectedLabel == 7 ? true : false,
              ),
              ColoredLabelWidget(
                callbackFunction: changeLabelCallback,
                labelCallbackIndex: 8,
                labelColor: kLabelToColor[8]!,
                showBorder: selectedLabel == 8 ? true : false,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ColoredLabelWidget extends StatelessWidget {
  final Function callbackFunction;
  final Color labelColor;
  final int labelCallbackIndex;
  final bool showBorder;
  const ColoredLabelWidget(
      {Key? key,
      required this.labelColor,
      required this.labelCallbackIndex,
      required this.showBorder,
      required this.callbackFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        callbackFunction(labelCallbackIndex);
        Navigator.pop(context);
      },
      child: Container(
        height: width * 0.1,
        width: width * 0.1,
        decoration: BoxDecoration(
          color: labelColor,
          borderRadius: BorderRadius.circular(width),
          border: this.showBorder
              ? Border.all(color: Colors.blueGrey, width: 5)
              : null,
        ),
      ),
    );
  }
}
