import 'package:vision_ucb_frontend/compiler/interpreter.dart';
import 'package:vision_ucb_frontend/compiler/tokenizer.dart';
import 'package:vision_ucb_frontend/compiler/parser.dart';

List<String> program1 = [
  'int a',
  'a=10',
  'for i=10 to 0',
  'print i',
  'for j = 0 to 15',
  'print j',
  'end',
  'end'
];

List<String> program2 = [
  'int a',
  'a=10',
  'print a',
  'for i=0 to 10',
  'print i',
  'end'
];

String compile(List<String> program) {
  var compiled = [];
  String result = "";
  print("Llegada despues Split");
  for(var i in program ){
    print(i);
    
  }
  // print(program.length);
  // print(program2.length);
  // for(var i = 0; i< program.length; i++){
  //   print(program[i] + "|" + program2[i]);
  //   print(program[i].compareTo(program2[i]));
  // }
  try {
    //print(program);
    var tokens = read(program);
    var tree = parser(tokens);
    compiled = interpreter(tree);
  } 
  catch (e) {
    if(e.toString().contains('RangeError')){
      print('Expected end');
    }
    else{
      print(e);
    }
  }
  for(var i in compiled){
    print(i);
    result = result + i.toString() +"\n";
  }
  return result;
}
