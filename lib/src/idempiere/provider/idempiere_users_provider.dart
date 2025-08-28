import 'dart:async';

import 'package:idempiere_rest/idempiere_rest.dart';
import 'package:solexpress_panel_sc/src/idempiere/provider/idempiere_rest_provider.dart';
import '../../data/memory.dart';
import '../../data/messages.dart';
import '../../models/idempiere/idempiere_session.dart';
import '../../models/idempiere/idempiere_user.dart';
import '../../models/response_api.dart';
import 'idempiere_provider_model.dart';
class IdempiereUsersProvider extends IdempiereProviderModel{


  Future<ResponseApi> login(IdempiereUser user) async{
    ResponseApi responseApi = ResponseApi();
    // instantiate the singleton idempiere client with the API url


    try {
      //LoginResponse login = await IdempiereClient().login('/auth/tokens','SuperUser', 'iDempiere@2024MO');
      LoginResponse login = await IdempiereRESTProvider().login('/auth/tokens', user.userName!, user.password!);
      
      
      List<Client> clients = login.clients ;
      responseApi.data = login;
      if(clients.isEmpty){
        responseApi.success = false ;
        showErrorMessages(  Messages.LOGIN_FAILED);
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
  Future<ResponseApi> getRoles(IdempiereUser user) async{
    ResponseApi responseApi = ResponseApi();
    // instantiate the singleton idempiere client with the API url

    print('-------------------------${user.clientId!}');
    try {
      List<Role> roles = await IdempiereRESTProvider().getRoles(user.clientId!);
      responseApi.data = roles;
      if(roles.isEmpty){
        responseApi.success = false ;
        showErrorMessages(  Messages.LOGIN_FAILED);
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

  Future<ResponseApi> getOrganizations(IdempiereUser user) async{
    ResponseApi responseApi = ResponseApi();
    // instantiate the singleton idempiere client with the API url

    print('-------------------------(${user.clientId!}, ${user.roleId!}');
    try {
      List<Organization> organizations = await IdempiereRESTProvider().getOrganizations(user.clientId!, user.roleId!);
      responseApi.data = organizations;
      if(organizations.isEmpty){
        responseApi.success = false ;
        showErrorMessages(  Messages.LOGIN_FAILED);
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
  Future<ResponseApi> getWarehouses(IdempiereUser user) async{
    ResponseApi responseApi = ResponseApi();
    // instantiate the singleton idempiere client with the API url


    try {
      List<Warehouse> warehouses = await IdempiereRESTProvider().getWarehouses(user.clientId!, user.roleId!,user.organizationId!);
      responseApi.data = warehouses;
      if(warehouses.isEmpty){
        responseApi.success = false ;
        showErrorMessages(  Messages.LOGIN_FAILED);
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

  Future<ResponseApi> initSession(IdempiereUser user) async{
    ResponseApi responseApi = ResponseApi();
    // instantiate the singleton idempiere client with the API url


    try {
      var session = await IdempiereRESTProvider().initSession(Memory.IDEMPIERE_ENDPOINT_AUTH_LOGIN, user.token!
          , user.clientId!, user.roleId!,organizationId: user.organizationId!, warehouseId: user.warehouseId!);
      
      if(user.token==null || user.token!.isEmpty){
        responseApi.success = false ;
        showErrorMessages(  Messages.LOGIN_FAILED);
        return responseApi;
      } else {
        responseApi.success = true;
        responseApi.data = session;
        user.token = session.token;
        String? date = DateTime.now().toIso8601String();
        user.tokenCreatedAt = date;
        user.refreshToken = session.refreshToken;
        user.refreshTokenCreatedAt = date;
        user.userId = session.userId;
        user.language = session.language;
        responseApi.data = user ;
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

  Future<ResponseApi> oneStepLogin(IdempiereUser user) async {
    ResponseApi responseApi = ResponseApi();
    // instantiate the singleton idempiere client with the API url


    try {
      IdempiereSession session = await IdempiereRESTProvider().oneStepLogin(
          Memory.IDEMPIERE_ENDPOINT_AUTH_LOGIN, user.userName!, user.password!,
           user.clientId!, user.roleId!);

      if(user.token==null || user.token!.isEmpty){
        responseApi.success = false ;
        showErrorMessages(  Messages.LOGIN_FAILED);
        return responseApi;
      } else {
        responseApi.success = true;
        responseApi.data = session;
        user.token = session.token;
        String? date = DateTime.now().toIso8601String();
        user.tokenCreatedAt = date;
        user.refreshToken = session.refreshToken;
        user.refreshTokenCreatedAt = date;
        user.userId = session.userId;
        user.language = session.language;
        responseApi.data = user ;
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




}