import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';

class OtpBoxes extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String) onCompleted;

  const OtpBoxes({
    required this.controller,
    required this.focusNode,
    required this.onCompleted,
  });

  @override
  State<OtpBoxes> createState() => _OtpBoxesState();
}

class _OtpBoxesState extends State<OtpBoxes>
    with SingleTickerProviderStateMixin {
  late AnimationController _cursorController;

  @override
  void initState() {
    super.initState();
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.focusNode.requestFocus(),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: widget.controller,
            builder: (_, __) {
              final v = widget.controller.text;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) {
                  final ch = i < v.length ? v[i] : '';
                  final isActive = i == v.length && v.length < 6;
                  final isCurrentBox = i == v.length && v.length < 6;
                  final showCursor = isCurrentBox && widget.focusNode.hasFocus;
                  return Container(
                    width: 50,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFEFEF),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: isActive
                            ? AnansiColors.darkBlue
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          ch,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        if (showCursor)
                          Opacity(
                            opacity: _cursorController.value,
                            child: Container(
                              width: 2,
                              height: 24,
                              color: Colors.black,
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              );
            },
          ),
          Opacity(
            opacity: 0.0,
            child: SizedBox(
              height: 64,
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                ),
                onChanged: (v) {
                  final onlyDigits = v.replaceAll(RegExp(r'[^0-9]'), '');
                  if (onlyDigits != v) {
                    widget.controller.value = widget.controller.value.copyWith(
                      text: onlyDigits,
                      selection: TextSelection.collapsed(
                        offset: onlyDigits.length,
                      ),
                    );
                  }
                  if (onlyDigits.length == 6) widget.onCompleted(onlyDigits);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
