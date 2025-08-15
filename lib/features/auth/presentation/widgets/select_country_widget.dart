import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/auth_bloc.dart';
import '../../domain/models/country_list_model.dart';

class SelectCountryWidget extends StatelessWidget {
  final BuildContext cont;
  final List<Country> countries;
  const SelectCountryWidget({super.key, required this.cont, required this.countries});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(value: cont.read<AuthBloc>(),
    child: BlocBuilder<AuthBloc,AuthState>(builder: (context, state) {
      return SafeArea(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            height: size.height * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(width: 10),
                      MyText(
                        text: AppLocalizations.of(context)!.selectCountry,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: MyText(
                          text: AppLocalizations.of(context)!.cancel,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: Theme.of(context).primaryColorDark,
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomTextField(
                    controller: context.read<AuthBloc>().searchController,
                    borderRadius: 10,
                    onChange: (p0) => context.read<AuthBloc>().add(AuthUpdateEvent()),
                    onSubmitted: (p0) => context.read<AuthBloc>().add(AuthUpdateEvent()),
                    suffixConstraints:
                        BoxConstraints(maxWidth: size.width * 0.1),
                    suffixIcon: InkWell(
                      onTap: () {
                        context.read<AuthBloc>().searchController.clear();
                        context.read<AuthBloc>().add(AuthUpdateEvent());
                      },
                      child: Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.cancel_outlined,
                            color: Theme.of(context).hintColor,
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: size.height * 0.75,
                  child: ListView.builder(
                    itemCount: countries.length,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (con, index) {
                      var countryData = countries.elementAt(index);
                      if (countryData.name.toLowerCase().toString().contains(
                              context
                                  .read<AuthBloc>()
                                  .searchController
                                  .text
                                  .toLowerCase()
                                  .toString()) ||
                          countryData.dialCode.toString().contains(context
                              .read<AuthBloc>()
                              .searchController
                              .text
                              .toString())) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          child: InkWell(
                            onTap: () {
                                context.read<AuthBloc>().dialCode =
                                    countryData.dialCode;
                                context.read<AuthBloc>().countryCode = 
                                    countryData.code;    
                                context.read<AuthBloc>().dialMaxLength =
                                    countryData.dialMaxLength;
                                context.read<AuthBloc>().flagImage =
                                    countryData.flag!;
                              context.read<AuthBloc>().searchController.clear();
                              context.read<AuthBloc>().add(AuthUpdateEvent());
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                Container(
                                  height: 20,
                                  width: 30,
                                  margin: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: AppColors.darkGrey,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: CachedNetworkImage(
                                      imageUrl: countryData.flag!,
                                      width: 30,
                                      height: 20,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                        child: Text(
                                          "",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: size.width * 0.7,
                                  child: MyText(
                                    text: countryData.name,
                                    maxLines: 2,
                                  ),
                                ),
                                const Spacer(),
                                MyText(text: countryData.dialCode),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      
    },),);
  }
}