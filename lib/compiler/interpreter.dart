import 'dart:math';
import 'package:petitparser/petitparser.dart';

var variables = [];
var output_console = [];

List interpreter(Map tree) {
  if (tree['type'] == 'program') {
    compile(tree['body']);
  }
  print(variables);
  return output_console;
}

void compile(List program) {
  for (var exp in program) {
    if (exp['type'] == 'declare') {
      declare(exp);
    }
    if (exp['type'] == 'assign') {
      assign(exp);
    }
    if (exp['type'] == 'conditional') {
      conditional(exp);
    }
    if (exp['type'] == 'output') {
      output(exp);
    }
    if (exp['type'] == 'whileLoop') {
      whileLoop(exp);
    }
    if (exp['type'] == 'forLoop') {
      forLoop(exp);
    }
  }
  print(variables);
}

void declare(Map exp) {
  variables.add({
    'type': exp['build'],
    'var': exp['value'],
    'value': null,
  });
}

void assign(Map exp) {
  var pos = search_var(exp['left']);
  var str = '';
  if (pos > -1) {
    for (var nodo in exp['right']) {
      if (nodo['type'] == 'number') {
        str += nodo['value'];
      }
      if (nodo['type'] == 'op') {
        str += nodo['value'];
      }
      if (nodo['type'] == 'var') {
        str += variables[search_var(nodo['value'])]['value'];
      }
      if (nodo['type'] == 'punc') {
        str += nodo['value'];
      }
    }
    variables[pos]['value'] = calcString(str).toString();
  } else {
    throw (exp['left'] + ' variable no declarada');
  }
}

int search_var(String vari) {
  for (var i = 0; i < variables.length; i++) {
    if (variables[i]['var'] == vari) {
      return i;
    }
  }
  return -1;
}

Parser buildParser() {
  final builder = ExpressionBuilder();
  builder.group()
    ..primitive((pattern('+-').optional() &
            digit().plus() &
            (char('.') & digit().plus()).optional() &
            (pattern('eE') & pattern('+-').optional() & digit().plus())
                .optional())
        .flatten('number expected')
        .trim()
        .map(num.tryParse))
    ..wrapper(
        char('(').trim(), char(')').trim(), (left, value, right) => value);
  builder.group()..prefix(char('-').trim(), (op, a) => -a);
  builder.group()..right(char('^').trim(), (a, op, b) => pow(a, b));
  builder.group()
    ..left(char('*').trim(), (a, op, b) => a * b)
    ..left(char('/').trim(), (a, op, b) => a / b);
  builder.group()
    ..left(char('+').trim(), (a, op, b) => a + b)
    ..left(char('%').trim(), (a, op, b) => a % b)
    ..left(char('-').trim(), (a, op, b) => a - b);
  return builder.build().end();
}

double calcString(String text) {
  final parser = buildParser();
  final input = text;
  final result = parser.parse(input);
  if (result.isSuccess) {
    return result.value.toDouble();
  } else {
    return double.parse(text);
  }
}

void conditional(Map exp) {
  var cond = verifyCondition(exp['cond']);
  if (cond) {
    compile(exp['body']);
  } else {
    if (exp['else'].isNotEmpty) {
      compile(exp['else']);
    }
  }
}

bool verifyCondition(Map exp) {
  var flag = false;
  var a;
  var b;
  if (exp['type'] == 'binary') {
    if (isNumber(exp['right'])) {
      b = double.parse(exp['right']);
    } else {
      if (search_var(exp['right']) == -1) {
        throw ('Variable no existe');
      } else {
        b = double.parse(variables[search_var(exp['right'])]['value']);
      }
    }

    if (isNumber(exp['left'])) {
      a = double.parse(exp['left']);
    } else {
      if (search_var(exp['left']) == -1) {
        throw ('Variable no existe');
      } else {
        a = double.parse(variables[search_var(exp['left'])]['value']);
      }
    }
    switch (exp['operator']) {
      case '&&':
        return a != false && b;
      case '||':
        return a != false ? a : b;
      case '<':
        return a < b;
      case '>':
        return a > b;
      case '<=':
        return a <= b;
      case '>=':
        return a >= b;
      case '==':
        return a == b;
      case '!=':
        return a != b;
    }
  }
}

bool isNumber(var char) {
  final numeric = RegExp(r'^[0-9.]+$');
  return numeric.hasMatch(char);
}

void output(Map exp) {
  if (exp['value'].toString().startsWith('"')) {
    output_console.add(exp['value'].toString().replaceAll('"', ''));
  } else {
    var pos = search_var(exp['value']);
    if (pos == -1) {
      throw ('Variable no existe');
    } else {
      if (variables[pos]['type'] == 'int') {
        var num_int = variables[pos]['value']
            .toString()
            .replaceAll('"', '')
            .split('.')[0];

        output_console.add(int.parse(num_int).toString());
      }
      if (variables[pos]['type'] == 'float') {
        output_console.add(
            double.parse(variables[pos]['value'].toString().replaceAll('"', ''))
                .toString());
      }
      if (variables[pos]['type'] == 'string') {
        output_console
            .add(variables[pos]['value'].toString().replaceAll('"', ''));
      }
    }
  }
}

void whileLoop(Map exp) {
  while (verifyCondition(exp['cond'])) {
    compile(exp['body']);
  }
}

void forLoop(Map exp) {
  //create local variable i
  if (exp['localVar']['left']['type'] == 'var') {
    if (exp['localVar']['right']['type'] == 'number') {
      variables.add({
        'type': 'int',
        'var': exp['localVar']['left']['value'],
        'value': exp['localVar']['right']['value'],
      });
    } else {
      if (exp['localVar']['right']['type'] == 'var') {
        var pos = search_var(exp['localVar']['right']['value']);
        if (pos != -1) {
          variables.add({
            'type': 'int',
            'var': exp['localVar']['left']['value'],
            'value': variables[pos]['value'],
          });
        } else {
          throw (exp['localVar']['right']['value'] + ' Variable no declarada');
        }
      }
    }
  }
  //loop through
  var pos = search_var(exp['localVar']['left']['value']);
  if (int.parse(variables[pos]['value'].toString().trim().replaceAll('"', '')) <
      int.parse(exp['limit']['value'].toString().trim())) {
    for (var i = int.parse(
            variables[pos]['value'].toString().trim().replaceAll('"', ''));
        i < int.parse(exp['limit']['value'].toString().trim());
        i++) {
      compile(exp['body']);
      var pos = search_var(exp['localVar']['left']['value']);
      variables[pos]['value'] = (i + 1).toString();
    }
  } else {
    if (int.parse(
            variables[pos]['value'].toString().trim().replaceAll('"', '')) >
        int.parse(exp['limit']['value'].toString().trim())) {
      for (var i = int.parse(
              variables[pos]['value'].toString().trim().replaceAll('"', ''));
          i > int.parse(exp['limit']['value'].toString().trim());
          i--) {
        compile(exp['body']);
        var pos = search_var(exp['localVar']['left']['value']);
        variables[pos]['value'] = (i - 1).toString();
      }
    }
  }
  pos = search_var(exp['localVar']['left']['value']);
  variables.removeAt(pos);
}
//juin
