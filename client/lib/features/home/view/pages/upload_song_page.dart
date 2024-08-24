import 'dart:io';

import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:client/features/home/viewmodel/song_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
// import 'package:flex_color_picker/flex_color_picker.dart';
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
  final formKey = GlobalKey<FormState>();
  Color selectedColor = Pallete.cardColor;
  File? selectedImage;
  File? selectedAudio;

  void selectAudio() async {
    final pickedAudio = await pickAudio();
    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    artistController.dispose();
    songNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(homeViewModelProvider.select((val) => val?.isLoading == true));
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Upload Song',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (formKey.currentState!.validate() && selectedAudio != null) {
                ref.read(homeViewModelProvider.notifier).uploadSong(
                      selectedAudio: selectedAudio!,
                      songName: songNameController.text,
                      artist: artistController.text,
                      // selectedColor: selectedColor,
                    );
              } else {
                showSnackBar(context, 'Missing Fields!');
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: selectedImage != null
                            ? SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Image.file(selectedImage!,
                                    fit: BoxFit.cover))
                            : DottedBorder(
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
                                      Text(
                                        'Select the thumbnail for your song',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 45,
                      ),
                      selectedAudio != null
                          ? AudioWave(path: selectedAudio!.path)
                          : CustomField(
                              hintText: 'Pick Song',
                              controller: null,
                              readOnly: true,
                              onTap: selectAudio,
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
                      const SizedBox(
                        height: 20,
                      ),
                      // ConstrainedBox(
                      //   constraints: const BoxConstraints(
                      //     minWidth: 200,
                      //     maxWidth: double.infinity,
                      //   ),
                      //   child: ColorPicker(
                      //     pickersEnabled: const {
                      //       ColorPickerType.wheel: true,
                      //     },
                      //     color: selectedColor,
                      //     onColorChanged: (Color color) {
                      //       setState(() {
                      //         selectedColor = color;
                      //       });
                      //     },
                      // heading: Text(
                      //   'Select color',
                      //   style: Theme.of(context).textTheme.headline5,
                      // ),
                      // subheading: Text(
                      //   'Pick a color shade',
                      //   style: Theme.of(context).textTheme.subtitle1,
                      // ),
                      //  ),
                      //  ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
