import 'package:client/core/widgets/custom_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final artistController = TextEditingController();
  final songNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    artistController.dispose();
    songNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Upload Song',
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              DottedBorder(
                  color: const Color.fromARGB(255, 158, 156, 177),
                  radius: const Radius.circular(10),
                  borderType: BorderType.RRect,
                  dashPattern: const [10, 10],
                  strokeCap: StrokeCap.round,
                  child: const SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_open, size: 40),
                        SizedBox(
                          height: 15,
                        ),
                        Text('Select the thumbnail for your song',
                            style: TextStyle(
                              fontSize: 15,
                            ))
                      ],
                    ),
                  )),
              const SizedBox(
                height: 45,
              ),
              CustomField(
                hintText: 'Pick Song',
                controller: null,
                readOnly: true,
                onTap: () {},
              ),
              const SizedBox(
                height: 20,
              ),
              CustomField(
                hintText: 'Artist',
                controller: artistController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomField(
                hintText: 'Song Name',
                controller: songNameController,
              ),
            ],
          ),
        ));
  }
}
