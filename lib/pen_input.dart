import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pencil_field/pencil_field.dart';
import 'package:selvy_pen/pencil_field_with_tools.dart';

class PenInput extends StatefulWidget {
  final Function(String) onAnswerChanged;
  final int answerCount;
  final String memberAnswer;
  const PenInput({Key? key, required this.onAnswerChanged, required this.answerCount, required this.memberAnswer}) : super(key: key);

  @override
  _PenInputState createState() => _PenInputState();
}

class _PenInputState extends State<PenInput> {
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  List<String>? memberInput;
  late List<TextEditingController> _controllerList;
  final _pencilController = PencilFieldController();
  double scale = 1;
  bool enablePenInput = false;

  @override
  void initState() {
    super.initState();
    memberInput = List<String>.filled(widget.answerCount, "");
    _controllerList = [_controller1, _controller2, _controller3];
    if(widget.memberAnswer.isNotEmpty) {
      print(widget.memberAnswer);
      for(int i = 0; i<widget.answerCount; i++){
        try{
          memberInput![i] = widget.memberAnswer.split(",")[i].replaceAll("\\Box", "");
          // _controllerList[i].updateValue(TeXParser(memberInput?[i]??"").parse());
          _controllerList[i].text = memberInput![i].replaceAll("\\Box", "");
        }
        catch(e){
          _controllerList[i].clear();
          // e.printError(info: "PenInput initState");
        }
      }
    }

  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.answerCount>1){
      return Container(
        height: 116,
        child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 24),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: widget.answerCount,
            separatorBuilder: (BuildContext context, int index) => SizedBox(width: 8),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: MediaQuery.of(context).size.width-60,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.0),
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(16.0))
                ),
                child: _buildAnswerInput(_controllerList[index], index),
              );
            }
        ),
      );
    }
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 24),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.0),
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16.0))
          ),
          child: _buildAnswerInput(_controller1, 0),
        ),
      ],
    );
  }

  // AddPoint
  void _drawingChanged(PencilDrawing _) {
    setState(() {
      _pencilController.drawing.lastStroke.last.x.toInt();
      _pencilController.drawing.lastStroke.last.y.toInt();
    });
  }

  // EndStroke
  void _drawingCompleted(PencilDrawing _) {
    setState(() {
      enablePenInput = false;
      _pencilController.drawing.lastStroke.last.x.toInt();
      _pencilController.drawing.lastStroke.last.y.toInt();
    });
  }

  Widget _buildAnswerInput(TextEditingController controller, int index){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 8,),
        Text("정답 입력", style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),),
        SizedBox(height: 8,),
        Container(
          color: Colors.yellow,
          child: Wrap(
              children: [
                Center(
                  child: SizedBox(
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      autovalidateMode: AutovalidateMode.disabled,
                      enabled: true,
                      textAlign: TextAlign.center,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        isCollapsed: true,
                        isDense: true,contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        labelStyle: const TextStyle(color: Color(0xff333333), fontWeight: FontWeight.w600, fontSize: 18,),
                        hintStyle: const TextStyle(color: Color(0xffdedede), fontWeight: FontWeight.w600, fontSize: 18,),
                        hintText: "주관식 정답 입력",
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0),),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0),),
                        counterText: '',
                        prefixIcon: SizedBox.shrink(),
                        suffixIcon: controller.text.isNotEmpty
                            ?IconButton(
                          onPressed: (){
                            HapticFeedback.heavyImpact();
                            controller.clear();
                            print("controller.clear()");
                            print("controller.text = ${controller.text.replaceAll("\\Box", "")}");
                            memberInput?[index] = controller.text.replaceAll("\\Box", "");
                            print("memberInput = ${memberInput?.join(",")}");
                            widget.onAnswerChanged(memberInput?.join(",")??"");
                          },
                          icon: Icon(Icons.highlight_remove_rounded, color: Colors.grey, size: 20,),
                        )
                            :SizedBox.shrink(),
                      ),
                      style: const TextStyle(color: Color(0xff333333), fontWeight: FontWeight.w600, fontSize: 18),
                      keyboardType: TextInputType.none,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9.-]")),
                      ],
                      controller: controller,
                      maxLength: 11,
                      onChanged: (value){
                        HapticFeedback.heavyImpact();
                        print("value = ${value.replaceAll("\\Box", "")}");
                        memberInput?[index] = value.replaceAll("\\Box", "");
                        print("memberInput = ${memberInput?.join(",")}");
                        widget.onAnswerChanged(memberInput?.join(",")??"");
                      },
                      onTap: (){
                        setState(() {
                          enablePenInput = !enablePenInput;
                          // _pencilController.drawingAsImage();
                        });
                      },
                    ),
                  ),
                )
              ]
          ),
        ),
        Visibility(
            visible: enablePenInput,
            child: PencilFieldWithTools(
              controller: _pencilController,
              onPencilDrawingChanged: _drawingChanged,
              onPencilDrawingCompleted: _drawingCompleted,
            )
        ),
        SizedBox(height: 8,),
      ],
    );
  }
}