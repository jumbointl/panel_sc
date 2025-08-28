
import 'package:solexpress_panel_sc/src/models/idempiere/idempiere_document_status.dart';
import 'package:solexpress_panel_sc/src/models/idempiere/idempiere_document_type.dart';
import 'package:solexpress_panel_sc/src/models/idempiere/idempiere_price_list.dart';
import 'package:solexpress_panel_sc/src/models/idempiere/idempiere_tenant.dart';

import '../../data/messages.dart';
import 'idempiere_object.dart';
import 'idempiere_organization.dart';
import 'idempiere_user.dart';



class IdempiereMovement extends IdempiereObject {
  String? uid;
  IdempiereTenant? aDClientID;
  IdempiereOrganization? aDOrgID;
  bool? isActive;
  String? created;
  IdempiereUser? createdBy;
  IdempiereUser? updatedBy;
  String? updated;
  String? documentNo;
  String? description;
  String? movementDate;
  bool? processed;
  bool? processing;
  bool? isInTransit;
  IdempiereDocumentStatus? docStatus;
  IdempiereDocumentType? cDocTypeID;
  int? approvalAmt;
  bool? isApproved;
  int? processedOn;
  IdempierePriceList? mPriceListID;

  IdempiereMovement(
      {
        this.uid,
        this.aDClientID,
        this.aDOrgID,
        this.isActive,
        this.created,
        this.createdBy,
        this.updatedBy,
        this.updated,
        this.documentNo,
        this.description,
        this.movementDate,
        this.processed,
        this.processing,
        this.isInTransit,
        this.docStatus,
        this.cDocTypeID,
        this.approvalAmt,
        this.isApproved,
        this.processedOn,
        this.mPriceListID,
        super.id,
        super.name,
        super.active,
        super.propertyLabel,
        super.identifier,
        super.modelName,
        super.image,
        super.category,
      });

  IdempiereMovement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    aDClientID = json['AD_Client_ID'] != null
        ?  IdempiereTenant.fromJson(json['AD_Client_ID'])
        : null;
    aDOrgID = json['AD_Org_ID'] != null
        ?  IdempiereOrganization.fromJson(json['AD_Org_ID'])
        : null;
    isActive = json['IsActive'];
    created = json['Created'];
    createdBy = json['CreatedBy'] != null
        ?  IdempiereUser.fromJson(json['CreatedBy'])
        : null;
    updatedBy = json['UpdatedBy'] != null
        ?  IdempiereUser.fromJson(json['UpdatedBy'])
        : null;
    updated = json['Updated'];
    documentNo = json['DocumentNo'];
    description = json['Description'];
    movementDate = json['MovementDate'];
    processed = json['Processed'];
    processing = json['Processing'];
    isInTransit = json['IsInTransit'];
    docStatus = json['DocStatus'] != null
        ?  IdempiereDocumentStatus.fromJson(json['DocStatus'])
        : null;
    cDocTypeID = json['C_DocType_ID'] != null
        ?  IdempiereDocumentType.fromJson(json['C_DocType_ID'])
        : null;
    approvalAmt = json['ApprovalAmt'];
    isApproved = json['IsApproved'];
    processedOn = json['ProcessedOn'];
    mPriceListID = json['M_PriceList_ID'] != null
        ?  IdempierePriceList.fromJson(json['M_PriceList_ID'])
        : null;
    modelName = json['model-name'];
    active = json['active'];
    propertyLabel = json['propertyLabel'];
    identifier = json['identifier'];
    image = json['image'];
    category = json['category'];
    name = json['name'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    if (aDClientID != null) {
      data['AD_Client_ID'] = aDClientID!.toJson();
    }
    if (aDOrgID != null) {
      data['AD_Org_ID'] = aDOrgID!.toJson();
    }
    data['IsActive'] = isActive;
    data['Created'] = created;
    if (createdBy != null) {
      data['CreatedBy'] = createdBy!.toJson();
    }
    if (updatedBy != null) {
      data['UpdatedBy'] = updatedBy!.toJson();
    }
    data['Updated'] = updated;
    data['DocumentNo'] = documentNo;
    data['Description'] = description;
    data['MovementDate'] = movementDate;
    data['Processed'] = processed;
    data['Processing'] = processing;
    data['IsInTransit'] = isInTransit;
    if (docStatus != null) {
      data['DocStatus'] = docStatus!.toJson();
    }
    if (cDocTypeID != null) {
      data['C_DocType_ID'] = cDocTypeID!.toJson();
    }
    data['ApprovalAmt'] = approvalAmt;
    data['IsApproved'] = isApproved;
    data['ProcessedOn'] = processedOn;
    if (mPriceListID != null) {
      data['M_PriceList_ID'] = mPriceListID!.toJson();
    }
    data['model-name'] = modelName;
    data['active'] = active;
    data['propertyLabel'] = propertyLabel;
    data['identifier'] = identifier;
    data['image'] = image;
    data['category'] = category;
    data['name'] = name;
    return data;
  }
  static List<IdempiereMovement> fromJsonList(List<dynamic> list){
    List<IdempiereMovement> result =[];
    for (var item in list) {
      if(item is IdempiereMovement){
        result.add(item);
      } else if(item is Map<String, dynamic>){
        IdempiereMovement idempiereMovement = IdempiereMovement.fromJson(item);
        result.add(idempiereMovement);
      }

    }
    return result;
  }
  @override
  List<String> getOtherDataToDisplay() {
    List<String> list = [];
    if(id != null){
      list.add('${Messages.ID}: ${id ?? '--'}');
    }
    if(description != null){
      list.add('${Messages.DESCRIPTION}: ${description ?? '--'}');
    }
    if( movementDate != null){
      list.add('${Messages.DATE}:${movementDate ?? '--'}');
    }
    return list;
  }
}











