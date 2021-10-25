import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

//var ip = "http://192.168.50.117";
//var ip="http://192.168.159.1:80";
//var ip="http://183.182.107.122:9997";
var ip = "https://pos.cyberia.la/apims/web";
var urlapi = "${ip}/index.php?r=";
var urlimg = "${ip}/images";
var urlfile = "${ip}/files";
int connectTimeout = 60000; // 60 second
int receiveTimeout = 60000; // 60 second
CheckPlatform() {
  try {
    return Platform.operatingSystem; //in your code
  } catch (e) {
    return null; //in your code
  }
}

Map<int, TableColumnWidth> reportColumnWidths = CheckPlatform() == 'windows'
    ? {
        0: FixedColumnWidth(70),
        1: FlexColumnWidth(),
        2: FixedColumnWidth(110),
        3: FixedColumnWidth(110),
        4: FixedColumnWidth(110),
        5: FixedColumnWidth(110),
      }
    : {
        1: FixedColumnWidth(150),
      };

Map<int, TableColumnWidth> subJectColumnWidths = CheckPlatform() == 'windows'
    ? {
        0: FlexColumnWidth(),
        2: FixedColumnWidth(140),
        3: FixedColumnWidth(140),
        4: FixedColumnWidth(140),
        5: FixedColumnWidth(100),
        6: FixedColumnWidth(100),
      }
    : {};

Map<int, TableColumnWidth> abSentColumnWidths = CheckPlatform() == 'windows'
    ? {
        0: FixedColumnWidth(70),
        1: FixedColumnWidth(90),
        2: FlexColumnWidth(),
        3: FixedColumnWidth(110),
      }
    : {
        2: FixedColumnWidth(150),
      };
int absentCrossAxisCount = CheckPlatform() == 'windows' ? 5 : 2;
Map<int, TableColumnWidth> activityColumnWidths = CheckPlatform() == 'windows'
    ? {
        0: FixedColumnWidth(100),
        1: FlexColumnWidth(),
        2: FixedColumnWidth(160),
      }
    : {
        1: FixedColumnWidth(150),
      };
int activityCrossAxisCount = CheckPlatform() == 'windows' ? 5 : 2;

Map<int, TableColumnWidth> examColumnWidths = CheckPlatform() == 'windows'
    ? {
        0: FlexColumnWidth(),
        1: FlexColumnWidth(),
        2: FixedColumnWidth(90),
        3: FixedColumnWidth(120),
        4: FixedColumnWidth(140),
        5: FixedColumnWidth(70),
        6: FixedColumnWidth(100),
      }
    : {};

Map<int, TableColumnWidth> questionColumnWidths = CheckPlatform() == 'windows'
    ? {
        0: FixedColumnWidth(70),
        1: FlexColumnWidth(),
        2: FixedColumnWidth(100),
        3: FixedColumnWidth(100),
      }
    : {};
