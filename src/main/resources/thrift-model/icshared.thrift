include "shared.thrift"

namespace java py.thrift.icshare
namespace perl icshare

//********** List Volumes Request ******************************/
struct ListVolumesRequest {
   1: i64 requestId,
   2: i64 accountId,
   // tagA=value1,tagA=value2,tagB=value3 means querying volumes whose (tagA is value1 or value2) and tagB is value3
//   3: optional list<shared.Tag> query
   3: optional set<i64> volumesCanBeList,
   4: optional bool containDeadVolume
}

struct ListAllDriversRequest{
   1:i64 requestId,
   2:optional i64 volumeId,
   3:optional i32 snapshotId,
   4:optional string drivercontainerHost,
   5:optional string driverHost,
   6:optional shared.DriverTypeThrift driverType
}

struct ListAllDriversResponse{
   1:i64 requestId,
   2:list<shared.DriverMetadataThrift> driverMetadatasthrift
}

struct ListDriverClientInfoRequest{
   1:i64 requestId,
   2:optional i64 volumeId,
   3:optional string volumeName,
   4:optional string driverName,
   5:optional string driverHost,
   6:optional string clientInfo,
   7:optional string volumeDescription
}

struct ListDriverClientInfoResponse{
   1:i64 requestId,
   2:list<shared.DriverClientInfoThrift> driverClientInfothrift
}

struct ListVolumesResponse {
   1: i64 requestId,
   2: list<shared.VolumeMetadataThrift> volumes,
   3: map<i64, shared.VolumeDeleteDelayInformationThrift> VolumeDeleteDelayInfo
}

//******** End of ListVolumesRequest *****/

//********** Get Volume Request ******************************/
struct GetVolumeRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i64 accountId,
   4: string name,
   5: bool withOutSegmentList,
   6: optional bool containDeadVolume,
   7: optional bool enablePagination,
   8: optional i32 startSegmentIndex,
   9: optional i32 paginationNumber
}

struct GetVolumeResponse {
   1: i64 requestId,
   2: optional shared.VolumeMetadataThrift volumeMetadata,
   3: list<shared.DriverMetadataThrift> driverMetadatas,
   4: optional list<shared.Tag> tags,
   5: optional bool leftSegment,
   6: optional i32 nextStartSegmentIndex
}

struct GetRootVolumeWithChildrenRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i64 accountId
}

struct GetRootVolumeWithChildrenResponse {
   1: i64 requestId,
   2: list<shared.VolumeMetadataThrift> rootVolumeWithChildren,
}

struct GetDriversRequestThrift {
   1: i64 requestId,
   2: i64 volumeId
}

struct GetDriversResponseThrift {
   1: i64 requestId,
   2: list<shared.DriverMetadataThrift> drivers
}

//******** End of GetVolumeRequest *****/


//********** list SegmentMetadata status *************/
struct GetSegmentMetadataStatusRequest {
   1: i64 requestId,
   2: i64 volumeId
}

struct GetSegmentMetadataStatusResponse {
   1: i64 requestId,
   2: map<i32, shared.SegmentStatusThrift> segmentMetadataStatus
}

//********** end list SegmentMetadata status **********/


//********** Report DriverMetadata Request *************/
struct ReportDriverMetadataRequest {
    1:i64 requestId,
    2:optional i64 drivercontainerId,
    3:list<shared.DriverMetadataThrift> drivers,
    4:optional i64 driverId
}

struct ReportDriverMetadataResponse {
    1:i64 requestId,
    2:optional list<i64> confictVolumeIds
}
//*********** End *****************************/

//********** Report DriverMetadata Request *************/
enum ScsiClientStatusThrift {
    OK = 1,
    ERROR = 2
}

enum ScsiDescriptionTypeThrift {
    LaunchDriver = 1,
    UmountDriver = 2
}

struct ScsiClientDescriptionThrift {
    1: string ip,
    2: ScsiClientStatusThrift status
}

struct ScsiClientInfoThrift {
    1: shared.VolumeMetadataThrift volume,
    2: shared.DriverStatusThrift driverStatus,
    3: shared.ScsiDeviceStatusThrift status,
    4: string path,
    5: string statusDescription,
    6: ScsiDescriptionTypeThrift descriptionTpye
}

struct ScsiClientInfoForEachClientThrift {
    1: i64 volumeId,
    2: shared.ScsiDeviceStatusThrift status,
    3: string path
    }

struct ScsiDeviceInfoThrift {
    1:i64 volumeId,
    2:i32 snapshotId,
    3:string driverIp,
    4:shared.ScsiDeviceStatusThrift scsiDeviceStatus,
    5:string scsiDevice
}

struct ReportScsiDriverMetadataRequest {
    1:i64 requestId,
    2:i64 drivercontainerId,
    3:list<ScsiDeviceInfoThrift> scsiList
}

struct ReportScsiDriverMetadataResponse {
    1:i64 requestId
}

struct ListScsiDriverMetadataRequest {
 1:i64 requestId,
 2:map<i64, i32> volumeInfo,
 3:string driverIp,
 4:i64 driverContainerIdScsi,
 5:set<i64> driverContainersIdWithPyd
}

struct ListScsiDriverMetadataResponse {
    1:i64 requestId,
    2:string driverIp,
    3:list<ScsiClientInfoThrift> scsiClientInfo,
    4:list<shared.VolumeMetadataThrift> unUsedVolumeInfos,
    5:list<shared.DriverMetadataThrift> driverInfo
}

struct ListArchivesResponseThrift {
   1: i64 requestId,
   2: list<shared.InstanceMetadataThrift> instanceMetadata
}

struct GetArchivesResponseThrift {
   1: i64 requestId,
   2: shared.InstanceMetadataThrift instanceMetadata
}

struct ListArchivesRequestThrift {
   1: i64 requestId
}

struct ListArchivesAfterFilterRequestThrift {
   1: i64 requestId
}

struct ListArchivesAfterFilterResponseThrift {
   1: i64 requestId
   2: list<shared.InstanceMetadataThrift> instanceMetadata
}

struct GetArchivesRequestThrift {
   1: i64 requestId,
   2: i64 instanceId
}

struct GetArchiveRequestThrift {
   1: i64 requestId,
   2: list<i64> archiveIds
}

struct GetArchiveResponseThrift {
   1: i64 requestId,
   2: list<shared.InstanceMetadataThrift> instanceMetadata
}

struct DeleteVolumeRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: string volumeName,
   4: i64 accountId
}

struct DeleteVolumeResponse {
   1: i64 requestId
}

struct UpdateVolumeDescriptionRequest {
   1: i64 requestId,
   2: i64 accountId,
   3: i64 volumeId,
   4: string volumeDescription
}

struct UpdateVolumeDescriptionResponse {
   1: i64 requestId
}


struct DeleteVolumeDelayRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: string volumeName,
   4: i64 accountId,
   5: i32 delaydate
}

struct DeleteVolumeDelayResponse {
   1: i64 requestId
}

struct StopDeleteVolumeDelayRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i64 accountId
}

struct StopDeleteVolumeDelayResponse {
   1: i64 requestId
}

struct StartDeleteVolumeDelayRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i64 accountId
}

struct StartDeleteVolumeDelayResponse {
   1: i64 requestId
}

struct GetDeleteVolumeDelayRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i64 accountId
}

struct GetDeleteVolumeDelayResponse {
   1: i64 requestId,
   2: shared.VolumeDeleteDelayInformationThrift volumeDeleteDelayInformation
}

struct CancelDeleteVolumeDelayRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i64 accountId
}

struct CancelDeleteVolumeDelayResponse {
   1: i64 requestId
}

struct MoveVolumeToRecycleRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i64 accountId
}

struct MoveVolumeToRecycleResponse {
   1: i64 requestId
}

struct RecycleVolumeToNormalRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i64 accountId
}

struct RecycleVolumeToNormalResponse {
   1: i64 requestId
}

struct ListRecycleVolumeInfoRequest {
   1: i64 requestId,
   2: i64 accountId
}

struct ListRecycleVolumeInfoResponse {
   1: i64 requestId,
   2: list<shared.VolumeMetadataThrift> volumes,
   3: map<i64, shared.VolumeRecycleInformationThrift> volumeRecycleInformationMap
}

struct CreateVolumeRequest {
   1:i64 requestId,
   2:i64 rootVolumeId,
   3:i64 volumeId,
   4:string name,
   5:i64 volumeSize,
   6:i64 segmentSize,
   7:shared.VolumeTypeThrift volumeType,
   8:i64 accountId,
   9:string requestType,
   10:list<shared.Tag> tags,
   11:i64 domainId,
   12:i64 storagePoolId,
   13: optional i32 leastSegmentUnitCount, // if not create all segment at the beginning, the least segment unit should be created
   14: bool enableLaunchMultiDrivers,
   15: optional string volumeDescription
}

struct CreateVolumeResponse {
   1: i64 requestId,
   2: i64 volumeId
}

struct UpdateVolumeRequest {
   1:i64 requestId,
   2:i64 volumeId,
   3:i64 accountId,
   4:optional string newVolumeName,
   5:optional shared.VolumeInActionThrift volumeInAction
}

struct UpdateVolumeResponse {
   1:i64 requestId,
}

struct CreateSegmentsRequest {
   1: i64 accountId,
   2: i64 requestId,
   3: i64 volumeId,
   4: i32 segmentNum,
   5: i32 segmentIndex,
   6: i64 domainId,
   7: i64 storagePoolId
}

struct CreateSegmentsResponse {
   1: i64 requestId,
}

struct GetLimitsRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i64 driverContainerId,
   4: shared.DriverTypeThrift driverType,
   5: i32 snapshotId
}

struct GetLimitsResponse {
   1: i64 requestId,
   2: i64 volumeId,
   3: list<shared.IoLimitationThrift> ioLimitations,
   4: bool staticLimit
}

struct AddOrModifyIoLimitRequest {
   1: i64 requestId,
   2: i64 accountId,
   3: i64 volumeId,
   4: i64 driverContainerId,
   5: shared.DriverTypeThrift driverType,
   6: i32 snapshotId,
   7: shared.IoLimitationThrift ioLimitation
}

struct AddOrModifyIoLimitResponse {
   1: i64 requestId,
   2: string volumeName,
   3: string driverTypeAndEndPoint
}

struct DeleteIoLimitRequest {
   1: i64 requestId,
   2: i64 accountId,
   3: i64 volumeId,
   4: i64 limitId,
   5: i64 driverContainerId,
   6: shared.DriverTypeThrift driverType,
   7: i32 snapshotId
}

struct DeleteIoLimitResponse {
   1: i64 requestId,
   2: string volumeName,
   3: string driverTypeAndEndPoint
}

struct ChangeLimitTypeRequest {
   1: i64 requestId,
   2: i64 accountId,
   3: i64 limitId,
   4: i64 volumeId,
   5: i64 driverContainerId,
   6: shared.DriverTypeThrift driverType,
   7: i32 snapshotId,
   8: bool staticLimit
}

struct ChangeLimitTypeResponse {
   1: i64 requestId,
}

struct RecycleVolumeRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i64 accountId
}

struct RecycleVolumeResponse {
   1: i64 requestId,
}

struct OrphanVolumeRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i64 accountId
}

/**
*  when MoveVolumeOnline operation should update volume accessrule
*  and iscsi access rule on drivers specified of new volume
*  then sweep thread will use rules on new volumes or drivers
*
*  should create new first then drivercontainer changeDriverBoundVolume
*  at last delete old access rule
*/

struct CreateAccessRuleOnNewVolumeRequest {
    1: i64 requestId,
    2: shared.DriverKeyThrift driver,
    3: i64 newVolumeId
}

struct CreateAccessRuleOnNewVolumeResponse{
    1: i64 requestId
}

struct DeleteAccessRuleOnOldVolumeRequest {
    1: i64 requestId,
    2: i64 oldVolumeId,
    3: shared.DriverKeyThrift driver,
}

struct DeleteAccessRuleOnOldVolumeResponse{
    1: i64 requestId
}

struct OrphanVolumeResponse {
   1: i64 requestId,
   2: list<shared.VolumeMetadataThrift> orphanVolumes
}

struct GetSegmentListRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i64 accountId,
   4: i32 startSegmentIndex,
   5: i32 endSegmentIndex
}

struct GetSegmentListResponse {
   1: i64 requestId,
   2: list<shared.SegmentMetadataThrift> segments
}

struct GetSegmentRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i32 segmentIndex,
}

struct GetSegmentResponse {
   1: i64 requestId,
   2: shared.SegmentMetadataThrift segment,
   3: i64 storagePoolId,
}

##-----------------this below is for dashboard info--------------------##

struct Capacity {
    1: string message,
    2: string totalCapacity,
    3: string availableCapacity,
    4: string usedCapacity,
    5: string freeSpace,
    6: string availableCapacityPer,
    7: string usedCapacityPer;
    8: string theUsedUniPerStr;
    9: string theunUsedUniPerStr;
    10:string theUsedUnitSpace;
    11:string theunUsedUnitSpace;
}

struct VolumeCounts {
    1: string message,
    2: i32 okCounts,
    3: i32 degreeCounts,
    4: i32 unavailableCounts,
    5: i32 totalClients,
    6: i32 connectedClients;
}

struct InstanceStatusStatistics {
    1: i32 serviceHealthy,
    2: i32 serviceSick,
    3: i32 serviceFailed,
    4: i32 serviceTotal;
    5: string message;
}

struct ClientTotal {
    1: string message,
    2: i32 clientTotal;
}

struct PoolStatistics {
    1: i32 poolHigh,
    2: i32 poolMiddle,
    3: i32 poolLow,
    4: i32 poolTotal;
    5: string message;
}

struct DiskStatistics {
    1: i32 goodDiskCount,
    2: i64 badDiskCount,
    3: i64 allDiskCount;
    4: string message;
}

struct ServerNodeStatistics {
    1: i32 okServerNodeCounts,
    2: i32 unknownServerNodeCount,
    3: i32 totalServerNodeCount;
    4: string message;
}

struct GetDashboardInfoRequest {
    1: i64 requestId,
    2: i64 accountId;
}

struct GetDashboardInfoResponse {
    1: i64 responseId,
    2: Capacity capacity,
    3: VolumeCounts volumeCounts,
    4: InstanceStatusStatistics instanceStatusStatistics,
    5: ClientTotal clientTotal,
    6: PoolStatistics poolStatistics,
    7: DiskStatistics diskStatistics,
    8: ServerNodeStatistics serverNodeStatistics;
}

##-----------------this above is for dashboard info--------------------##