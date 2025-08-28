import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:input_dialog/input_dialog.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';

import '../../data/memory.dart';
import '../../widgets/no_data_widget.dart';
import '../../models/idempiere/idempiere_filter.dart';
import 'idempiere_filter_generator.dart';

class IdempiereFilterCreatePageModel extends StatelessWidget implements IdempiereFilterGenerator{

  List<IdempiereFilter> idempiereFilters = <IdempiereFilter>[].obs;

  List<TextEditingController> valueControllers = <TextEditingController>[].obs;
  TextEditingController valueController = TextEditingController();
  //List<String> from IdempiereRESTCommand;
  List<String> operators = <String>[].obs;
  List<String> fields = <String>[].obs;
  List<String> values = <String>[].obs;
  List<String> images = <String>[].obs;
  List<String> conjunctions = <String>[].obs;
  Color bottomNavigationBarColor = Colors.cyan[200]!;
  RxBool isLoading = false.obs;
  RxBool showInputText = false.obs;
  var field = ''.obs;
  var operator = ''.obs;
  var value = ''.obs;
  var conjunction = ''.obs;
  String title = '';

  double buttonWidth = 300;

  /*
  example:
  idempiereFilters = controller.idempiereFilters;
   */

  IdempiereFilterCreatePageModel({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return Obx (() => Scaffold(

        bottomNavigationBar: Container(
          color: bottomNavigationBarColor,
          height: 60,
          child: Column(
            children: [
              SizedBox(height: 10),
              IconButton(
                icon: isLoading.value
                    ? CircularProgressIndicator(color: Colors.redAccent)
                    : Text(Messages.FIND_BY_CONDITION),
                onPressed: () => findByCondition(context),
                tooltip: isLoading.value ? Messages.LOADING
                    : Messages.FIND_BY_CONDITION,
                style: IconButton.styleFrom(
                  backgroundColor: isLoading.value
                      ? Colors.amber
                      : Memory.PRIMARY_COLOR,
                  fixedSize: Size(buttonWidth, 40),
                ),
              ),
            ],
          ),
        ),


        appBar: AppBar(
          centerTitle: true,
          //backgroundColor: ,
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          title: Text(
            title,
            style: TextStyle(
                color: Colors.black
            ),
          ),
          //bottom: _buttonsDate(context),
        ),
        
        body: SafeArea(
          child: SizedBox(
             height: context.height*0.9,
            child: Column(
              children: [
                _addFilterPanel(context),
                Expanded(
                  child: Form(
                    child: idempiereFilters.isNotEmpty ? ListView(
                      children: idempiereFilters.map((IdempiereFilter idempiereFilter) {
                        int i = idempiereFilters.indexOf(idempiereFilter);

                        return _cardIdempiereFilter(context,idempiereFilter,i,valueControllers[i]);
                      }).toList(),
                    ) :  SingleChildScrollView(
                      child: Center(
                          child:
                          NoDataWidget(text: Messages.NO_IDEMPIERE_FILTER_ADDED_YET)
                      ),
                    ),
                  ),
                ),
              ],
            )
          ),
        )

      ),
    );
  }

  Widget _addFilterPanel(BuildContext context) {
    return  Container(
          color: bottomNavigationBarColor,
          height: context.height*0.4,
          margin: EdgeInsets.only(left: 20, right: 20,top: 10,bottom: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(idempiereFilters.isNotEmpty) _dropDownConjunctions(),
                _dropDownFields(),
                _dropDownOperators(),
                _dropDownValues(),
                if(showInputText.value) Container(
                  margin: EdgeInsets.only(top: 10,right: 20,left: 20),
                  child: TextField(
                    controller: valueController,
                    keyboardType: TextInputType.text,

                    decoration: InputDecoration(

                    filled: true,
                    fillColor: Colors.white,
                    hintText: Messages.VALUE,
                    //prefixIcon: Icon(Icons.find_in_page),
                    border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                IconButton(
                  icon: isLoading.value
                      ? CircularProgressIndicator(color: Colors.redAccent)
                      : Text(Messages.ADD),
                  onPressed: () => addFilter(context),
                  tooltip: isLoading.value ? Messages.LOADING
                      : Messages.ADD,
                  style: IconButton.styleFrom(
                    backgroundColor: isLoading.value
                        ? Colors.amber
                        : Memory.PRIMARY_COLOR,
                    fixedSize: Size(buttonWidth, 40),
                  ),
                ),

              ],
            ),
          ),
        );

  }

  Widget _cardIdempiereFilter(BuildContext context,IdempiereFilter idempiereFilter, int i,TextEditingController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          //_imageIdempiereFilter(idempiereFilter),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                idempiereFilter.getSentence(),
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 7),
              _buttonsAddOrRemove(context,idempiereFilter,i,controller)
            ],
          ),
          Spacer(),
          _iconDelete(idempiereFilter,i)
        ],
      ),
    );
  }

  Widget _iconDelete(IdempiereFilter idempiereFilter,int i) {
    return IconButton(
        onPressed: () => deleteItem(idempiereFilter,i),
        icon: Icon(
          Icons.delete,
          color: Colors.red,
        )
    );
  }



  Widget _buttonsAddOrRemove(BuildContext context,IdempiereFilter idempiereFilter, int i,TextEditingController controller) {
    return Row(
      spacing: 10,
      children: [
        Text(Messages.VALUE),
        SizedBox(
          width: 200.0,
          height: 37,
        child: GestureDetector(child: TextField(
            onTap: () async {
              await getTextFromDialog(context,idempiereFilter,i,controller,Messages.SENTENCE);

            },

            readOnly: true,
            textAlign: TextAlign.end,
            decoration: InputDecoration(
              filled: true,
              hintText: Messages.QUANTITY,
              fillColor: Colors.white,


            ),
            controller: controller,
            keyboardType: TextInputType.number,
            style: TextStyle(
                color: Colors.black,
                fontSize: 18
            ),
          )),
        ),
      ],
    );
  }

  Widget _imageIdempiereFilter(IdempiereFilter idempiereFilter) {
    return SizedBox(
      height: 70,
      width: 70,
      // padding: EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FadeInImage(
          image: idempiereFilter.image != null
              ? NetworkImage(idempiereFilter.image!)
              : AssetImage(Memory.IMAGE_NO_IMAGE) as ImageProvider,
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder:  AssetImage(Memory.IMAGE_NO_IMAGE),
        ),
      ),
    );
  }

  Widget _dropDownConjunctions() {
    return Container(
      margin: EdgeInsets.only(top: 10,right: 20,left: 20),
      child: DropdownButton<String>(
        underline: Container(
          height: 1.0,
          alignment: Alignment.centerRight,
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 0.0))),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          Messages.SELECT_A_CONJUNCTION,

          style: TextStyle(

              color: Colors.black
          ),
        ),
        items: _dropDownItemsConjunctions(conjunctions),
        value: conjunction.value == '' ? null : conjunction.value,
        onChanged: (option) {
           if(option!=null && option==''){
             return;
           }
           conjunction.value = option.toString();
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItemsConjunctions(List<String> data) {
    List<DropdownMenuItem<String>> list = [];
    for (var item in data) {
      list.add(DropdownMenuItem(
        value: item,
        child: Text(item),
      ));
    }

    return list;
  }

  Widget _dropDownFields() {
    return Container(
      margin: EdgeInsets.only(top: 10,right: 20,left: 20),
      child: DropdownButton<String>(
        underline: Container(
          height: 1.0,
          alignment: Alignment.centerRight,
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 0.0))),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          Messages.SELECT_A_FIELD,

          style: TextStyle(

              color: Colors.black
          ),
        ),
        items: _dropDownItemsFields(fields),
        value: field.value == '' ? null : field.value,
        onChanged: (option) {
          if(option!=null && option==''){
            return;
          }
          field.value = option.toString();
        },
      ),
    );
  }
  List<DropdownMenuItem<String>> _dropDownItemsFields(List<String> data) {
    List<DropdownMenuItem<String>> list = [];
    for (var item in data) {
      list.add(DropdownMenuItem(
        value: item,
        child: Text(item),
      ));
    }

    return list;
  }
  Widget _dropDownOperators() {
    return Container(
      margin: EdgeInsets.only(top: 10,right: 20,left: 20),
      child: DropdownButton<String>(
        underline: Container(
          height: 1.0,
          alignment: Alignment.centerRight,
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 0.0))),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          Messages.SELECT_AN_OPERATOR,

          style: TextStyle(

              color: Colors.black
          ),
        ),
        items: _dropDownItemsOperators(operators),
        value: operator.value == '' ? null : operator.value,
        onChanged: (option) {
          if(option!=null && option==''){
            return;
          }
          operator.value = option.toString();
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItemsOperators(List<String> data) {
    List<DropdownMenuItem<String>> list = [];
    for (var item in data) {
      list.add(DropdownMenuItem(
        value: item,
        child: Text(item),
      ));
    }

    return list;
  }
  Widget _dropDownValues() {
    return Container(
      margin: EdgeInsets.only(top: 10,right: 20,left: 20),
      child: DropdownButton<String>(
        underline: Container(
          height: 1.0,
          alignment: Alignment.centerRight,
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 0.0))),
          /*
          child: Icon(
            Icons.arrow_drop_down_circle,
            color: Colors.amber,
          ),

           */
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          Messages.SELECT_A_VALUE,

          style: TextStyle(

              color: Colors.black
          ),
        ),
        items: _dropDownItemsValues(values),
        value: value.value == '' ? null : value.value,
        onChanged: (option) {
          if(option!=null && option==''){
            return;
          }
          value.value = option.toString();
          if(option!=values[0] && option!=values[1]){
            showInputText.value = true;
          } else {
            showInputText.value = false;
          }

        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItemsValues(List<String> data) {
    List<DropdownMenuItem<String>> list = [];
    for (var item in data) {
      list.add(DropdownMenuItem(
        value: item,
        child: Text(item),
      ));
    }

    return list;
  }

  @override
  IdempiereFilter getIdempiereFilter() {
    IdempiereFilter data = IdempiereFilter(field: field.value, operator: operator.value,
         value: value.value);
    if(idempiereFilters.isNotEmpty){
      data.conjunction = conjunction.value;
    }

    return data;
  }
  @override
  List<IdempiereFilter> getIdempiereFilters() {
    return idempiereFilters;
  }

  void setItem(IdempiereFilter idempiereFilter, int index, String command) {
      idempiereFilters[index].value = command;
  }

  void deleteItem(IdempiereFilter idempiereFilter, int i) {
    idempiereFilters.removeAt(i);
    valueControllers.removeAt(i);
  }

  void findByCondition(BuildContext context) {

  }

  Future<void> getTextFromDialog(BuildContext context,IdempiereFilter idempiereFilter, int i,TextEditingController controller, String sentence) async {

    final result = await InputDialog.show(
      context: context,
      title: title,
      cancelText: Messages.CANCEL,
      okText: Messages.CONFIRM,
    );
    if(result!=null){
      controller.text = result;
      setItem(idempiereFilter, i,sentence);
    }


  }

  void addFilter(BuildContext context) {

    String data = '';
    if(showInputText.value){
      data = valueController.text;
    } else {
      data = value.value;
    }
    if(data.isEmpty){
      return;
    }

    IdempiereFilter filter = IdempiereFilter(field: field.value, operator: operator.value, value: data);
    if(idempiereFilters.isNotEmpty){
      if(conjunction.value.isEmpty){
          AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                title: '${Messages.ERROR}:${Messages.EMPTY_CONJUNCTION}',
                desc: '',
                btnCancelOnPress: () {},
                btnOkOnPress: () {},
          ).show();
          return;
      }
      filter.conjunction = conjunction.value;

    } else {
      filter.conjunction = '';
    }
    idempiereFilters.add(filter);
    TextEditingController text =  TextEditingController();
    text.text = data;
    valueControllers.add(text);
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: '${Messages.SUCCESS}:${Messages.FILTER_ADDED}',
      desc: '',
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
    ).show();

  }





}
