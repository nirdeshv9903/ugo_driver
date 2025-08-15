import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:appzeto_taxi_driver/core/model/user_detail_model.dart';
import 'package:appzeto_taxi_driver/features/driverprofile/presentation/pages/driver_profile_pages.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/presentation/pages/home_page/page/home_page.dart';
import '../../../loading/application/loading_bloc.dart';
import '../../application/auth_bloc.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';

class VerifyPage extends StatefulWidget {
  static const String routeName = '/verifyPage';
  final VerifyArguments arg;
  const VerifyPage({super.key, required this.arg});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage>
    with SingleTickerProviderStateMixin {
  Timer? timer;
  timerCount(BuildContext cont,
      {required int duration, bool? isCloseTimer}) async {
    int count = duration;

    if (isCloseTimer == null) {
      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        count--;
        if (count <= 0) {
          timer?.cancel();
        }
        cont.read<AuthBloc>().add(VerifyTimerEvent(duration: count));
      });
    }

    if (isCloseTimer != null && isCloseTimer) {
      timer?.cancel();
      cont.read<AuthBloc>().add(VerifyTimerEvent(duration: 0));
    }
  }

  @override
  void dispose() {
    if (timer != null) {
      timer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()
        ..add(GetDirectionEvent())
        ..add(GetCommonModuleEvent())
        ..add(VerifyPageInitEvent(arg: widget.arg)),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitialState) {
            CustomLoader.loader(context);
          } else if (state is AuthDataLoadingState) {
            CustomLoader.loader(context);
          } else if (state is AuthDataLoadedState) {
            CustomLoader.dismiss(context);
          } else if (state is AuthDataSuccessState) {
            CustomLoader.dismiss(context);
            if (!widget.arg.userExist && widget.arg.isOtpVerify) {
              context.read<AuthBloc>().add(
                    SignInWithOTPEvent(
                      isOtpVerify: widget.arg.isOtpVerify,
                      isForgotPassword: false,
                      mobileOrEmail: widget.arg.mobileOrEmail,
                      dialCode: widget.arg.dialCode,
                      isLoginByEmail: widget.arg.isLoginByEmail,
                    ),
                  );
              timerCount(context, duration: 60);
            }
          } else if (state is ForgotPasswordOTPSendState) {
            Navigator.pushNamed(
              context,
              ForgotPasswordPage.routeName,
              arguments: ForgotPasswordPageArguments(
                  isLoginByEmail: widget.arg.isLoginByEmail,
                  contryCode: widget.arg.dialCode,
                  countryFlag: widget.arg.countryFlag,
                  emailOrMobile: widget.arg.mobileOrEmail,
                  loginAs: (widget.arg.loginAs == '')
                      ? 'driver'
                      : widget.arg.loginAs),
            );
          } else if (state is NewUserRegisterState) {
            Navigator.pushNamedAndRemoveUntil(
                context,
                RegisterPage.routeName,
                arguments: RegisterPageArguments(
                    isLoginByEmail: widget.arg.isLoginByEmail,
                    dialCode: widget.arg.dialCode,
                    contryCode: widget.arg.countryCode,
                    countryFlag: widget.arg.countryFlag,
                    emailOrMobile: widget.arg.mobileOrEmail,
                    countryList: widget.arg.countryList,
                    loginAs: (widget.arg.loginAs == '')
                        ? 'driver'
                        : widget.arg.loginAs,
                    isRefferalEarnings: widget.arg.isRefferalEarnings),
                (route) => false);
          } else if (state is LoginSuccessState) {
            if (userData != null) {
              context.read<LoaderBloc>().add(UpdateUserLocationEvent());
            }
            if (userData!.serviceLocationId != null) {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomePage.routeName, (route) => false);
            } else {
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  DriverProfilePage.routeName,
                  arguments: VehicleUpdateArguments(
                    from: '',
                  ),
                  (route) => false);
            }
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                body: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primary,
                        AppColors.primaryDark,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        // Header Section
                        Container(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              // Back Button and Title
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: AppColors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const Spacer(),
                                  MyText(
                                    text: context.read<AuthBloc>().isOtpVerify
                                        ? AppLocalizations.of(context)!.enterOtp
                                        : AppLocalizations.of(context)!
                                            .enterYourPassword,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  const Spacer(),
                                  const SizedBox(
                                      width: 48), // Balance the layout
                                ],
                              ),
                              const SizedBox(height: 32),

                              // Icon
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  context.read<AuthBloc>().isOtpVerify
                                      ? Icons.security
                                      : Icons.lock_outline,
                                  color: AppColors.white,
                                  size: 48,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Description Text
                              MyText(
                                text: context.read<AuthBloc>().isOtpVerify
                                    ? (widget.arg.isLoginByEmail
                                        ? AppLocalizations.of(context)!
                                            .otpSentEmail
                                        : AppLocalizations.of(context)!
                                            .otpSentMobile)
                                    : AppLocalizations.of(context)!
                                        .enterYourPassword,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: AppColors.white,
                                      fontSize: 16,
                                    ),
                              ),
                              const SizedBox(height: 16),

                              // Phone/Email Display
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!widget.arg.isLoginByEmail)
                                      Container(
                                        height: 20,
                                        width: 30,
                                        margin: const EdgeInsets.only(right: 8),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: Image.network(
                                            widget.arg.countryFlag,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    MyText(
                                      text: widget.arg.mobileOrEmail,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    const SizedBox(width: 8),
                                    InkWell(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color:
                                              AppColors.white.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: MyText(
                                          text: AppLocalizations.of(context)!
                                              .change,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                color: AppColors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Content Section
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(32),
                                topRight: Radius.circular(32),
                              ),
                            ),
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                children: [
                                  if (widget.arg.userExist &&
                                      !context.read<AuthBloc>().isOtpVerify)
                                    passwordField(context),
                                  if (!widget.arg.userExist ||
                                      context.read<AuthBloc>().isOtpVerify)
                                    buildPinField(context),
                                  const SizedBox(height: 32),
                                  buildLoginButton(context),
                                  const SizedBox(
                                      height: 20), // Extra bottom padding
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget passwordField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and Switch Option
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: AppLocalizations.of(context)!.password,
              textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColors.onSurfaceLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
            InkWell(
              onTap: () {
                context.read<AuthBloc>().isOtpVerify = true;
                context.read<AuthBloc>().add(SignInWithOTPEvent(
                      isOtpVerify: true,
                      isForgotPassword: false,
                      dialCode: widget.arg.dialCode,
                      mobileOrEmail: widget.arg.mobileOrEmail,
                      isLoginByEmail: widget.arg.isLoginByEmail,
                    ));

                timerCount(context, duration: 60);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: MyText(
                  text: AppLocalizations.of(context)!.signUsingOtp,
                  textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w600, color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Password Input Field
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryAccent.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              CustomTextField(
                controller: context.read<AuthBloc>().passwordController,
                filled: false,
                obscureText: !context.read<AuthBloc>().showPassword,
                hintText: AppLocalizations.of(context)!.enterYourPassword,
                suffixIcon: InkWell(
                  onTap: () {
                    context.read<AuthBloc>().add(ShowPasswordIconEvent(
                        showPassword: context.read<AuthBloc>().showPassword));
                  },
                  child: !context.read<AuthBloc>().showPassword
                      ? Icon(
                          Icons.visibility_off_outlined,
                          color: AppColors.grey,
                        )
                      : Icon(
                          Icons.visibility,
                          color: AppColors.grey,
                        ),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
                  context.read<AuthBloc>().add(
                        SignInWithOTPEvent(
                          isOtpVerify: true,
                          isForgotPassword: true,
                          mobileOrEmail: widget.arg.mobileOrEmail,
                          dialCode: widget.arg.dialCode,
                          isLoginByEmail: widget.arg.isLoginByEmail,
                        ),
                      );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: MyText(
                    text: '${AppLocalizations.of(context)!.forgotPassword} ?',
                    textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPinField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and Switch Option
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: AppLocalizations.of(context)!.enterOtp,
              textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColors.onSurfaceLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
            if (widget.arg.userExist &&
                context.read<AuthBloc>().timerDuration == 0)
              InkWell(
                onTap: () {
                  context.read<AuthBloc>().isOtpVerify = false;
                  timerCount(context, duration: 0, isCloseTimer: true);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: MyText(
                    text: AppLocalizations.of(context)!.signUsingPassword,
                    textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 24),

        // OTP Input Field
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryAccent.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              MyText(
                text: AppLocalizations.of(context)!.enterOtp,
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.grey,
                      fontSize: 14,
                    ),
              ),
              const SizedBox(height: 16),
              PinCodeTextField(
                appContext: context,
                controller: context.read<AuthBloc>().otpController,
                textStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                length: 6,
                obscureText: false,
                blinkWhenObscuring: false,
                animationType: AnimationType.scale,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  fieldHeight: 55,
                  fieldWidth: 45,
                  activeFillColor: AppColors.primaryAccent.withOpacity(0.1),
                  inactiveFillColor: AppColors.greyContainerColor,
                  selectedFillColor: AppColors.primaryAccent.withOpacity(0.2),
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.grey,
                  selectedColor: AppColors.primary,
                  selectedBorderWidth: 2,
                  inactiveBorderWidth: 1,
                  activeBorderWidth: 2,
                ),
                cursorColor: AppColors.primary,
                animationDuration: const Duration(milliseconds: 200),
                enableActiveFill: true,
                enablePinAutofill: false,
                autoDisposeControllers: false,
                keyboardType: TextInputType.number,
                beforeTextPaste: (_) => false,
                onChanged: (_) =>
                    context.read<AuthBloc>().add(OTPOnChangeEvent()),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Resend OTP Button
        Center(
          child: InkWell(
            onTap: context.read<AuthBloc>().timerDuration != 0
                ? null
                : () {
                    context.read<AuthBloc>().add(
                          SignInWithOTPEvent(
                            isOtpVerify: true,
                            isForgotPassword: false,
                            dialCode: widget.arg.dialCode,
                            mobileOrEmail: widget.arg.mobileOrEmail,
                            isLoginByEmail: widget.arg.isLoginByEmail,
                          ),
                        );
                    timerCount(context, duration: 60);
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: context.read<AuthBloc>().timerDuration != 0
                    ? AppColors.grey.withOpacity(0.3)
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.read<AuthBloc>().timerDuration != 0
                      ? AppColors.grey
                      : AppColors.primary,
                  width: 1,
                ),
              ),
              child: MyText(
                text: context.read<AuthBloc>().timerDuration != 0
                    ? '${AppLocalizations.of(context)!.resendOtp} 00:${context.read<AuthBloc>().timerDuration}'
                    : AppLocalizations.of(context)!.resendOtp,
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: context.read<AuthBloc>().timerDuration != 0
                          ? AppColors.grey
                          : AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SizedBox(
            width: double.infinity,
            child: CustomButton(
              borderRadius: 10,
              width: double.infinity,
              height: 56, // Fixed height instead of percentage
              buttonName: (!widget.arg.userExist)
                  ? AppLocalizations.of(context)!.signup
                  : AppLocalizations.of(context)!.login,
              isLoader: context.read<AuthBloc>().isLoading,
              onTap: () {
                if (widget.arg.isOtpVerify ||
                    context.read<AuthBloc>().isOtpVerify) {
                  // OTPverify
                  context.read<AuthBloc>().add(
                        ConfirmOrVerifyOTPEvent(
                            isUserExist: widget.arg.userExist,
                            isLoginByEmail: widget.arg.isLoginByEmail,
                            isOtpVerify: context.read<AuthBloc>().isOtpVerify,
                            isForgotPasswordVerify: false,
                            mobileOrEmail: widget.arg.mobileOrEmail,
                            otp: context.read<AuthBloc>().otpController.text,
                            password: context
                                .read<AuthBloc>()
                                .passwordController
                                .text,
                            firebaseVerificationId:
                                context.read<AuthBloc>().firebaseVerificationId,
                            loginAs: widget.arg.loginAs),
                      );
                } else {
                  // PasswordLogin
                  context.read<AuthBloc>().add(LoginUserEvent(
                      emailOrMobile: widget.arg.mobileOrEmail,
                      otp: context.read<AuthBloc>().otpController.text,
                      password:
                          context.read<AuthBloc>().passwordController.text,
                      isOtpLogin: context.read<AuthBloc>().isOtpVerify,
                      isLoginByEmail: widget.arg.isLoginByEmail,
                      loginAs: widget.arg.loginAs));
                }
              },
            ),
          ),
        );
      },
    );
  }
}
