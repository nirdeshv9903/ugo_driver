import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';
import '../../../../domain/models/walletpage_model.dart';

class WalletHistoryDataWidget extends StatelessWidget {
  final BuildContext cont;
  final List<WalletHistoryData> walletHistoryList;
  const WalletHistoryDataWidget(
      {super.key, required this.cont, required this.walletHistoryList});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<AccBloc>(),
      child: BlocBuilder<AccBloc, AccState>(
        builder: (context, state) {
          return walletHistoryList.isNotEmpty
              ? Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: RawScrollbar(
                    radius: const Radius.circular(20),
                    child: ListView.builder(
                      shrinkWrap: true,
                      // reverse: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: walletHistoryList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              width: size.width,
                              height: size.width * 0.175,
                              margin:
                                  EdgeInsets.only(bottom: size.width * 0.030),
                              padding: EdgeInsets.all(size.width * 0.025),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 0.5,
                                    color: Theme.of(context)
                                        .primaryColorDark
                                        .withAlpha((0.5 * 255).toInt())),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: size.width * 0.15,
                                    width: size.width * 0.125,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).dividerColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: (walletHistoryList[index].remarks ==
                                            'Money Deposited')
                                        ? Image.asset(
                                            AppImages.moneyDeposited,
                                            fit: BoxFit.contain,
                                            width: size.width * 0.065,
                                            color: AppColors.black,
                                          )
                                        : Image.asset(
                                            AppImages.moneyTransfered,
                                            fit: BoxFit.contain,
                                            width: size.width * 0.065,
                                            color: AppColors.black,
                                          ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.025,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MyText(
                                            text: walletHistoryList[index]
                                                .remarks,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),
                                        MyText(
                                            text: walletHistoryList[index]
                                                .createdAt,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .disabledColor)),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MyText(
                                          text: (walletHistoryList[index]
                                                      .isCredit ==
                                                  0)
                                              ? '- '
                                              : '+ ',
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color:
                                                      (walletHistoryList[index]
                                                                  .isCredit ==
                                                              0)
                                                          ? AppColors.red
                                                          : AppColors.green,
                                                  fontWeight: FontWeight.w600)),
                                      MyText(
                                          text: walletHistoryList[index]
                                              .amount
                                              .toString(),
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color:
                                                      (walletHistoryList[index]
                                                                  .isCredit ==
                                                              0)
                                                          ? AppColors.red
                                                          : AppColors.green,
                                                  fontWeight: FontWeight.w600)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImages.walletNoData,
                          height: size.width * 0.6,
                          width: 200,
                        ),
                        const SizedBox(height: 10),
                        MyText(
                          text: AppLocalizations.of(context)!.noPaymentHistory,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Theme.of(context).disabledColor),
                        ),
                        MyText(
                          text: AppLocalizations.of(context)!.bookingRideText,
                          textStyle:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context).disabledColor,
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
