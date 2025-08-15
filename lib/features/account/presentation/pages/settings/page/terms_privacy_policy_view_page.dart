import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:appzeto_taxi_driver/core/utils/custom_appbar.dart';
import 'package:appzeto_taxi_driver/features/account/application/acc_bloc.dart';
import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../l10n/app_localizations.dart';

class TermsPrivacyPolicyViewPage extends StatelessWidget {
  static const String routeName = '/termsPrivacyPolicyViewPage';
  final TermsAndPrivacyPolicyArguments args;
  const TermsPrivacyPolicyViewPage({super.key,required this.args});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => AccBloc()
      ..add(AccGetDirectionEvent())
      ..add(GetHtmlStringEvent(isPrivacy: args.isPrivacyPolicy)),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) async {
          if(state is AccDataLoadingStartState){
            CustomLoader.loader(context);
          }
          if(state is AccDataLoadingStopState){
            CustomLoader.dismiss(context);
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          final accBloc = context.read<AccBloc>();
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: CustomAppBar(
              title: args.isPrivacyPolicy 
                ? AppLocalizations.of(context)!.privacy
                : AppLocalizations.of(context)!.terms,
              automaticallyImplyLeading: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Expanded(
                  //   child: InAppWebView(
                  //       initialUrlRequest: URLRequest(
                  //           url: WebUri(args.url)),
                  //       onLoadStart: (controller, url) {
                  //         context.read<AccBloc>().add(AccDataLoaderShowEvent(showLoader: true));
                  //       },
                  //       onLoadStop: (controller, url) async {
                  //         context.read<AccBloc>().add(AccDataLoaderShowEvent(showLoader: false));
                  //       },
                  //       onPermissionRequest:
                  //           (controller, request) async {
                  //         return PermissionResponse(
                  //           resources: request.resources,
                  //           action: PermissionResponseAction.GRANT,
                  //         );
                  //       },
                  //       ),
                  // ),
                  if(accBloc.htmlString != null)
                  Html(
                    data: accBloc.htmlString,
                  ),
                  SizedBox(height: size.width * 0.1),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
