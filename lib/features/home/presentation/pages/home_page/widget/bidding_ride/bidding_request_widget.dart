import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appzeto_taxi_driver/common/common.dart';
import 'package:appzeto_taxi_driver/common/pickup_icon.dart';
import 'package:appzeto_taxi_driver/core/model/user_detail_model.dart';
import 'package:appzeto_taxi_driver/core/utils/custom_button.dart';
import 'package:appzeto_taxi_driver/core/utils/custom_text.dart';
import 'package:appzeto_taxi_driver/features/home/application/home_bloc.dart';
import 'package:appzeto_taxi_driver/l10n/app_localizations.dart';

class BiddingRequestWidget extends StatelessWidget {
  final BuildContext cont;
  const BiddingRequestWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<HomeBloc>(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (context.read<HomeBloc>().bidRideAmount.text.isEmpty &&
              context.read<HomeBloc>().rideList.isNotEmpty) {
            context.read<HomeBloc>().bidRideAmount.text =
                '${context.read<HomeBloc>().rideList.firstWhere((e) => e['request_id'] == context.read<HomeBloc>().choosenRide)['price']}';
          }

          List stops = [];
          if (context.read<HomeBloc>().rideList.isNotEmpty &&
              context.read<HomeBloc>().rideList.firstWhere((e) =>
                      e['request_id'] ==
                      context.read<HomeBloc>().choosenRide)['trip_stops'] !=
                  'null') {
            stops = jsonDecode(context.read<HomeBloc>().rideList.firstWhere(
                (e) =>
                    e['request_id'] ==
                    context.read<HomeBloc>().choosenRide)['trip_stops']);
          }
          double total = double.parse(context
              .read<HomeBloc>()
              .rideList
              .firstWhere((e) =>
                  e['request_id'] ==
                  context.read<HomeBloc>().choosenRide)['base_price']);
          double lowPercentage = double.parse(userData!.biddingLowPercentage);
          double highPercentage = double.parse(userData!.biddingHighPercentage);

          context.read<HomeBloc>().maxFare =
              (total + ((highPercentage / 100) * total));
          context.read<HomeBloc>().minFare =
              (total - ((lowPercentage / 100) * total));
          return Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: Column(
              children: [
                SizedBox(height: size.width * 0.05),
                Container(
                  width: size.width * 0.9,
                  padding: EdgeInsets.all(size.width * 0.05),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context)
                        .hintColor
                        .withAlpha((0.5 * 255).toInt()),
                    border: Border.all(
                        color: Theme.of(context).disabledColor.withAlpha(100)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: size.width * 0.128,
                        height: size.width * 0.128,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(context
                                  .read<HomeBloc>()
                                  .rideList
                                  .firstWhere((e) =>
                                      e['request_id'] ==
                                      context
                                          .read<HomeBloc>()
                                          .choosenRide)['user_img']),
                              fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              text: context
                                  .read<HomeBloc>()
                                  .rideList
                                  .firstWhere((e) =>
                                      e['request_id'] ==
                                      context
                                          .read<HomeBloc>()
                                          .choosenRide)['user_name'],
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context).primaryColorDark,
                                      fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 12.5,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    MyText(
                                      text:
                                          '${context.read<HomeBloc>().rideList.firstWhere((e) => e['request_id'] == context.read<HomeBloc>().choosenRide)['ratings']}',
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                if (context
                                            .read<HomeBloc>()
                                            .rideList
                                            .firstWhere((e) =>
                                                e['request_id'] ==
                                                context
                                                    .read<HomeBloc>()
                                                    .choosenRide)[
                                        'completed_ride_count'] !=
                                    '0')
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(width: 5),
                                      Container(
                                        width: 1,
                                        height: 20,
                                        color: Theme.of(context)
                                            .disabledColor
                                            .withAlpha((0.5 * 255).toInt()),
                                      ),
                                      const SizedBox(width: 5),
                                      MyText(
                                        text:
                                            '${context.read<HomeBloc>().rideList.firstWhere((e) => e['request_id'] == context.read<HomeBloc>().choosenRide)['completed_ride_count']} ${AppLocalizations.of(context)!.tripsDoneText}',
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                                fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          MyText(
                            text: AppLocalizations.of(context)!.rideFare,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context).primaryColorDark,
                                    fontWeight: FontWeight.bold),
                          ),
                          MyText(
                            text:
                                '${context.read<HomeBloc>().rideList.firstWhere((e) => e['request_id'] == context.read<HomeBloc>().choosenRide)['currency']} ${context.read<HomeBloc>().rideList.firstWhere((e) => e['request_id'] == context.read<HomeBloc>().choosenRide)['price']}',
                            textStyle: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(
                                    color: AppColors.green,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: size.width * 0.03),
                SizedBox(
                  height:(context
                      .read<HomeBloc>()
                            .rideList
                            .firstWhere((e) =>
                                e['request_id'] ==
                                context.read<HomeBloc>().choosenRide)['transport_type']
                            .toString() ==
                        'delivery') ? stops.length > 1
                  ? size.height * 0.25
                  : null : null,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                    width: size.width * 0.8,
                    child: Row(
                      children: [
                        Container(
                          height: size.width * 0.05,
                          width: size.width * 0.05,
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: Container(
                            height: size.width * 0.05,
                            width: size.width * 0.05,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: AppColors.primary),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.025,
                        ),
                        Expanded(
                            child: MyText(
                          text: context.read<HomeBloc>().rideList.firstWhere(
                              (e) =>
                                  e['request_id'] ==
                                  context
                                      .read<HomeBloc>()
                                      .choosenRide)['pick_address'],
                          maxLines: 2,            
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                        ))
                      ],
                    ),
                    ),
                    if ((context
                      .read<HomeBloc>()
                            .rideList
                            .firstWhere((e) =>
                                e['request_id'] ==
                                context.read<HomeBloc>().choosenRide)['transport_type']
                            .toString() ==
                        'delivery') && context
                            .read<HomeBloc>()
                            .rideList
                            .firstWhere((e) =>
                                e['request_id'] ==
                                context.read<HomeBloc>().choosenRide)['pick_poc_instruction']
                            .toString().isNotEmpty)...[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: size.width * 0.02),
                          SizedBox(
                            width: size.width * 0.8,
                            child: MyText(
                              text:
                                  '${AppLocalizations.of(context)!.instruction}: ',
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: size.width * 0.01),
                          SizedBox(
                            width: size.width * 0.8,
                            child: MyText(
                                text: context
                                      .read<HomeBloc>()
                                      .rideList
                                      .firstWhere((e) =>
                                          e['request_id'] ==
                                          context.read<HomeBloc>().choosenRide)['pick_poc_instruction'],
                                maxLines: 5,
                                textStyle: Theme.of(context).textTheme.bodySmall),
                          ),
                        ],
                      ),
                      SizedBox(height: size.width * 0.01),
                    ], 
                    (stops.isEmpty)
                      ? Column(
                          children: [
                            SizedBox(
                              height: size.width * 0.03,
                            ),
                            SizedBox(
                              width: size.width * 0.8,
                              child: Row(
                                children: [
                                  const DropIcon(),
                                  SizedBox(
                                    width: size.width * 0.025,
                                  ),
                                  Expanded(
                                      child: MyText(
                                    text: context
                                        .read<HomeBloc>()
                                        .rideList
                                        .firstWhere((e) =>
                                            e['request_id'] ==
                                            context
                                                .read<HomeBloc>()
                                                .choosenRide)['drop_address'],
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                  ))
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            for (var i = 0; i < stops.length; i++)
                              Column(
                                children: [
                                  SizedBox(height: size.width * 0.03),
                                  SizedBox(
                                    width: size.width * 0.8,
                                    child: Row(
                                      children: [
                                        const DropIcon(),
                                        SizedBox(
                                          width: size.width * 0.025,
                                        ),
                                        Expanded(
                                            child: MyText(
                                          text: stops[i]['address'],
                                          maxLines: 2,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                        ))
                                      ],
                                    ),
                                  ),
                                  if ((context
                                          .read<HomeBloc>()
                                          .rideList
                                          .firstWhere((e) =>
                                              e['request_id'] ==
                                              context.read<HomeBloc>().choosenRide)['transport_type']
                                          .toString() ==
                                      'delivery') && stops[i]['poc_instruction'].toString().isNotEmpty)...[
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: size.width * 0.02),
                                        SizedBox(
                                          width: size.width * 0.8,
                                          child: MyText(
                                            text:
                                                '${AppLocalizations.of(context)!.instruction}: ',
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(height: size.width * 0.01),
                                        SizedBox(
                                          width: size.width * 0.8,
                                          child: MyText(
                                              text: stops[i]['poc_instruction'],
                                              maxLines: 5,
                                              textStyle: Theme.of(context).textTheme.bodySmall),
                                        ),
                                      ],
                                    ),
                                  ], 
                                ],
                              )
                          ],
                        ),
                                    SizedBox(height: size.width * 0.038),
                                    if (context
                          .read<HomeBloc>()
                          .rideList
                          .firstWhere((e) =>
                              e['request_id'] ==
                              context.read<HomeBloc>().choosenRide)['goods']
                          .toString() !=
                      'null')
                    Column(
                      children: [
                        SizedBox(
                          width: size.width * 0.8,
                          child: MyText(
                            text:
                                '${context.read<HomeBloc>().rideList.firstWhere((e) => e['request_id'] == context.read<HomeBloc>().choosenRide)['goods']})',
                            maxLines: 2,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: size.width * 0.038),
                      ],
                    ),
                    if ((context
                          .read<HomeBloc>()
                          .rideList
                          .firstWhere((e) =>
                              e['request_id'] ==
                              context.read<HomeBloc>().choosenRide)['transport_type']
                          .toString() !=
                      'delivery') && context
                          .read<HomeBloc>()
                          .rideList
                          .firstWhere((e) =>
                              e['request_id'] ==
                              context.read<HomeBloc>().choosenRide)['taxi_instruction']
                          .toString().isNotEmpty)...[
                      Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.width * 0.02),
                        SizedBox(
                          width: size.width * 0.8,
                          child: MyText(
                            text:
                                '${AppLocalizations.of(context)!.instruction}: ',
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: size.width * 0.01),
                        SizedBox(
                          width: size.width * 0.8,
                          child: MyText(
                              text: context
                          .read<HomeBloc>()
                          .rideList
                          .firstWhere((e) =>
                              e['request_id'] ==
                              context.read<HomeBloc>().choosenRide)['taxi_instruction']
                          .toString(),
                              maxLines: 5,
                              textStyle: Theme.of(context).textTheme.bodySmall),
                        ),
                      ],
                    ),
                    SizedBox(height: size.width * 0.03),
                                    ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.width * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        if (!context
                            .read<HomeBloc>()
                            .isBiddingDecreaseLimitReach) {
                          context.read<HomeBloc>().add(
                              BiddingIncreaseOrDecreaseEvent(
                                  isIncrease: false));
                        }
                      },
                      child: Container(
                        width: size.width * 0.2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: context
                                    .read<HomeBloc>()
                                    .isBiddingDecreaseLimitReach
                                ? Theme.of(context)
                                    .disabledColor
                                    .withAlpha((0.2 * 255).toInt())
                                : Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.all(size.width * 0.025),
                        child: MyText(
                          text:
                              '-${double.parse(userData!.biddingAmountIncreaseOrDecrease.toString())}',
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: context
                                          .read<HomeBloc>()
                                          .isBiddingDecreaseLimitReach
                                      ? AppColors.black
                                      : AppColors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.3,
                      child: TextField(
                        enabled: true,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: context.read<HomeBloc>().bidRideAmount,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            double typedFare = double.tryParse(value) ?? 0.0;

                            if (typedFare < context.read<HomeBloc>().minFare!) {
                              context
                                  .read<HomeBloc>()
                                  .isBiddingDecreaseLimitReach = true;
                              context
                                  .read<HomeBloc>()
                                  .isBiddingIncreaseLimitReach = false;
                            } else if (typedFare >
                                context.read<HomeBloc>().maxFare!) {
                              context
                                  .read<HomeBloc>()
                                  .isBiddingIncreaseLimitReach = true;
                              context
                                  .read<HomeBloc>()
                                  .isBiddingDecreaseLimitReach = false;
                            } else {
                              context
                                  .read<HomeBloc>()
                                  .isBiddingIncreaseLimitReach = false;
                              context
                                  .read<HomeBloc>()
                                  .isBiddingDecreaseLimitReach = false;
                            }
                          }
                        },
                        decoration: InputDecoration(
                          hintText: context.read<HomeBloc>().acceptedRideFare,
                          border: const UnderlineInputBorder(
                              borderSide: BorderSide()),
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (!context
                            .read<HomeBloc>()
                            .isBiddingIncreaseLimitReach) {
                          context.read<HomeBloc>().add(
                              BiddingIncreaseOrDecreaseEvent(isIncrease: true));
                        }
                      },
                      child: Container(
                        width: size.width * 0.2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: context
                                    .read<HomeBloc>()
                                    .isBiddingIncreaseLimitReach
                                ? Theme.of(context)
                                    .disabledColor
                                    .withAlpha((0.2 * 255).toInt())
                                : Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.all(size.width * 0.025),
                        child: MyText(
                          text:
                              '+${double.parse(userData!.biddingAmountIncreaseOrDecrease.toString())}',
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: context
                                          .read<HomeBloc>()
                                          .isBiddingIncreaseLimitReach
                                      ? AppColors.black
                                      : AppColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.width * 0.05),
                SizedBox(
                  width: size.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomButton(
                        buttonName: AppLocalizations.of(context)!.accept,
                        onTap: () {
                          if ((!context
                                      .read<HomeBloc>()
                                      .isBiddingIncreaseLimitReach &&
                                  !context
                                      .read<HomeBloc>()
                                      .isBiddingDecreaseLimitReach) ||
                              (context
                                      .read<HomeBloc>()
                                      .isBiddingDecreaseLimitReach &&
                                  (double.parse(context
                                          .read<HomeBloc>()
                                          .bidRideAmount
                                          .text) >=
                                      context.read<HomeBloc>().minFare!)) ||
                              (context
                                      .read<HomeBloc>()
                                      .isBiddingIncreaseLimitReach &&
                                  (double.parse(context
                                          .read<HomeBloc>()
                                          .bidRideAmount
                                          .text) <=
                                      context.read<HomeBloc>().maxFare!))) {
                            context.read<HomeBloc>().add(AcceptBidRideEvent(
                                id: context.read<HomeBloc>().choosenRide!));
                          } else {
                            showModalBottomSheet(
                              context: context,
                              isDismissible: true,
                              isScrollControlled: true,
                              enableDrag: false,
                              elevation: 0,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.0),
                                ),
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              builder: (_) {
                                return BlocProvider.value(
                                  value: context.read<HomeBloc>(),
                                  child: Container(
                                    width: size.width,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(height: size.width * 0.1),
                                          MyText(
                                            text: ((double.parse(context
                                                            .read<HomeBloc>()
                                                            .bidRideAmount
                                                            .text) >=
                                                        context
                                                            .read<HomeBloc>()
                                                            .minFare!) ==
                                                    false)
                                                ? '${AppLocalizations.of(context)!.minimumRideFareError} (${userData!.currencySymbol} ${context.read<HomeBloc>().minFare!.toStringAsFixed(2)})'
                                                : '${AppLocalizations.of(context)!.maximumRideFareError} (${userData!.currencySymbol} ${context.read<HomeBloc>().maxFare!.toStringAsFixed(2)})',
                                            maxLines: 3,
                                            textAlign: TextAlign.center,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error),
                                          ),
                                          SizedBox(height: size.width * 0.1),
                                          CustomButton(
                                            width: size.width,
                                            buttonName:
                                                AppLocalizations.of(context)!
                                                    .ok,
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          SizedBox(height: size.width * 0.1),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                        width: size.width * 0.41,
                        buttonColor: AppColors.green,
                      ),
                      CustomButton(
                        buttonName: AppLocalizations.of(context)!.decline,
                        onTap: () {
                          context.read<HomeBloc>().add(DeclineBidRideEvent(
                              id: context.read<HomeBloc>().choosenRide!));
                        },
                        width: size.width * 0.41,
                        buttonColor: AppColors.red,
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
