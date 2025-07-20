import 'package:flutter/material.dart';
import 'package:device_frame_plus/device_frame_plus.dart';
import 'package:ecotte/screen/home_screen.dart';
import 'package:ecotte/screen/auth_screen/login_screen/login_screen.dart';
import 'package:ecotte/utility/extensions.dart';
import 'package:get/get.dart'; // if not already

class FramePreviewWrapper extends StatefulWidget {
  final Widget child;
  const FramePreviewWrapper({super.key, required this.child});

  @override
  State<FramePreviewWrapper> createState() => _FramePreviewWrapperState();
}

class _FramePreviewWrapperState extends State<FramePreviewWrapper> {
  bool enableDeviceSelection = true;
  final DeviceInfo defaultDevice = Devices.ios.iPhone13ProMax;

  final Map<String, List<DeviceInfo>> deviceMap = {
    'Android': Devices.android.all,
    'iOS': Devices.ios.all,
    'macOS': Devices.macOS.all,
    'Windows': Devices.windows.all,
    'Linux': Devices.linux.all,
  };

  late String selectedPlatform;
  late DeviceInfo selectedDevice;

  @override
  void initState() {
    super.initState();
    selectedPlatform = 'iOS';
    selectedDevice = deviceMap[selectedPlatform]!.first;
  }

  @override
  Widget build(BuildContext context) {
    // final user = context.userProvider.getLoginUsr();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            if (enableDeviceSelection)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.grey[200],
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isSmallScreen = constraints.maxWidth < 600;

                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 3,
                          runSpacing: 5,
                          children: [
                            const Text("Platform:"),
                            // const SizedBox(height: 10),
                            DropdownButton<String>(
                              value: selectedPlatform,
                              onChanged: (newPlatform) {
                                if (newPlatform == null) return;
                                setState(() {
                                  selectedPlatform = newPlatform;
                                  selectedDevice =
                                      deviceMap[newPlatform]!.first;
                                });
                              },
                              items: deviceMap.keys
                                  .map(
                                    (platform) => DropdownMenuItem(
                                      value: platform,
                                      child: Text(platform),
                                    ),
                                  )
                                  .toList(),
                            ),
                            // const SizedBox(width: 10),
                            const Text("Device:"),
                            // const SizedBox(width: 2),
                            DropdownButton<DeviceInfo>(
                              value: selectedDevice,
                              onChanged: (newDevice) {
                                if (newDevice == null) return;
                                setState(() => selectedDevice = newDevice);
                              },
                              items: deviceMap[selectedPlatform]!
                                  .map(
                                    (device) => DropdownMenuItem(
                                      value: device,
                                      child: Text(device.name),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text("Enable Preview:"),
                                Switch(
                                  value: enableDeviceSelection,
                                  onChanged: (val) {
                                    setState(() => enableDeviceSelection = val);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: enableDeviceSelection
                        ? DeviceFrame(
                            device: selectedDevice,
                            isFrameVisible: true,
                            orientation: Orientation.portrait,
                            screen: widget.child,
                          )
                        : DeviceFrame(
                            device: defaultDevice,
                            isFrameVisible: true,
                            orientation: Orientation.portrait,
                            screen: widget.child,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
