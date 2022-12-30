include "shared.thrift"
include "icshared.thrift"
include "monitorserver.thrift"

/**
 * This thrift file define information center service and its client
 * 
 */
namespace java py.thrift.infocenter.service


/**
 * Requests and Responses
 */
// data node service sends its archive metadata to me
struct ReportArchivesRequest {
   1:i64 requestId, 
   2:shared.InstanceMetadataThrift instance,
   3:shared.ReportDbRequestThrift reportDbRequest,
   4:set<i64> volumeUpdateReportTableOk
}

struct ReportArchivesResponse {
   1:i64 requestId,
   2:shared.GroupThrift group,
   3:shared.NextActionInfoThrift datanodeNextAction,
   4:map<i64, shared.NextActionInfoThrift> archiveIdMapNextAction,
   5:shared.ReportDbResponseThrift reportDbResponse,
   6:map<i64, shared.PageMigrationSpeedInfoThrift> archiveIdMapMigrationSpeed,
   7:map<i64, string> archiveIdMapMigrationStrategy
   8:optional map<i64,shared.CheckSecondaryInactiveThresholdThrift> archiveIdMapCheckSecondaryInactiveThreshold,
   9:optional shared.RebalanceTaskListThrift rebalanceTasks,
   //just for Equilibrium
   10:map<i64, map<i64, i64>> volumeReportToInstancesSameTime,
   11:i64 updateReportToInstancesVersion,
   12:map<i64, map<i64, i64>> updateTheDatanodeReportTable,
   13:bool equilibriumOkAndClearValue,
   14:map<i64, map<i64, shared.VolumeStatusThrift>> eachStoragePoolVolumesStatus
}

// data node service sends its segment units metadata to me
struct ReportSegmentUnitsMetadataRequest {
   1:i64 requestId, 
   2:i64 instanceId, 
   3:list<shared.SegmentUnitMetadataThrift> segUnitsMetadata
}

struct ReportSegmentUnitCloneFailRequest {
   1:i64 requestId,
   2:i64 myInstanceId,
   3:i64 volumeId,
   4:i32 segIndex
}

struct ReportSegmentUnitCloneFailResponse {
   1:i64 requestId
}

struct ReportSegmentUnitRecycleFailRequest {
   1:i64 requestId,
   2:list<shared.SegmentUnitMetadataThrift> segUnitsMetadata
}

struct ReportSegmentUnitRecycleFailResponse {
   1:i64 requestId
}

//this struct is used to restore the segment unit whose status is conflict to the volume status
struct SegUnitConflictThrift {
   1:i64 volumeId,
   2:i32 segIndex,
   3:shared.SegmentUnitStatusConflictCauseThrift cause,
   4:optional binary mySnapshotManagerInBinary
}

// I responses with the latest segment unit metadata of all its segment units
// if the segment unit is rejected for any reason, it's returned
struct ReportSegmentUnitsMetadataResponse {
   1: i64 requestId,
   2: list<SegUnitConflictThrift> conflicts,
   3: list<shared.SegmentUnitMetadataThrift> segUnitsMetadata,
   4: map<i64, set<i64>> whichHaThisVolumeToReport,
   5: map<i64, set<i64>> volumeNotToReportCurrentInstance,
   6: optional map<i64, i32> volumeMaxSnapshotId,
}

struct ReserveVolumeRequest {
   1:i64 requestId,
   2:i64 rootVolumeId,
   3:i64 volumeId,
   4:string name,
   5:i64 volumeSize,
   6:i64 segmentSize,
   7:shared.VolumeTypeThrift volumeType,
   8:i64 accountId,
   9:list<shared.Tag> tags,
   10: bool notCreateAllSegmentAtBegining, // mark create all segment at the beginning
   11: i32 leastSegmentUnitCount, // if not create all segment at the beginning, the least segment unit should be created
   12: bool simpleConfiguration
}

struct ReserveVolumeResponse {
   1:i64 requestId,
   2:map<i32, map<shared.SegmentUnitTypeThrift, list<shared.InstanceIdAndEndPointThrift>>> segIndex2Instances
}

struct LoadVolumeRequest {
    1:i64 accountId,
}
struct LoadVolumeResponse {

}



struct ChangeVolumeStatusFromFixToUnavailableRequest{
    1:i64 requestId,
    2:i64 volumeId,
    3:i64 accountId,
}

struct ChangeVolumeStatusFromFixToUnavailableResponse{
    1:bool changeSucess,
}

struct ThriftAlarmInformation {
    1:string alarmObject,
    2:string alarmName,
    3:string timeStamp,
    4:string alarmLevel,
    5:string description
}

struct DriverContainerCandidateThrift {
	1:string hostName,
	2:i32 port,
	3:i64 sequenceId
}

struct RetrieveOneRebalanceTaskRequest {
	1:i64 requestId,
	2:bool record
}

struct RetrieveOneRebalanceTaskResponse {
    1:i64 requestId,
    2:shared.RebalanceTaskThrift rebalanceTask,
}

struct RecoverDatabaseRequest {
    1: i64 requestId
}
struct RecoverDatabaseResponse {
    1: bool success
}

struct GetServerNodeByIpRequest {
    1: i64 requestId,
    2: string ip,
}

struct GetServerNodeByIpResponse {
    1: i64 responseId,
    2: shared.ServerNodeThrift serverNode,
}

struct PingPeriodicallyRequest {
    1: i64 requestId,
    2: string serverId,
}

struct PingPeriodicallyResponse {
    1: i64 responseId,
}

exception NoNeedToRebalanceThrift {
    1: optional string detail
}

exception SegmentNotFoundExceptionThrift {
  1: optional string detail
}



//**********for other ***/
exception VolumeBeingCreatedExceptionThrift {
   1: optional string detail
}

//********** Create Segment Request ******************************/
struct CreateSegmentUnitRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i32 segIndex,
   4: shared.VolumeTypeThrift volumeType,
   5: shared.SegmentUnitTypeThrift segmentUnitType,
   6: optional shared.SegmentMembershipThrift initMembership, // the initial membership, used by a new node trying to join an existing group
   7: optional list<i64> initMembers, // the initial members, used by new nodes to create a brand new volume. If initMembership is set too,
   // then initMembership has higher preference to initMembers.
   8:optional bool fixVolume,
   9:optional i64 storagePoolId,
   10:optional shared.SegmentUnitRoleThrift segmentRole,
   11:optional map<shared.InstanceIdAndEndPointThrift,shared.SegmentMembershipThrift> segmentMembershipMap,
   12:optional shared.SegmentMembershipThrift srcMembership,
   13:optional i32 segmentWrapSize,
   14:i64 requestTimestampMillis,
   15:i64 requestTimeoutMillis,
   17: bool enableLaunchMultiDrivers,
   18: shared.VolumeSourceThrift volumeSource
}

struct CreateSegmentUnitResponse {
   1: i64 requestId
}

struct CreateSegmentsRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i32 segIndex,
   4: i32 numToCreate,
   5: shared.VolumeTypeThrift volumeType,
   6: shared.CacheTypeThrift cacheType,
   7: optional list<i64> initMembers,
   8: i64 accountId,
   9: i64 domainId,
   10: i64 storagePoolId
}

struct CreateSegmentsResponse {
   1: i64 requestId
}

struct UpdateVolumeLayoutRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i32 segIndex,
   4: i32 numToCreate
}

struct UpdateVolumeLayoutResponse {
   1: i64 requestId,
   2: string volumeLayout
}

struct ReportJustCreatedSegmentUnitRequest {
   1: i64 requestId,
   2: shared.SegmentUnitMetadataThrift segUnitMeta
}

struct ReportJustCreatedSegmentUnitResponse {
   1: i64 requestId,
}

struct ReportVolumeInfoRequest {
   1: i64 requestId,
   2: i64 instanceId,
   3: string instanceName,
   4: list<shared.VolumeMetadataThrift> volumeMetadatas,
   5: list<shared.VolumeMetadataThrift> volumeMetadatasForDelete,
   6: map<i64, i64> totalSegmentUnitMetadataNumber
}

struct ReportVolumeInfoResponse {
   1: i64 requestId,
   2: list<shared.VolumeMetadataThrift> volumeMetadatasChangeInMaster,
   3: set<i64> notReportThisVolume,
   4: map<i64, i32> volumeIdToSnapshotVersion,
}

//******** End of CreateSegmentUnitRequest *****/

struct ExtendVolumeRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i64 extendSize,
   4: i64 originalSize,
   5: i64 accountId
   6: i64 domainId,
   7: i64 storagePoolId
}

struct ExtendVolumeResponse {
   1: i64 requestId
}

struct MarkVolumesReadWriteRequest {
   1: i64 requestId,
   2: i64 accountId,
   3: set<i64> volumeIds,
   4: shared.ReadWriteTypeThrift readWrite
}

struct MarkVolumesReadWriteResponse {
   1: i64 requestId
}

struct CheckVolumeIsReadOnlyRequest {
   1: i64 requestId,
   2: i64 volumeId
}
struct CheckVolumeIsReadOnlyResponse {
   1: i64 requestId,
   2: i64 volumeId,
   3: bool readOnly
}

struct CreateRoleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: string roleName,
    4: string description,
    5: set<string> apiNames;
}
struct CreateRoleResponse {
    1: i64 requestId,
    2: i64 createdRoleId;
}

struct AssignRolesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: i64 assignedAccountId,
    4: set<i64> roleIds;
}
struct AssignRolesResponse {
    1: i64 requestId;
}

struct UpdateRoleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: i64 roleId,
    4: string roleName,
    5: string description,
    6: set<string> apiNames;
}

struct UpdateRoleResponse {
    1: i64 requestId;
}

struct ListApisRequest {
    1: i64 requestId,
    2: i64 accountId;
}

struct ListApisResponse {
    1: i64 requestId,
    2: set<shared.ApiToAuthorizeThrift> apis;
}

struct ListRolesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: optional set<i64> listRoleIds;
}

struct ListRolesResponse {
    1: i64 requestId,
    2: set<shared.RoleThrift> roles;
}

struct DeleteRolesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: set<i64> roleIds;
}
struct DeleteRolesResponse {
    1: i64 requestId,
    2: set<i64> deletedRoleIds;
}

struct InstanceMaintainRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: i64 instanceId,
    4: i64 durationInMinutes,
    5: string ip
}
struct InstanceMaintainResponse {
    1: i64 requestId
}

struct CancelMaintenanceRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: i64 instanceId
}
struct CancelMaintenanceResponse {
    1: i64 requestId
}

struct InstanceMaintenanceThrift {
    1: i64 instanceId,
    2: i64 startTime,
    3: i64 endTime,
    4: i64 currentTime,
    5: i64 duration
    6: string ip
}

struct ListInstanceMaintenancesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: optional list<i64> instanceIds
}
struct ListInstanceMaintenancesResponse {
    1: i64 requestId,
    2: list<InstanceMaintenanceThrift> instanceMaintenances
}

struct LogoutRequest {
    1: i64 requestId,
    2: i64 accountId
}
struct LogoutResponse {
    1: i64 requestId
}

struct GetSegmentSizeResponse {
    1: i64 segmentSize
}

struct VerifyReportStatisticsPermissionRequest {
    1: i64 requestId,
    2: i64 accountId
}
struct VerifyReportStatisticsPermissionResponse {
    1: i64 responseId
}

struct SaveOperationLogsToCsvRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: optional string accountName,
    4: optional string operationType,
    5: optional string targetType,
    6: optional string targetName,
    7: optional string status,
    8: optional i64 startTime,
    9: optional i64 endTime
}
struct SaveOperationLogsToCsvResponse {
    1: i64 requestId,
    2: binary csvFile
}

/** scsi ****/
struct CreateScsiClientRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: string ip,
    4: i64 driverContainerId
}

struct CreateScsiClientResponse {
    1: i64 requestId
}

struct DeleteScsiClientRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<string> ips
}

struct DeleteScsiClientResponse {
    1: i64 requestId,
    2: map<string, shared.ScsiClientOperationExceptionThrift> error
}

struct ListScsiClientRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: string ip
}

struct ListScsiClientResponse {
    1: i64 requestId,
    2: list<icshared.ScsiClientDescriptionThrift> clientDescriptions,
    3: string currentIp,
    4: list<icshared.ScsiClientInfoThrift> launchVolumesForScsi,
    5: list<shared.VolumeMetadataThrift> unLaunchVolumesForScsi,
}

// throw this exception when fail to apply or cancel volume access rules in driver
exception FailedToTellDriverAboutAccessRulesExceptionThrift {
   1: optional string detail
}

exception CreateRoleNameExistedExceptionThrift {
   1: optional string detail
}

//**** end *******/

/**
 * The definition of the service that manages segment membership
 */
service InformationCenter extends shared.DebugConfigurator{
   // Healthy?
   void ping(),
   
   //Shutdown 
   void shutdown(),

    ReportVolumeInfoResponse reportVolumeInfo(1:ReportVolumeInfoRequest request) throws(
                                        1:shared.ServiceHavingBeenShutdownThrift shbs,
                                        2:shared.ServiceIsNotAvailableThrift sina),

    RecoverDatabaseResponse recoverDatabase() throws(
                                    1:shared.ServiceHavingBeenShutdownThrift shbs,
                                    2:shared.ServiceIsNotAvailableThrift sina),

   // Add more exceptions here
   ReportArchivesResponse reportArchives(1:ReportArchivesRequest request) throws(
   							1:shared.ServiceHavingBeenShutdownThrift shbsd,
   							2:shared.InvalidGroupExceptionThrift ige,
   							3:shared.ServiceIsNotAvailableThrift sina,
   							4:shared.InvalidInputExceptionThrift iie),

   // Add more exceptions here
   ReportSegmentUnitsMetadataResponse reportSegmentUnitsMetadata(1:ReportSegmentUnitsMetadataRequest request) throws (
   						1:shared.InternalErrorThrift ie,
   						2:shared.ServiceHavingBeenShutdownThrift shbsd,
   						3:shared.ServiceIsNotAvailableThrift sina),

   ReportSegmentUnitRecycleFailResponse reportSegmentUnitRecycleFail(1:ReportSegmentUnitRecycleFailRequest request) throws (
                        1:shared.InternalErrorThrift ie,
                        2:shared.ServiceHavingBeenShutdownThrift shbsd,
                        3:shared.ServiceIsNotAvailableThrift sina),

   CreateSegmentsResponse createSegments(1:CreateSegmentsRequest request) throws (
                                                1:shared.NotEnoughSpaceExceptionThrift nese,
                                                2:shared.SegmentExistingExceptionThrift seet,
                                                3:shared.NoMemberExceptionThrift nmet,
                                                4:shared.ServiceHavingBeenShutdownThrift shbsd,
                                                5:shared.ServiceIsNotAvailableThrift sina,
                                                6:shared.EndPointNotFoundExceptionThrift epnfe,
                                                7:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                8:shared.NetworkErrorExceptionThrift nme
                                                ),

   UpdateVolumeLayoutResponse updateVolumeLayout(1:UpdateVolumeLayoutRequest request) throws (
                                                   1:shared.ServiceHavingBeenShutdownThrift shbsd,
                                                   2:shared.ServiceIsNotAvailableThrift sina
                                                   ),

   icshared.GetSegmentListResponse getSegmentList(1:icshared.GetSegmentListRequest request) throws (
                                        1:shared.InternalErrorThrift ie,
                                        2:shared.InvalidInputExceptionThrift iie,
                                        3:shared.NotEnoughSpaceExceptionThrift nese,
                                        4:shared.VolumeNotFoundExceptionThrift vnfe,
                                        5:shared.ServiceHavingBeenShutdownThrift shbsd,
                                        6:shared.ServiceIsNotAvailableThrift sina),

   icshared.GetSegmentResponse getSegment(1:icshared.GetSegmentRequest request) throws (
                                        1:shared.InternalErrorThrift ie,
                                        2:shared.VolumeNotFoundExceptionThrift vnfe,
                                        3:shared.ServiceHavingBeenShutdownThrift shbsd,
                                        4:shared.ServiceIsNotAvailableThrift sina),

   icshared.OrphanVolumeResponse listOrphanVolume(1:icshared.OrphanVolumeRequest request) throws (
                                                                                            1:shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                        2:shared.ServiceIsNotAvailableThrift sina),
     
   icshared.GetVolumeResponse getVolumeNotDeadByName(1:icshared.GetVolumeRequest request) throws (
      					1:shared.InternalErrorThrift ie,
      					2:shared.InvalidInputExceptionThrift iie,
      					3:shared.NotEnoughSpaceExceptionThrift nese,
      					4:shared.VolumeNotFoundExceptionThrift vnfe,
      					5:shared.ServiceHavingBeenShutdownThrift shbsd,
      					6:shared.ServiceIsNotAvailableThrift sina),

   icshared.ListArchivesResponseThrift listArchives(1:icshared.ListArchivesRequestThrift request) throws (
                        1:shared.ServiceHavingBeenShutdownThrift shbsd,
                        2:shared.ServiceIsNotAvailableThrift sina),

   icshared.ListArchivesAfterFilterResponseThrift ListArchivesAfterFilter(1:icshared.ListArchivesAfterFilterRequestThrift request)
                           throws (
                           1:shared.ServiceHavingBeenShutdownThrift shbsd,
                           2:shared.ServiceIsNotAvailableThrift sina),

   icshared.GetArchiveResponseThrift getArchive(1:icshared.GetArchiveRequestThrift request) throws (
                        1:shared.ServiceHavingBeenShutdownThrift shbsd,
                        2:shared.ServiceIsNotAvailableThrift sina),

   icshared.GetArchivesResponseThrift getArchives(1:icshared.GetArchivesRequestThrift request) throws (
                        1:shared.ServiceHavingBeenShutdownThrift shbsd,
                        2:shared.ServiceIsNotAvailableThrift sina),
   icshared.GetDriversResponseThrift getDrivers(1: icshared.GetDriversRequestThrift request) throws (
                           1:shared.ServiceHavingBeenShutdownThrift shbsd,
                           2:shared.VolumeNotFoundExceptionThrift vnfe,
                           3:shared.ServiceIsNotAvailableThrift sina),

                        
   LoadVolumeResponse loadVolume(1:LoadVolumeRequest request) throws (
   						1:shared.LoadVolumeExceptionThrift lve),

   //********** StoragePool Qos end************/
   icshared.ReportDriverMetadataResponse reportDriverMetadata(1:icshared.ReportDriverMetadataRequest request) throws (1:shared.ServiceIsNotAvailableThrift sina),
   
    shared.ChangeDriverBoundVolumeResponse changeDriverBoundVolume(1:shared.ChangeDriverBoundVolumeRequest request) throws (
                                                                                                    1:shared.ServiceHavingBeenShutdownThrift shbsd,
   																									2:shared.ServiceIsNotAvailableThrift sina),

   shared.ListVolumeAccessRulesByVolumeIdsResponse listVolumeAccessRulesByVolumeIds(1:shared.ListVolumeAccessRulesByVolumeIdsRequest request) throws (
                               1:shared.ServiceIsNotAvailableThrift sina),

   shared.CancelDriversRulesResponse cancelDriversRules(1:shared.CancelDriversRulesRequest request) throws (
                               1:shared.ServiceHavingBeenShutdownThrift shbsd,
                               2:shared.ServiceIsNotAvailableThrift sina),

   shared.ListIscsiAccessRulesByDriverKeysResponse listIscsiAccessRulesByDriverKeys(1:shared.ListIscsiAccessRulesByDriverKeysRequest request) throws (
                               1:shared.ServiceIsNotAvailableThrift sina),


   ReportSegmentUnitCloneFailResponse reportCloneFailed(1:ReportSegmentUnitCloneFailRequest request) throws (
                                                                      1:shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                      2:shared.ServiceIsNotAvailableThrift sina,
                                                                      3:shared.VolumeNotFoundExceptionThrift vnf),

   RetrieveOneRebalanceTaskResponse retrieveOneRebalanceTask(1: RetrieveOneRebalanceTaskRequest request) throws (
                                                                      1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                      2: shared.ServiceIsNotAvailableThrift sina,
                                                                      3: NoNeedToRebalanceThrift nntr),

   bool discardRebalanceTask(1:i64 requestTaskId) throws (1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                          2: shared.ServiceIsNotAvailableThrift sina),

   ChangeVolumeStatusFromFixToUnavailableResponse changeVolumeStatusFromFixToUnavailable(1:ChangeVolumeStatusFromFixToUnavailableRequest request) throws(1:shared.InternalErrorThrift ie
                                                                                                                   2:shared.VolumeNotFoundExceptionThrift vnf,
                                                                                                                   3:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                                                                   4:shared.ServiceIsNotAvailableThrift sina),

   shared.ReportServerNodeInfoResponseThrift reportServerNodeInfo(1:shared.ReportServerNodeInfoRequestThrift request) throws(1:shared.ServiceIsNotAvailableThrift sin,
                                                                                        2:shared.ServiceHavingBeenShutdownThrift shbs),


   shared.TurnOffAllDiskLightByServerIdResponseThrift turnOffAllDiskLightByServerId(1:shared.TurnOffAllDiskLightByServerIdRequestThrift request) throws(1:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                                                                           2:shared.ServiceIsNotAvailableThrift sina),


   shared.GetIoLimitationResponseThrift getIoLimitationsInOneDriverContainer(1:shared.GetIoLimitationRequestThrift request) throws(1:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                                        2:shared.ServiceIsNotAvailableThrift sina),

   GetServerNodeByIpResponse getServerNodeByIp(1:GetServerNodeByIpRequest request) throws(1:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                                           2:shared.ServiceIsNotAvailableThrift sina),

   PingPeriodicallyResponse pingPeriodically(1:PingPeriodicallyRequest request) throws(1:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                                        2:shared.ServiceIsNotAvailableThrift sina),

icshared.CreateAccessRuleOnNewVolumeResponse createAccessRuleOnNewVolume(1:icshared.CreateAccessRuleOnNewVolumeRequest request) throws ( 1:shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                                                                         2:shared.ServiceIsNotAvailableThrift sina,
                                                                                                                                         3:shared.InvalidInputExceptionThrift iie,
                                                                                                                                         4:shared.VolumeNotFoundExceptionThrift vnfe,
                                                                                                                                         5:shared.VolumeNameExistedExceptionThrift vnee),
icshared.DeleteAccessRuleOnOldVolumeResponse deleteAccessRuleOnOldVolume(1:icshared.DeleteAccessRuleOnOldVolumeRequest request) throws ( 1:shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                                                                         2:shared.ServiceIsNotAvailableThrift sina,
                                                                                                                                         3:shared.InvalidInputExceptionThrift iie,
                                                                                                                                         4:shared.VolumeNotFoundExceptionThrift vnfe,
                                                                                                                                         5:shared.VolumeNameExistedExceptionThrift vnee),

/** for other ***/
   // Store the create volume request and a job will pick up the request and fulfill the request asynchronously
    icshared.CreateVolumeResponse createVolume(1:icshared.CreateVolumeRequest request) throws (
                        1:shared.NotEnoughSpaceExceptionThrift nese,
                        2:shared.NetworkErrorExceptionThrift nme,
                        3:shared.InvalidInputExceptionThrift iie,
                        4:shared.AccessDeniedExceptionThrift ade,
                        5:shared.ServiceHavingBeenShutdownThrift shbsd,
                        6:shared.VolumeSizeNotMultipleOfSegmentSizeThrift vsnmogss,
                        7:shared.VolumeExistingExceptionThrift vee,
                        8:shared.VolumeNameExistedExceptionThrift vnee,
                        9:shared.BadLicenseTokenExceptionThrift blte,
                        10:shared.UselessLicenseExceptionThrift ule,
                        11:shared.NotEnoughLicenseTokenExceptionThrift nelte,
                        12:shared.ServiceIsNotAvailableThrift sina,
                        13:shared.StoragePoolNotExistInDoaminExceptionThrift sneide,
                        14:shared.DomainNotExistedExceptionThrift dnee,
                        15:shared.StoragePoolNotExistedExceptionThrift spnee,
                        16:shared.DomainIsDeletingExceptionThrift dide,
                        17:shared.StoragePoolIsDeletingExceptionThrift spide,
                        18:shared.NotEnoughGroupExceptionThrift nege,
                        19:shared.PermissionNotGrantExceptionThrift png,
                        20:shared.AccountNotFoundExceptionThrift anf,
                        21:shared.EndPointNotFoundExceptionThrift epnf,
                        22:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                        23:shared.LicenseExceptionThrift le,
                        24:shared.VolumeNotFoundExceptionThrift vnfe,
                        25:shared.NotEnoughNormalGroupExceptionThrift nenge),

   icshared.DeleteVolumeResponse deleteVolume(1:icshared.DeleteVolumeRequest request) throws (
                        1:shared.AccessDeniedExceptionThrift ade,
                        2:shared.NotEnoughSpaceExceptionThrift nese,
                        3:shared.VolumeNotFoundExceptionThrift vnfe,
                        4:shared.VolumeBeingDeletedExceptionThrift vbde,
                        5:shared.ServiceHavingBeenShutdownThrift shbsd,
                        6:shared.VolumeInExtendingExceptionThrift vee,
                        7:shared.LaunchedVolumeCannotBeDeletedExceptionThrift lvcbde,
                        8:shared.ServiceIsNotAvailableThrift sina,
                        9:shared.VolumeUnderOperationExceptionThrift vuoe,
                        10:shared.SnapshotRollingBackExceptionThrift srbe,
                        11:shared.DriverLaunchingExceptionThrift dle,
                        12:shared.DriverUnmountingExceptionThrift due,
                        13:shared.VolumeDeletingExceptionThrift vde,
                        14:shared.VolumeWasRollbackingExceptionThrift vwre,
                        15:shared.InvalidInputExceptionThrift iie,
                        16:shared.VolumeIsCloningExceptionThrift vic,
                        17:shared.ResourceNotExistsExceptionThrift rne,
                        18:shared.PermissionNotGrantExceptionThrift png,
                        19:shared.AccountNotFoundExceptionThrift anf,
                        20:shared.VolumeIsCopingExceptionThrift vice,
                        21:shared.ExistsDriverExceptionThrift ede,
                        22:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                        23:shared.NetworkErrorExceptionThrift nme,
                        24:shared.EndPointNotFoundExceptionThrift epnfe,
                        25:shared.VolumeInMoveOnlineDoNotHaveOperationExceptionThrift vimodnhoe,
                        26:shared.VolumeIsBeginMovedExceptionThrift vibme,
                        27:shared.VolumeIsMovingExceptionThrift vime),

      icshared.UpdateVolumeDescriptionResponse updateVolumeDescription(1:icshared.UpdateVolumeDescriptionRequest request) throws (
                           1:shared.AccessDeniedExceptionThrift ade,
                           2:shared.VolumeNotFoundExceptionThrift vnfe,
                           3:shared.VolumeBeingDeletedExceptionThrift vbde,
                           4:shared.ServiceHavingBeenShutdownThrift shbsd,
                           5:shared.ServiceIsNotAvailableThrift sina ),

      icshared.DeleteVolumeDelayResponse deleteVolumeDelay(1:icshared.DeleteVolumeDelayRequest request) throws (
                           1:shared.AccessDeniedExceptionThrift ade,
                           2:shared.VolumeNotFoundExceptionThrift vnfe,
                           3:shared.VolumeBeingDeletedExceptionThrift vbde,
                           4:shared.ServiceHavingBeenShutdownThrift shbsd,
                           5:shared.ServiceIsNotAvailableThrift sina ),

     icshared.StopDeleteVolumeDelayResponse stopDeleteVolumeDelay(1:icshared.StopDeleteVolumeDelayRequest request) throws (
                          1:shared.AccessDeniedExceptionThrift ade,
                          2:shared.VolumeNotFoundExceptionThrift vnfe,
                          3:shared.VolumeBeingDeletedExceptionThrift vbde,
                          4:shared.ServiceHavingBeenShutdownThrift shbsd,
                          5:shared.ServiceIsNotAvailableThrift sina ),

     icshared.StartDeleteVolumeDelayResponse startDeleteVolumeDelay(1:icshared.StartDeleteVolumeDelayRequest request) throws (
                        1:shared.AccessDeniedExceptionThrift ade,
                        2:shared.VolumeNotFoundExceptionThrift vnfe,
                        3:shared.VolumeBeingDeletedExceptionThrift vbde,
                        4:shared.ServiceHavingBeenShutdownThrift shbsd,
                        5:shared.ServiceIsNotAvailableThrift sina ),

     icshared.GetDeleteVolumeDelayResponse getDeleteVolumeDelay(1:icshared.GetDeleteVolumeDelayRequest request) throws (
                        1:shared.AccessDeniedExceptionThrift ade,
                        2:shared.VolumeNotFoundExceptionThrift vnfe,
                        3:shared.VolumeBeingDeletedExceptionThrift vbde,
                        4:shared.ServiceHavingBeenShutdownThrift shbsd,
                        5:shared.ServiceIsNotAvailableThrift sina ),

    icshared.CancelDeleteVolumeDelayResponse cancelDeleteVolumeDelay(1:icshared.CancelDeleteVolumeDelayRequest request) throws (
                         1:shared.AccessDeniedExceptionThrift ade,
                         2:shared.VolumeNotFoundExceptionThrift vnfe,
                         3:shared.ServiceHavingBeenShutdownThrift shbsd,
                         4:shared.ServiceIsNotAvailableThrift sina ),

     icshared.MoveVolumeToRecycleResponse moveVolumeToRecycle(1:icshared.MoveVolumeToRecycleRequest request) throws (
                          1:shared.AccessDeniedExceptionThrift ade,
                          3:shared.VolumeNotFoundExceptionThrift vnfe,
                          4:shared.VolumeBeingDeletedExceptionThrift vbde,
                          5:shared.ServiceHavingBeenShutdownThrift shbsd,
                          6:shared.VolumeInExtendingExceptionThrift vee,
                          7:shared.LaunchedVolumeCannotBeDeletedExceptionThrift lvcbde,
                          8:shared.ServiceIsNotAvailableThrift sina,
                          9:shared.DriverLaunchingExceptionThrift dle,
                          10:shared.DriverUnmountingExceptionThrift due,
                          11:shared.VolumeDeletingExceptionThrift vde,
                          12:shared.VolumeWasRollbackingExceptionThrift vwre,
                          13:shared.VolumeIsCloningExceptionThrift vic,
                          14:shared.PermissionNotGrantExceptionThrift png,
                          15:shared.AccountNotFoundExceptionThrift anf,
                          16:shared.VolumeIsCopingExceptionThrift vice,
                          17:shared.NetworkErrorExceptionThrift nme,
                          18:shared.VolumeInMoveOnlineDoNotHaveOperationExceptionThrift vimodnhoe,
                          19:shared.VolumeIsBeginMovedExceptionThrift vibme,
                          20:shared.VolumeIsMovingExceptionThrift vime),

     icshared.ListRecycleVolumeInfoResponse listRecycleVolumeInfo(1:icshared.ListRecycleVolumeInfoRequest request) throws (
                          1:shared.AccessDeniedExceptionThrift ade,
                          2:shared.ServiceHavingBeenShutdownThrift shbsd,
                          3:shared.ServiceIsNotAvailableThrift sina ),

   icshared.RecycleVolumeToNormalResponse recycleVolumeToNormal(1:icshared.RecycleVolumeToNormalRequest request) throws (
                        1:shared.AccessDeniedExceptionThrift ade,
                        2:shared.VolumeNotFoundExceptionThrift vnfe,
                        3:shared.VolumeBeingDeletedExceptionThrift vbde,
                        4:shared.ServiceHavingBeenShutdownThrift shbsd,
                        5:shared.ServiceIsNotAvailableThrift sina ),

   CreateSegmentUnitResponse createSegmentUnit(1:CreateSegmentUnitRequest request) throws (
                        1:shared.NotEnoughSpaceExceptionThrift nese,
                        2:shared.SegmentExistingExceptionThrift seet,
                        3:shared.SegmentUnitBeingDeletedExceptionThrift sbet,
                        4:shared.NoMemberExceptionThrift nmet,
                        5:shared.ServiceHavingBeenShutdownThrift shbsd,
                        6:shared.InternalErrorThrift ie,
                        7:shared.ServiceIsNotAvailableThrift sina),


   shared.LaunchDriverResponseThrift launchDriver(1:shared.LaunchDriverRequestThrift request) throws (1:shared.VolumeNotFoundExceptionThrift vnfe,
                                                                                              2:shared.VolumeNotAvailableExceptionThrift vane,
                                                                                              3:shared.TooManyDriversExceptionThrift tmde,
                                                                                              4:shared.NotRootVolumeExceptionThrift nrve,
                                                                                              5:shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                              6:shared.VolumeBeingDeletedExceptionThrift vbde,
                                                                                              7:shared.DriverTypeConflictExceptionThrift dtce,
                                                                                              8:shared.AccessDeniedExceptionThrift ade,
                                                                                              9:shared.InvalidInputExceptionThrift iie,
                                                                                              10:shared.ServiceIsNotAvailableThrift sina,
                                                                                              11:shared.VolumeUnderOperationExceptionThrift vuoe,
                                                                                              12:shared.SnapshotRollingBackExceptionThrift srbe,
                                                                                              13:shared.DriverLaunchingExceptionThrift dle,
                                                                                              14:shared.DriverUnmountingExceptionThrift due,
                                                                                              15:shared.VolumeDeletingExceptionThrift vde,
                                                                                              16:shared.VolumeWasRollbackingExceptionThrift vwre,
                                                                                              17:shared.SystemMemoryIsNotEnoughThrift smie,
                                                                                              18:shared.DriverAmountAndHostNotFitThrift dahn,
                                                                                              19:shared.DriverHostCannotUseThrift dhcu,
                                                                                              20:shared.DriverIsUpgradingExceptionThrift diu,
                                                                                              21:shared.PermissionNotGrantExceptionThrift png,
                                                                                              22:shared.AccountNotFoundExceptionThrift anf,
                                                                                              23:shared.DriverTypeIsConflictExceptionThrift dtic,
                                                                                              24:shared.DriverNameExistsExceptionThrift dneet,
                                                                                              25:shared.ExistsDriverExceptionThrift ed,
                                                                                              26:shared.VolumeLaunchMultiDriversExceptionThrift vlmd,
                                                                                              27:shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                              28:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                              29:shared.NetworkErrorExceptionThrift nme,
                                                                                              30:shared.VolumeInMoveOnlineDoNotHaveOperationExceptionThrift vimodnhoe,
                                                                                              31:shared.SystemCpuIsNotEnoughThrift scine,
                                                                                              32:shared.UnknownIpv4HostExceptionThrift ui4he,
                                                                                              33:shared.UnknownIpv6HostExceptionThrift ui6he,
                                                                                              34:shared.VolumeCanNotLaunchMultiDriversThisTimeExceptionThrift vcnlmdtte
                                                                                              ),

    shared.UmountDriverResponseThrift umountDriver(1:shared.UmountDriverRequestThrift request) throws (1:shared.VolumeNotFoundExceptionThrift vnfe,
                                                                                           2:shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                           3:shared.NoDriverLaunchExceptionThrift ndle
                                                                                           4:shared.ExistsClientExceptionThrift ece,
                                                                                           5:shared.DriverIsLaunchingExceptionThrift dile,
                                                                                           6:shared.AccessDeniedExceptionThrift ade,
                                                                                           7:shared.ServiceIsNotAvailableThrift sina,
                                                                                           8:shared.SnapshotRollingBackExceptionThrift srbe,
                                                                                           9:shared.DriverLaunchingExceptionThrift dle,
                                                                                           10:shared.DriverUnmountingExceptionThrift due,
                                                                                           11:shared.VolumeDeletingExceptionThrift vde,
                                                                                           12:shared.VolumeUnderOperationExceptionThrift vuoe,
                                                                                           13:shared.InvalidInputExceptionThrift iie,
                                                                                           14:shared.DriverIsUpgradingExceptionThrift diu,
                                                                                           15:shared.TransportExceptionThrift tet,
                                                                                           16:shared.DriverContainerIsIncExceptionThrift dcii,
                                                                                           17:shared.PermissionNotGrantExceptionThrift png,
                                                                                           18:shared.AccountNotFoundExceptionThrift anf,
                                                                                           19:shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                           20:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                           21:shared.NetworkErrorExceptionThrift nme,
                                                                                           22:shared.DriverStillReportExceptionThrift dsre),

    shared.GetPerformanceFromPyMetricsResponseThrift pullPerformanceFromPyMetrics(1:shared.GetPerformanceParameterRequestThrift request) throws (
                                                                                            1:shared.VolumeHasNotBeenLaunchedExceptionThrift vhnble,
                                                                                            2:shared.ReadPerformanceParameterFromFileExceptionThrift gppffe,
                                                                                            3:shared.ServiceIsNotAvailableThrift sina,
                                                                                            4:shared.ServiceHavingBeenShutdownThrift shbs),

   shared.GetStoragePerformanceFromPyMetricsResponseThrift pullStoragePerformanceFromPyMetrics(1:shared.GetStoragePerformanceParameterRequestThrift request) throws (
                               1:shared.VolumeHasNotBeenLaunchedExceptionThrift vhnble,
                               2:shared.ReadPerformanceParameterFromFileExceptionThrift gppffe,
                               3:shared.ServiceIsNotAvailableThrift sina,
                               4:shared.InvalidInputExceptionThrift iie,
                               5:shared.ServiceHavingBeenShutdownThrift shbs),

       shared.GetPerformanceResponseThrift pullPerformanceParameter(1:shared.GetPerformanceParameterRequestThrift request) throws (
                                  1:shared.VolumeHasNotBeenLaunchedExceptionThrift vhnble,
                                  2:shared.ReadPerformanceParameterFromFileExceptionThrift gppffe,
                                  3:shared.ServiceIsNotAvailableThrift sina,
                                  4:shared.ServiceHavingBeenShutdownThrift shbs),

    ExtendVolumeResponse extendVolume(1:ExtendVolumeRequest request) throws (
                               1:shared.NotEnoughSpaceExceptionThrift nese,
                               2:shared.EndPointNotFoundExceptionThrift epnfe,
                               3:shared.InvalidInputExceptionThrift iie,
                               4:shared.AccessDeniedExceptionThrift ade,
                               5:shared.ServiceHavingBeenShutdownThrift shbsd,
                               6:shared.VolumeSizeNotMultipleOfSegmentSizeThrift vsnmogss,
                               7:shared.RootVolumeBeingDeletedExceptionThrift rvde,
                               8:shared.RootVolumeNotFoundExceptionThrift rvnfe,
                               9:shared.ServiceIsNotAvailableThrift sina,
                               10:shared.VolumeWasRollbackingExceptionThrift vwre,
                               11:shared.NotEnoughGroupExceptionThrift nege,
                               12:shared.VolumeIsCloningExceptionThrift vic,
                               13:shared.PermissionNotGrantExceptionThrift png,
                               14:shared.AccountNotFoundExceptionThrift anf,
                               15:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                               16:shared.NetworkErrorExceptionThrift nme,
                               17:shared.DomainNotExistedExceptionThrift dnee,
                               18:shared.NotEnoughLicenseTokenExceptionThrift nelte,
                               19:shared.LicenseExceptionThrift le,
                               20:shared.UselessLicenseExceptionThrift ule,
                               21:shared.VolumeNotFoundExceptionThrift vnfe,
                               22:shared.BadLicenseTokenExceptionThrift blte,
                               23:shared.VolumeIsCopingExceptionThrift vice,
                               24:shared.VolumeExistingExceptionThrift vee,
                               25:shared.StoragePoolNotExistedExceptionThrift spnee,
                               26:shared.NotEnoughNormalGroupExceptionThrift agnfe,
                               27:shared.StoragePoolNotExistInDoaminExceptionThrift spnede,
                               28:shared.DomainIsDeletingExceptionThrift dide,
                               29:shared.StoragePoolIsDeletingExceptionThrift spide,
                               30:shared.VolumeInMoveOnlineDoNotHaveOperationExceptionThrift vimodnhoe,
                               31:shared.VolumeNotAvailableExceptionThrift vnae,
                               32:shared.VolumeOriginalSizeNotMatchExceptionThrift veede
                               ),

    shared.ApplyVolumeAccessRulesResponse applyVolumeAccessRules(1:shared.ApplyVolumeAccessRulesRequest request) throws (1: shared.VolumeNotFoundExceptionThrift vnfe,
                                                                                                                           2: shared.VolumeBeingDeletedExceptionThrift vbde,
                                                                                                                           3: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                                                           4: FailedToTellDriverAboutAccessRulesExceptionThrift fttdaare,
                                                                                                                           5:shared.ServiceIsNotAvailableThrift sina,
                                                                                                                           6: shared.ApplyFailedDueToVolumeIsReadOnlyExceptionThrift afdtviro,
                                                                                                                           7:shared.PermissionNotGrantExceptionThrift png,
                                                                                                                           8:shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                                                           9:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                                                           10:shared.NetworkErrorExceptionThrift nme,
                                                                                                                           11:shared.AccessDeniedExceptionThrift ade,
                                                                                                                           12:shared.InvalidInputExceptionThrift iie
                                                                                                                           ),

    shared.CancelVolumeAccessRulesResponse cancelVolumeAccessRules(1:shared.CancelVolumeAccessRulesRequest request) throws (1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                                                            2: FailedToTellDriverAboutAccessRulesExceptionThrift fttdaare,
                                                                                                                            3:shared.ServiceIsNotAvailableThrift sina,
                                                                                                                            4:shared.AccessRuleNotAppliedThrift arna,
                                                                                                                            5:shared.PermissionNotGrantExceptionThrift png,
                                                                                                                            6:shared.AccountNotFoundExceptionThrift anfe,
                                                                                                                            7:shared.VolumeNotFoundExceptionThrift vnfe,
                                                                                                                            8:shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                                                            9:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                                                            10:shared.NetworkErrorExceptionThrift nme,
                                                                                                                            11:shared.AccessDeniedExceptionThrift ade,
                                                                                                                            12:shared.InvalidInputExceptionThrift iie
                                                                                                                            ),

   shared.ApplyVolumeAccessRuleOnVolumesResponse applyVolumeAccessRuleOnVolumes(1:shared.ApplyVolumeAccessRuleOnVolumesRequest request) throws (
                               1:shared.VolumeNotFoundExceptionThrift vnfe,
                               2:shared.VolumeBeingDeletedExceptionThrift vbde,
                               3:shared.ServiceHavingBeenShutdownThrift shbsd,
                               4:shared.ServiceIsNotAvailableThrift sina,
                               5:shared.ApplyFailedDueToVolumeIsReadOnlyExceptionThrift afdtviro,
                               6:shared.AccessRuleUnderOperationThrift aruot,
                               7:shared.AccessRuleNotFoundThrift arnft
                               8:shared.PermissionNotGrantExceptionThrift png,
                               9:shared.AccountNotFoundExceptionThrift anf,
                               10:shared.EndPointNotFoundExceptionThrift epnfe,
                               11:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                               12:shared.NetworkErrorExceptionThrift nme),

   shared.CancelVolAccessRuleAllAppliedResponse cancelVolAccessRuleAllApplied(1:shared.CancelVolAccessRuleAllAppliedRequest request) throws (
                               1:shared.ServiceHavingBeenShutdownThrift shbsd,
                               2:shared.ServiceIsNotAvailableThrift sina,
                               3:shared.AccessRuleNotAppliedThrift arna,
                               4:shared.AccessRuleUnderOperationThrift aruot,
                               5:shared.AccessRuleNotFoundThrift arnft,
                               6:shared.PermissionNotGrantExceptionThrift png,
                               7:shared.AccountNotFoundExceptionThrift anf,
                               8:shared.EndPointNotFoundExceptionThrift epnfe,
                               9:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                               10:shared.NetworkErrorExceptionThrift nme),

    shared.DeleteVolumeAccessRulesResponse deleteVolumeAccessRules(1:shared.DeleteVolumeAccessRulesRequest request) throws (1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                                                            2: FailedToTellDriverAboutAccessRulesExceptionThrift fttdaare,
                                                                                                                            3:shared.ServiceIsNotAvailableThrift sina,
                                                                                                                            4:shared.PermissionNotGrantExceptionThrift png,
                                                                                                                            5:shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                                                            6:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                                                            7:shared.NetworkErrorExceptionThrift nme),

    shared.ListVolumeAccessRulesResponse listVolumeAccessRules(1:shared.ListVolumeAccessRulesRequest request) throws (1: shared.ServiceIsNotAvailableThrift sina,
                                                                                                                      2: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                                                      3:shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                                                      4:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                                                      5:shared.NetworkErrorExceptionThrift nme),

  icshared.ListAllDriversResponse listAllDrivers(1:icshared.ListAllDriversRequest request) throws (1: shared.ServiceIsNotAvailableThrift sina,
                                                                                                   2: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                                   3: shared.ParametersIsErrorExceptionThrift piee,
                                                                                                   4: shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                                   5: shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                                   6: shared.NetworkErrorExceptionThrift nme),

 icshared.ListDriverClientInfoResponse listDriverClientInfo(1:icshared.ListDriverClientInfoRequest request) throws (1: shared.ServiceIsNotAvailableThrift sina,
                                                                                                  2: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                                  3: shared.ParametersIsErrorExceptionThrift piee),

  shared.GetVolumeAccessRulesResponse getVolumeAccessRules(1:shared.GetVolumeAccessRulesRequest request) throws (1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                                                 2: shared.ServiceIsNotAvailableThrift sina,
                                                                                                                 3: shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                                                 4: shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                                                 5: shared.NetworkErrorExceptionThrift nme),

  shared.CreateVolumeAccessRulesResponse createVolumeAccessRules(1:shared.CreateVolumeAccessRulesRequest request) throws (
                        1:shared.VolumeAccessRuleDuplicateThrift vard,
                        2:shared.InvalidInputExceptionThrift iie,
                        3:shared.ServiceHavingBeenShutdownThrift shbsd,
                        4:shared.ServiceIsNotAvailableThrift sina,
                        5:shared.PermissionNotGrantExceptionThrift png,
                        6: shared.EndPointNotFoundExceptionThrift epnfe,
                        7: shared.TooManyEndPointFoundExceptionThrift tmepfe,
                        8: shared.NetworkErrorExceptionThrift nme,
                        9: shared.AccountNotFoundExceptionThrift anfe
                        ),

  shared.GetAppliedVolumesResponse getAppliedVolumes(1: shared.GetAppliedVolumesRequest request) throws (1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                                            2:shared.ServiceIsNotAvailableThrift sina,
                                                                                                            3:shared.PermissionNotGrantExceptionThrift png,
                                                                                                            4: shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                                            5: shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                                            6: shared.NetworkErrorExceptionThrift nme)
/* iscsi access rules */
  shared.ApplyIscsiAccessRulesResponse applyIscsiAccessRules(1:shared.ApplyIscsiAccessRulesRequest request) throws (1: shared.IscsiNotFoundExceptionThrift vnfe,
                                                                                                                      2: shared.IscsiBeingDeletedExceptionThrift vbde,
                                                                                                                      3: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                                                      4: FailedToTellDriverAboutAccessRulesExceptionThrift fttdaare,
                                                                                                                      5: shared.ServiceIsNotAvailableThrift sina,
                                                                                                                      6: shared.ApplyFailedDueToConflictExceptionThrift afdtviro,
                                                                                                                      7: shared.PermissionNotGrantExceptionThrift png,
                                                                                                                      8: shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                                                      9: shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                                                      10: shared.NetworkErrorExceptionThrift nme,
                                                                                                                      11: shared.AccountNotFoundExceptionThrift anfe,
                                                                                                                      12: shared.AccessDeniedExceptionThrift ade
                                                                                                                      ),

  shared.CancelIscsiAccessRulesResponse cancelIscsiAccessRules(1:shared.CancelIscsiAccessRulesRequest request) throws (1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                                                        2: FailedToTellDriverAboutAccessRulesExceptionThrift fttdaare,
                                                                                                                        3: shared.ServiceIsNotAvailableThrift sina,
                                                                                                                        4: shared.AccessRuleNotAppliedThrift arna,
                                                                                                                        5:shared.PermissionNotGrantExceptionThrift png,
                                                                                                                        6: shared.AccountNotFoundExceptionThrift anfe,
                                                                                                                        7: shared.AccessDeniedExceptionThrift ade,
                                                                                                                        8: shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                                                        9: shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                                                        10: shared.NetworkErrorExceptionThrift nme
                                                                                                                        ),

  shared.ApplyIscsiAccessRuleOnIscsisResponse applyIscsiAccessRuleOnIscsis(1:shared.ApplyIscsiAccessRuleOnIscsisRequest request) throws (
                               1:shared.IscsiNotFoundExceptionThrift vnfe,
                               2:shared.IscsiBeingDeletedExceptionThrift vbde,
                               3:shared.ServiceHavingBeenShutdownThrift shbsd,
                               4:shared.ServiceIsNotAvailableThrift sina,
                               5:shared.ApplyFailedDueToConflictExceptionThrift afdtviro,
                               6:shared.IscsiAccessRuleUnderOperationThrift iaruo,
                               7:shared.IscsiAccessRuleNotFoundThrift iarnf,
                               8: shared.EndPointNotFoundExceptionThrift epnfe,
                               9: shared.TooManyEndPointFoundExceptionThrift tmepfe,
                               10: shared.NetworkErrorExceptionThrift nme
                                ),

  shared.CancelIscsiAccessRuleAllAppliedResponse cancelIscsiAccessRuleAllApplied(1:shared.CancelIscsiAccessRuleAllAppliedRequest request) throws (
                               1:shared.ServiceHavingBeenShutdownThrift shbsd,
                               2:shared.ServiceIsNotAvailableThrift sina,
                               3:shared.AccessRuleNotAppliedThrift arna,
                               4:shared.IscsiAccessRuleUnderOperationThrift iaruo,
                               5:shared.IscsiAccessRuleNotFoundThrift iarnf,
                               6: shared.EndPointNotFoundExceptionThrift epnfe,
                               7: shared.TooManyEndPointFoundExceptionThrift tmepfe,
                               8: shared.NetworkErrorExceptionThrift nme
                               ),

  shared.DeleteIscsiAccessRulesResponse deleteIscsiAccessRules(1:shared.DeleteIscsiAccessRulesRequest request) throws (1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                                                         2: FailedToTellDriverAboutAccessRulesExceptionThrift fttdaare,
                                                                                                                         3: shared.ServiceIsNotAvailableThrift sina,
                                                                                                                         4:shared.PermissionNotGrantExceptionThrift png,
                                                                                                                         5:shared.AccountNotFoundExceptionThrift anfe,
                                                                                                                         6: shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                                                         7: shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                                                         8: shared.NetworkErrorExceptionThrift nee
                                                                                                                         ),

  shared.ListIscsiAccessRulesResponse listIscsiAccessRules(1:shared.ListIscsiAccessRulesRequest request) throws (1: shared.ServiceIsNotAvailableThrift sina,
                                                                                                                 2: shared.ServiceHavingBeenShutdownThrift shbs,
                                                                                                                 3: shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                                                 4: shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                                                 5: shared.NetworkErrorExceptionThrift nee
                                                                                                                ),

  shared.GetIscsiAccessRulesResponse getIscsiAccessRules(1:shared.GetIscsiAccessRulesRequest request) throws (1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                                              2: shared.ServiceIsNotAvailableThrift sina,
                                                                                                              3: shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                                              4: shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                                              5: shared.NetworkErrorExceptionThrift nee
                                                                                                              ),
  shared.ReportIscsiAccessRulesResponse reportIscsiAccessRules(1:shared.ReportIscsiAccessRulesRequest request) throws (1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                                                ),

  shared.GetAppliedIscsisResponse getAppliedIscsis(1: shared.GetAppliedIscsisRequest request) throws (1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                                      2: shared.ServiceIsNotAvailableThrift sina,
                                                                                                      3: shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                                      4: shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                                      5: shared.NetworkErrorExceptionThrift nee
                                                                                                      ),

  shared.CreateIscsiAccessRulesResponse createIscsiAccessRules(1:shared.CreateIscsiAccessRulesRequest request) throws (
                                    1:shared.IscsiAccessRuleDuplicateThrift vard,
                                    2:shared.IscsiAccessRuleFormatErrorThrift iarft,
                                    3:shared.InvalidInputExceptionThrift iie,
                                    4:shared.ServiceHavingBeenShutdownThrift shbsd,
                                    5:shared.ServiceIsNotAvailableThrift sina,
                                    6:shared.PermissionNotGrantExceptionThrift png,
                                    7:shared.ChapSameUserPasswdErrorThrift csur,
                                    8: shared.AccountNotFoundExceptionThrift anfe,
                                    9: shared.EndPointNotFoundExceptionThrift epnfe,
                                    10: shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                    11: shared.NetworkErrorExceptionThrift nee
                                    ),

  shared.OnlineDiskResponse onlineDisk(1:shared.OnlineDiskRequest request) throws (
                           1:shared.DiskNotFoundExceptionThrift dnfe,
                           2:shared.DiskHasBeenOnlineThrift dhble,
                           3:shared.ServiceHavingBeenShutdownThrift shbsd,
                           4:shared.AccessDeniedExceptionThrift ade,
                           5:shared.InternalErrorThrift ie,
                           6:shared.ServiceIsNotAvailableThrift sina,
                           7:shared.PermissionNotGrantExceptionThrift png,
                           8:shared.AccountNotFoundExceptionThrift anfe,
                           9:shared.NetworkErrorExceptionThrift nee
                           ),

  shared.OfflineDiskResponse offlineDisk(1:shared.OfflineDiskRequest request) throws (
                            1:shared.DiskNotFoundExceptionThrift dnfe,
                           2:shared.DiskHasBeenOfflineThrift dhbn,
                           3:shared.ServiceHavingBeenShutdownThrift shbsd,
                           4:shared.AccessDeniedExceptionThrift ade,
                           5:shared.DiskIsBusyThrift dbe,
                           6:shared.NetworkErrorExceptionThrift nee,
                           7:shared.ServiceIsNotAvailableThrift sina,
                           8:shared.PermissionNotGrantExceptionThrift png,
                           9:shared.AccountNotFoundExceptionThrift anfe
                           ),

    shared.SettleArchiveTypeResponse settleArchiveType(1:shared.SettleArchiveTypeRequest request) throws (
                            1:shared.DiskNotFoundExceptionThrift dnfe,
                            2:shared.DiskSizeCanNotSupportArchiveTypesThrift ds,
                            3:shared.ServiceHavingBeenShutdownThrift shbsd,
                            4:shared.ArchiveManagerNotSupportExceptionThrift atn,
                            5:shared.DiskHasBeenOfflineThrift dhbn,
                            6:shared.ServiceIsNotAvailableThrift sina,
                            7:shared.PermissionNotGrantExceptionThrift png,
                            8:shared.NetworkErrorExceptionThrift nee
                            ),

  shared.OnlineDiskResponse fixBrokenDisk(1:shared.OnlineDiskRequest request) throws (
                           1:shared.DiskNotFoundExceptionThrift dnfe,
                           2:shared.DiskNotBrokenThrift dnbe,
                           3:shared.ServiceHavingBeenShutdownThrift shbsd,
                           4:shared.AccessDeniedExceptionThrift ade,
                           5:shared.AccountNotFoundExceptionThrift anfe,
                           6: shared.ServiceIsNotAvailableThrift sina,
                           7:shared.PermissionNotGrantExceptionThrift png,
                            8:shared.NetworkErrorExceptionThrift nee
                           ),

  shared.OnlineDiskResponse fixConfigMismatchDisk(1:shared.OnlineDiskRequest request) throws (
                            1:shared.DiskNotFoundExceptionThrift dnfe,
                           2:shared.DiskNotMismatchConfigThrift dnbe,
                           3:shared.ServiceHavingBeenShutdownThrift shbsd,
                           4:shared.AccessDeniedExceptionThrift ade,
                           5:shared.AccountNotFoundExceptionThrift anfe,
                           6:shared.ServiceIsNotAvailableThrift sina,
                           7:shared.PermissionNotGrantExceptionThrift png,
                            8:shared.NetworkErrorExceptionThrift nee
                           ),

  shared.CreateDomainResponse createDomain(1:shared.CreateDomainRequest request) throws (1:shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                              2:shared.InvalidInputExceptionThrift iie,
                                                                                              3:shared.DomainExistedExceptionThrift dee,
                                                                                              4:shared.DomainNameExistedExceptionThrift dnee,
                                                                                              5:shared.ServiceIsNotAvailableThrift sina,
                                                                                              6:shared.DatanodeNotFreeToUseExceptionThrift dnfe,
                                                                                              7:shared.DatanodeNotFoundExceptionThrift dnnfe,
                                                                                              8:shared.DatanodeIsUsingExceptionThrift dniue,
                                                                                              9:shared.PermissionNotGrantExceptionThrift png,
                                                                                              10:shared.AccountNotFoundExceptionThrift anfe,
                                                                                              11:shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                              12:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                              13:shared.NetworkErrorExceptionThrift nee
                                                                                              ),

   shared.UpdateDomainResponse updateDomain(1:shared.UpdateDomainRequest request) throws (1:shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                              2:shared.InvalidInputExceptionThrift iie,
                                                                                              3:shared.ServiceIsNotAvailableThrift sina,
                                                                                              4:shared.DatanodeNotFreeToUseExceptionThrift dnfe,
                                                                                              5:shared.DatanodeNotFoundExceptionThrift dnnfe,
                                                                                              6:shared.DomainNotExistedExceptionThrift dhbde,
                                                                                              7:shared.DatanodeIsUsingExceptionThrift dniue,
                                                                                              8:shared.DomainIsDeletingExceptionThrift dide,
                                                                                              9:shared.PermissionNotGrantExceptionThrift png,
                                                                                              10:shared.AccountNotFoundExceptionThrift anfe,
                                                                                              11:shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                              12:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                              13:shared.NetworkErrorExceptionThrift nee,
                                                                                              14:shared.AccessDeniedExceptionThrift ade,
                                                                                              15:shared.InstanceIsSubHealthExceptionThrift ish
                                                                                              ),

   shared.RemoveDatanodeFromDomainResponse removeDatanodeFromDomain(1:shared.RemoveDatanodeFromDomainRequest request) throws (1:shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                              2:shared.InvalidInputExceptionThrift iie,
                                                                                              3:shared.ServiceIsNotAvailableThrift sina,
                                                                                              4:shared.FailToRemoveDatanodeFromDomainExceptionThrift frdfde,
                                                                                              5:shared.DatanodeNotFoundExceptionThrift dnnfe,
                                                                                              6:shared.DomainNotExistedExceptionThrift dhbde,
                                                                                              7:shared.DomainIsDeletingExceptionThrift dide,
                                                                                              8:shared.PermissionNotGrantExceptionThrift png,
                                                                                              9:shared.AccessDeniedExceptionThrift ade,
                                                                                              10:shared.AccountNotFoundExceptionThrift anfe,
                                                                                              11:shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                              12:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                              13:shared.NetworkErrorExceptionThrift nee
                                                                                              ),

   shared.DeleteDomainResponse deleteDomain(1:shared.DeleteDomainRequest request) throws (1:shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                            2:shared.InvalidInputExceptionThrift iie,
                                                                            3:shared.DomainNotExistedExceptionThrift dhbde,
                                                                            4:shared.ServiceIsNotAvailableThrift sina,
                                                                            5:shared.StillHaveStoragePoolExceptionThrift shspe,
                                                                            6:shared.DomainIsDeletingExceptionThrift dide,
                                                                            7:shared.ResourceNotExistsExceptionThrift rne,
                                                                            8:shared.PermissionNotGrantExceptionThrift png,
                                                                            9:shared.AccessDeniedExceptionThrift ade,
                                                                            10:shared.AccountNotFoundExceptionThrift anfe,
                                                                            11:shared.EndPointNotFoundExceptionThrift epnfe,
                                                                            12:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                            13:shared.NetworkErrorExceptionThrift nee
                                                                            ),

   shared.ListDomainResponse listDomains(1:shared.ListDomainRequest request) throws (1:shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                      2:shared.InvalidInputExceptionThrift iie,
                                                                      3:shared.ServiceIsNotAvailableThrift sina,
                                                                      4:shared.EndPointNotFoundExceptionThrift epnfe,
                                                                      5:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                      6:shared.NetworkErrorExceptionThrift nee
                                                                      ),


   shared.CreateStoragePoolResponseThrift createStoragePool(1:shared.CreateStoragePoolRequestThrift request) throws (1:shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                              2:shared.InvalidInputExceptionThrift iie,
                                                                                              3:shared.StoragePoolExistedExceptionThrift see,
                                                                                              4:shared.StoragePoolNameExistedExceptionThrift snee,
                                                                                              5:shared.ServiceIsNotAvailableThrift sina,
                                                                                              6:shared.ArchiveNotFreeToUseExceptionThrift anftue,
                                                                                              7:shared.ArchiveNotFoundExceptionThrift anfex,
                                                                                              8:shared.DomainNotExistedExceptionThrift dnee,
                                                                                              9:shared.ArchiveIsUsingExceptionThrift aiue,
                                                                                              10:shared.DomainIsDeletingExceptionThrift dide,
                                                                                              11:shared.PermissionNotGrantExceptionThrift png,
                                                                                              12:shared.AccessDeniedExceptionThrift ade,
                                                                                              13:shared.AccountNotFoundExceptionThrift anfe,
                                                                                              14:shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                              15:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                              16:shared.NetworkErrorExceptionThrift nee
                                                                                              ),

   shared.UpdateStoragePoolResponseThrift updateStoragePool(1:shared.UpdateStoragePoolRequestThrift request) throws (1:shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                              2:shared.InvalidInputExceptionThrift iie,
                                                                                              3:shared.ServiceIsNotAvailableThrift sina,
                                                                                              4:shared.ArchiveNotFreeToUseExceptionThrift anftue,
                                                                                              5:shared.ArchiveNotFoundExceptionThrift anfex,
                                                                                              6:shared.StoragePoolNotExistedExceptionThrift spnee,
                                                                                              7:shared.DomainNotExistedExceptionThrift dnee,
                                                                                              8:shared.ArchiveIsUsingExceptionThrift aiue,
                                                                                              9:shared.StoragePoolIsDeletingExceptionThrift spide,
                                                                                              10:shared.PermissionNotGrantExceptionThrift png,
                                                                                              11:shared.AccessDeniedExceptionThrift ade,
                                                                                              12:shared.AccountNotFoundExceptionThrift anfe,
                                                                                              13:shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                              14:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                              15:shared.NetworkErrorExceptionThrift nee,
                                                                                              16:shared.StoragePoolNameExistedExceptionThrift spnee2
                                                                                              ),

   shared.RemoveArchiveFromStoragePoolResponseThrift removeArchiveFromStoragePool(1:shared.RemoveArchiveFromStoragePoolRequestThrift request) throws (
                                                                                                1:shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                              2:shared.InvalidInputExceptionThrift iie,
                                                                                              3:shared.ServiceIsNotAvailableThrift sina,
                                                                                              4:shared.FailToRemoveArchiveFromStoragePoolExceptionThrift frafse,
                                                                                              5:shared.ArchiveNotFoundExceptionThrift anfe,
                                                                                              6:shared.StoragePoolNotExistedExceptionThrift spnee,
                                                                                              7:shared.DomainNotExistedExceptionThrift dnee,
                                                                                              8:shared.StoragePoolIsDeletingExceptionThrift spide,
                                                                                              9:shared.PermissionNotGrantExceptionThrift png,
                                                                                              10:shared.AccessDeniedExceptionThrift ade,
                                                                                              11:shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                              12:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                              13:shared.NetworkErrorExceptionThrift nee
                                                                                              ),

   shared.DeleteStoragePoolResponseThrift deleteStoragePool(1:shared.DeleteStoragePoolRequestThrift request) throws (1:shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                            2:shared.InvalidInputExceptionThrift iie,
                                                                            3:shared.StoragePoolNotExistedExceptionThrift spnee,
                                                                            4:shared.ServiceIsNotAvailableThrift sina,
                                                                            5:shared.StillHaveVolumeExceptionThrift shve,
                                                                            6:shared.DomainNotExistedExceptionThrift dnee,
                                                                            7:shared.StoragePoolIsDeletingExceptionThrift spide,
                                                                            8:shared.ResourceNotExistsExceptionThrift rne,
                                                                            9:shared.PermissionNotGrantExceptionThrift png,
                                                                              10:shared.AccessDeniedExceptionThrift ade,
                                                                              11:shared.AccountNotFoundExceptionThrift anfe,
                                                                              12:shared.EndPointNotFoundExceptionThrift epnfe,
                                                                              13:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                              14:shared.NetworkErrorExceptionThrift nee
                                                                            ),

   shared.ListStoragePoolResponseThrift listStoragePools(1:shared.ListStoragePoolRequestThrift request) throws (1:shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                      2:shared.InvalidInputExceptionThrift iie,
                                                                      3:shared.ServiceIsNotAvailableThrift sina,
                                                                      4:shared.AccountNotFoundExceptionThrift anfe,
                                                                      5:shared.EndPointNotFoundExceptionThrift epnfe,
                                                                      6:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                      7:shared.NetworkErrorExceptionThrift nee,
                                                                      8:shared.ResourceNotExistsExceptionThrift rnee
                                                                      ),



   shared.GetCapacityRecordResponseThrift getCapacityRecord(1: shared.GetCapacityRecordRequestThrift request) throws (
                                                                      1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                      2: shared.ServiceIsNotAvailableThrift sina),
   shared.ListStoragePoolCapacityResponseThrift listStoragePoolCapacity(1:shared.ListStoragePoolCapacityRequestThrift request) throws (
                                                                      1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                      2: shared.ServiceIsNotAvailableThrift sina,
                                                                      3: shared.InvalidInputExceptionThrift iie),


  shared.ListIscsiAppliedAccessRulesResponseThrift listIscsiAppliedAccessRules(1:shared.ListIscsiAppliedAccessRulesRequestThrift request) throws(1:shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                                2: shared.ServiceIsNotAvailableThrift sina,
                                                                                                3: shared.DriverContainerIsIncExceptionThrift diit,
                                                                                                4: shared.NetworkErrorExceptionThrift nee
                                                                                                ),

   icshared.ListVolumesResponse listVolumes(1:icshared.ListVolumesRequest request) throws (
                            1:shared.AccessDeniedExceptionThrift ade,
                            2:shared.ResourceNotExistsExceptionThrift rnee,
                            3:shared.InvalidInputExceptionThrift iie,
                            4:shared.ServiceHavingBeenShutdownThrift shbsd,
                            5:shared.VolumeNotFoundExceptionThrift vnfe,
                            6:shared.ServiceIsNotAvailableThrift sina,
                            7:shared.AccountNotFoundExceptionThrift anf,
                            8:shared.EndPointNotFoundExceptionThrift epnfe,
                            9:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                            10:shared.NetworkErrorExceptionThrift nee
         					),

   icshared.GetVolumeResponse getVolume(1:icshared.GetVolumeRequest request) throws (
                          1:shared.AccessDeniedExceptionThrift ade,
                          2:shared.AccountNotFoundExceptionThrift anfe,
                          3:shared.InvalidInputExceptionThrift iie,
                          4:shared.NotEnoughSpaceExceptionThrift nese,
                          5:shared.VolumeNotFoundExceptionThrift vnfe,
                          6:shared.ServiceHavingBeenShutdownThrift shbsd,
                          7:shared.ServiceIsNotAvailableThrift sina,
                          8:shared.PermissionNotGrantExceptionThrift png
                          ),

   shared.GetCapacityResponse getCapacity(1:shared.GetCapacityRequest request) throws (1:shared.StorageEmptyExceptionThrift see,
                                                                                           2:shared.ServiceIsNotAvailableThrift sina,
                                                                                          3:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                                          4:shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                          5:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                          6:shared.NetworkErrorExceptionThrift nee
                                                                                           ),

    ReportJustCreatedSegmentUnitResponse reportJustCreatedSegmentUnit(1: ReportJustCreatedSegmentUnitRequest request) throws (1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                                                2: shared.ServiceIsNotAvailableThrift sina),

    shared.CreateDefaultDomainAndStoragePoolResponseThrift createDefaultDomainAndStoragePool(1: shared.CreateDefaultDomainAndStoragePoolRequestThrift request) throws
                                                                                                           (1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                                           2: shared.ServiceIsNotAvailableThrift sina,
                                                                                                            3: shared.DatanodeNotFoundExceptionThrift dnfe,
                                                                                                            4: shared.NetworkErrorExceptionThrift nee,
                                                                                                            5: shared.DomainNameExistedExceptionThrift dnee,
                                                                                                            6: shared.DatanodeIsUsingExceptionThrift diue,
                                                                                                            7: shared.DatanodeNotFreeToUseExceptionThrift dnftue,
                                                                                                            8: shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                                            9: shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                                            10: shared.PermissionNotGrantExceptionThrift pnge,
                                                                                                            11: shared.InvalidInputExceptionThrift iie,
                                                                                                            12: shared.AccountNotFoundExceptionThrift anfe,
                                                                                                            13: shared.DomainExistedExceptionThrift dee,
                                                                                                            14: shared.DomainNotExistedExceptionThrift dnotee,
                                                                                                            15: shared.StoragePoolNameExistedExceptionThrift spnee,
                                                                                                            16: shared.ArchiveIsUsingExceptionThrift aiue,
                                                                                                            17: shared.ArchiveNotFoundExceptionThrift arnfe,
                                                                                                            18: shared.ArchiveNotFreeToUseExceptionThrift arnftue,
                                                                                                            19: shared.StoragePoolExistedExceptionThrift spee,
                                                                                                            20: shared.AccessDeniedExceptionThrift ade,
                                                                                                            21: shared.DomainIsDeletingExceptionThrift dide
                                                                                                           ),
    shared.ListOperationsResponse listOperations(1:shared.ListOperationsRequest request) throws (1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                                 2: shared.ServiceIsNotAvailableThrift sina,
                                                                                                 3: shared.OperationNotFoundExceptionThrift onf,
                                                                                                 4:shared.PermissionNotGrantExceptionThrift png
                                                                                                 ),

   icshared.RecycleVolumeResponse recycleVolume(1:icshared.RecycleVolumeRequest request) throws (
                        1:shared.AccessDeniedExceptionThrift ade,
                        2:shared.NotEnoughSpaceExceptionThrift nese,
                        3:shared.VolumeNotFoundExceptionThrift vnfe,
                        4:shared.VolumeCannotBeRecycledExceptionThrift vcbre,
                        5:shared.ServiceHavingBeenShutdownThrift shbsd,
                        6:shared.VolumeInExtendingExceptionThrift vee,
                        7:shared.ExistsDriverExceptionThrift ede,
                        8:shared.ServiceIsNotAvailableThrift sina,
                        9:shared.PermissionNotGrantExceptionThrift png,
                        10:shared.AccountNotFoundExceptionThrift anfe,
                        11:shared.VolumeWasRollbackingExceptionThrift vwre,
                         12:shared.EndPointNotFoundExceptionThrift enfe,
                         13:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                         14:shared.NetworkErrorExceptionThrift nee
                        ),

    shared.FixVolumeResponseThrift fixVolume(1:shared.FixVolumeRequestThrift request) throws (1:shared.AccountNotFoundExceptionThrift anfe,
                                                                                                2:shared.VolumeNotFoundExceptionThrift vnf,
                                                                                                3:shared.AccessDeniedExceptionThrift ad,
                                                                                                4:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                                                5:shared.ServiceIsNotAvailableThrift sina,
                                                                                                6:shared.PermissionNotGrantExceptionThrift png,
                                                                                                7:shared.EndPointNotFoundExceptionThrift enfe,
                                                                                                8:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                                9:shared.NetworkErrorExceptionThrift nee,
                                                                                                10:shared.VolumeInMoveOnlineDoNotHaveOperationExceptionThrift vimodnhoe
                                                                                                ),

    shared.ConfirmFixVolumeResponseThrift confirmFixVolume(1:shared.ConfirmFixVolumeRequestThrift request) throws (1:shared.InternalErrorThrift ie,
                                                                                                                     2:shared.VolumeNotFoundExceptionThrift vnf,
                                                                                                                     3:shared.AccessDeniedExceptionThrift ad,
                                                                                                                     4:shared.LackDatanodeExceptionThrift ld,
                                                                                                                     5:shared.NotEnoughSpaceExceptionThrift nes,
                                                                                                                     6:shared.InvalidInputExceptionThrift ii,
                                                                                                                     7:shared.ServiceIsNotAvailableThrift sin,
                                                                                                                     8:shared.VolumeFixingOperationExceptionThrift vfo,
                                                                                                                     9:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                                                                     10:shared.FrequentFixVolumeRequestThrift ffv,
                                                                                                                     11:shared.PermissionNotGrantExceptionThrift png,
                                                                                                                    12:shared.AccountNotFoundExceptionThrift anfe,
                                                                                                                    13:shared.EndPointNotFoundExceptionThrift enfe,
                                                                                                                    14:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                                                    15:shared.NetworkErrorExceptionThrift nee
                                                                                                                     ),

    MarkVolumesReadWriteResponse markVolumesReadWrite(1:MarkVolumesReadWriteRequest request) throws (1:shared.ServiceIsNotAvailableThrift sina,
                                                                                                     2:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                                                     3:shared.PermissionNotGrantExceptionThrift png,
                                                                                                    4:shared.AccountNotFoundExceptionThrift anfe,
                                                                                                    5:shared.VolumeNotFoundExceptionThrift vnfe,
                                                                                                    6:shared.EndPointNotFoundExceptionThrift enfe,
                                                                                                    7:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                                    8:shared.NetworkErrorExceptionThrift nee
                                                                                                     ),

    CheckVolumeIsReadOnlyResponse checkVolumeIsReadOnly(1:CheckVolumeIsReadOnlyRequest request) throws (1:shared.ServiceIsNotAvailableThrift sina,
                                                                                                        2:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                                                        3:shared.VolumeIsMarkWriteExceptionThrift vimw,
                                                                                                        4:shared.VolumeIsAppliedWriteAccessRuleExceptionThrift viawar,
                                                                                                        5:shared.VolumeIsConnectedByWritePermissionClientExceptionThrift vicbwpc,
                                                                                                        6:shared.PermissionNotGrantExceptionThrift png,
                                                                                                        7:shared.VolumeNotFoundExceptionThrift vnfe,
                                                                                                        8:shared.EndPointNotFoundExceptionThrift enfe,
                                                                                                        9:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                                        10:shared.NetworkErrorExceptionThrift nee
                                                                                                        ),

    shared.GetDriverConnectPermissionResponseThrift  getDriverConnectPermission(1:shared.GetDriverConnectPermissionRequestThrift request) throws (1:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                                                                                                    2:shared.ServiceIsNotAvailableThrift sina,
                                                                                                                                                    3:shared.NetworkErrorExceptionThrift nee
                                                                                                                                                   ),

    CreateRoleResponse createRole(1:CreateRoleRequest request) throws (1:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                     2:shared.ServiceIsNotAvailableThrift sina,
                                                                     3:CreateRoleNameExistedExceptionThrift crne,
                                                                     4:shared.PermissionNotGrantExceptionThrift png,
                                                                     5:shared.AccountNotFoundExceptionThrift anfe
                                                                     ),

    AssignRolesResponse assignRoles(1:AssignRolesRequest request) throws (1:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                        2:shared.ServiceIsNotAvailableThrift sina,
                                                                        3:shared.CrudSuperAdminAccountExceptionThrift crudSaa,
                                                                        4:shared.PermissionNotGrantExceptionThrift png,
                                                                        5:shared.AccountNotFoundExceptionThrift anfe
                                                                        ),

    UpdateRoleResponse updateRole(1:UpdateRoleRequest request) throws (1:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                     2:shared.ServiceIsNotAvailableThrift sina,
                                                                     3:shared.RoleNotExistedExceptionThrift rne,
                                                                     4:shared.CrudBuiltInRoleExceptionThrift crudBir,
                                                                     5:shared.PermissionNotGrantExceptionThrift png,
                                                                     6:shared.AccountNotFoundExceptionThrift anfe
                                                                     ),

    DeleteRolesResponse deleteRoles(1:DeleteRolesRequest request) throws (1:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                  2:shared.ServiceIsNotAvailableThrift sina,
                                                                  3:shared.DeleteRoleExceptionThrift dr,
                                                                  4:shared.PermissionNotGrantExceptionThrift png,
                                                                  5:shared.AccountNotFoundExceptionThrift anfe
                                                                  ),

    ListApisResponse listApis(1:ListApisRequest request) throws (1:shared.ServiceHavingBeenShutdownThrift shbs,
                                                               2:shared.ServiceIsNotAvailableThrift sina),

    ListRolesResponse listRoles(1:ListRolesRequest request) throws (1:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                  2:shared.ServiceIsNotAvailableThrift sina,
                                                                  3:shared.PermissionNotGrantExceptionThrift png,
                                                                  4:shared.AccountNotFoundExceptionThrift anfe
                                                                  ),

   shared.CreateAccountResponse createAccount(1:shared.CreateAccountRequest request) throws (
   						1:shared.AccessDeniedExceptionThrift ade,
      					2:shared.AccountNotFoundExceptionThrift anfe,
      					3:shared.InvalidInputExceptionThrift iie,
      					4:shared.AccountAlreadyExistsExceptionThrift uaee,
      					5:shared.ServiceHavingBeenShutdownThrift shbsd,
      					6:shared.ServiceIsNotAvailableThrift sina,
      					7:shared.PermissionNotGrantExceptionThrift png
      					),

   shared.DeleteAccountsResponse deleteAccounts(1:shared.DeleteAccountsRequest request) throws (
   						1:shared.AccessDeniedExceptionThrift ade,
      					2:shared.InvalidInputExceptionThrift iie,
      					3:shared.AccountNotFoundExceptionThrift unfe,
      					4:shared.ServiceHavingBeenShutdownThrift shbsd,
      					5:shared.ServiceIsNotAvailableThrift sina,
      					6:shared.DeleteLoginAccountExceptionThrift dla,
      					7:shared.PermissionNotGrantExceptionThrift png
      					),

   shared.UpdatePasswordResponse updatePassword(1:shared.UpdatePasswordRequest request) throws (
   						1:shared.OlderPasswordIncorrectExceptionThrift opie,
      					2:shared.InsufficientPrivilegeExceptionThrift ipe,
      					3:shared.InvalidInputExceptionThrift iie,
      					4:shared.AccountNotFoundExceptionThrift unfe,
      					5:shared.ServiceHavingBeenShutdownThrift shbsd,
      					6:shared.ServiceIsNotAvailableThrift sina),

   shared.ListAccountsResponse listAccounts(1:shared.ListAccountsRequest request) throws (
   						1:shared.AccessDeniedExceptionThrift ade,
      					2:shared.AccountNotFoundExceptionThrift anfe,
      					3:shared.InvalidInputExceptionThrift iie,
      					4:shared.ServiceHavingBeenShutdownThrift shbsd,
      					5:shared.ServiceIsNotAvailableThrift sina
      					),

   shared.AuthenticateAccountResponse authenticateAccount(1:shared.AuthenticateAccountRequest request) throws (
   						1:shared.AuthenticationFailedExceptionThrift afe,
      					2:shared.InvalidInputExceptionThrift iie,
      					3:shared.ServiceHavingBeenShutdownThrift shbsd,
      					4:shared.ServiceIsNotAvailableThrift sina),

   shared.ResetAccountPasswordResponse resetAccountPassword(1:shared.ResetAccountPasswordRequest request) throws (
   						1:shared.InvalidInputExceptionThrift iie,
	                    2:shared.AccessDeniedExceptionThrift ade,
	                    3:shared.AccountNotFoundExceptionThrift unfe,
	                    4:shared.ServiceHavingBeenShutdownThrift shbsd,
	                    5:shared.ServiceIsNotAvailableThrift sina,
	                    6:shared.PermissionNotGrantExceptionThrift png),

   shared.ListResourcesResponse listResources(1:shared.ListResourcesRequest request) throws (
	                    1:shared.ServiceHavingBeenShutdownThrift shbsd,
	                    2:shared.ServiceIsNotAvailableThrift sina,
	                    3:shared.PermissionNotGrantExceptionThrift png,
	                    4:shared.AccountNotFoundExceptionThrift anfe
	                    ),

   shared.AssignResourcesResponse assignResources(1:shared.AssignResourcesRequest request) throws (
	                    1:shared.ServiceHavingBeenShutdownThrift shbsd,
	                    2:shared.ServiceIsNotAvailableThrift sina,
	                    3:shared.PermissionNotGrantExceptionThrift png,
	                    4:shared.AccountNotFoundExceptionThrift anfe
	                    ),

    shared.DeleteServerNodesResponseThrift deleteServerNodes(1:shared.DeleteServerNodesRequestThrift request) throws(1:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                                                                    2:shared.ServiceIsNotAvailableThrift sina,
                                                                                                                    3:shared.ServerNodeIsUnknownThrift sniu,
                                                                                                                    4:shared.PermissionNotGrantExceptionThrift png,
                                                                                                                    5:shared.AccountNotFoundExceptionThrift anf),

    shared.UpdateServerNodeResponseThrift updateServerNode(1:shared.UpdateServerNodeRequestThrift request) throws(1:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                                                                    2:shared.ServiceIsNotAvailableThrift sina,
                                                                                                                    3:shared.PermissionNotGrantExceptionThrift png,
                                                                                                                    4:shared.AccountNotFoundExceptionThrift anf,
                                                                                                                    5:shared.ServerNodePositionIsRepeatExceptionThrift snpire),

    shared.ListServerNodesResponseThrift listServerNodes(1:shared.ListServerNodesRequestThrift request) throws(1:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                                                                 2:shared.ServiceIsNotAvailableThrift sina,
                                                                                                                 3:shared.PermissionNotGrantExceptionThrift png,
                                                                                                                 4:shared.AccountNotFoundExceptionThrift anf,
                                                                                                                 5:shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                                                 6:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                                                 7:shared.NetworkErrorExceptionThrift nee
                                                                                                                 ),

    shared.ListServerNodeByIdResponseThrift listServerNodeById(1:shared.ListServerNodeByIdRequestThrift request) throws(1:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                                                                     2:shared.ServiceIsNotAvailableThrift sina,
                                                                                                                    3:shared.EndPointNotFoundExceptionThrift epnfe,
                                                                                                                    4:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                                                                    5:shared.NetworkErrorExceptionThrift nee
                                                                                                                     ),

    LogoutResponse logout(1:LogoutRequest request) throws(1:shared.ServiceHavingBeenShutdownThrift shbs,
                                                          2:shared.ServiceIsNotAvailableThrift sina,
                                                          3:shared.AccountNotFoundExceptionThrift anf),

    InstanceMaintainResponse markInstanceMaintenance(1:InstanceMaintainRequest request) throws (
                                                                            1:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                            2:shared.ServiceIsNotAvailableThrift sina,
                                                                            3:shared.PermissionNotGrantExceptionThrift png,
                                                                            4:shared.AccountNotFoundExceptionThrift anf,
                                                                            5:shared.EndPointNotFoundExceptionThrift epnfe,
                                                                            6:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                            7:shared.NetworkErrorExceptionThrift nee
                                                                            ),

    CancelMaintenanceResponse cancelInstanceMaintenance(1:CancelMaintenanceRequest request) throws (
                                                                            1:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                            2:shared.ServiceIsNotAvailableThrift sina,
                                                                            3:shared.PermissionNotGrantExceptionThrift png,
                                                                            4:shared.AccountNotFoundExceptionThrift anf,
                                                                            5:shared.EndPointNotFoundExceptionThrift epnfe,
                                                                            6:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                                                            7:shared.NetworkErrorExceptionThrift nee
                                                                            ),

    ListInstanceMaintenancesResponse listInstanceMaintenances(1:ListInstanceMaintenancesRequest request) throws (
                                                                            1:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                            2:shared.ServiceIsNotAvailableThrift sina,
                                                                            3:shared.PermissionNotGrantExceptionThrift png,
                                                                            4:shared.AccountNotFoundExceptionThrift anf),

    SaveOperationLogsToCsvResponse saveOperationLogsToCsv(1:SaveOperationLogsToCsvRequest request) throws (
                                                                            1:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                            2:shared.ServiceIsNotAvailableThrift sina,
                                                                            3:shared.PermissionNotGrantExceptionThrift png,
                                                                            4:shared.AccountNotFoundExceptionThrift anf,
                                                                            5:shared.UnsupportedEncodingExceptionThrift usee
                                                                            ),
    //********** Driver Qos begin*****************/

    shared.ApplyIoLimitationsResponse applyIoLimitations(1:shared.ApplyIoLimitationsRequest request) throws (
                            1:shared.VolumeNotFoundExceptionThrift vnfe,
                            2:shared.VolumeBeingDeletedExceptionThrift vbde,
                            3:shared.ServiceHavingBeenShutdownThrift shbsd,
                            4:FailedToTellDriverAboutAccessRulesExceptionThrift fttdaare,
                            5:shared.ServiceIsNotAvailableThrift sina,
                            6:shared.ApplyFailedDueToVolumeIsReadOnlyExceptionThrift afdtviro,
                            7:shared.AccountNotFoundExceptionThrift anf,
                            8:shared.PermissionNotGrantExceptionThrift png,
                            9:shared.EndPointNotFoundExceptionThrift epnfe,
                            10:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                            11:shared.NetworkErrorExceptionThrift nee
                            ),

    shared.CancelIoLimitationsResponse cancelIoLimitations(1:shared.CancelIoLimitationsRequest request) throws (
                            1:shared.ServiceHavingBeenShutdownThrift shbsd,
                            2:FailedToTellDriverAboutAccessRulesExceptionThrift fttdaare,
                            3:shared.ServiceIsNotAvailableThrift sina,
                            4:shared.AccessRuleNotAppliedThrift arna,
                            5:shared.AccountNotFoundExceptionThrift anf,
                            6:shared.PermissionNotGrantExceptionThrift png,
                            7:shared.EndPointNotFoundExceptionThrift epnfe,
                            8:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                            9:shared.NetworkErrorExceptionThrift nee
                            ),
   shared.DeleteIoLimitationsResponse deleteIoLimitations(1:shared.DeleteIoLimitationsRequest request) throws (
                             1:shared.ServiceHavingBeenShutdownThrift shbsd,
                             2:FailedToTellDriverAboutAccessRulesExceptionThrift fttdaare,
                             3:shared.ServiceIsNotAvailableThrift sina,
                             4:shared.AccountNotFoundExceptionThrift anf,
                             5:shared.PermissionNotGrantExceptionThrift png,
                             6:shared.EndPointNotFoundExceptionThrift epnfe,
                             7:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                             8:shared.NetworkErrorExceptionThrift nee
                             ),


    shared.ListIoLimitationsResponse listIoLimitations(1:shared.ListIoLimitationsRequest request) throws (
                            1: shared.ServiceHavingBeenShutdownThrift shbsd,
                            2: shared.ServiceIsNotAvailableThrift sina,
                            3:shared.EndPointNotFoundExceptionThrift epnfe,
                            4:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                            5:shared.NetworkErrorExceptionThrift nee
                            ),

    shared.GetIoLimitationsResponse getIoLimitations(1:shared.GetIoLimitationsRequest request) throws (
                            1: shared.ServiceHavingBeenShutdownThrift shbsd,
                            2: shared.ServiceIsNotAvailableThrift sina,
                            3:shared.EndPointNotFoundExceptionThrift epnfe,
                            4:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                            5:shared.NetworkErrorExceptionThrift nee
                            ),

    shared.CreateIoLimitationsResponse createIoLimitations(1:shared.CreateIoLimitationsRequest request) throws (
                            1:shared.IoLimitationsDuplicateThrift vard,
                            2:shared.InvalidInputExceptionThrift iie,
                            3:shared.ServiceHavingBeenShutdownThrift shbsd,
                            4:shared.ServiceIsNotAvailableThrift sina,
                            5:shared.AccountNotFoundExceptionThrift anf,
                            6:shared.PermissionNotGrantExceptionThrift png,
                            7:shared.IoLimitationTimeInterLeavingThrift ioltil,
                            8:shared.EndPointNotFoundExceptionThrift epnfe,
                            9:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                            10:shared.NetworkErrorExceptionThrift nee
                            ),

    shared.UpdateIoLimitationsResponse updateIoLimitations(1:shared.UpdateIoLimitationRulesRequest request) throws (
                            1:shared.IoLimitationsDuplicateThrift vard,
                            2:shared.InvalidInputExceptionThrift iie,
                            3:shared.ServiceHavingBeenShutdownThrift shbsd,
                            4:shared.ServiceIsNotAvailableThrift sina,
                            5:shared.AccountNotFoundExceptionThrift anf,
                            6:shared.PermissionNotGrantExceptionThrift png,
                            7:shared.IoLimitationTimeInterLeavingThrift ioltil,
                            8:shared.EndPointNotFoundExceptionThrift epnfe,
                            9:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                            10:shared.NetworkErrorExceptionThrift nee
                            ),

    shared.GetIoLimitationAppliedDriversResponse getIoLimitationAppliedDrivers(1: shared.GetIoLimitationAppliedDriversRequest request) throws (
                            1: shared.ServiceHavingBeenShutdownThrift shbsd,
                            2:shared.ServiceIsNotAvailableThrift sina,
                            3:shared.PermissionNotGrantExceptionThrift png,
                            4:shared.EndPointNotFoundExceptionThrift epnfe,
                            5:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                            6:shared.NetworkErrorExceptionThrift nee
                            ),

    //********** Driver Qos end*****************/


    //********** StoragePool Qos begin************/

    shared.ApplyMigrationRulesResponse applyMigrationRules(1:shared.ApplyMigrationRulesRequest request) throws (
                            1: shared.VolumeNotFoundExceptionThrift vnfe,
                            2: shared.VolumeBeingDeletedExceptionThrift vbde,
                            3: shared.ServiceHavingBeenShutdownThrift shbsd,
                            4: FailedToTellDriverAboutAccessRulesExceptionThrift fttdaare,
                            5:shared.ServiceIsNotAvailableThrift sina,
                            6: shared.ApplyFailedDueToVolumeIsReadOnlyExceptionThrift afdtviro,
                            7:shared.AccountNotFoundExceptionThrift anf,
                            8:shared.PermissionNotGrantExceptionThrift png,
                            9:shared.EndPointNotFoundExceptionThrift epnfe,
                            10:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                            11:shared.NetworkErrorExceptionThrift nee
                            ),

    shared.CancelMigrationRulesResponse cancelMigrationRules(1:shared.CancelMigrationRulesRequest request) throws (
                            1:shared.ServiceHavingBeenShutdownThrift shbsd,
                            2:FailedToTellDriverAboutAccessRulesExceptionThrift fttdaare,
                            3:shared.ServiceIsNotAvailableThrift sina,
                            4:shared.AccessRuleNotAppliedThrift arna,
                            5:shared.AccountNotFoundExceptionThrift anf,
                            6:shared.PermissionNotGrantExceptionThrift png,
                            7:shared.EndPointNotFoundExceptionThrift epnfe,
                            8:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                            9:shared.NetworkErrorExceptionThrift nee
                            ),

    shared.ListMigrationRulesResponse listMigrationRules(1:shared.ListMigrationRulesRequest request) throws (
                            1: shared.ServiceIsNotAvailableThrift sina,
                            2:shared.ServiceHavingBeenShutdownThrift shbsd,
                            3:shared.EndPointNotFoundExceptionThrift epnfe,
                            4:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                            5:shared.NetworkErrorExceptionThrift nee
                            ),

    shared.GetMigrationRulesResponse getMigrationRules(1:shared.GetMigrationRulesRequest request) throws (
                            1: shared.ServiceHavingBeenShutdownThrift shbsd,
                            2: shared.ServiceIsNotAvailableThrift sina,
                            3:shared.EndPointNotFoundExceptionThrift epnfe,
                            4:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                            5:shared.NetworkErrorExceptionThrift nee
                            ),

    shared.GetAppliedStoragePoolsResponse getAppliedStoragePools(1: shared.GetAppliedStoragePoolsRequest request) throws (
                            1: shared.ServiceHavingBeenShutdownThrift shbsd,
                            2:shared.ServiceIsNotAvailableThrift sina,
                            3:shared.MigrationRuleNotExists mrne,
                            4:shared.EndPointNotFoundExceptionThrift epnfe,
                            5:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                            6:shared.NetworkErrorExceptionThrift nee
                            ),

    //********** StoragePool Qos end************/

    //********** iscsi chap control begin ********** /
    shared.SetIscsiChapControlResponseThrift  setIscsiChapControl(1:shared.SetIscsiChapControlRequestThrift request) throws (
                            1:shared.ServiceHavingBeenShutdownThrift shbsd,
                            2:shared.ServiceIsNotAvailableThrift sina,
                            3:shared.EndPointNotFoundExceptionThrift epnfe,
                            4:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                            5:shared.NetworkErrorExceptionThrift nee
                            ),
    //********** iscsi chap control end   ********** /

    icshared.GetLimitsResponse getLimits(1:icshared.GetLimitsRequest request) throws (
                            1:shared.DriverNotFoundExceptionThrift dnfe,
                            2:shared.ServiceIsNotAvailableThrift sina,
                            3:shared.ServiceHavingBeenShutdownThrift shbsd,
                            4:shared.EndPointNotFoundExceptionThrift epnfe,
                            5:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                            6:shared.NetworkErrorExceptionThrift nee
                            ),

    icshared.AddOrModifyIoLimitResponse addOrModifyIoLimit(1:icshared.AddOrModifyIoLimitRequest request) throws (
                            1:shared.DriverNotFoundExceptionThrift dnfe
                            2:shared.InvalidInputExceptionThrift iie,
                            3:shared.AlreadyExistStaticLimitationExceptionThrift aesle,
                            4:shared.ServiceIsNotAvailableThrift sina,
                            5:shared.PermissionNotGrantExceptionThrift png,
                            6:shared.AccessDeniedExceptionThrift ad,
                            7:shared.AccountNotFoundExceptionThrift anf,
                            8:shared.DynamicIoLimitationTimeInterleavingExceptionThrift diltie,
                            9:shared.ServiceHavingBeenShutdownThrift shbsd,
                            10:shared.EndPointNotFoundExceptionThrift epnfe,
                            11:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                            12:shared.NetworkErrorExceptionThrift nee
                            ),

    icshared.DeleteIoLimitResponse deleteIoLimit(1:icshared.DeleteIoLimitRequest request) throws (
                            1:shared.DriverNotFoundExceptionThrift dnfe
                            2:shared.InvalidInputExceptionThrift iie,
                            3:shared.ServiceIsNotAvailableThrift sina,
                            4:shared.PermissionNotGrantExceptionThrift png,
                            5:shared.AccessDeniedExceptionThrift ad,
                            6:shared.AccountNotFoundExceptionThrift anf,
                            7:shared.ServiceHavingBeenShutdownThrift shbsd,
                            8:shared.EndPointNotFoundExceptionThrift epnfe,
                            9:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                            10:shared.NetworkErrorExceptionThrift nee
                            ),

    icshared.ChangeLimitTypeResponse changeLimitType(1:icshared.ChangeLimitTypeRequest request) throws (
                            1:shared.DriverNotFoundExceptionThrift dnfe
                            2:shared.InvalidInputExceptionThrift iie,
                            3:shared.ServiceIsNotAvailableThrift sina,
                            4:shared.PermissionNotGrantExceptionThrift png,
                            5:shared.AccessDeniedExceptionThrift ad,
                            6:shared.AccountNotFoundExceptionThrift anf,
                            7:shared.ServiceHavingBeenShutdownThrift shbsd
                            ),

//******************************** MonitorServer user authentification begin **********************************************************/
    icshared.GetDashboardInfoResponse getDashboardInfo(1: icshared.GetDashboardInfoRequest request) throws (
                                                                                              1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                              2: shared.ServiceIsNotAvailableThrift sina,
                                                                                              3: shared.PermissionNotGrantExceptionThrift png,
                                                                                              4: shared.AccountNotFoundExceptionThrift anf),



//******************************** MonitorServer user authentification end   **********************************************************/
    void startAutoRebalance() throws (1: shared.NetworkErrorExceptionThrift nee),

    void pauseAutoRebalance() throws (1: shared.NetworkErrorExceptionThrift nee),

    bool rebalanceStarted() throws (1: shared.NetworkErrorExceptionThrift nee),

    void addRebalanceRule(1: shared.AddRebalanceRuleRequest request) throws (
                            1: shared.NetworkErrorExceptionThrift nee,
                            2: shared.RebalanceRuleExistingExceptionThrift rreet),

    shared.DeleteRebalanceRuleResponse deleteRebalanceRule(1: shared.DeleteRebalanceRuleRequest request) throws (
                            1: shared.NetworkErrorExceptionThrift nee,
                            2: shared.RebalanceRuleNotExistExceptionThrift rreet),

    shared.GetRebalanceRuleResponse getRebalanceRule(1: shared.GetRebalanceRuleRequest request) throws (1: shared.NetworkErrorExceptionThrift nee),

    void updateRebalanceRule(1: shared.UpdateRebalanceRuleRequest request) throws (
                            1: shared.NetworkErrorExceptionThrift nee,
                            2: shared.RebalanceRuleNotExistExceptionThrift rreet,
                            3: shared.RebalanceRuleExistingExceptionThrift exist),

    shared.GetAppliedRebalanceRulePoolResponse getAppliedRebalanceRulePool(1: shared.GetAppliedRebalanceRulePoolRequest request) throws (
                            1: shared.NetworkErrorExceptionThrift nee,
                            2: shared.StoragePoolNotExistedExceptionThrift spneet,
                            3: shared.RebalanceRuleNotExistExceptionThrift rreet),

    shared.GetUnAppliedRebalanceRulePoolResponse getUnAppliedRebalanceRulePool(1: shared.GetUnAppliedRebalanceRulePoolRequest request) throws (
                            1: shared.NetworkErrorExceptionThrift nee,
                            2: shared.StoragePoolNotExistedExceptionThrift spneet),

    void applyRebalanceRule(1: shared.ApplyRebalanceRuleRequest request) throws (
                            1: shared.NetworkErrorExceptionThrift nee,
                            2: shared.StoragePoolNotExistedExceptionThrift spneet,
                            3: shared.PoolAlreadyAppliedRebalanceRuleExceptionThrift paarret,
                            4: shared.RebalanceRuleNotExistExceptionThrift rreet),

    void unApplyRebalanceRule(1: shared.UnApplyRebalanceRuleRequest request) throws (
                            1: shared.NetworkErrorExceptionThrift nee,
                            2: shared.StoragePoolNotExistedExceptionThrift spneet,
                            3: shared.RebalanceRuleNotExistExceptionThrift rreet),

    shared.CleanOperationInfoResponse cleanOperationInfo(1: shared.CleanOperationInfoRequest request) throws (
                            1:shared.ServiceHavingBeenShutdownThrift shbs,
                            2:shared.ServiceIsNotAvailableThrift sina),

    shared.InstanceIncludeVolumeInfoResponse getInstanceIncludeVolumeInfo(1: shared.InstanceIncludeVolumeInfoRequest request) throws (
                            1:shared.ServiceHavingBeenShutdownThrift shbs,
                            2:shared.ServiceIsNotAvailableThrift sina),

    shared.EquilibriumVolumeResponse setEquilibriumVolumeStartOrStop(1: shared.EquilibriumVolumeRequest request) throws (
                            1:shared.ServiceHavingBeenShutdownThrift shbs,
                            2:shared.ServiceIsNotAvailableThrift sina),

    CreateScsiClientResponse createScsiClient(1: CreateScsiClientRequest request) throws (
                                1:shared.ServiceHavingBeenShutdownThrift shbs,
                                2:shared.ServiceIsNotAvailableThrift sina,
                                3:shared.ScsiClientIsExistExceptionThrift scieet,
                                4:shared.AccountNotFoundExceptionThrift anf,
                                5:shared.PermissionNotGrantExceptionThrift png),

    DeleteScsiClientResponse deleteScsiClient(1: DeleteScsiClientRequest request) throws (
                                1:shared.ServiceHavingBeenShutdownThrift shbs,
                                2:shared.ServiceIsNotAvailableThrift sina,
                                3:shared.AccountNotFoundExceptionThrift anf,
                                4:shared.PermissionNotGrantExceptionThrift png),

    ListScsiClientResponse listScsiClient(1: ListScsiClientRequest request) throws (
                                1:shared.ServiceHavingBeenShutdownThrift shbs,
                                2:shared.ServiceIsNotAvailableThrift sina,
                                3:shared.EndPointNotFoundExceptionThrift epnf,
                                4:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                5:shared.NetworkErrorExceptionThrift nme),
   shared.LaunchDriverResponseThrift launchDriverForScsi(1:shared.LaunchScsiDriverRequestThrift request) throws (
                                1:shared.ServiceHavingBeenShutdownThrift shbsd,
                                2:shared.ServiceIsNotAvailableThrift sina,
                                3:shared.PermissionNotGrantExceptionThrift png,
                                4:shared.AccountNotFoundExceptionThrift anf,
                                5:shared.ScsiClientIsNotOkExceptionThrift scinoe),

    shared.UmountScsiDriverResponseThrift umountDriverForScsi(1:shared.UmountScsiDriverRequestThrift request) throws (
                                1:shared.ServiceHavingBeenShutdownThrift shbsd,
                                2:shared.ServiceIsNotAvailableThrift sina,
                                3:shared.PermissionNotGrantExceptionThrift png,
                                4:shared.AccountNotFoundExceptionThrift anf
                                5:shared.ScsiClientIsNotOkExceptionThrift scinoe),

    icshared.ReportScsiDriverMetadataResponse reportScsiDriverMetadata(1:icshared.ReportScsiDriverMetadataRequest request) throws (
                               1:shared.InternalErrorThrift ie,
                               2:shared.ServiceHavingBeenShutdownThrift shbsd,
                               3:shared.ServiceIsNotAvailableThrift sina),

    icshared.ListScsiDriverMetadataResponse listScsiDriverMetadata(1:icshared.ListScsiDriverMetadataRequest request) throws (
                                  1:shared.InternalErrorThrift ie,
                                  2:shared.ServiceHavingBeenShutdownThrift shbsd,
                                  3:shared.ServiceIsNotAvailableThrift sina),

   shared.GetDiskSmartInfoResponseThrift getDiskSmartInfo(1:shared.GetDiskSmartInfoRequestThrift request) throws (
                                    1:shared.ServiceHavingBeenShutdownThrift shbs,
                                    2:shared.ServiceIsNotAvailableThrift sina,
                                    3:shared.EndPointNotFoundExceptionThrift epnfe,
                                    4:shared.TooManyEndPointFoundExceptionThrift tmepfe,
                                    5:shared.NetworkErrorExceptionThrift nee,
                                    6:shared.ServerNodeNotExistExceptionThrift snnee,
                                    7:shared.DiskNameIllegalExceptionThrift dnie),

   shared.UpdateDiskLightStatusByIdResponseThrift updateDiskLightStatusById(1:shared.UpdateDiskLightStatusByIdRequestThrift request) throws(
                                    1:shared.ServiceHavingBeenShutdownThrift shbs,
                                    2:shared.ServiceIsNotAvailableThrift sina),

  GetSegmentSizeResponse getSegmentSize(),

  shared.listZookeeperServiceStatusResponse listZookeeperServiceStatus(1:shared.listZookeeperServiceStatusRequest request) throws(
                                          1:shared.ServiceHavingBeenShutdownThrift shbs,
                                          2:shared.ServiceIsNotAvailableThrift sina,
                                          3:shared.EndPointNotFoundExceptionThrift vnfe,
                                          4:shared.NetworkErrorExceptionThrift errpoint),
}
