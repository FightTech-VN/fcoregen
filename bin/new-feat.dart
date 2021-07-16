import 'package:args/args.dart';
import 'package:fcoregen/fcoregen.dart' as fcoregen;

void main(List<String> args) {
  var parser = ArgParser();
  parser.addOption('path',
      callback: (path) => {fcoregen.handleGenerateFeature()});
  parser.parse(args);
}
