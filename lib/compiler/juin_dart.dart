import 'package:vision_ucb_frontend/compiler/interpreter.dart';
import 'package:vision_ucb_frontend/compiler/tokenizer.dart';
import 'package:vision_ucb_frontend/compiler/parser.dart';

List<String> program = [
  'int a',
  'a = 10',
  'for i=10 to 0',
  'print i',
  'for j = 0 to 15',
  'print j',
  'end',
  'end'
];

List compile() {
  var compiled = [];
  try {
    var tokens = read(program);
    print(tokens);
    var tree = parser(tokens);
    compiled = interpreter(tree);
    print(compiled);
  } 
  catch (e) {
    if(e.toString().contains('RangeError')){
      print('Expected end');
    }
    else{
      print(e);
    }
  }
  return compiled;
}
