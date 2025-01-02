import 'package:calculator/button_values.dart';
import 'package:flutter/material.dart';


class  CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}


class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = ""; // . 0-9
  String operand = ""; // + - * /
  String number2 = ""; // . 0-9

  @override
  Widget build(BuildContext context) {
    final screenSize=MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
          //output
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(16),
              child: Text(
                "$number1$operand$number2".isEmpty?"0":"$number1$operand$number2",
              style: TextStyle(
                fontSize:58,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,),
            ),
          ),
          // buttons
            Expanded(
              flex: 2,
                child: Wrap(
                  alignment: WrapAlignment.center, 
                  runSpacing: 8.0, 
                  spacing: 8.0, 
                  children: Btn.buttonValues
                      .map(
                        (value) => SizedBox(
                          width: screenSize.width / 5,
                          height: screenSize.width / 11,
                          child: buildButton(value),
                        ),
                      )
                      .toList(),
                ),
            ),
        ],),
      ),
    );
  }

  Widget buildButton(value){
       return Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide:BorderSide(
            color:Colors.white24,
          ) ,
          borderRadius: BorderRadius.circular(100)
        ),
         child: InkWell(
          onTap: ()=>onBtnTap(value),
           child: Center(
            child:Text(value,
            style:TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24
            )) ,
            ),
         ),
       );
  }


//onBtnTap
void onBtnTap(String value){
  if(value==Btn.del){
    delete();
    return;
  }
  if(value==Btn.clr){
    clearall();
    return;
  }
  if(value==Btn.per){
    percentage();
    return;
  }
  if(value==Btn.calculate){
    calculate();
    return;
  }
  appendValue(value);
}


//percentage
void percentage(){
  if(number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty){
    calculate();
  }

  if(operand.isNotEmpty){
    return;
  }

  final number= double.parse(number1);
  setState((){
     number1=(number/100).toString();
     number2="";
     operand="";
  });
}

//calculate
void calculate(){
  if (number1.isEmpty) return;
  if(operand.isEmpty) return;
  if(number2.isEmpty) return;

   final double num1 = double.parse(number1);
   final double num2 = double.parse(number2);
 
  var result=0.0;
   switch(operand){
    case Btn.add:
      result=num1+num2;
      break;
    case Btn.subtract:
      result=num1-num2;
      break;
    case Btn.multiply:
      result=num1*num2;
      break;
    case Btn.divide:
      if(num2==0){
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cannot divide by 0')),
    );
      }
      else{
      result=num1/num2;
      }
      break;
    default:
   }

   setState((){
    number1=result.toString();
    // number1=result.toStringAsPrecision(2);

    if(number1.endsWith(".0")){
      number1=number1.substring(0,number1.length-2);
    }

    number2= "";
    operand= "";
   });
}


//clearall
void clearall(){
  setState((){
    number1="";
    number2="";
    operand="";
  });
}


//Delete
void delete(){
  if(number2.isNotEmpty){
    number2=number2.substring(0,number2.length-1);
  }
  else if(operand.isNotEmpty){
    operand="";
  }
  else if(number1.isNotEmpty){
    number1=number1.substring(0,number1.length-1);
  }
  setState(() {});
} 

//COndition --> append
void appendValue(String value){
  if(value!=Btn.dot && int.tryParse(value)==null){
    if(operand.isNotEmpty && number2.isNotEmpty){
         calculate();
    }
    operand=value;
  }
  else if(number1.isEmpty || operand.isEmpty){
    if(value==Btn.dot && number1.contains(Btn.dot))return;
    if(value==Btn.dot && (number1.isEmpty || number1==Btn.n0)){
      value="0.";
    }
    number1+=value;
  }
  else if(number2.isEmpty || operand.isNotEmpty){
    if(value==Btn.dot && number2.contains(Btn.dot))return;
    if(value==Btn.dot && (number2.isEmpty || number2==Btn.n0)){
      value="0.";
    }
    number2+=value;
  }
  setState(() {});
}




  // button colors
  Color getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate,
          ].contains(value)
            ? Colors.orange
            : Colors.black87;
  }

}