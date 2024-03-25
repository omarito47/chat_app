import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

class AgoraVideoChatWidget extends StatefulWidget {
  final String channelName;
  final String userName;

  const AgoraVideoChatWidget({
    Key? key,
    required this.channelName,
    required this.userName,
  }) : super(key: key);

  @override
  State<AgoraVideoChatWidget> createState() => _AgoraVideoChatWidgetState();
}

class _AgoraVideoChatWidgetState extends State<AgoraVideoChatWidget> {
  late final AgoraClient client;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: "84018ededd484e6b8821c26bd528a0a1",
        channelName: widget.channelName,
        username: widget.userName,
      ),
    );
    await client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora VideoUIKit'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: client,
              layoutType: Layout.floating,
              enableHostControls: true, // Add this to enable host controls
            ),
            AgoraVideoButtons(
              client: client,
              addScreenSharing: false, // Add this to enable screen sharing
            ),
          ],
        ),
      ),
    );
  }
}