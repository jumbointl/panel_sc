import 'dart:convert';

import 'package:solexpress_panel_sc/src/models/sol_express_event.dart';

import 'object_with_name_and_id.dart';

PanelScConfig panelScConfigFromJson(String str) => PanelScConfig.fromJson(json.decode(str));

String panelScConfigToJson(PanelScConfig data) => json.encode(data.toJson());

class PanelScConfig extends ObjectWithNameAndId{

  String? host2nd;
  bool? repeatSpeaking;
  int? repeatSpeakingTimes;
  String? dbHost;
  int? dbPort;
  String? dbName;
  String? dbUser;
  String? dbPassword;
  String? listenTableName;
  String? listenChanelName;
  int? dBQueryIntervalInSeconds = 10;
  double? speedOfSpeech =0.35;
  String? languageOfSpeech ="es-ES";
  double? videoSoundVolume = 0.8;
  double? videoSoundVolumeWhenSpeaking = 0.0;
  String? sectorsIn ;

  int? showProgressBarEachXTimes = 10;
  String? logoUrl;
  String? eventName;
  String? landingUrl;
  int? barcodeLength;
  int? placeIdLength;
  int? timeOffsetMinutes;
  String? eventDate;
  int? eventId;
  SolExpressEvent? event;

  PanelScConfig({
    super.id,
    super.name,
    super.active,
    this.host2nd,
    this.repeatSpeaking,
    this.repeatSpeakingTimes,
    this.dbHost,
    this.dbPort,
    this.dbName,
    this.dbUser,
    this.dbPassword,
    this.listenTableName,
    this.listenChanelName,
    this.dBQueryIntervalInSeconds,
    this.speedOfSpeech,
    this.languageOfSpeech,
    this.videoSoundVolume,
    this.videoSoundVolumeWhenSpeaking,
    this.sectorsIn,
    this.showProgressBarEachXTimes,
    this.logoUrl,
    this.eventName,
    this.landingUrl,
    this.barcodeLength,
    this.placeIdLength,
    this.timeOffsetMinutes,
    this.eventDate,
    this.eventId,
    this.event,


  });


  factory PanelScConfig.fromJson(Map<String, dynamic> json) => PanelScConfig(
    id: json["id"],
    host2nd: json["host2nd"],
    name: json["name"],
    active: json["active"],
    repeatSpeaking: json["repeat_speaking"],
    repeatSpeakingTimes : json["repeat_speaking_times"],
    dbHost: json["db_host"],
    dbPort: json["db_port"],
    dbName: json["db_name"],
    dbUser: json["db_user"],
    dbPassword: json["db_password"],
    listenTableName: json["listen_table_name"],
    listenChanelName: json["listen_chanel_name"],
    dBQueryIntervalInSeconds: json["db_query_interval_in_seconds"],
    speedOfSpeech: json["speed_of_speech"],
    languageOfSpeech: json["language_of_speech"],
    videoSoundVolume: json["video_sound_volume"],
    videoSoundVolumeWhenSpeaking: json["video_sound_volume_when_speaking"],
    sectorsIn: json["sectors_in"],
    showProgressBarEachXTimes: json["show_progress_bar_each_x_times"],
    logoUrl: json["logo_url"],
    eventName: json["event_name"],
    landingUrl: json["landing_url"],
    barcodeLength: json["barcode_length"],
    placeIdLength: json["place_id_length"],
    timeOffsetMinutes: json["time_offset_minutes"],
    eventDate: json["event_date"],
    eventId: json["event_id"],
    event: SolExpressEvent.fromJson(json["event"]),
  );
  static List<PanelScConfig> fromJsonList(List<dynamic> list){
    List<PanelScConfig> newList =[];
    for (var item in list) {
      if(item is PanelScConfig){
        newList.add(item);
      } else {
        PanelScConfig panelScConfig = PanelScConfig.fromJson(item);
        newList.add(panelScConfig);
      }

    }
    return newList;
  }

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "host2nd" : host2nd,
    "name": name,
    "repeat_speaking": repeatSpeaking,
    "active":active,
    "repeat_speaking_times": repeatSpeakingTimes,
    "db_host": dbHost,
    "db_port": dbPort,
    "db_name": dbName,
    "db_user": dbUser,
    "db_password": dbPassword,
    "listen_table_name": listenTableName,
    "listen_chanel_name": listenChanelName,
    "db_query_interval_in_seconds": dBQueryIntervalInSeconds,
    "speed_of_speech": speedOfSpeech,
    "language_of_speech" : languageOfSpeech,
    "video_sound_volume" : videoSoundVolume,
    "video_sound_volume_when_speaking" : videoSoundVolumeWhenSpeaking,
    "sectors_in" : sectorsIn,
    "show_progress_bar_each_x_times" : showProgressBarEachXTimes,
    "logo_url" : logoUrl,
    "event_name" : eventName,
    "landing_url" : landingUrl,
    "barcode_length" : barcodeLength,
    "place_id_length" : placeIdLength,
    "time_offset_minutes" : timeOffsetMinutes,
    "event_date" : eventDate,
    "event_id" : eventId,
    "event" : event?.toJson(),
  };
}
