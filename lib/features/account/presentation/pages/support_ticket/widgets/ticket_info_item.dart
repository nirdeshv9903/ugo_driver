import 'package:flutter/material.dart';
import 'package:appzeto_taxi_driver/core/utils/custom_text.dart';

class TicketInfoItem extends StatelessWidget {
  final String title;
  final String value;

  const TicketInfoItem({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: title,
          textStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Theme.of(context).disabledColor),
        ),
        MyText(
          text: value,
          textStyle: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).primaryColorDark),
        ),
      ],
    );
  }
}
