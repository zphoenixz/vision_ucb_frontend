import 'dart:ffi';

var mapProgram = <Map<String, dynamic>>[];
var kw = [
  'int',
  'float',
  'string',
  'print',
  'if',
  'else',
  'end',
  'while',
  'for',
  'to',
  'input'
];

List<Map> read(List<String> program) {
  var mapProgram = <Map<String, dynamic>>[];
  for (var i = 0; i < program.length; i++) {
    //print('Linea $i => ' + program[i]);
    //print(novis_tk.tokenizer((program[i]).toString(), i));
    var line = i+1;
    mapProgram = tokenizer((program[i]).toString(), line);
  }
  return mapProgram;
}


List<Map<String, dynamic>> tokenizer (String line, int num_line) {
  var c = 0;
  while (c < line.length) {
    var char = line[c];
    //print(char);
    if (char == '#') {
      break;
    }
    if (char == ' ') {
      c++;
      continue;
    }
    if (char == '(') {
      mapProgram.add({'type': 'punc', 'value': '(', 'line': num_line.toString()});
      c++;
      continue;
    }
    if (char == ')') {
      mapProgram.add({'type': 'punc', 'value': ')', 'line': num_line.toString()});
      c++;
      continue;
    }
    if (char == '"') {
      c++;
      c = readString(c, line, num_line);
      continue;
    }
    if (isChar(char)) {
      c = readVarKW(c, line, num_line);
      continue;
    }
    if (isNumber(char)) {
      c = readNumber(c, line, num_line);
      continue;
    }
    if (isOperator(char)) {
      c = readOperator(c, line, num_line);
    } else {
      throw('I can\'t read <' + char + '>');
    }
  }
  return(mapProgram);
}

int readString(int c, String line, int num_line) {
  var str = '"';
  while (c < line.length) {
    var char = line[c];
    if (char != '"') {
      str += char;
      c++;
    } else {
      str += char;
      c++;
      break;
    }
  }
  mapProgram.add({'type': 'string', 'value': str, 'line': num_line.toString()});
  return c;
}

bool isKeyword(String s) {
  for (var key in kw) {
    if (key == s) {
      return true;
    }
  }
  return false;
}

bool isChar(var char) {
  final alpha = RegExp(r'^[a-zA-Z]+$');
  return alpha.hasMatch(char);
}

int readVarKW(int c, String line, int num_line) {
  var str = '';
  var lgth = line.length;
  lgth -= 1;
  while (c < line.length) {
    var char = line[c];
    if (isChar(char)) {
      str += char;
      if (isKeyword(str)) {
        c++;
        mapProgram.add({'type': 'kw', 'value': str.trim(), 'line': num_line.toString()});
        break;
      }
      if (c == lgth) {
        c++;
        mapProgram.add({'type': 'var', 'value': str.trim(), 'line': num_line.toString()});
        break;
      }
      c++;
    } else {
      mapProgram.add({'type': 'var', 'value': str.trim(), 'line': num_line.toString()});
      break;
    }
  }
  return c;
}

bool isNumber(var char) {
  //final numeric = RegExp(r'\d');
  final numeric = RegExp(r'^[0-9.]+$');
  return numeric.hasMatch(char);
}

int readNumber(int c, String line, int num_line) {
  var str = '';
  var lgth = line.length;
  lgth -= 1;
  while (c < line.length) {
    var char = line[c];
    if (isNumber(char)) {
      str += char;
      if (c == lgth) {
        c++;
        mapProgram
            .add({'type': 'number', 'value': str, 'line': num_line.toString()});
        break;
      }
      c++;
    } else {
      mapProgram
          .add({'type': 'number', 'value': str, 'line': num_line.toString()});
      break;
    }
  }
  return c;
}

bool isOperator(var char) {
  final numeric = RegExp(r'[!@#<>?":_`~;/[\]\\|=+)(*&^%\s-]');
  return numeric.hasMatch(char);
}

int readOperator(int c, String line, int num_line) {
  var str = '';
  var lgth = line.length;
  lgth -= 1;
  while (c < line.length) {
    var char = line[c];
    if (isOperator(char)) {
      str += char;
      if (c == lgth) {
        c++;
        mapProgram.add({'type': 'op', 'value': str.trim(), 'line': num_line.toString()});
        break;
      }
      c++;
    } else {
      mapProgram.add({'type': 'op', 'value': str.trim(), 'line': num_line.toString()});
      break;
    }
  }
  return c;
}
