import '../../models/idempiere/idempiere_filter.dart';

abstract class IdempiereFilterGenerator {

  IdempiereFilter getIdempiereFilter() ;
  List<IdempiereFilter> getIdempiereFilters() ;
}