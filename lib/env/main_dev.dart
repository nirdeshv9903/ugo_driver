import 'package:flutter/material.dart';
import '../app/app.dart';
import '../common/common.dart';
import 'flavor_config.dart';
import '../common/app_constants.dart';

Future<void> main() async {
  const values = FlavorValues(
    baseUrl: AppConstants.baseUrl,
    logNetworkInfo: true,
    authProvider: '',
  );

  FlavorConfig(
    flavor: Flavor.dev,
    name: 'DEV',
    color: Colors.white,
    values: values,
  );

  await commonSetup();
  runApp(const MyApp());
}
