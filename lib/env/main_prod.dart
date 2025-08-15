import 'package:flutter/material.dart';
import '../app/app.dart';
import '../common/common.dart';
import 'flavor_config.dart';

Future<void> main() async {
  const values = FlavorValues(
    baseUrl: '',
    logNetworkInfo: true,
    authProvider: ' ',
  );

  FlavorConfig(
    flavor: Flavor.production,
    name: 'Release',
    color: Colors.white,
    values: values,
  );

  await commonSetup();

  runApp(const MyApp());
}
