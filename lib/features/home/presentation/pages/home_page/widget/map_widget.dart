import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:appzeto_taxi_driver/common/app_constants.dart';
import 'package:appzeto_taxi_driver/common/common.dart';
import 'package:appzeto_taxi_driver/core/model/user_detail_model.dart';
import 'package:appzeto_taxi_driver/core/utils/custom_button.dart';
import 'package:appzeto_taxi_driver/core/utils/custom_text.dart';
import 'package:appzeto_taxi_driver/features/home/application/home_bloc.dart';
import 'package:appzeto_taxi_driver/features/home/presentation/pages/home_page/widget/bidding_ride/bidding_request_widget.dart';
import 'package:appzeto_taxi_driver/features/home/presentation/pages/home_page/widget/bidding_ride/bidding_ride_list_widget.dart';
import 'package:appzeto_taxi_driver/features/home/presentation/pages/home_page/widget/on_ride/on_ride_widget.dart';
import 'package:appzeto_taxi_driver/features/home/presentation/pages/home_page/widget/accept_reject_widget.dart';
import 'package:appzeto_taxi_driver/features/home/presentation/pages/home_page/widget/outstation_request_page.dart';
import 'package:appzeto_taxi_driver/features/home/presentation/pages/home_page/widget/instand_ride/avatar_glow.dart';
import 'package:appzeto_taxi_driver/l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart' as fmlt;
import 'bidding_ride/bidding_timer_widget.dart';
import 'instand_ride/auto_search_places.dart';
import 'earnings_widget.dart';
import 'locate_me_widget.dart';
import 'map_appbar_widget.dart';
import 'on_ride/cancel_reason_widget.dart';
import 'on_ride/navigation_widget.dart';
import 'on_ride/onride_slider_button_widget.dart';
import 'on_ride/signature_get_widget.dart';
import 'outstation_ride_list_widget.dart';
import 'peak_zone_widget.dart';
import 'quick_action_widget.dart';
import 'on_ride/sos_widget.dart';
import 'vehicles_status_widget.dart';

class MapWidget extends StatelessWidget {
  final BuildContext cont;

  const MapWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<HomeBloc>(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final homeBloc = context.read<HomeBloc>();
          homeBloc.bidRideTop ??= (size.height) - (size.height * 0.67);
          if (homeBloc.showBiddingPage) {
            if (homeBloc.bidRideTop == (size.height) - (size.height * 0.67)) {
              homeBloc.bidRideTop =
                  MediaQuery.paddingOf(context).top + size.width * 0.05;
            }
          }
          return Stack(
            children: [
              if (homeBloc.currentLatLng != null) ...[
                (mapType == 'google_map')
                    ? _GoogleMapWidget(size: size, homeBloc: homeBloc)
                    : BlocProvider<HomeBloc>.value(
                        value: homeBloc,
                        child: _FlutterMapWidget(homeBloc),
                      ),
              ],
              if (homeBloc.showGetDropAddress && homeBloc.polyline.isEmpty) ...[
                BlocProvider<HomeBloc>.value(
                  value: homeBloc,
                  child: const _DropAddressView(),
                ),
                if (homeBloc.confirmPinAddress)
                  BlocProvider<HomeBloc>.value(
                    value: homeBloc,
                    child: _ConfirmPinAddressView(homeBloc),
                  ),
              ],
              if (homeBloc.autoSuggestionSearching ||
                  homeBloc.autoCompleteAddress.isNotEmpty)
                BlocProvider<HomeBloc>.value(
                  value: homeBloc,
                  child: const _AutoSuggestionView(),
                ),
              if (homeBloc.choosenRide != null)
                BlocProvider<HomeBloc>.value(
                  value: homeBloc,
                  child: _RideView(homeBloc),
                ),
              if (userData != null && userData!.role == 'owner') ...[
                Positioned(
                    top: size.height * 0.06,
                    child: VehicleStatusWidget(cont: context)),
              ],
              if (userData != null &&
                  userData!.role == 'driver' &&
                  userData!.metaRequest == null &&
                  userData!.onTripRequest == null)
                Positioned(top: 0, child: MapAppBarWidget(cont: context)),
              if (homeBloc.autoSuggestionSearching == false &&
                  homeBloc.autoCompleteAddress.isEmpty)
                BlocProvider<HomeBloc>.value(
                  value: homeBloc,
                  child: _AutoCompletionEmptyView(homeBloc),
                ),
              if (userData != null &&
                  userData!.role == 'driver' &&
                  userData!.metaRequest == null &&
                  userData!.onTripRequest == null &&
                  homeBloc.choosenRide == null &&
                  homeBloc.showGetDropAddress == false)
                DraggableScrollableSheet(
                  initialChildSize: 0.25,
                  minChildSize: 0.25,
                  maxChildSize: 1.0,
                  builder: (context, scrollController) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return NotificationListener<
                            DraggableScrollableNotification>(
                          onNotification: (notification) {
                            double currentSize = notification.extent;

                            // Determine widget based on height threshold
                            if (currentSize >= 0.6) {
                              homeBloc.animatedWidget =
                                  QuickActionsWidget(cont: cont);
                            } else {
                              homeBloc.animatedWidget =
                                  EarningsWidget(cont: cont);
                            }

                            // Update the bottom size in the Bloc
                            homeBloc.bottomSize = currentSize * size.height;

                            // Trigger a state update
                            homeBloc.add(UpdateEvent());
                            return true;
                          },
                          child: Container(
                            width: size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(size.width * 0.1),
                                topRight: Radius.circular(size.width * 0.1),
                              ),
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(size.width * 0.1),
                                topRight: Radius.circular(size.width * 0.1),
                              ),
                              child: SingleChildScrollView(
                                controller: scrollController,
                                physics: const ClampingScrollPhysics(),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 400),
                                  child: homeBloc.animatedWidget ??
                                      EarningsWidget(cont: cont),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              if (userData != null &&
                  homeBloc.isBiddingEnabled &&
                  homeBloc.choosenRide == null &&
                  userData!.onTripRequest == null &&
                  userData!.metaRequest == null &&
                  homeBloc.showGetDropAddress == false &&
                  userData!.active &&
                  homeBloc.bottomSize < size.height * 0.5)
                AnimatedPositioned(
                  right: 0,
                  top: homeBloc.bidRideTop,
                  duration: const Duration(milliseconds: 250),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: size.width * 0.05),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  spreadRadius: 1,
                                  blurRadius: 1)
                            ]),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            if (homeBloc.bidRideTop ==
                                (size.height) - (size.height * 0.67)) {
                              homeBloc.bidRideTop =
                                  MediaQuery.paddingOf(context).top +
                                      size.width * 0.05;
                            } else {
                              homeBloc.bidRideTop =
                                  (size.height) - (size.height * 0.67);
                            }
                            homeBloc.add(UpdateEvent());
                            context
                                .read<HomeBloc>()
                                .add(ShowBiddingPageEvent());
                          },
                          child: Container(
                            height: size.width * 0.1,
                            width: size.width * 0.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            alignment: Alignment.center,
                            child: Image.asset(
                              AppImages.biddingCar,
                              width: size.width * 0.07,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),
                      ),
                      AnimatedCrossFade(
                          firstChild: Container(),
                          secondChild: BiddingRideListWidget(cont: context),
                          crossFadeState: (homeBloc.bidRideTop ==
                                  (size.height) - (size.height * 0.67))
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 250))
                    ],
                  ),
                ),
              if (homeBloc.showGetDropAddress)
                Positioned(
                  bottom: 0,
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    height: size.width * 0.5,
                    padding: EdgeInsets.all(size.width * 0.05),
                    width: size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MyText(
                          text: homeBloc.dropAddress,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                          maxLines: 4,
                        ),
                        SizedBox(height: size.width * 0.05),
                        CustomButton(
                            buttonName:
                                AppLocalizations.of(context)!.confirmLocation,
                            onTap: () {
                              context
                                  .read<HomeBloc>()
                                  .add(GetEtaRequestEvent());
                            })
                      ],
                    ),
                  ),
                ),
              if (userData != null && userData!.metaRequest != null)
                Positioned(bottom: 0, child: AcceptRejectWidget(cont: context)),
              if (homeBloc.choosenRide != null &&
                  (homeBloc.outStationList.isNotEmpty ||
                      homeBloc.rideList.isNotEmpty))
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: size.width,
                    padding: EdgeInsets.all(size.width * 0.05),
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )),
                    child: Column(
                      children: [
                        (homeBloc.choosenRide != null &&
                                homeBloc.showOutstationWidget &&
                                context
                                    .read<HomeBloc>()
                                    .outStationList
                                    .isNotEmpty)
                            ? OutstationRequestWidget(cont: context)
                            : BiddingRequestWidget(cont: context),
                      ],
                    ),
                  ),
                ),
              if (userData != null && (userData!.onTripRequest != null))
                Positioned(
                  bottom: 0,
                  child: SizedBox(
                    height: size.height,
                    width: size.width,
                    child: Stack(
                      children: [
                        DraggableScrollableSheet(
                          initialChildSize:
                              (userData?.onTripRequest!.arrivedAt == null)
                                  ? 0.32
                                  : 0.38, // Start at half screen
                          minChildSize:
                              (userData?.onTripRequest!.arrivedAt == null)
                                  ? 0.32
                                  : 0.38, // Minimum height
                          maxChildSize: 0.80,
                          builder: (BuildContext ctx,
                              ScrollController scrollController) {
                            return Container(
                              height: size.height,
                              width: size.width,
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(30)),
                              ),
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: (userData != null &&
                                        userData?.onTripRequest != null)
                                    ? ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(30)),
                                        child: OnRideWidget(cont: context),
                                      )
                                    : Container(),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: OnrideCustomSliderButtonWidget(size: size),
                        ),
                      ],
                    ),
                  ),
                ),
              if (homeBloc.visibleOutStation && userData!.active)
                Positioned(child: BiddingOutStationListWidget(cont: context)),
              // bidding timer widget
              if (homeBloc.waitingList.isNotEmpty &&
                  !homeBloc.showOutstationWidget)
                Positioned(top: 0, child: BiddingTimerWidget(cont: context)),
              // Showing cancel reasons
              if (homeBloc.showCancelReason == true)
                Positioned(top: 0, child: CancelReasonWidget(cont: context)),
              // Showing signature field
              if (homeBloc.showSignature == true)
                Positioned(top: 0, child: SignatureGetWidget(cont: context)),
            ],
          );
        },
      ),
    );
  }
}

class _GoogleMapWidget extends StatelessWidget {
  const _GoogleMapWidget({
    required this.size,
    required this.homeBloc,
  });

  final Size size;
  final HomeBloc homeBloc;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      key: const PageStorageKey('goole_map'),
      padding: EdgeInsets.fromLTRB(
          size.width * 0.05,
          (homeBloc.choosenRide != null || homeBloc.showGetDropAddress)
              ? size.width * 0.15 + MediaQuery.paddingOf(context).top
              : size.width * 0.05 + MediaQuery.paddingOf(context).top,
          size.width * 0.05,
          (userData != null &&
                  (userData!.metaRequest != null ||
                      userData!.onTripRequest != null ||
                      homeBloc.choosenRide != null ||
                      homeBloc.showGetDropAddress))
              ? size.width
              : size.width * 0.05),
      gestureRecognizers: {
        Factory<OneSequenceGestureRecognizer>(
          () => EagerGestureRecognizer(),
        ),
      },
      onMapCreated: (GoogleMapController controller) {
        homeBloc.googleMapController = controller;
        homeBloc.add(SetMapStyleEvent(context: context));
      },
      compassEnabled: false,
      initialCameraPosition: (homeBloc.initialCameraPosition != null)
          ? homeBloc.initialCameraPosition!
          : CameraPosition(
              target: homeBloc.currentLatLng ?? const LatLng(0, 0),
              zoom: 15.0,
            ),
      onCameraMove: (CameraPosition position) {
        homeBloc.mapPoint = position.target;
      },
      onCameraIdle: () {
        if (homeBloc.showGetDropAddress &&
            homeBloc.mapPoint != null &&
            homeBloc.autoCompleteAddress.isEmpty &&
            homeBloc.polyline.isEmpty) {
          homeBloc.confirmPinAddress = true;
          homeBloc.add(UpdateEvent());
        } else if (homeBloc.showGetDropAddress &&
            homeBloc.mapPoint != null &&
            homeBloc.autoCompleteAddress.isNotEmpty &&
            !homeBloc.confirmPinAddress) {
          homeBloc.add(ClearAutoCompleteEvent());
        }
      },
      markers: Set<Marker>.from(homeBloc.markers),
      minMaxZoomPreference: const MinMaxZoomPreference(0, 20),
      buildingsEnabled: false,
      zoomControlsEnabled: false,
      myLocationEnabled:
          (userData != null && userData!.role == 'owner') ? true : false,
      myLocationButtonEnabled: false,
      polylines: homeBloc.polyline,
      polygons: (homeBloc.showPeakZones &&
              !homeBloc.showGetDropAddress &&
              homeBloc.polygons.isNotEmpty &&
              userData != null &&
              userData!.role != 'owner' &&
              userData!.enablePeakZoneFeature &&
              (userData!.metaRequest == null &&
                  userData!.onTripRequest == null))
          ? homeBloc.polygons
          : {},
    );
  }
}

class _AutoCompletionEmptyView extends StatelessWidget {
  final HomeBloc homeBloc;
  const _AutoCompletionEmptyView(this.homeBloc);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Positioned(
        right: (homeBloc.textDirection == 'rtl') ? null : size.width * 0.05,
        left: (homeBloc.textDirection == 'ltr') ? null : size.width * 0.05,
        bottom: (userData != null &&
                homeBloc.showGetDropAddress == false &&
                userData!.metaRequest == null &&
                userData!.onTripRequest == null &&
                userData!.role == 'driver')
            ? size.width * 0.75
            : size.height * 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (userData != null &&
                userData!.onTripRequest != null &&
                userData!.onTripRequest!.isTripStart == 1)
              SosWidget(cont: context),
            if (userData != null &&
                userData!.onTripRequest != null &&
                userData!.onTripRequest!.acceptedAt != null &&
                userData!.onTripRequest!.dropAddress != null &&
                userData!.onTripRequest!.requestStops.isEmpty)
              NavigationWidget(cont: context),
            SizedBox(height: size.width * 0.025),
            if (!homeBloc.showGetDropAddress &&
                userData != null &&
                userData!.role != 'owner' &&
                userData!.active &&
                userData!.available &&
                userData!.enablePeakZoneFeature &&
                (userData!.metaRequest == null &&
                    userData!.onTripRequest == null))
              PeakZoneWidget(cont: context),
            SizedBox(height: size.width * 0.025),
            LocateMeWidget(cont: context),
          ],
        ));
  }
}

class _RideView extends StatelessWidget {
  final HomeBloc homeBloc;
  const _RideView(this.homeBloc);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Positioned(
      top: MediaQuery.paddingOf(context).top + size.width * 0.05,
      left: size.width * 0.05,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).shadowColor,
                  spreadRadius: 1,
                  blurRadius: 1)
            ]),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            homeBloc.add(RemoveChoosenRideEvent());
          },
          child: Container(
            height: size.width * 0.1,
            width: size.width * 0.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.arrow_back,
              size: size.width * 0.07,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _AutoSuggestionView extends StatelessWidget {
  const _AutoSuggestionView();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      child: AutoSearchPlacesWidget(cont: context),
    );
  }
}

class _ConfirmPinAddressView extends StatelessWidget {
  final HomeBloc homeBloc;
  const _ConfirmPinAddressView(this.homeBloc);

  @override
  Widget build(BuildContext context1) {
    final size = MediaQuery.sizeOf(context1);
    return Positioned(
      // top: (size.height - size.width) / 2,
      top: size.width * 0.23 + MediaQuery.paddingOf(context1).top,
      right: size.width * 0.38,
      child: Container(
        height: size.height * 0.8,
        alignment: Alignment.center,
        child: Padding(
            padding: EdgeInsets.only(bottom: size.width * 0.6 + 25),
            child: Row(
              children: [
                CustomButton(
                    height: size.width * 0.08,
                    width: size.width * 0.25,
                    onTap: () {
                      homeBloc.confirmPinAddress = false;
                      homeBloc.add(UpdateEvent());
                      if (homeBloc.mapPoint != null) {
                        homeBloc.add(GeocodingLatLngEvent(
                            lat: homeBloc.mapPoint!.latitude,
                            lng: homeBloc.mapPoint!.longitude));
                      }
                    },
                    textSize: 12,
                    buttonName: AppLocalizations.of(context1)!.confirm)
              ],
            )),
      ),
    );
  }
}

class _DropAddressView extends StatelessWidget {
  const _DropAddressView();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Positioned(
        // top: (size.height - size.width * 0.72) / 2,
        top: size.width * 0.53 + MediaQuery.paddingOf(context).top,
        child: SizedBox(
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AvatarGlow(
                  glowRadiusFactor: 1.0,
                  glowColor: AppColors.primary,
                  child: Container(
                    margin: EdgeInsets.only(bottom: size.width * 0.075),
                    child: Image.asset(
                      AppImages.pickupIcon,
                      width: size.width * 0.12,
                      height: size.width * 0.12,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            )));
  }
}

// class _MapWidget extends StatelessWidget {
//   final BuildContext context;
//   const _MapWidget(this.context);

//   @override
//   Widget build(BuildContext context1) {
//     final size = MediaQuery.sizeOf(context1);

//     return SizedBox();
//   }
// }

class _FlutterMapWidget extends StatelessWidget {
  final HomeBloc homeBloc;
  const _FlutterMapWidget(this.homeBloc);

  @override
  Widget build(BuildContext context1) {
    return fm.FlutterMap(
      mapController: homeBloc.fmController,
      options: fm.MapOptions(
          onMapEvent: (v) {
            if (v.source == fm.MapEventSource.dragEnd ||
                v.source == fm.MapEventSource.mapController) {
              if (homeBloc.showGetDropAddress &&
                  homeBloc.autoCompleteAddress.isEmpty &&
                  homeBloc.fmpoly.isEmpty) {
                homeBloc.add(GeocodingLatLngEvent(
                    lat: v.camera.center.latitude,
                    lng: v.camera.center.longitude));
              } else if (homeBloc.showGetDropAddress &&
                  homeBloc.mapPoint != null &&
                  homeBloc.autoCompleteAddress.isNotEmpty) {
                homeBloc.add(ClearAutoCompleteEvent());
              }
            }
          },
          initialCenter: fmlt.LatLng(homeBloc.currentLatLng!.latitude,
              homeBloc.currentLatLng!.longitude),
          initialZoom: 16,
          onTap: (P, L) {}),
      children: [
        fm.TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        if (homeBloc.showPeakZones &&
            !homeBloc.showGetDropAddress &&
            homeBloc.polygons.isNotEmpty &&
            userData != null &&
            userData!.role != 'owner' &&
            (userData!.metaRequest == null && userData!.onTripRequest == null))
          fm.PolygonLayer(
            polygons: List.generate(
              homeBloc.polygons.length,
              (index) {
                return fm.Polygon(
                    points: List.generate(
                      homeBloc.polygons.elementAt(index).points.length,
                      (ind) {
                        return fmlt.LatLng(
                            homeBloc.polygons
                                .elementAt(index)
                                .points
                                .elementAt(ind)
                                .latitude,
                            homeBloc.polygons
                                .elementAt(index)
                                .points
                                .elementAt(ind)
                                .longitude);
                      },
                    ),
                    color: Colors.red.withAlpha((0.2 * 255).toInt()),
                    borderStrokeWidth: 2,
                    borderColor: Colors.red);
              },
            ),
          ),
        if (homeBloc.fmpoly.isNotEmpty)
          fm.PolylineLayer(
            polylines: [
              fm.Polyline(
                  points: homeBloc.fmpoly,
                  color: Theme.of(context1).primaryColor,
                  strokeWidth: 4),
            ],
          ),
        if (userData != null && userData!.role == 'owner')
          fm.MarkerLayer(
            markers: List.generate(homeBloc.markers.length, (index) {
              final marker = homeBloc.markers.elementAt(index);
              return fm.Marker(
                point: fmlt.LatLng(
                    marker.position.latitude, marker.position.longitude),
                alignment: Alignment.topCenter,
                child: RotationTransition(
                  turns: AlwaysStoppedAnimation(marker.rotation / 360),
                  child: Image.asset(
                    (marker.markerId.value
                                .toString()
                                .replaceAll('MarkerId(', '')
                                .replaceAll(')', '')
                                .split('_')[3] ==
                            'car')
                        ? (marker.markerId.value
                                    .toString()
                                    .replaceAll('MarkerId(', '')
                                    .replaceAll(')', '')
                                    .split('_')[2] ==
                                '1')
                            ? AppImages.carOnline
                            : (marker.markerId.value
                                        .toString()
                                        .replaceAll('MarkerId(', '')
                                        .replaceAll(')', '')
                                        .split('_')[2] ==
                                    '2')
                                ? AppImages.carOffline
                                : AppImages.carOnride
                        : (marker.markerId.value
                                    .toString()
                                    .replaceAll('MarkerId(', '')
                                    .replaceAll(')', '')
                                    .split('_')[3] ==
                                'motor_bike')
                            ? (marker.markerId.value
                                        .toString()
                                        .replaceAll('MarkerId(', '')
                                        .replaceAll(')', '')
                                        .split('_')[2] ==
                                    '1')
                                ? AppImages.bikeOnline
                                : (marker.markerId.value
                                            .toString()
                                            .replaceAll('MarkerId(', '')
                                            .replaceAll(')', '')
                                            .split('_')[2] ==
                                        '2')
                                    ? AppImages.bikeOffline
                                    : AppImages.bikeOnride
                            : (marker.markerId.value
                                        .toString()
                                        .replaceAll('MarkerId(', '')
                                        .replaceAll(')', '')
                                        .split('_')[2] ==
                                    '1')
                                ? AppImages.deliveryOnline
                                : (marker.markerId.value
                                            .toString()
                                            .replaceAll('MarkerId(', '')
                                            .replaceAll(')', '')
                                            .split('_')[2] ==
                                        '2')
                                    ? AppImages.deliveryOffline
                                    : AppImages.deliveryOnride,
                    width: 16,
                    height: 30,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox();
                    },
                  ),
                ),
              );
            }),
          ),
        if (userData != null && userData!.role != 'owner')
          fm.MarkerLayer(markers: [
            if (homeBloc.currentLatLng != null)
              fm.Marker(
                point: fmlt.LatLng(homeBloc.currentLatLng!.latitude,
                    homeBloc.currentLatLng!.longitude),
                alignment: Alignment.topCenter,
                child: Image.asset(
                  (userData!.vehicleTypeIcon.toString().contains('truck'))
                      ? AppImages.truck
                      : userData!.vehicleTypeIcon
                              .toString()
                              .contains('motor_bike')
                          ? AppImages.bikeOffline
                          : userData!.vehicleTypeIcon
                                  .toString()
                                  .contains('auto')
                              ? AppImages.auto
                              : userData!.vehicleTypeIcon
                                      .toString()
                                      .contains('lcv')
                                  ? AppImages.lcv
                                  : userData!.vehicleTypeIcon
                                          .toString()
                                          .contains('ehcv')
                                      ? AppImages.ehcv
                                      : userData!.vehicleTypeIcon
                                              .toString()
                                              .contains('hatchback')
                                          ? AppImages.hatchBack
                                          : userData!.vehicleTypeIcon
                                                  .toString()
                                                  .contains('hcv')
                                              ? AppImages.hcv
                                              : userData!.vehicleTypeIcon
                                                      .toString()
                                                      .contains('mcv')
                                                  ? AppImages.mcv
                                                  : userData!.vehicleTypeIcon
                                                          .toString()
                                                          .contains('luxury')
                                                      ? AppImages.luxury
                                                      : userData!
                                                              .vehicleTypeIcon
                                                              .toString()
                                                              .contains(
                                                                  'premium')
                                                          ? AppImages.premium
                                                          : userData!
                                                                  .vehicleTypeIcon
                                                                  .toString()
                                                                  .contains(
                                                                      'suv')
                                                              ? AppImages.suv
                                                              : (userData!
                                                                      .vehicleTypeIcon
                                                                      .toString()
                                                                      .contains(
                                                                          'car'))
                                                                  ? AppImages
                                                                      .car
                                                                  : '',
                  width: 16,
                  height: 30,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox();
                  },
                ),
              ),
            if ((userData != null && userData!.metaRequest != null) ||
                (userData != null && userData!.onTripRequest != null))
              (userData != null && userData!.metaRequest != null)
                  ? fm.Marker(
                      width: 100,
                      height: 20,
                      alignment: Alignment.topCenter,
                      point: fmlt.LatLng(userData!.metaRequest!.pickLat,
                          userData!.metaRequest!.pickLng),
                      child: Image.asset(
                        AppImages.pickupIcon,
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                      ),
                    )
                  : fm.Marker(
                      width: 100,
                      height: 30,
                      alignment: Alignment.topCenter,
                      point: fmlt.LatLng(userData!.onTripRequest!.pickLat,
                          userData!.onTripRequest!.pickLng),
                      child: Image.asset(
                        AppImages.pickupIcon,
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                      ),
                    ),
            if ((userData != null &&
                    userData!.metaRequest != null &&
                    userData!.metaRequest!.dropAddress != null &&
                    userData!.metaRequest!.requestStops.isEmpty) ||
                (userData != null &&
                    userData!.onTripRequest != null &&
                    userData!.onTripRequest!.dropAddress != null &&
                    userData!.onTripRequest!.requestStops.isEmpty))
              (userData != null &&
                      userData!.metaRequest != null &&
                      userData!.metaRequest!.dropAddress != null)
                  ? fm.Marker(
                      width: 100,
                      height: 30,
                      alignment: Alignment.topCenter,
                      point: fmlt.LatLng(userData!.metaRequest!.dropLat!,
                          userData!.metaRequest!.dropLng!),
                      child: Image.asset(
                        AppImages.dropIcon,
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                      ),
                    )
                  : fm.Marker(
                      width: 100,
                      height: 30,
                      alignment: Alignment.topCenter,
                      point: fmlt.LatLng(userData!.onTripRequest!.dropLat!,
                          userData!.onTripRequest!.dropLng!),
                      child: Image.asset(
                        AppImages.dropIcon,
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                      ),
                    ),
            if ((userData != null &&
                userData!.metaRequest != null &&
                userData!.metaRequest!.requestStops.isNotEmpty))
              for (var i = 0;
                  i < userData!.metaRequest!.requestStops.length;
                  i++)
                fm.Marker(
                  width: 100,
                  height: 30,
                  alignment: Alignment.center,
                  point: fmlt.LatLng(
                      userData!.metaRequest!.requestStops[i]['latitude'],
                      userData!.metaRequest!.requestStops[i]['longitude']),
                  child: Image.asset(
                    (i == 0)
                        ? AppImages.stopOne
                        : (i == 1)
                            ? AppImages.stopTwo
                            : (i == 2)
                                ? AppImages.stopThree
                                : AppImages.stopFour,
                    height: 15,
                    width: 15,
                    fit: BoxFit.contain,
                  ),
                ),
            if (userData != null &&
                userData!.onTripRequest != null &&
                userData!.onTripRequest!.requestStops.isNotEmpty)
              for (var i = 0;
                  i < userData!.onTripRequest!.requestStops.length;
                  i++)
                fm.Marker(
                  width: 100,
                  height: 30,
                  alignment: Alignment.center,
                  point: fmlt.LatLng(
                      userData!.onTripRequest!.requestStops[i]['latitude'],
                      userData!.onTripRequest!.requestStops[i]['longitude']),
                  child: Image.asset(
                    (i == 0)
                        ? AppImages.stopOne
                        : (i == 1)
                            ? AppImages.stopTwo
                            : (i == 2)
                                ? AppImages.stopThree
                                : AppImages.stopFour,
                    height: 15,
                    width: 15,
                    fit: BoxFit.contain,
                  ),
                ),
          ]),
        if (userData != null &&
            userData!.role != 'owner' &&
            ((userData != null && userData!.metaRequest != null) ||
                (userData != null && userData!.onTripRequest != null)) &&
            homeBloc.markers.any((element) =>
                element.markerId.value.toString().contains('distance')))
          fm.MarkerLayer(
            markers: List.generate(1, (index) {
              final marker = homeBloc.markers.firstWhere((element) =>
                  element.markerId.value.toString().contains('distance'));
              return fm.Marker(
                point: fmlt.LatLng(
                    marker.position.latitude, marker.position.longitude),
                alignment: Alignment.bottomCenter,
                height: 50,
                width: 100,
                child: RotationTransition(
                  turns: AlwaysStoppedAnimation(
                    ((marker.rotation.isNaN || marker.rotation.isInfinite)
                            ? 0.0
                            : marker.rotation) /
                        360,
                  ),
                  child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(color: AppColors.primary, width: 1)),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5)),
                                  color: AppColors.primary),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MyText(
                                    text: homeBloc.fmDistance,
                                    textStyle: AppTextStyle.normalStyle()
                                        .copyWith(
                                            color: ThemeData.light()
                                                .scaffoldBackgroundColor,
                                            fontSize: 12),
                                  ),
                                  MyText(
                                    text: userData!.distanceUnit,
                                    textStyle: AppTextStyle.normalStyle()
                                        .copyWith(
                                            color: ThemeData.light()
                                                .scaffoldBackgroundColor,
                                            fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        bottomRight: Radius.circular(5)),
                                    color: ThemeData.light()
                                        .scaffoldBackgroundColor),
                                child: MyText(
                                  text: ((homeBloc.fmDuration) > 60)
                                      ? '${(homeBloc.fmDuration / 60).toStringAsFixed(1)} hrs'
                                      : '${homeBloc.fmDuration.toStringAsFixed(0)} mins',
                                  textStyle: AppTextStyle.normalStyle()
                                      .copyWith(
                                          color: AppColors.primary,
                                          fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              );
            }),
          ),
      ],
    );
  }
}
