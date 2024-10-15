import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team_project2_pure_me/view/manage/manage_feed_detial.dart';
import 'package:team_project2_pure_me/vm/manage/manage_handler.dart';

class ManageFeed extends StatelessWidget {
  const ManageFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final vmhandler = Get.put(ManageHandler());

    TextEditingController _searchController = TextEditingController(); 




    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'images/main_background_plain.png',
              ),
            ),
          ),
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Feed 관리',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.transparent,
            ),
            //// update()를 위한 겟빌더
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GetBuilder<ManageHandler>(builder: (context) {
                /// async처리를 위한 퓨처빌더
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: Get.width*0.2-8,
                            child: IconButton(
                              
                              onPressed: (){
                                vmhandler.searchWriterChanged(_searchController.text.trim());
                              }, 
                              icon: Icon(Icons.search)
                            ),
                          ),
                          SizedBox(
                            width: Get.width*0.8-8,
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                labelText: "유저 검색"
                              ),                            
                            ),
                          )
                        ],
                      ),
                      FutureBuilder(
                          future: vmhandler.fetchFeeds(),
                          builder: (context, snapshot) {
                            // if문: 예외처리
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text("Error : ${snapshot.error}"),
                              );
                            } else {
                              return Obx(
                                () {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Radio(
                                            value: 0, 
                                            groupValue: vmhandler.radioFeedIndex, 
                                            onChanged: (value) {
                                              vmhandler.feedRadioChanged(value);                                       
                                            },
                                          ),
                                          const Text("게시"),
                                          Radio(
                                            value: 1, 
                                            groupValue: vmhandler.radioFeedIndex, 
                                            onChanged: (value) {
                                              vmhandler.feedRadioChanged(value);                                       
                                            },
                                          ),
                                          const Text("숨김"),
                                          Radio(
                                            value: 2, 
                                            groupValue: vmhandler.radioFeedIndex, 
                                            onChanged: (value) {
                                              vmhandler.feedRadioChanged(value);                                       
                                            },
                                          ),
                                          const Text("삭제"),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height * 0.4,
                                        child: ListView.builder(
                                          itemCount: vmhandler.searchFeedList.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: vmhandler.searchFeedIndex == index ? Colors.blue : Colors.transparent, 
                                                          width: 2.0,
                                                        ),
                                                        borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              child: ListTile(
                                                onTap: () {
                                                  vmhandler.changeFeedIndex(index);
                                                },
                                                leading: Icon(Icons.person),
                                                title: Text('작성자: ${vmhandler.searchFeedList[index].authorEMail}'),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 100,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height:
                                                MediaQuery.of(context).size.height * 0.03,
                                            child: vmhandler.searchFeedIndex != null
                                                ? ElevatedButton(
                                                  onPressed: (){
                                                    Get.to(()=> ManageFeedDetail(), arguments: vmhandler.searchFeedList[vmhandler.searchFeedIndex!]);
                                                  }, 
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.amber[50]
                                                  ),
                                                  child: const Text("게시글 보기")
                                                )
                                                : null,
                                          ),
                                          const SizedBox( width: 40,),
                                          SizedBox(
                                            height:
                                                MediaQuery.of(context).size.height * 0.03,
                                            child: vmhandler.searchFeedIndex != null
                                                ? ElevatedButton(
                                                  onPressed: (){
                                                    deleteAlert(vmhandler);
                                                  }, 
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.amber[50]
                                                  ),
                                                  child: const Text("게시글 처리하기")
                                                )
                                                : null,
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                },
                              );
                            }
                          }),
                    ],
                  ),
                );
              }),
            ),
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }

  deleteAlert(ManageHandler vmhandler) {
    Get.defaultDialog(
      title: '게시글 처리',
      middleText: '게시글 상태를 골라주십시오.',
      actions: [
        GetBuilder<ManageHandler>(
          builder: (context) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(value: 0, groupValue: vmhandler.radioChangeFeedIndex, onChanged: (value)=> vmhandler.dailogFeedRadioChanged(value)),
                const Text("게시"),
                Radio(value: 1, groupValue: vmhandler.radioChangeFeedIndex, onChanged: (value) => vmhandler.dailogFeedRadioChanged(value)),
                const Text("숨김"),
                Radio(value: 2, groupValue: vmhandler.radioChangeFeedIndex, onChanged: (value) => vmhandler.dailogFeedRadioChanged(value)),
                const Text("삭제"),
              ],
            );
          }
        ),
        TextButton(
          onPressed: ()async {
            final box = GetStorage();
            String manager_manageEMail = await box.read('manager');
            String chengeKind = ['게시', '숨김', '삭제'][vmhandler.radioChangeFeedIndex!];
            
            vmhandler.changeFeedState(vmhandler.searchFeedList[vmhandler.searchFeedIndex!].feedName!, manager_manageEMail, chengeKind);

            Get.back();
            vmhandler.dailogFeedRadioChanged(0);
          },
          child: const Text('처리'),
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('취소'),
        ),
      ],
    );
  }

}//End