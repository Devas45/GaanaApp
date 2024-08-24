import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioWave extends StatefulWidget {
  final String path;
  const AudioWave({super.key, required this.path});

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  final PlayerController playercontroller = PlayerController();

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  void initAudioPlayer() async {
    await playercontroller.preparePlayer(path: widget.path);
  }

  Future<void> playandpause() async {
    if (!playercontroller.playerState.isPlaying) {
      await playercontroller.startPlayer(finishMode: FinishMode.stop);
    } else if (!playercontroller.playerState.isPaused) {
      await playercontroller.stopPlayer();
    }
    setState(() {});
  }

  @override
  void dispose() {
    playercontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      IconButton(
        onPressed: playandpause,
        icon: Icon(
          playercontroller.playerState.isPlaying
              ? CupertinoIcons.pause_solid
              : CupertinoIcons.play_arrow_solid,
        ),
      ),
      Expanded(
        child: AudioFileWaveforms(
          size: const Size(double.infinity, 100),
          playerController: playercontroller,
          playerWaveStyle: const PlayerWaveStyle(
            fixedWaveColor: Pallete.borderColor,
            liveWaveColor: Pallete.gradient2,
            spacing: 6,
            showSeekLine: false,
          ),
        ),
      ),
    ]);
  }
}
