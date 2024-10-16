import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:team_project2_pure_me/vm/calc/calc_handler.dart';

// ignore: must_be_immutable
class CalcElec extends StatelessWidget {
  CalcElec({super.key});
  final TextEditingController electricController = TextEditingController();
  final TextEditingController gasController = TextEditingController();
  late String? result = '__';
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final vmHandler = Get.put(CalcHandler());
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('images/background_id.png'),
        )),
        child: GestureDetector(
           onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: GetBuilder<CalcHandler>(builder: (controller) {
                // FutureBuilder(
                //   future: controller.,
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return const Center(
                //         child: CircularProgressIndicator(),
                //       );
                //     } else if (snapshot.hasError) {
                //       return Center(
                //         child: Text('Error : ${snapshot.error}'),
                //       );
                //     } else {
                //       return
          
                return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(25, 70, 25, 50),
                          child: Container(
                              decoration: const BoxDecoration(
                                  color: const Color(0xFFB8F2B4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  )),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          IconButton(
                                              onPressed: () => Get.back(),
                                              icon: Icon(Icons.arrow_back_ios))
                                        ],
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child: Text(
                                          '전기 사용량 입력',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text('당신의 전기 사용량을 통해 절감된 탄소량을 계산합니다.'),
                                  Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: Container(
                                      color: Colors.white,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text('Tip: 전기 사용량 입력 하는 법\n\n'),
                                            const Text(
                                                '전기 사용량 : 전기 청구서를 확인하여 월간 kWh 사용량을 \n입력하세요. 청구서가 없다면, 에어컨이나 가전 제품 사용\n시간을 추정할 수 있습니다.\n\n'),
                                            const Text(
                                              '가정 내 전기 사용량\n',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Text('예) 300kWh'),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextField(
                                                controller: electricController,
                                                decoration: const InputDecoration(
                                                  hintText: '월간 전기 사용량(kWh)',
                                                  hintStyle: TextStyle(color: Colors.grey),
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                            const Text(
                                              '가스 사용량\n',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Text('예) 50m3'),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextField(
                                                controller: gasController,
                                                decoration: const InputDecoration(
                                                  hintText: '월간 가스 사용량(m3)',
                                                  hintStyle: TextStyle(color: Colors.grey),
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(20.0),
                                              child: ElevatedButton(
                                                  onPressed: () async {
                                                    if (electricController.text
                                                            .trim()
                                                            .isEmpty ||
                                                        gasController.text.trim().isEmpty) {
                                                      _errorSnackBar();
                                                    } else {
                                                      await insertCarbonGen(vmHandler);
                                                      _showDialog();
                                                    }
                                                  },
                                                  child: const Text('전기 사용량 입력')),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        )
                      ],
                    ),
                  ),
                );
              })),
        ));
  }

  insertCarbonGen(CalcHandler vmHandler) {
    double? electricity = double.tryParse(electricController.text.trim());
    double? gas = double.tryParse(gasController.text.trim());

    if (electricity != null || gas != null) {
      vmHandler.giveData(vmHandler, vmHandler.electricitylist[0],
          electricController.text.trim(), box.read('pureme_id'));
      vmHandler.giveData(vmHandler, vmHandler.electricitylist[1],
          gasController.text.trim(), box.read('pureme_id'));
    } else {
      Get.snackbar('경고', '숫자를 모두 입력해주세요.');
    }
  }

  _errorSnackBar() {
    Get.snackbar(
      "경고",
      "값을 입력하세요.",
      snackPosition: SnackPosition.TOP,
    );
  }

  _showDialog() {
    Get.defaultDialog(
      title: '입력',
      middleText: '입력하였습니다.',
      backgroundColor: Colors.white,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
