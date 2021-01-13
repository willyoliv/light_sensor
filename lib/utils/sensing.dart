import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

class Sensing {
  Study study;
  StudyController controller;

  Sensing();

  /// Start sensing.
  void start() async {
    // create the study
    study = Study(
      id: '2',
      userId: 'user@cachet.dk',
      name: 'A default / common study',
    )..addTriggerTask(
      ImmediateTrigger(),
      AutomaticTask()
        ..measures = SamplingSchema.debug().getMeasureList(
          namespace: NameSpace.CARP,
          types: [
            SensorSamplingPackage.LIGHT,
          ],
        ),
    );
    // Create a Study Controller that can manage this study and initialize it.
    controller = StudyController(
      study,
      debugLevel: DebugLevel.DEBUG,
      privacySchemaName: PrivacySchema.DEFAULT,
    );
    await controller.initialize();

    // Resume (i.e. start) data sampling.
    controller.resume();
  }

  // /// Is sensing running, i.e. has the study executor been resumed?
  bool get isRunning =>
      (controller != null) && controller.executor.state == ProbeState.resumed;

  /// Resume sensing
  void resume() async {
    controller.resume();
  }

  /// Pause sensing
  void pause() async {
    controller.pause();
  }

  /// Stop sensing.
  void stop() async {
    controller.stop();
    study = null;
  }
}