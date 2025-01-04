import 'package:logger/logger.dart';

Logger getLogger(String className, String method){
  return Logger(printer: CustomLogPrinter(className, method));
}

class CustomLogPrinter extends LogPrinter{
  final String className;
  final String method;
  CustomLogPrinter(this.className, this.method);

  @override
  List<String> log(LogEvent event) {
    AnsiColor? color = PrettyPrinter.defaultLevelColors[event.level];
    String? emoji = PrettyPrinter.defaultLevelEmojis[event.level];
    return [color!('$emoji $className | $method - ${event.message}')];
  }
}