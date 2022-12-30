include "shared.thrift"
include "icshared.thrift"
/**
 * This thrift defines a service interface for processor server
 */

namespace java py.thrift.monitorserver.service

/**
 * ----------------------------------------------------requests&responses----------------------------------------------------
 */

struct MetricsCollectionResolveRequest {
    1:i64 requestId,
    2:i32 querylogAmount,
    3:i64 querylogLength,
    4:bool isCompressed,
    5:string querylogString
}


struct AlertMessageThrift {
    1: string id,
    2: string sourceId,
    3: string sourceName,
    4: string alertDescription,
    5: string alertLevel,
    6: string alertType,
    7: string alertRuleName,
    8: bool alertAcknowledge,
    9: i64 alertAcknowledgeTime,
    10: i64 firstAlertTime,
    11: i64 lastAlertTime,
    12: i32 alertFrequency,
    13: bool alertClear,
    14: i64 clearTime
}

struct PerformanceSearchTemplateThrift {
    1: i64 id,
    2: string name,
    3: i64 startTime,
    4: i64 endTime,
    5: i64 period,
    6: string timeUnit,
    7: string counterKeyJson,
    8: string sourcesJson,
    9: i64 accountId,
    10: string objectType
}

struct EventLogInfoThrift {
    1: i64 id,
    2: i64 startTime,
    3: string eventLog
}

struct AlertMessageDetailThrift {
    1: AlertMessageThrift alertMessageThrift,
    2: optional string ip,
    3: optional string hostname,
    4: optional string alertItem,
    5: optional string serialNum,
    6: optional string slotNo,
    7: optional string serverNodeRackNo,
    8: optional string serverNodeChildFramNo,
    9: optional string serverNodeSlotNo,
    10: optional string lastActualValue,
    11: optional set<EventLogInfoThrift> eventLogInfoSet
}


//**************** alert message readfiletosendprocessor begin ******************************/
struct MetricsCollectionResolveResponse {
   1:i64 requestId,
}

struct AlertsAcknowledgeRequestThrift {
    1: i64 requestId,
    2: list<string> alertMessageIds
}

struct AlertsAcknowledgeResponseThrift {
    1: i64 responseId
}

struct ClearAlertsAcknowledgeRequestThrift {
    1: i64 requestId,
    2: list<string> alertMessageIds
}

struct ClearAlertsAcknowledgeResponseThrift {
    1: i64 responseId
}

struct AlertsClearRequestThrift {
    1: i64 requestId,
    2: list<string> alertMessageIds
}

struct AlertsClearResponseThrift {
    1: i64 responseId
}

struct DeleteAlertRequestThrift {
    1: i64 requestId,
    2: string alertMessageId
}

struct DeleteAlertResponseThrift {
    1: i64 responseId
}

struct DeleteAlertsRequestThrift {
    1: i64 requestId,
    2: list<string> alertMessageIds
}

struct DeleteAlertsResponseThrift {
    1: i64 responseId
}

struct GetAlertMessageDetailRequestThrift {
    1: i64 requestId,
    2: i64 alertMessageId,
    3: optional bool withEventLog
}

struct GetAlertMessageDetailResponseThrift {
    1: i64 responseId,
    2: AlertMessageDetailThrift alertMessageDetail
}

struct ListAlertsByTableRequestThrift {
    1: i64 requestId,
    2: optional i32 pageSize,
    3: optional i32 pageNo,
    4: optional string sortFeild,
    5: optional string sortDirection,
    6: optional string sourceId,
    7: optional string sourceName,
    8: optional i64 startTime,
    9: optional i64 endTime,
    10: optional string alertLevel,
    11: optional bool acknowledge,
    12: optional string alertType,
    13: optional string alertRuleName,
    14: optional bool alertClear,
    15: optional bool isCsi
}

struct ListAlertByTableResponseThrift {
    1: i64 responseId,
    2: i32 recordsTotal,
    3: i32 recordsAfterFilter,
    4: list<AlertMessageThrift> alertMessageList,
}

struct ListAlertCountRequestThrift {
    1: i64 requestId,
    2: optional bool acknowledge,
    3: optional string alertLevel,
    4: optional string alertType,
    5: optional i64 startTime,
    6: optional i64 endTime,
    7: optional string alertRuleName,
    8: optional bool alertClear,
    9: optional bool isCsi;
}

struct ListAlertCountResponseThrift {
    1: i64 responseId,
    2: i32 recordsTotal,
}

struct TotalRecords {
    1: i32 criticalAlertCount,
    2: i32 majorAlertCount,
    3: i32 minorAlertCount,
    4: i32 warningAlertCount,
    5: i32 clearedAlertCount;
}

struct ListAllAlertCountRequestThrift {
    1: i64 requestId,
    2: optional bool acknowledge,
    3: optional string alertType,
    4: optional i64 startTime,
    5: optional i64 endTime,
    6: optional string alertRuleName,
    7: optional bool alertClear,
    8: optional bool isCsi;
}

struct ListAllAlertCountResponseThrift {
    1: i64 responseId,
    2: TotalRecords recordsTotal;
}

//**************** alert message readfiletosendprocessor end ******************************/



//**************** performance message task start ******************************/
struct PerformanceTaskThrift {
    1: i64 requestId,
    2: string id,
    3: string counterKey,
    4: string sourceId,
    5: string sourceName,
    6: i64 startTime,
    7: bool status,
}

struct CreatePerformanceTaskRequestThrift {
    1: i64 requestId,
    2: string counterKey,
    3: optional string sourceId,
    4: optional string sourceName,
}

struct CreatePerformanceTaskReponseThrift {
    1: i64 reponseId,
}

struct DeletePerformanceTaskRequestThrift {
    1: i64 requestId,
    2: set<string> ids,
}

struct DeletePerformanceTaskResponseThrift {
    1: i64 responseId,
}

struct StartPerformanceTaskRequestThrift {
    1: i64 requestId,
    2: set<string> ids,
}

struct StartPerformanceTaskResponseThrift {
    1: i64 responseId,
}

struct StopPerformanceTaskRequestThrift {
    1: i64 requestId,
    2: set<string> ids,
}

struct StopPerformanceTaskResponseThrift {
    1: i64 responseId,
}

struct ListPerformanceTaskRequestThrift {
    1: i64 requestId,
}

struct ListPerformanceTaskReponseThrift {
    1: i64 responseId,
    2: set<PerformanceTaskThrift> performanceTasks,
}

struct EventLogCompressedThrift {
    1: string id,
    2: string counterKey,
    3: i64 startTime,
    4: i64 endTime,
    5: i64 counterTotal,
    6: i32 frequency,
    7: string sourceId,
    8: string operation,
}

struct ListCompressedPerformanceByCountRequestThrift {
    1: i64 requestId,
    2: i32 count,
    3: optional string sortFeild,
    4: optional string sortDirection,
    5: optional string counterKey,
    6: optional i64 startTime,
    7: optional i64 endTime,
    8: optional string sourceId,
}

struct ListCompressedPerformanceByCountResponseThrift {
    1: i64 responseId,
    2: list<EventLogCompressedThrift> eventLogMessageThriftList,
    3: i64 timeInterval,
}

struct CompressedPerformanceDataPointThrift {
    1: string counterValue,
    2: i64 startTime,
    3: i64 endTime,
}

struct SourceObjectThrift {
    1: string sourceId,
    2: string sourceName,
}

struct CompressedPerformanceDataThrift {
    1: SourceObjectThrift sourceObject,
    2: string counterKey,
    3: list<CompressedPerformanceDataPointThrift> compressedPerformanceDataPointList,
}

enum PerformanceDataTimeUnit{
    FIVEMINUTES = 1,
    ONEHOUR = 2,
    ONEDAY = 3,
}

struct ListMultiCompressedPerformanceDataRequestThrift {
    1: i64 requestId,
    2: optional i32 count,
    3: optional i64 startTime,
    4: optional i64 endTime,
    5: list<SourceObjectThrift> sourceObjects,
    6: list<string> counterKeys,
    7: optional PerformanceDataTimeUnit performanceDataTimeUnit,
}

struct ListMultiCompressedPerformanceDataResponseThrift {
    1: i64 responseId,
    2: i64 timeInterval,
    3: list<CompressedPerformanceDataThrift> compressedPerformanceDataList;
}

struct GetPerformanceDataTimeSpanRequestThrift {
    1: i64 requestId,
}

struct GetPerformanceDataTimeSpanResponseThrift {
    1: i64 responseId,
    2: map<PerformanceDataTimeUnit, i32> timeSpanMap,
    3: map<PerformanceDataTimeUnit, i32> retentionTimeMap,
}

struct ListCompressedPerformanceRequestThrift {
    1: i64 requestId,
    2: i32 pageSize,
    3: optional i32 page,
    4: optional string sortFeild,
    5: optional string sortDirection,
    6: optional string counterKey,
    7: optional i64 startTime,
    8: optional i64 endTime,
    9: optional string sourceId,
}

struct ListCompressedPerformanceResponseThrift {
    1: i64 responseId,
    2: i32 recordsTotal,
    3: i32 recordsAfterFilter,
    4: list<EventLogCompressedThrift> eventLogMessageThriftList,
}

//**************** performance message task end ******************************/

//**************** alert template start ******************************/

struct AlertRuleThrift {
    1: string id;
    2: string name,
    3: string counterKey,
    4: string description,
    5: string alertLevelOne,
    6: string alertLevelTwo,
    7: i32 alertLevelOneThreshold,
    8: i32 alertLevelTwoThreshold,
    9: string relationOperator,
    10: i32 continuousOccurTimes,
    11: bool repeatAlert,
    12: string leftId,
    13: string rightId,
    14: string parentId,
    15: string logicOperator,
    16: string alertTemplateId,
    17: i32 alertRecoveryThreshold,
    18: i32 alertRecoveryEventContinuousOccurTimes,
    19: string alertRecoveryRelationOperator,
    20: bool enable,
}

struct AlertTemplateThrift {
    1: string id,
    2: string name,
    3: string sourceId,
    4: map<string, AlertRuleThrift> alertRuleMap, 
}

struct GetAlertTemplateRequestThrift {
    1: i64 requestId,
    2: optional string id,
}

struct GetAlertTemplateResponseThrift {
    1: i64 reponseId,
    2: map<string, AlertTemplateThrift> alertTemplateMap,
}

//struct DeleteAlertTemplateRequestThrift {
//    1: i64 requestId,
//    2: optional string id,
//}
//
//struct DeleteAlertTemplateResponseThrift {
//    1: i64 responseId,
//}
//
//struct UpdateAlertTemplateRequestThrift {
//    1: i64 requestId,
//    2: AlertTemplateThrift alertTemplate,
//}
//
//struct UpdateAlertTemplateResponseThrift {
//    1: i64 responseId,
//}
//

struct ListNotUsedCounterKeyRequestThrift {
    1: i64 requestId,
}

struct ListNotUsedCounterKeyResponseThrift {
    1: i64 requestId,
    2: map<string, list<string>> templateKey2CounterKeyMap;
}

struct CreateAlertRuleRequestThrift {
    1: i64 requestId,
    2: string name,
    3: string counterKey,
    4: optional string description,
    5: string alertLevelOne,
    6: optional string alertLevelTwo,
    7: optional i32 alertLevelOneThreshold,
    8: optional i32 alertLevelTwoThreshold,
    9: optional string relationOperator,
    10: optional i32 continuousOccurTimes,
    11: optional bool repeatAlert,
    12: optional string leftId,
    13: optional string rightId,
    14: optional string parentId,
    15: optional string logicOperator,
    16: optional string alertTemplateId,
    17: optional i32 alertRecoveryThreshold,
    18: optional string alertRecoveryLevel,
    19: optional i32 alertRecoveryEventContinuousOccurTimes,
    20: optional string alertRecoveryRelationOperator,
}

struct CreateAlertRuleResponseThrift {
    1: i64 responseId,
}

struct DeleteAlertRuleRequestThrift {
    1: i64 requestId,
    2: string alertRuleId,
}

struct DeleteAlertRuleResponseThrift {
    1: i64 responseId,
}

struct MergeAlerRuleRequestThrift {
    1: i64 requestId,
    2: string name,
    3: string leftId,
    4: string rightId,
    5: string logicOperator,
    6: optional string description,
    7: string alertLevelOne,
    8: optional string alertLevelTwo,
    9: bool repeatAlert,
    10: string recoveryAlertOperator,
}

struct MergeAlerRuleResponseThrift {
    1: i64 responseId,
}

struct UpdateAlertRuleRequestThrift {
    1: i64 requestId,
    2: string id,
    3: optional string name,
    4: optional string description,
    5: optional string alertLevelOne,
    6: optional i32 alertLevelOneThreshold,
    7: optional string alertLevelTwo,
    8: optional i32 alertLevelTwoThreshold,
    9: optional string relationOperator,
    10: optional string logicOperator,
    11: optional i32 continuousOccurTimes,
    12: optional bool repeatAlert,
    13: optional i32 alertRecoveryThreshold,
    14: optional i32 alertRecoveryEventContinuousOccurTimes,
    15: optional string alertRecoveryRelationOperator,
    16: optional bool enable,
}

struct UpdateAlertRuleReponseThrift {
    1: i64 responseId,
}

struct EnableAlertRuleRequestThrift {
    1: i64 requestId,
    2: set<i64> ids,
}

struct EnableAlertRuleResponseThrift {
    1: i64 responseId,
}

struct DisableAlertRuleRequestThrift {
    1: i64 requestId,
    2: set<i64> ids,
}

struct DisableAlertRuleResponseThrift {
    1: i64 responseId,
}

//struct AddBaseAlertTemplateRequestThrift {
//    1: i64 requestId,
//    2: BaseAlertTemplateThrift baseAlertTemplateThrift,
//}
//
//struct AddBaseAlertTemplateResponseThrift {
//    1: i64 responseId,
//}
//
//struct DeleteBaseAlertTemplateRequestThrift {
//    1: i64 requestId,
//    2: string baseAlertTemplateKey,
//}
//
//struct DeleteBaseAlertTemplateResponseThrift {
//    1: i64 responseId,
//}


//**************** alert template end ******************************/


//**************** snmp forward setting start ******************************/

enum SnmpVersion {
    SNMPV1 = 1,
    SNMPV2C = 2,
    SNMPV3 = 3,
}

enum SecurityLevel {
    NoAuthNoPriv =1,
    AuthNoPriv =2,
    AuthPriv = 3,
}

enum AuthProtocol {
    MD5 = 1,
    SHA = 2,
}

enum PrivProtocol {
    AES = 1,
    DES = 2,
}

enum Language {
    ENGLISH = 1,
    CHINESE = 2,
}

enum LanguageFormat {
    UTF8 = 1,
    GB2312 = 2,
}

struct SaveSnmpForwardItemResponseThrift {
    1: i64 responseId,
}

struct SaveSnmpForwardItemRequestThrift {
    1: i64 requestId,
    2: string trapServerip,
    3: i32 trapServerport,
    4: bool enable,
    5: SnmpVersion snmpVersion,
    6: string community,
    7: SecurityLevel securityLevel,
    8: string securityName,
    9: AuthProtocol authProtocol,
    10: PrivProtocol privProtocol,
    11: string authKey,
    12: string privKey,
    13: string NmsName,
    14: string NmsDescription,
    15: i32 timeoutMs,
    16: optional Language language,
    17: optional LanguageFormat languageFormat,
}

struct UpdateSnmpForwardItemRequestThrift {
    1: i64 requestId,
    2: i64 id,
    3: string trapServerip,
    4: i32 trapServerport,
    5: bool enable,
    6: SnmpVersion snmpVersion,
    7: string community,
    8: SecurityLevel securityLevel,
    9: string securityName,
    10: AuthProtocol authProtocol,
    11: PrivProtocol privProtocol,
    12: string authKey,
    13: string privKey,
    14: string NmsName,
    15: string NmsDescription,
    16: i32 timeoutMs,
    17: optional Language language,
    18: optional LanguageFormat languageFormat,
}

struct UpdateSnmpForwardItemResponseThrift {
    1: i64 responseId,
}

struct SnmpForwardItemThrift {
    1: i64 id,
    2: string trapServerip,
    3: i32 trapServerport,
    4: bool enable,
    5: SnmpVersion snmpVersion,
    6: string community,
    7: SecurityLevel securityLevel,
    8: string securityName,
    9: AuthProtocol authProtocol,
    10: PrivProtocol privProtocol,
    11: string authKey,
    12: string privKey,
    13: string NmsName,
    14: string NmsDescription,
    15: i32 timeoutMs,
    16: Language language,
    17: LanguageFormat languageFormat,
}

struct DeleteSnmpForwardItemRequestThrift {
    1: i64 requestId,
    2: list<i64> snmpForwardItemIdList,
}

struct DeleteSnmpForwardItemResponseThrift {
    1: i64 responseId,
}

struct ListSnmpForwardItemRequestThrift {
    1: i64 requestId,
}
struct ListSnmpForwardItemResponseThrift {
    1: i64 responseId,
    2: list<SnmpForwardItemThrift> snmpForwardItemThriftList,
}

//**************** snmp forward setting end ******************************/

//**************** email forward setting start ******************************/

struct SaveEmailForwardItemResponseThrift {
    1: i64 responseId,
}

struct SaveEmailForwardItemRequestThrift {
    1: i64 requestId,
    2: string email,
    3: optional string name,
    4: optional string desc
    5: bool enable,
}

struct UpdateEmailForwardItemRequestThrift {
    1: i64 requestId,
    2: i64 id,
    3: string email,
    4: string name,
    5: string desc
    6: bool enable,
}

struct UpdateEmailForwardItemResponseThrift {
    1: i64 responseId,
}

struct EmailForwardItemThrift {
    1: i64 id,
    2: optional string email,
    3: optional string name,
    4: optional string desc,
    5: optional bool enable,
}

struct DeleteEmailForwardItemRequestThrift {
    1: i64 requestId,
    2: list<EmailForwardItemThrift> emailForwardItemThriftList,
}

struct DeleteEmailForwardItemResponseThrift {
    1: i64 responseId,
}

struct ListEmailForwardItemRequestThrift {
    1: i64 requestId,
}
struct ListEmailForwardItemResponseThrift {
    1: i64 responseId,
    2: list<EmailForwardItemThrift> emailForwardItemThriftList,
}

//**************** email forward setting end ******************************/


//**************** Message forward setting start ******************************/

struct SaveMessageForwardItemResponseThrift {
    1: i64 responseId,
}

struct SaveMessageForwardItemRequestThrift {
    1: i64 requestId,
    2: string phoneNum,
    3: optional string name,
    4: optional string desc
    5: bool enable,
}

struct UpdateMessageForwardItemRequestThrift {
    1: i64 requestId,
    2: i64 id,
    3: string phoneNum,
    4: string name,
    5: string desc
    6: bool enable,
}

struct UpdateMessageForwardItemResponseThrift {
    1: i64 responseId,
}

struct MessageForwardItemThrift {
    1: i64 id,
    2: optional string phoneNum,
    3: optional string name,
    4: optional string desc,
    5: optional bool enable,
}

struct DeleteMessageForwardItemRequestThrift {
    1: i64 requestId,
    2: list<MessageForwardItemThrift> messageForwardItemThriftList,
}

struct DeleteMessageForwardItemResponseThrift {
    1: i64 responseId,
}

struct ListMessageForwardItemRequestThrift {
    1: i64 requestId,
}

struct ListMessageForwardItemResponseThrift {
    1: i64 responseId,
    2: list<MessageForwardItemThrift> messageForwardItemThriftList,
}

struct GetMessageForwardItemRequestThrift {
    1: i64 requestId,
    2: list<string> phoneNumList,
}

struct GetMessageForwardItemResponseThrift {
    1: i64 responseId,
    2: list<MessageForwardItemThrift> messageForwardItemThriftList,
}

//**************** Message fowward setting end ******************************/

//**************** SMTP setting end ******************************/

enum SmtpContentTypeThrift {
    PLAIN = 1,
    HTML = 2,
}

enum SmtpEncryptTypeThrift {
    AUTH = 1,
    SSL = 2 ,
    TLS = 3,
}

struct SmtpItemThrift {
    1: bool enable,
    2: string userName;
    3: string password;
    4: i32 smtpPort;
    5: SmtpEncryptTypeThrift encryptType;
    6: string subject;
    7: string smtpServer;
    8: SmtpContentTypeThrift contentType;
}

struct SaveOrUpdateSmtpItemRequestThrift {
    1: i64 requestId,
    2: SmtpItemThrift smtpItmeThrift,
}

struct SaveOrUpdateSmtpItemResponseThrift {
    1: i64 responseId,
}

struct GetSmtpItemRequestThrift {
    1: i64 requestId,
}

struct GetSmtpItemResponseThrift {
    1: i64 responseId,
    2: SmtpItemThrift smtpItmeThrift,
}

//**************** SMTP setting end ******************************/

//**************** SMTP Send Email begin ******************************/

struct CheckSmtpSendEmailRequestThrift {
    1: i64 requestId,
    2: string smtpHost,
    3: string userName,
    4: string password,
    5: i32 smtpPort,
    6: SmtpEncryptTypeThrift encryptType,
    7: SmtpContentTypeThrift contentType,
    8: string subject,
}

struct CheckSmtpSendEmailResponseThrift {
    1: i64 responseId,
}

//**************** SMTP Send Email end ******************************/


//********************************* MonitorServer user authentification begin **********************************************************/
/*
StartPerformanceTask
StopPerformanceTask
CreatePerformanceTask
DeletePerformanceTask
ListPerformanceTask
 */
struct StartPerformanceTaskRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: StartPerformanceTaskRequestThrift request,
}
struct StartPerformanceTaskResponse {
    1: i64 responseId,
    2: StartPerformanceTaskResponseThrift response,
}

struct StopPerformanceTaskRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: StopPerformanceTaskRequestThrift request,
}
struct StopPerformanceTaskResponse {
    1: i64 responseId,
    2: StopPerformanceTaskResponseThrift response,
}

struct CreatePerformanceTaskRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: CreatePerformanceTaskRequestThrift request,
}
struct CreatePerformanceTaskResponse {
    1: i64 responseId,
    2: CreatePerformanceTaskReponseThrift response,
}

struct DeletePerformanceTaskRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: DeletePerformanceTaskRequestThrift request,
}
struct DeletePerformanceTaskResponse {
    1: i64 responseId,
    2: DeletePerformanceTaskResponseThrift response,
}

struct ListPerformanceTaskRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: ListPerformanceTaskRequestThrift request,
}
struct ListPerformanceTaskResponse {
    1: i64 responseId,
    2: ListPerformanceTaskReponseThrift response,
}

/*
ListCompressedPerformanceByCount
ListMultiCompressedPerformanceData
 */
struct ListCompressedPerformanceByCountRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: ListCompressedPerformanceByCountRequestThrift request,
}
struct ListCompressedPerformanceByCountResponse {
    1: i64 responseId,
    2: ListCompressedPerformanceByCountResponseThrift response,
}
struct ListMultiCompressedPerformanceDataRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: ListMultiCompressedPerformanceDataRequestThrift request,
}
struct ListMultiCompressedPerformanceDataResponse {
    1: i64 responseId,
    2: ListMultiCompressedPerformanceDataResponseThrift response,
}

/*
GetAlertTemplate
CreateAlertRule
DeleteAlertRule
MergeAlertRule
UpdateAlertRule
*/
struct GetAlertTemplateRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: GetAlertTemplateRequestThrift request,
}
struct GetAlertTemplateResponse {
    1: i64 responseId,
    2: GetAlertTemplateResponseThrift response,
}
struct CreateAlertRuleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: CreateAlertRuleRequestThrift request,
}
struct CreateAlertRuleResponse {
    1: i64 responseId,
    2: CreateAlertRuleResponseThrift response,
}
struct DeleteAlertRuleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: DeleteAlertRuleRequestThrift request,
}
struct DeleteAlertRuleResponse {
    1: i64 responseId,
    2: DeleteAlertRuleResponseThrift response,
}
struct MergeAlertRuleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: MergeAlerRuleRequestThrift request,
}
struct MergeAlertRuleResponse {
    1: i64 responseId,
    2: MergeAlerRuleResponseThrift response,
}
struct UpdateAlertRuleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: UpdateAlertRuleRequestThrift request,
}
struct UpdateAlertRuleResponse {
    1: i64 responseId,
    2: UpdateAlertRuleReponseThrift response,
}
struct EnableAlertRuleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: EnableAlertRuleRequestThrift request,
}
struct EnableAlertRuleResponse {
    1: i64 responseId,
    2: EnableAlertRuleResponseThrift response,
}
struct DisableAlertRuleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: DisableAlertRuleRequestThrift request,
}
struct DisableAlertRuleResponse {
    1: i64 responseId,
    2: DisableAlertRuleResponseThrift response,
}
/*
AlertsAcknowledge
ClearAlertsAcknowledge
AlertsClear
DeleteAlert
DeleteAlerts
GetAlertMessageDetail
ListAlertsByTable
ListAlertCount
*/
struct AlertsAcknowledgeRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: AlertsAcknowledgeRequestThrift request,
}
struct AlertsAcknowledgeResponse {
    1: i64 responseId,
    2: AlertsAcknowledgeResponseThrift response,
}
struct ClearAlertsAcknowledgeRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: ClearAlertsAcknowledgeRequestThrift request,
}
struct ClearAlertsAcknowledgeResponse {
    1: i64 responseId,
    2: ClearAlertsAcknowledgeResponseThrift response,
}
struct AlertsClearRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: AlertsClearRequestThrift request,
}
struct AlertsClearResponse {
    1: i64 responseId,
    2: AlertsClearResponseThrift response,
}
struct DeleteAlertRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: DeleteAlertRequestThrift request,
}
struct DeleteAlertResponse {
    1: i64 responseId,
    2: DeleteAlertResponseThrift response,
}
struct DeleteAlertsRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: DeleteAlertsRequestThrift request,
}
struct DeleteAlertsResponse {
    1: i64 responseId,
    2: DeleteAlertsResponseThrift response,
}
struct GetAlertMessageDetailRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: GetAlertMessageDetailRequestThrift request,
}
struct GetAlertMessageDetailResponse {
    1: i64 responseId,
    2: GetAlertMessageDetailResponseThrift response,
}
struct ListAlertsByTableRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: ListAlertsByTableRequestThrift request,
}
struct ListAlertsByTableResponse {
    1: i64 responseId,
    2: ListAlertByTableResponseThrift response,
}
struct ListAlertCountRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: ListAlertCountRequestThrift request,
}
struct ListAlertCountResponse {
    1: i64 responseId,
    2: ListAlertCountResponseThrift response,
}

/*
SaveSnmpForwardItem
UpdateSnmpForwardItem
DeleteSnmpForwardItem
ListSnmpForwardItem
*/
struct SaveSnmpForwardItemRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: SaveSnmpForwardItemRequestThrift request,
}
struct SaveSnmpForwardItemResponse {
    1: i64 responseId,
    2: SaveSnmpForwardItemResponseThrift response,
}
struct UpdateSnmpForwardItemRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: UpdateSnmpForwardItemRequestThrift request,
}
struct UpdateSnmpForwardItemResponse {
    1: i64 responseId,
    2: UpdateSnmpForwardItemResponseThrift response,
}
struct DeleteSnmpForwardItemRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: DeleteSnmpForwardItemRequestThrift request,
}
struct DeleteSnmpForwardItemResponse {
    1: i64 responseId,
    2: DeleteSnmpForwardItemResponseThrift response,
}
struct ListSnmpForwardItemRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: ListSnmpForwardItemRequestThrift request,
}
struct ListSnmpForwardItemResponse {
    1: i64 responseId,
    2: ListSnmpForwardItemResponseThrift response,
}
/*
SaveEmailForwardItem
UpdateEmailForwardItem
DeleteEmailForwardItem
ListEmailForwardItem
*/
struct SaveEmailForwardItemRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: SaveEmailForwardItemRequestThrift request,
}
struct SaveEmailForwardItemResponse {
    1: i64 responseId,
    2: SaveEmailForwardItemResponseThrift response,
}
struct UpdateEmailForwardItemRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: UpdateEmailForwardItemRequestThrift request,
}
struct UpdateEmailForwardItemResponse {
    1: i64 responseId,
    2: UpdateEmailForwardItemResponseThrift response,
}
struct DeleteEmailForwardItemRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: DeleteEmailForwardItemRequestThrift request,
}
struct DeleteEmailForwardItemResponse {
    1: i64 responseId,
    2: DeleteEmailForwardItemResponseThrift response,
}
struct ListEmailForwardItemRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: ListEmailForwardItemRequestThrift request,
}
struct ListEmailForwardItemResponse {
    1: i64 responseId,
    2: ListEmailForwardItemResponseThrift response,
}
/*
SaveOrUpdateSmtpItem
GetSmtpItem
CheckSmtpSendEmail
*/
struct SaveOrUpdateSmtpItemRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: SaveOrUpdateSmtpItemRequestThrift request,
}
struct SaveOrUpdateSmtpItemResponse {
    1: i64 responseId,
    2: SaveOrUpdateSmtpItemResponseThrift response,
}
struct GetSmtpItemRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: GetSmtpItemRequestThrift request,
}
struct GetSmtpItemResponse {
    1: i64 responseId,
    2: GetSmtpItemResponseThrift response,
}
struct MonitorPlatformDataDtoThrift {
    1: bool sendMessage,
    2: string alarmSource,
    3: string alarmMetric,
    4: string alarmTag,
    5: string alarmInfo,
    6: string alarmLevel,
    7: string eventType,
    8: string alarmTime,
    9: string sms,
    10: string email,
    11: string link,
    12: string phone,
    13: string system,
    14: string alarmSysCode,
    15: string alarmName,
    16: string alarmValue,
    17: string alarmThreshold,
}
struct SendNoticeDtoThrift {
    1: string type,
    2: list<string> receiverList,
    3: string appId,
    4: string message,
    5: optional map<string,string> extension,
    6: optional bool emailHtmlFlag,
    7: optional MonitorPlatformDataDtoThrift monitorPlatformDataDto,
}
struct DtoUserThrift {
    1: i64 id,
    2: string userName,
    3: optional string jobNum,
    4: optional string sms,
    5: optional string email,
    6: optional string link,
    7: optional string description,
    8: optional bool enableSms,
    9: optional bool enableEmail,
    10: optional bool enableLink,
    11: bool flag,
}
struct SaveDtoUserRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: DtoUserThrift dtoUser,
}
struct SaveDtoUserResponse {
    1: i64 responseId,
}
struct UpdateDtoUserRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: DtoUserThrift dtoUser,
}
struct UpdateDtoUserResponse {
    1: i64 responseId,
}
struct UpdateDtoUserFlagRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: bool flag,
    4: list<i64> ids,
}
struct UpdateDtoUserFlagResponse {
    1: i64 responseId,
    }
struct ListDtoUsersRequest {
    1: i64 requestId,
    2: i64 accountId,
}
struct ListDtoUsersResponse {
    1: i64 responseId,
    2: list<DtoUserThrift> dtoUsers,
}
struct GetDtoUserRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: i64 id,
}
struct GetDtoUserResponse {
    1: i64 responseId,
    2: DtoUserThrift dtoUser,
}
struct DeleteDtoUsersRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<i64> ids,
}
struct DeleteDtoUsersResponse {
    1: i64 responseId,
}
struct DtoSenderLogThrift {
    1: i64 id,
    2: string userName,
    3: optional string jobNum,
    4: string type,
    5: bool result,
    6: i64 sendTime,
    7: string eventType,
    8: string sendNotice,
}
struct GetDtoSendLogCountRequest{
    1: i64 requestId,
    2: i64 accountId,
}
struct GetDtoSendLogCountResponse{
    1: i64 responseId,
    2: i32 count,
}
struct ListDtoSendLogRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: optional i32 pageSize,
    4: optional i32 pageNo,
    5: optional string sortFeild,
    6: optional string sortDirection,
}
struct ListDtoSendLogResponse {
    1: i64 responseId,
    2: i32 recordsTotal,
    3: i32 recordsAfterFilter,
    4: list<DtoSenderLogThrift> sendLogs,
}
struct DeleteDtoSendLogRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<i64> ids
}
struct DeleteDtoSendLogResponse {
    1: i64 responseId,
}
struct CheckSmtpSendEmailRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: CheckSmtpSendEmailRequestThrift request,
}
struct CheckSmtpSendEmailResponse {
    1: i64 responseId,
    2: CheckSmtpSendEmailResponseThrift response,
}

enum StatementStatisticsTimeUnit {
    day = 1,
    week = 2,
    month = 3,
    year = 4;
}
struct GetStatisticsRequestThrift {
    1: i64 requestId,
    2: i64 accountId,
    3: list<string> counterKeyList,
    4: StatementStatisticsTimeUnit timeUnit,
    5: i64 time,
    6: list<SourceObjectThrift> resource;
}
struct GetStatisticsResponseThrift {
    1: i64 responseId,
    2: binary csvFile,
}

struct ReportMaintenanceModeInfoRequest {
    1: i64 requestId,
    2: string maintenanceIp,
    3: i64 maintenanceTime,
}
struct ReportMaintenanceModeInfoResponse {
    1: i64 responseId,
}

struct SaveOrUpdatePerformanceSearchTemplateRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: string name,
    4: optional i64 startTime,
    5: optional i64 endTime,
    6: optional i64 period,
    7: string timeUnit,
    8: string counterKeyJson,
    9: string sourcesJson,
    10: string objectType
}
struct SaveOrUpdatePerformanceSearchTemplateResponse {
    1: i64 responseId,
}

struct DeletePerformanceSearchTemplateRequest {
    1: i64 requestId,
    2: i64 id,
    3: i64 accountId
}
struct DeletePerformanceSearchTemplateResponse {
    1: i64 responseId,
}

struct ListPerformanceSearchTemplateRequest {
    1: i64 requestId,
    2: i64 accountId
}
struct ListPerformanceSearchTemplateResponse {
    1: i64 responseId,
    2: list<PerformanceSearchTemplateThrift> performanceSearchTemplateList
}

//********************************** MonitorServer user authentification end   **********************************************************/

 /**
 * ----------------------------------------------------exceptions----------------------------------------------------
 */
exception IllegalParameterExceptionThrift {
  1: optional string detail
}


exception PerformanceTaskIsRudundantExceptionThrift {
    1: optional string detail
}

exception CounterKeyExitedExceptionThrift {
    1: optional string detail
}

exception CounterKeyIllegalExceptionThrift {
    1: optional string detail
}

exception SmtpSendEmailExceptionThrift {
    1: optional string detail
}

exception DuplicateIpPortExceptionThrift {
    1: optional string detail
}

exception UsmPassphrasesLengthException {
    1: optional string detail
}

exception PerformanceDataTimeSpanIsBigExceptionThrift {
    1: optional string detail,
    2: optional i32 maxTimeSpanDays
}
exception PerformanceDataTimeCrossBorderExceptionThrift {
    1: optional string detail,
}
exception DtoUserAlreadyExistedExceptionThrift {
    1: optional string detail,
}
exception DtoTypeNoCorrespondNumberExceptionThrift {
    1: optional string detail,
}
 /**
 * ----------------------------------------------------service----------------------------------------------------
 */
 service MonitorServer extends shared.DebugConfigurator {
   // Healthy?
   void ping(),

   //Shutdown
   void shutdown(),
    MetricsCollectionResolveResponse metricsCollectionResolve(1:MetricsCollectionResolveRequest request)
                                                                        throws (1:shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe),
   
    AlertsAcknowledgeResponseThrift alertsAcknowledge(1:AlertsAcknowledgeRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe),
    ClearAlertsAcknowledgeResponseThrift clearAlertsAcknowledge(1:ClearAlertsAcknowledgeRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe),

    AlertsClearResponseThrift alertsClear(1:AlertsClearRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe),
    
    DeleteAlertResponseThrift deleteAlert(1:DeleteAlertRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe),
    DeleteAlertsResponseThrift deleteAlerts(1:DeleteAlertsRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe),

    GetAlertMessageDetailResponseThrift getAlertMessageDetail(1:GetAlertMessageDetailRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe),

    ListAlertByTableResponseThrift listAlertsByTable(1:ListAlertsByTableRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe),

    ListAlertCountResponseThrift listAlertCount(1:ListAlertCountRequestThrift request) throws(
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe),

    ListAllAlertCountResponseThrift listAllAlertCount(1:ListAllAlertCountRequestThrift request) throws(
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe),
                                                                                
    CreatePerformanceTaskReponseThrift createPerformanceTask(1:CreatePerformanceTaskRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe,
                                                                                4: PerformanceTaskIsRudundantExceptionThrift ptire),
    DeletePerformanceTaskResponseThrift deletePerformanceTask(1:DeletePerformanceTaskRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe),
    StartPerformanceTaskResponseThrift startPerformanceTask(1:StartPerformanceTaskRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe),
    StopPerformanceTaskResponseThrift stopPerformanceTask(1:StopPerformanceTaskRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe),
    ListPerformanceTaskReponseThrift listPerformanceTask(1:ListPerformanceTaskRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe),
    ListCompressedPerformanceResponseThrift listCompressedPerformance(1:ListCompressedPerformanceRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe),
    ListCompressedPerformanceByCountResponseThrift listCompressedPerformanceByCount(1: ListCompressedPerformanceByCountRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe),
    ListMultiCompressedPerformanceDataResponseThrift listMultiCompressedPerformanceData(1: ListMultiCompressedPerformanceDataRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe,
                                                                                4: PerformanceDataTimeSpanIsBigExceptionThrift pdtsibe,
                                                                                5: PerformanceDataTimeCrossBorderExceptionThrift pdtcbe),
    GetPerformanceDataTimeSpanResponseThrift getPerformanceDataTimeSpan(1:GetPerformanceDataTimeSpanRequestThrift request) throws (
                                                                                    1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                    2: shared.ServiceIsNotAvailableThrift sina,
                                                                                    3: IllegalParameterExceptionThrift ipe),
    GetStatisticsResponseThrift getPerformanceStatistics(1: GetStatisticsRequestThrift request) throws (
                                                                                    1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                    2: shared.ServiceIsNotAvailableThrift sina,
                                                                                    3: IllegalParameterExceptionThrift ipe),

//    AddBaseAlertTemplateResponseThrift addBaseAlertTemplate(1: AddBaseAlertTemplateRequestThrift request) throws (
//                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
//                                                                                2: shared.ServiceIsNotAvailableThrift sina,
//                                                                                3: IllegalParameterExceptionThrift ipe),
//    DeleteAlertTemplateResponseThrift deleteAlertTemplate(1:DeleteAlertTemplateRequestThrift request) throws (
//                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
//                                                                                2: shared.ServiceIsNotAvailableThrift sina,
//                                                                                3: IllegalParameterExceptionThrift ipe),
//    UpdateAlertTemplateResponseThrift updateAlertTemplate(1:UpdateAlertTemplateRequestThrift request) throws (
//                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
//                                                                                2: shared.ServiceIsNotAvailableThrift sina,
//                                                                                3: IllegalParameterExceptionThrift ipe),
    GetAlertTemplateResponseThrift getAlertTemplate(1:GetAlertTemplateRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe),

    ListNotUsedCounterKeyResponseThrift listNotUsedCounterKey(1:ListNotUsedCounterKeyRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina),

    CreateAlertRuleResponseThrift createAlertRule(1:CreateAlertRuleRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe,
                                                                                4: CounterKeyExitedExceptionThrift ckee,
                                                                                5: CounterKeyIllegalExceptionThrift ckie),
    DeleteAlertRuleResponseThrift deleteAlertRule(1:DeleteAlertRuleRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe),
    MergeAlerRuleResponseThrift mergeAlertRule(1: MergeAlerRuleRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe),
    UpdateAlertRuleReponseThrift updateAlertRule(1: UpdateAlertRuleRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe),
    EnableAlertRuleResponseThrift enableAlertRule(1: EnableAlertRuleRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe),
    DisableAlertRuleResponseThrift disableAlertRule(1: DisableAlertRuleRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe),
    SaveSnmpForwardItemResponseThrift saveSnmpForwardItem(1: SaveSnmpForwardItemRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe,
                                                                                4: DuplicateIpPortExceptionThrift dupe),
    UpdateSnmpForwardItemResponseThrift updateSnmpForwardItem(1: UpdateSnmpForwardItemRequestThrift request) throws (
                                                                                 1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                 2: shared.ServiceIsNotAvailableThrift sina,
                                                                                 3: IllegalParameterExceptionThrift ipe,
                                                                                 4: DuplicateIpPortExceptionThrift dupe,
                                                                                 5: UsmPassphrasesLengthException uple),
    DeleteSnmpForwardItemResponseThrift deleteSnmpForwardItem(1: DeleteSnmpForwardItemRequestThrift request) throws (
                                                                                 1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                 2: shared.ServiceIsNotAvailableThrift sina,
                                                                                 3: IllegalParameterExceptionThrift ipe),
    ListSnmpForwardItemResponseThrift listSnmpForwardItem(1: ListSnmpForwardItemRequestThrift request) throws (
                                                                                 1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                 2: shared.ServiceIsNotAvailableThrift sina,
                                                                                 3: IllegalParameterExceptionThrift ipe),
    SaveEmailForwardItemResponseThrift saveEmailForwardItem(1: SaveEmailForwardItemRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe),
    UpdateEmailForwardItemResponseThrift updateEmailForwardItem(1: UpdateEmailForwardItemRequestThrift request) throws (
                                                                                 1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                 2: shared.ServiceIsNotAvailableThrift sina,
                                                                                 3: IllegalParameterExceptionThrift ipe),
    DeleteEmailForwardItemResponseThrift deleteEmailForwardItem(1: DeleteEmailForwardItemRequestThrift request) throws (
                                                                                 1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                 2: shared.ServiceIsNotAvailableThrift sina,
                                                                                 3: IllegalParameterExceptionThrift ipe),
    ListEmailForwardItemResponseThrift listEmailForwardItem(1: ListEmailForwardItemRequestThrift request) throws (
                                                                                 1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                 2: shared.ServiceIsNotAvailableThrift sina,
                                                                                 3: IllegalParameterExceptionThrift ipe),
    SaveMessageForwardItemResponseThrift saveMessageForwardItem(1: SaveMessageForwardItemRequestThrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                3: IllegalParameterExceptionThrift ipe),
    UpdateMessageForwardItemResponseThrift updateMessageForwardItem(1: UpdateMessageForwardItemRequestThrift request) throws (
                                                                                 1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                 2: shared.ServiceIsNotAvailableThrift sina,
                                                                                 3: IllegalParameterExceptionThrift ipe),
    DeleteMessageForwardItemResponseThrift deleteMessageForwardItem(1: DeleteMessageForwardItemRequestThrift request) throws (
                                                                                 1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                 2: shared.ServiceIsNotAvailableThrift sina,
                                                                                 3: IllegalParameterExceptionThrift ipe),
    ListMessageForwardItemResponseThrift listMessageForwardItem(1: ListMessageForwardItemRequestThrift request) throws (
                                                                                 1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                 2: shared.ServiceIsNotAvailableThrift sina,
                                                                                 3: IllegalParameterExceptionThrift ipe),
    GetMessageForwardItemResponseThrift getMessageForwardItemByPhoneNum(1: GetMessageForwardItemRequestThrift request) throws (
                                                                                 1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                 2: shared.ServiceIsNotAvailableThrift sina,
                                                                                 3: IllegalParameterExceptionThrift ipe),
    SaveOrUpdateSmtpItemResponseThrift saveOrUpdateSmtpItem(1: SaveOrUpdateSmtpItemRequestThrift request) throws (
                                                                                  1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                  2: shared.ServiceIsNotAvailableThrift sina,
                                                                                  3: IllegalParameterExceptionThrift ipe),
    GetSmtpItemResponseThrift getSmtpItem(1: GetSmtpItemRequestThrift request) throws (
                                                                                  1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                  2: shared.ServiceIsNotAvailableThrift sina,
                                                                                  3: IllegalParameterExceptionThrift ipe),
    SaveDtoUserResponse saveDtoUser(1: SaveDtoUserRequest request) throws (
                                                                                  1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                  2: shared.ServiceIsNotAvailableThrift sina,
                                                                                  3: IllegalParameterExceptionThrift ipe,
                                                                                  4: DtoUserAlreadyExistedExceptionThrift duae),
    UpdateDtoUserResponse updateDtoUser(1: UpdateDtoUserRequest request) throws (
                                                                                  1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                  2: shared.ServiceIsNotAvailableThrift sina,
                                                                                  3: IllegalParameterExceptionThrift ipe,
                                                                                  4: DtoUserAlreadyExistedExceptionThrift djae),
    UpdateDtoUserFlagResponse updateDtoUserFlag(1: UpdateDtoUserFlagRequest request) throws (
                                                                                  1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                  2: shared.ServiceIsNotAvailableThrift sina,
                                                                                  3: IllegalParameterExceptionThrift ipe),
    ListDtoUsersResponse listDtoUsers(1: ListDtoUsersRequest request) throws (
                                                                                  1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                  2: shared.ServiceIsNotAvailableThrift sina,
                                                                                  3: IllegalParameterExceptionThrift ipe),
    GetDtoUserResponse getDtoUser(1: GetDtoUserRequest request) throws (
                                                                                  1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                  2: shared.ServiceIsNotAvailableThrift sina,
                                                                                  3: IllegalParameterExceptionThrift ipe),
    DeleteDtoUsersResponse deleteDtoUsers(1: DeleteDtoUsersRequest request) throws (
                                                                                  1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                  2: shared.ServiceIsNotAvailableThrift sina,
                                                                                  3: IllegalParameterExceptionThrift ipe),
    GetDtoSendLogCountResponse getDtoSendLogCount(1:GetDtoSendLogCountRequest request) throws(
                                                                                  1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                  2: shared.ServiceIsNotAvailableThrift sina,
                                                                                  3: IllegalParameterExceptionThrift ipe),
    ListDtoSendLogResponse listDtoSendLog(1: ListDtoSendLogRequest request) throws (
                                                                                  1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                  2: shared.ServiceIsNotAvailableThrift sina,
                                                                                  3: IllegalParameterExceptionThrift ipe),
    DeleteDtoSendLogResponse deleteDtoSendLog(1: DeleteDtoSendLogRequest request) throws (
                                                                                  1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                  2: shared.ServiceIsNotAvailableThrift sina,
                                                                                  3: IllegalParameterExceptionThrift ipe),
    CheckSmtpSendEmailResponseThrift checkSmtpSendEmail(1: CheckSmtpSendEmailRequestThrift request) throws (
                                                                                  1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                  2: shared.ServiceIsNotAvailableThrift sina,
                                                                                  3: SmtpSendEmailExceptionThrift spe),

    ReportMaintenanceModeInfoResponse reportMaintenanceModeInfo(1: ReportMaintenanceModeInfoRequest request) throws (
                                                                                  1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                  2: shared.ServiceIsNotAvailableThrift sina),

    SaveOrUpdatePerformanceSearchTemplateResponse saveOrUpdatePerformanceSearchTemplate(1: SaveOrUpdatePerformanceSearchTemplateRequest request) throws (
                                                                                  1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                  2: shared.ServiceIsNotAvailableThrift sina,
                                                                                  3: PerformanceDataTimeSpanIsBigExceptionThrift pdtsibe,
                                                                                  4: PerformanceDataTimeCrossBorderExceptionThrift pdtcbe),

    DeletePerformanceSearchTemplateResponse deletePerformanceSearchTemplate(1: DeletePerformanceSearchTemplateRequest request) throws (
                                                                                      1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                      2: shared.ServiceIsNotAvailableThrift sina,
                                                                                      3: shared.PermissionNotGrantExceptionThrift pnge),

    ListPerformanceSearchTemplateResponse listPerformanceSearchTemplate(1:ListPerformanceSearchTemplateRequest request) throws (
                                                                                      1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                      2: shared.ServiceIsNotAvailableThrift sina),


 }
