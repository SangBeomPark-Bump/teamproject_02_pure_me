import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_project2_pure_me/model/feed.dart';
import 'package:team_project2_pure_me/view/feed/feed_detail.dart';
import 'package:team_project2_pure_me/vm/feed_handler.dart';

class FeedHome extends StatelessWidget {
  FeedHome({super.key});

  // GetX 컨트롤러 초기화
  final feedHandler = Get.put(FeedHandler());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 배경 설정을 투명
      backgroundColor: Colors.transparent,
      body: Obx(
        // Obx를 사용하여 반응형 UI 구현
        () {
          return Padding(
            padding: const EdgeInsets.fromLTRB(25, 70, 25, 0),
            child: Card(
              elevation: 3,
              margin: EdgeInsets.zero, // Card의 기본 마진 제거
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)), // Card의 모서리 둥글기 제거
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start, // 명시적으로 시작 정렬 설정
                mainAxisSize: MainAxisSize.min, // 컬럼이 필요한 만큼만 공간 차지
                children: [
                  // 제목 부분
                  Container(
                    color: const Color(0xFF4CAF50), // 배경색 설정
                    padding: const EdgeInsets.fromLTRB(16, 16, 110, 16),
                    child: const Text(
                      '탄소 절감, 우리의 이야기',
                      style: TextStyle(
                        fontSize: 24, 
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // 텍스트 색상
                      ),
                    ),
                  ),
                  // 그리드뷰 부분
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10), // 그리드뷰의 패딩 수정
                      itemCount: feedHandler.feedList.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 한줄당 갯수
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        Feed feed = feedHandler.feedList[index];
                        return GestureDetector(
                          // 클릭시 클릭한 피드의 정보를 argument로 보냄
                          onTap: () {
                            Get.to(
                              () => FeedDetail(),
                              arguments: feed,
                            )!.then(
                              (value) {
                                // 상세 페이지에서 돌아올 때 이미지 파일 초기화
                                feedHandler.imgFile = null;
                                feedHandler.imageFile = null;
                              },
                            );
                          },
                          // 화면 구성
                          child: Card(
                            elevation: 2,
                            color: const Color(0xFFB1B1B1),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(feed.feedImagePath),
                            ), // 이미지 변경
                          ),
                        );
                      },
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