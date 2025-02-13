import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rain/app/controller/controller.dart';
import 'package:rain/app/widgets/desc.dart';
import 'package:rain/app/widgets/shimmer.dart';
import 'package:rain/app/widgets/weather_daily.dart';
import 'package:rain/app/widgets/weather_now.dart';
import 'package:rain/app/widgets/weather_hourly.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final locale = Get.locale;
  final locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await locationController.deleteAll();
        locationController.deleteCache();
        await locationController.getCurrentLocation();
        setState(() {});
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 15, left: 15),
          child: ListView(
            children: [
              Obx(
                () => locationController.isLoading.isFalse
                    ? WeatherNow(
                        time: locationController
                            .hourly.time![locationController.hourOfDay.value],
                        weather: locationController.hourly
                            .weathercode![locationController.hourOfDay.value],
                        degree: locationController.hourly
                            .temperature2M![locationController.hourOfDay.value],
                      )
                    : const MyShimmer(hight: 350),
              ),
              Obx(
                () => locationController.isLoading.isFalse
                    ? Container(
                        height: 130,
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                            color: context.theme.colorScheme.primaryContainer,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: ScrollablePositionedList.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          separatorBuilder: (BuildContext context, int index) {
                            return VerticalDivider(
                              width: 10,
                              color: context.theme.unselectedWidgetColor,
                              indent: 40,
                              endIndent: 40,
                            );
                          },
                          scrollDirection: Axis.horizontal,
                          itemScrollController:
                              locationController.itemScrollController,
                          itemCount: locationController.hourly.time!.length,
                          itemBuilder: (ctx, i) => GestureDetector(
                            onTap: () {
                              locationController.hourOfDay.value = i;
                              setState(() {});
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                  color: i == locationController.hourOfDay.value
                                      ? Get.isDarkMode
                                          ? Colors.indigo
                                          : Colors.amberAccent
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: WeatherHourly(
                                time: locationController.hourly.time![i],
                                weather:
                                    locationController.hourly.weathercode![i],
                                degree:
                                    locationController.hourly.temperature2M![i],
                              ),
                            ),
                          ),
                        ),
                      )
                    : const MyShimmer(
                        hight: 130,
                        edgeInsetsMargin: EdgeInsets.symmetric(vertical: 15),
                        edgeInsetsPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                      ),
              ),
              Obx(
                () => locationController.isLoading.isFalse
                    ? Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                            color: context.theme.colorScheme.primaryContainer,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: Center(
                          child: Wrap(
                            spacing: 5,
                            runSpacing: 15,
                            children: [
                              DescWeather(
                                imageName: 'assets/images/humidity.png',
                                value:
                                    '${locationController.hourly.relativehumidity2M![locationController.hourOfDay.value]}%',
                                desc: 'humidity'.tr,
                              ),
                              DescWeather(
                                imageName: 'assets/images/wind.png',
                                value:
                                    '${locationController.hourly.windspeed10M![locationController.hourOfDay.value].round()} ${'km/h'.tr}',
                                desc: 'wind'.tr,
                              ),
                              DescWeather(
                                imageName: 'assets/images/foggy.png',
                                value:
                                    '${locationController.hourly.visibility![locationController.hourOfDay.value] > 1000 ? (locationController.hourly.visibility![locationController.hourOfDay.value] / 1000).round() : (locationController.hourly.visibility![locationController.hourOfDay.value] / 1000)} ${'km'.tr}',
                                desc: 'visibility'.tr,
                              ),
                              DescWeather(
                                imageName: 'assets/images/temperature.png',
                                value:
                                    '${locationController.hourly.apparentTemperature![locationController.hourOfDay.value].round()}°',
                                desc: 'feels'.tr,
                              ),
                              DescWeather(
                                imageName: 'assets/images/evaporation.png',
                                value:
                                    '${locationController.hourly.evapotranspiration![locationController.hourOfDay.value].abs()} ${'mm'.tr}',
                                desc: 'evaporation'.tr,
                              ),
                              DescWeather(
                                imageName: 'assets/images/rainfall.png',
                                value:
                                    '${locationController.hourly.precipitation![locationController.hourOfDay.value]} ${'mm'.tr}',
                                desc: 'precipitation'.tr,
                              ),
                              DescWeather(
                                imageName: 'assets/images/wind-direction.png',
                                value:
                                    '${locationController.hourly.winddirection10M![locationController.hourOfDay.value]}°',
                                desc: 'direction'.tr,
                              ),
                              DescWeather(
                                imageName: 'assets/images/atmospheric.png',
                                value:
                                    '${locationController.hourly.surfacePressure![locationController.hourOfDay.value].round()} ${'hPa'.tr}',
                                desc: 'pressure'.tr,
                              ),
                              DescWeather(
                                imageName: 'assets/images/water.png',
                                value:
                                    '${locationController.hourly.rain![locationController.hourOfDay.value]} ${'mm'.tr}',
                                desc: 'rain'.tr,
                              ),
                            ],
                          ),
                        ),
                      )
                    : const MyShimmer(
                        hight: 350,
                        edgeInsetsMargin: EdgeInsets.only(bottom: 15),
                        edgeInsetsPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                      ),
              ),
              Obx(
                () => locationController.isLoading.isFalse
                    ? Container(
                        height: 405,
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                            color: context.theme.colorScheme.primaryContainer,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: locationController.daily.time!.length,
                          itemBuilder: (ctx, i) => WeatherDaily(
                            date: locationController.daily.time![i],
                            weather: locationController.daily.weathercode![i],
                            minDegree:
                                locationController.daily.temperature2MMin![i],
                            maxDegree:
                                locationController.daily.temperature2MMax![i],
                          ),
                        ),
                      )
                    : const MyShimmer(
                        hight: 405,
                        edgeInsetsMargin: EdgeInsets.only(bottom: 15),
                        edgeInsetsPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
