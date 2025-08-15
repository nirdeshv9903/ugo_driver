// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:appzeto_taxi_driver/common/app_arguments.dart';
import 'package:appzeto_taxi_driver/common/app_colors.dart';
import 'package:appzeto_taxi_driver/common/app_constants.dart';
import 'package:appzeto_taxi_driver/core/utils/custom_button.dart';
import 'package:appzeto_taxi_driver/core/utils/custom_text.dart';
import 'package:appzeto_taxi_driver/features/auth/presentation/pages/user_choose_page.dart';
import 'package:appzeto_taxi_driver/features/loading/application/loading_bloc.dart';
import 'package:appzeto_taxi_driver/l10n/app_localizations.dart';
import '../../../common/app_images.dart';
import '../../auth/presentation/pages/auth_page.dart';
import '../../home/presentation/pages/home_page/page/home_page.dart';
import '../../landing/presentation/page/landing_page.dart';

class LoaderPage extends StatefulWidget {
  static const String routeName = '/loaderPage';

  const LoaderPage({super.key});

  @override
  State<LoaderPage> createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => LoaderBloc()..add(CheckPermissionEvent()),
      child: BlocListener<LoaderBloc, LoaderState>(
        listener: (context, state) {
          if (state is LoaderLocationSuccessState) {
            context.read<LoaderBloc>().add(LoaderGetLocalDataEvent());
          }
          if (state is LoaderSuccessState) {
            WidgetsBinding.instance.addPostFrameCallback(
              (timeStamp) {
                Future.delayed(const Duration(seconds: 2), () {
                  if (!state.loginStatus) {
                    if (state.isOwnerEnabled) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        SelectUserPage.routeName,
                        (route) => false,
                      );
                    } else {
                      if (state.landingStatus) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AuthPage.routeName,
                          arguments: AuthPageArguments(type: 'driver'),
                          (route) => false,
                        );
                      } else {
                        Navigator.pushNamedAndRemoveUntil(
                            context, LandingPage.routeName, (route) => false,
                            arguments: LandingPageArguments(type: 'driver'));
                      }
                    }
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                        context, HomePage.routeName, (route) => false);
                  }
                });
              },
            );
          }
        },
        child: BlocBuilder<LoaderBloc, LoaderState>(
          builder: (context, state) {
            return PopScope(
              canPop: false,
              child: Scaffold(
                backgroundColor:
                    (context.read<LoaderBloc>().locationApproved == null ||
                            context.read<LoaderBloc>().locationApproved == true)
                        ? const Color(0xFF4bbbc7)
                        : Theme.of(context).scaffoldBackgroundColor,
                resizeToAvoidBottomInset: false,
                body: Center(
                  child: (context.read<LoaderBloc>().locationApproved == null ||
                          context.read<LoaderBloc>().locationApproved == true)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Go Peacefully',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dancingScript(
                                fontSize: 48,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                                letterSpacing: 2.0,
                                height: 1.2,
                              ),
                            ),
                            Image.asset(
                              AppImages.loader,
                              width: size.width,
                              height: size.height,
                            ),
                            Text(
                              'I am feel more at ease and in control with is app',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w300,
                                color: Colors.black87,
                                letterSpacing: 1.2,
                              ),
                            )
                          ],
                        )
                      : (context.read<LoaderBloc>().locationApproved == false)
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.locationImage,
                                  width: size.width * 0.9,
                                  height: size.width * 0.9,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(height: size.width * 0.05),
                                SizedBox(
                                  width: size.width * 0.9,
                                  child: MyText(
                                    // text: AppLocalizations.of(context)!
                                    //     .welcomeToName
                                    //     .toString()
                                    //     .replaceAll('1111', AppConstants.title),
                                    text: AppLocalizations.of(context)!
                                        .whyBackgroundLocation,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: size.width * 0.05),
                                SizedBox(
                                  width: size.width * 0.9,
                                  child: MyText(
                                    text: AppLocalizations.of(context)!
                                        .locationPermDesc
                                        .replaceAll('111', AppConstants.title),
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: const Color(0xff847979),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center,
                                    maxLines: 10,
                                  ),
                                ),
                                SizedBox(height: size.width * 0.05),
                                SizedBox(
                                    width: size.width * 0.9,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          AppImages.allowLocationIcon,
                                          width: size.width * 0.05,
                                          fit: BoxFit.contain,
                                        ),
                                        SizedBox(width: size.width * 0.025),
                                        MyText(
                                          text: AppLocalizations.of(context)!
                                              .allowLocation,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: AppColors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )),
                                SizedBox(height: size.width * 0.1),
                                CustomButton(
                                    buttonName: AppLocalizations.of(context)!
                                        .continueText,
                                    onTap: () async {
                                      await Permission.location.request();
                                      await Permission.locationAlways
                                          .request()
                                          .whenComplete(
                                        () async {
                                          context
                                              .read<LoaderBloc>()
                                              .add(LoaderGetLocalDataEvent());
                                        },
                                      );
                                    })
                              ],
                            )
                          : Container(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
