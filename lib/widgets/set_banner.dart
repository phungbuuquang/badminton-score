import 'package:flutter/material.dart';

class SetBanner extends StatelessWidget {
  final int setIndex;
  final List<(int,int)> history; // (a,b)
  final String setLabel; // already formatted i18n string
  const SetBanner({super.key, required this.setIndex, required this.history, required this.setLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Text(setLabel, style: Theme.of(context).textTheme.titleLarge),
          const Spacer(),
          Wrap(
            spacing: 10,
            children: [
              for (final s in history)
                Chip(label: Text('${s.$1} : ${s.$2}')),
            ],
          )
        ],
      ),
    );
  }
}
