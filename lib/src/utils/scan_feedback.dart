import 'package:audioplayers/audioplayers.dart';

/// Plays short audio cues as feedback for barcode/QR scans.
///
/// [ok] is played when a valid code is accepted, [error] when a code is
/// rejected (e.g. shorter than the configured barcode length). Two dedicated
/// players are reused in low-latency mode so feedback stays snappy even when
/// codes are scanned in quick succession. Playback is best-effort: failures
/// are swallowed so audio never breaks the scan flow.
class ScanFeedback {
  ScanFeedback._();

  static final ScanFeedback instance = ScanFeedback._();

  final AudioPlayer _okPlayer = AudioPlayer(playerId: 'scan_ok');
  final AudioPlayer _errorPlayer = AudioPlayer(playerId: 'scan_error');
  bool _configured = false;

  void _ensureConfigured() {
    if (_configured) return;
    _configured = true;
    for (final player in [_okPlayer, _errorPlayer]) {
      player.setReleaseMode(ReleaseMode.stop);
      player.setPlayerMode(PlayerMode.lowLatency);
    }
  }

  /// Beep for a correctly received code.
  Future<void> ok() => _play(_okPlayer, 'sounds/beep_ok.wav');

  /// Distinct lower tone for an incorrect / rejected code.
  Future<void> error() => _play(_errorPlayer, 'sounds/beep_error.wav');

  Future<void> _play(AudioPlayer player, String asset) async {
    _ensureConfigured();
    try {
      await player.stop();
      await player.play(AssetSource(asset));
    } catch (_) {
      // Audio feedback is best-effort; never break the scan flow.
    }
  }

  Future<void> dispose() async {
    await _okPlayer.dispose();
    await _errorPlayer.dispose();
  }
}
