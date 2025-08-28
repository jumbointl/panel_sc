
import 'idempiere_provider_model.dart';
class IdempiereProductsProvider extends IdempiereProviderModel{
  /*
  Future<ResponseApi> findByCondition(String query) async{
    ResponseApi responseApi = ResponseApi();
    // instantiate the singleton idempiere client with the API url
    query ='${Memory.IDEMPIERE_ROUTE_PRODUCTS}?\$filter=$query';
    query = query.replaceAll(' ', '%20');
    print('-----------------------------------------------------------------------------------');
    print('----query: $query');
    print('-----------------------------------------------------------------------------------');
    responseApi.success = false ;
    try {
      IdempiereQueryResult? queryResult = await IdempiereRESTProvider().getIdempiereLists(query);
      responseApi.data = queryResult;
      if(queryResult == null){
        return responseApi;
      } else {
        responseApi.success = true;
        return responseApi;
      }

    } on TimeoutException catch (err) {
      /// here is the response if api call time out
      /// you can show snackBar here or where you handle api call
      showErrorMessages(  Messages.TIME_OUT);
      print(err);
      return responseApi;
    }catch(e){
      showErrorMessages(  Messages.ERROR_HTTP);
      print(e);
      return responseApi;
    }

  }
  */


}