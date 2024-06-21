import 'dart:async';
import 'dart:io';

import 'package:rugbydriver/constant/constant.dart';
import 'package:rugbydriver/constant/show_toast_dialog.dart';
import 'package:rugbydriver/controller/conversation_controller.dart';
import 'package:rugbydriver/themes/constant_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'FullScreenImageViewer.dart';
import 'FullScreenVideoViewer.dart';

class ConversationScreen extends StatelessWidget {
  ConversationScreen({Key? key}) : super(key: key);

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GetX<ConversationController>(
      init: ConversationController(),
      initState: (controller) {
        if (_controller.hasClients) {
          Timer(const Duration(milliseconds: 500),
              () => _controller.jumpTo(_controller.position.maxScrollExtent));
        }
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: ConstantColors.background,
          appBar: AppBar(
            backgroundColor: ConstantColors.background,
            leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                )),
            centerTitle: true,
            title: Text(controller.receiverName.value,
                style: const TextStyle(color: Colors.black)),
          ),
          body: Column(
            children: [
              Expanded(
                child: PaginateFirestore(
                  scrollController: _controller,
                  physics: const BouncingScrollPhysics(),
                  onEmpty: Center(
                    child: Text(
                      "No message found".tr,
                      style: TextStyle(
                          color: ConstantColors.titleTextColor, fontSize: 16),
                    ),
                  ),
                  itemBuilder: (context, documentSnapshots, index) {
                    final data = documentSnapshots[index].data() as Map?;
                    return chatItemView(
                        data!['senderId'] == controller.senderId.value,
                        data,
                        controller);
                  },
                  // orderBy is compulsory to enable pagination
                  query: Constant.conversation
                      .doc(
                          "${controller.senderId.value < controller.receiverId.value ? controller.senderId.value : controller.receiverId.value}-${controller.orderId}-${controller.senderId.value < controller.receiverId.value ? controller.receiverId.value : controller.senderId.value}")
                      .collection("thread")
                      .orderBy('created', descending: false),
                  //Change types accordingly
                  itemBuilderType: PaginateBuilderType.listView,
                  // to fetch real-time data
                  isLive: true,
                ),
              ),
              buildMessageInput(controller, context)
            ],
          ),
        );
      },
    );
  }

  Widget chatItemView(bool isMe, Map<dynamic, dynamic> data,
      ConversationController controller) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: isMe
          ? Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  data['type'].toString() == "text"
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                            color: ConstantColors.primary,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Text(
                            data['message'].toString(),
                            style: TextStyle(
                                color: data['senderId'] ==
                                        controller.senderId.value
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        )
                      : data['type'] == "image"
                          ? ConstrainedBox(
                              constraints: const BoxConstraints(
                                minWidth: 50,
                                maxWidth: 200,
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(FullScreenImageViewer(
                                            imageUrl: data['url']['url'],
                                          ));
                                        },
                                        child: Hero(
                                          tag: data['url']['url'],
                                          child: CachedNetworkImage(
                                            imageUrl: data['url']['url'],
                                            placeholder: (context, url) =>
                                                Constant.loader(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ]),
                              ))
                          : FloatingActionButton(
                              mini: true,
                              heroTag: data['id'],
                              backgroundColor: ConstantColors.primary,
                              onPressed: () {
                                Get.to(FullScreenVideoViewer(
                                  heroTag: data['id'],
                                  videoUrl: data['url']['url'],
                                ));
                              },
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                              ),
                            ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CachedNetworkImage(
                        imageUrl: controller.senderPhoto.value,
                        height: 35,
                        width: 35,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CachedNetworkImage(
                      imageUrl: controller.receiverPhoto.value,
                      height: 35,
                      width: 35,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                data['type'] == "text"
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          color: Colors.grey.shade300,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Text(
                          data['message'].toString(),
                          style: TextStyle(
                              color:
                                  data['senderId'] == controller.senderId.value
                                      ? Colors.white
                                      : Colors.black),
                        ),
                      )
                    : data['type'] == "image"
                        ? ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 50,
                              maxWidth: 200,
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              child:
                                  Stack(alignment: Alignment.center, children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(FullScreenImageViewer(
                                      imageUrl: data['url']['url'],
                                    ));
                                  },
                                  child: Hero(
                                    tag: data['url']['url'],
                                    child: CachedNetworkImage(
                                      imageUrl: data['url']['url'],
                                      placeholder: (context, url) =>
                                          Constant.loader(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ]),
                            ))
                        : FloatingActionButton(
                            mini: true,
                            heroTag: data['id'],
                            backgroundColor: ConstantColors.primary,
                            onPressed: () {
                              Get.to(FullScreenVideoViewer(
                                heroTag: data['id'],
                                videoUrl: data['url']['url'],
                              ));
                            },
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ),
                          ),
              ],
            ),
    );
  }

  static final _messageController = TextEditingController();

  Widget buildMessageInput(
      ConversationController controller, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 50,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  onPressed: () async {
                    _onCameraClick(context, controller);
                  },
                  icon: const Icon(Icons.camera_alt),
                  color: ConstantColors.primary,
                ),
              ),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextField(
                  textInputAction: TextInputAction.send,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  controller: _messageController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.05),
                    contentPadding: const EdgeInsets.only(top: 3, left: 10),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.05), width: 0.0),
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.05), width: 0.0),
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                    ),
                    hintText: 'Start typing ...'.tr,
                  ),
                  onSubmitted: (value) {
                    controller.sendMessage(_messageController.text.trim(),
                        Url(mime: '', url: ''), "", "text");
                    Timer(
                        const Duration(milliseconds: 500),
                        () => _controller
                            .jumpTo(_controller.position.maxScrollExtent));
                    _messageController.clear();
                  },
                ),
              )),
              Container(
                margin: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  onPressed: () async {
                    if (_messageController.text.trim().isNotEmpty) {
                      controller.sendMessage(_messageController.text.trim(),
                          Url(mime: '', url: ''), "", "text");
                      Timer(
                          const Duration(milliseconds: 500),
                          () => _controller
                              .jumpTo(_controller.position.maxScrollExtent));
                      _messageController.clear();
                    } else {
                      ShowToastDialog.showToast("Please enter a message".tr);
                    }
                  },
                  icon: const Icon(Icons.send_rounded),
                  color: ConstantColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onCameraClick(BuildContext context, ConversationController controller) {
    final action = CupertinoActionSheet(
      message: Text(
        'Send media'.tr,
        style: const TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: false,
          onPressed: () async {
            Get.back();
            XFile? image =
                await ImagePicker().pickImage(source: ImageSource.gallery);
            if (image != null) {
              Url url =
                  await Constant.uploadChatImageToFireStorage(File(image.path));
              controller.sendMessage("Sent an image".tr, url, "", 'image');
            }
          },
          child: Text('Choose image from gallery'.tr),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: false,
          onPressed: () async {
            Get.back();
            XFile? galleryVideo =
                await ImagePicker().pickVideo(source: ImageSource.gallery);
            if (galleryVideo != null) {
              ChatVideoContainer videoContainer =
                  await Constant.uploadChatVideoToFireStorage(
                      File(galleryVideo.path));
              controller.sendMessage(
                  "Sent an video".tr,
                  videoContainer.videoUrl,
                  videoContainer.thumbnailUrl,
                  'video');
            }
          },
          child: Text('Choose video from gallery'.tr),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: false,
          onPressed: () async {
            Get.back();
            XFile? image =
                await ImagePicker().pickImage(source: ImageSource.camera);
            if (image != null) {
              Url url =
                  await Constant.uploadChatImageToFireStorage(File(image.path));
              controller.sendMessage('Sent an image'.tr, url, '', 'image');
            }
          },
          child: Text('Take a picture'.tr),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: false,
          onPressed: () async {
            Get.back();
            XFile? recordedVideo =
                await ImagePicker().pickVideo(source: ImageSource.camera);
            if (recordedVideo != null) {
              ChatVideoContainer videoContainer =
                  await Constant.uploadChatVideoToFireStorage(
                      File(recordedVideo.path));
              controller.sendMessage(
                  'Sent an video'.tr,
                  videoContainer.videoUrl,
                  videoContainer.thumbnailUrl,
                  'video');
            }
          },
          child: Text('Record video'.tr),
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          'cancel'.tr,
        ),
        onPressed: () {
          Get.back();
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }
}

class ChatVideoContainer {
  Url videoUrl;

  String thumbnailUrl;

  ChatVideoContainer({required this.videoUrl, required this.thumbnailUrl});
}
