import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:solexpress_panel_sc/src/models/object_with_name_and_id.dart';
import '../../data/memory.dart';
import '../../data/messages.dart';
import '../../models/idempiere/idempiere_object.dart';
import '../../widgets/no_data_widget.dart';
class IdempiereObjectsListPageModel extends StatelessWidget{


  IdempiereObjectsListPageModel({super.key});
  double imageHeight = 60;
  double imageWidth = 60;
  double heightTextFieldSearch = 30;
  Color resultColor = Colors.lightBlue;
  Color dropDownColor = Colors.lightGreen;
  NumberFormat currencyFormatter = Memory.currencyFormatter;
  NumberFormat numberFormatter = Memory.numberFormatter;
  late double marginsHorizontal;
  late double columnsWidth;
  RxBool isLoading = false.obs;
  int count = 1;
  var cardColor = Colors.white.obs;
  Color evenRow = Colors.amber[100]!;
  Color oddRow = Colors.white;


  @override
  Widget build(BuildContext context) {


    isLoading = getIsLoadingObs();
    marginsHorizontal = getMarginsForMaximumColumns(context);
    columnsWidth = getMaximumInputFieldWidth(context);


        return Obx(() => DefaultTabController(
              length: getCategories().length,
              child: Scaffold(
                appBar: PreferredSize(preferredSize: Size.fromHeight(160),

                    child: AppBar(
                      backgroundColor: getAppBarColor(context) ,
                      automaticallyImplyLeading: false,
                      centerTitle: true,
                      actions: getActionButton(),
                      title: Text(getTitle()),
                      flexibleSpace:Container(
                        alignment: Alignment.center,
                        width: columnsWidth,
                        margin: EdgeInsets.only(top: 10),
                        child:  Wrap(
                            direction: Axis.horizontal,
                          
                            children: [
                              SizedBox(width: 5,),
                              _textFieldSearch(context),
                              SizedBox(width: 5,),
                            ],),

                      ),
                      bottom: isLoading.value ? null : TabBar(
                          tabAlignment: TabAlignment.center,
                          isScrollable: true,
                          indicatorColor: Memory.BAR_ACTIVE_COLOR,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey[600],
                          tabs: List<Widget>.generate(getCategories().length, (index){
                            return Tab(child: Text(getCategories()[index].name ?? ''),);

                          })),
                      ),
                    ),
                body: SafeArea(
                  child: Container(
                    width: columnsWidth,
                    margin: EdgeInsets.symmetric(horizontal: marginsHorizontal),
                    child: isLoading.value ? CircularProgressIndicator() : TabBarView(children: getCategories().map((ObjectWithNameAndId category){
                      return FutureBuilder(
                          future: getObjects(context, category),
                          builder: (context, AsyncSnapshot<List<IdempiereObject>> snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.isNotEmpty) {
                                return  ListView.builder(
                                      itemCount: snapshot.data?.length ?? 0,
                                      itemBuilder: (_, index) {
                                        index.isEven ? cardColor.value = evenRow : cardColor.value = oddRow;
                                        IdempiereObject idempiereObject = snapshot.data![index];

                                        if (category.id == Memory.ALL_CATEGORIES_ID || category.id == idempiereObject.category?.id) {
                                          return _cardIdempiereObject(context, idempiereObject,getCategories().indexOf(category));
                                        } else {
                                          return SizedBox.shrink(); // Return an empty widget if the idempiereObjectCategory doesn't match
                                        }

                                      }
                                  );
                              }
                              else {
                                return NoDataWidget(text: Messages.NO_DATA_FOUND);
                              }
                            }
                            else {
                              return NoDataWidget(text: Messages.NO_DATA_FOUND);
                            }
                          }
                      );
                      }).toList(),
                    ),
                  ),
                )
          )),

    );
  }

  Widget _textFieldSearch(BuildContext context){
    return Container(

        width: getMaximumInputFieldWidth(context)-40,
        height: heightTextFieldSearch ,
        margin: EdgeInsets.only(top: 10),
        child: TextField(

          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: Messages.FIND_BY_NAME,
            suffixIcon: Icon(Icons.search,color: Colors.black,),
            hintStyle: TextStyle(fontSize: 17),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey),

            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.black),

            ),
            contentPadding: EdgeInsets.all(15),
          ),
        ),
    );

  }
  Widget _cardIdempiereObject(BuildContext context, IdempiereObject idempiereObject, int indexOf) {
    return GestureDetector(
      onTap: () => cardIdempiereObjectTaped(context, idempiereObject),
      child: Container(
        margin: EdgeInsets.only(top: 15, left: 10, right: 10),
        color: cardColor.value,
        child: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              SizedBox(height: 5),
              ...idempiereObject.getOtherDataToDisplay().map((data) {
                return Text(
                  data,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                );
              }),
              idempiereObject.isDisplayImage() ?  SizedBox(
                height: imageHeight,
                width: imageWidth,
                // padding: EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FadeInImage(
                    image: idempiereObject.image != null
                        ? NetworkImage(idempiereObject.image!)
                        : AssetImage(Memory.IMAGE_NO_IMAGE) as ImageProvider,
                    fit: BoxFit.cover,
                    fadeInDuration: Duration(milliseconds: 50),
                    placeholder:  AssetImage(Memory.IMAGE_NO_IMAGE),
                  ),
                ),
              ): Container(),
            ],
            ),
        ),
        ),
      );

  }

  Future<List<IdempiereObject>> getObjects(BuildContext context, ObjectWithNameAndId category) async {
    return [];
  }



  RxBool getIsLoadingObs() {
    return false.obs;
  }

  double getMarginsForMaximumColumns(BuildContext context) {
    return 20;
  }

  double getMaximumInputFieldWidth(BuildContext context) {
    return MediaQuery.of(context).size.width*0.7;
  }

  List<ObjectWithNameAndId> getCategories() {
    ObjectWithNameAndId category = ObjectWithNameAndId(id: Memory.ALL_CATEGORIES_ID, name: Messages.ALL_CATEGORIES);
    return [category];
  }

  String getTitle() { return '';}

  Widget getBottomActionButton() {
    return Container();
  }

  Widget getAppBarTitle() {

    return Text('');
  }

  Color getAppBarColor(BuildContext context) {
    return Colors.cyan[300]!;
  }

  List<Widget> getActionButton() {
    return <Widget>[];
  }

  void cardIdempiereObjectTaped(BuildContext context,  IdempiereObject object) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: object.isDisplayImage() ? MediaQuery.of(context).size.height * 0.4
          : MediaQuery.of(context).size.height * 0.3,

        child: Container(
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(25.0),
              topRight: const Radius.circular(25.0),
            ),
          ),
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  ...object.getOtherDataToDisplay().map((e) => Text(e)),
                  object.isDisplayImage() ?  SizedBox(
                    height: imageHeight,
                    width: imageWidth,
                    // padding: EdgeInsets.all(2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FadeInImage(
                        image: object.image != null
                            ? NetworkImage(object.image!)
                            : AssetImage(Memory.IMAGE_NO_IMAGE) as ImageProvider,
                        fit: BoxFit.cover,
                        fadeInDuration: Duration(milliseconds: 50),
                        placeholder:  AssetImage(Memory.IMAGE_NO_IMAGE),
                      ),
                    ),
                  ): Container(),
                ]),
          ),


        ),
      ),

    );
  }


  void buttonBackPressed() {

  }


}
