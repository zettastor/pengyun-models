// Defining the shared data

namespace java py.thrift.share
namespace perl shared
/*
 * Structures used by the service request
 */
enum SegmentUnitStatusThrift {
   Start = 1, // just created, doesn't have any data, migration is needed
   ModeratorSelected = 2, // a moderator has been selected
   SecondaryEnrolled = 3, // Received a sync log request from the PrePrimary. 
   SecondaryApplicant = 4, // Want to join the segment group
   PreSecondary = 5, // the primary has accepted joining request, and accept read/write request
   PreArbiter = 6,
   PrePrimary = 7, // The group has reached consensus about this primary
   Secondary = 8, // the segment is secondary and readable/writable
   Arbiter = 9,
   Primary = 10, // the segment is primary and readable/writable
   OFFLINING = 12, // segment unit is being offlined
   OFFLINED = 13, // segment unit has been offlined
   Deleting = 14, // the segment is being deleted
   Deleted = 15, // the segment has been deleted. GC should collect this segment
   Broken = 16, // the disk which contains the segment unit is broken
   Unknown = 17
}

enum SegmentStatusThrift {
   Available = 1,
   UnAvailable = 2
}

enum VolumeSourceThrift {
   CREATE=1,
}

enum SegmentUnitTypeThrift {
   Normal = 1,
   Arbiter = 2,
   Flexible = 3 // for simple configured volumes
}

enum PortalTypeThrift {
    IPV4 = 1,
    IPV6 = 2
}

enum DriverStatusThrift {
    START=1,
    LAUNCHING=2,
    SLAUNCHED=3,
    LAUNCHED=4,
    REMOVING=5,
    UNAVAILABLE=6,
    UNKNOWN=7,
    ERROR=8,
    RECOVERING=9,
    MIGRATING=10
}

enum LimitTypeThrift {
   Static = 1,
   Dynamic = 2
}

enum CacheTypeThrift {
   NONE = 0,
   SSD = 1
}

enum VolumeTypeThrift {
   REGULAR = 1, // regular volume type, 3 nodes
   LARGE = 2, // large volume type, 5 nodes
   SMALL = 3
}

enum StoragePoolStrategyThrift {
    Capacity=1,
    Performance=2,
    Mixed=3
}

enum VolumeStatusThrift {
   ToBeCreated = 1,
   Creating = 2,
   Available = 3,
   Unavailable = 4,
   Deleting = 5,
   Deleted = 6,
   Recycling = 7, // volume is recycling from deleting or deleted status
   Fixing = 8,
   Dead = 9,
   Stable = 10,
}

enum VolumeInActionThrift {
    CREATING = 1,
    EXTENDING = 2,
    DELETING = 3,
    RECYCLING = 4,
    FIXING = 5,
    CLONING = 6,
    BEINGCLONED = 7,
    COPYING = 10,
    BEINGCOPIED = 11,
    NULL = 14
}

enum DriverTypeThrift {
    NBD = 1,
    JSCSI = 2,
    ISCSI = 3,
    NFS = 4,
    FSD = 5
}

enum ServiceStatusThrift {
    ACTIVATING=1,
    ACTIVE=2,
    DEACTIVATING=3,
    DEACTIVE=4,
    UPGRADING=5,
    UPGRADED=6,
    ERROR=7
}

enum CheckSecondaryInactiveThresholdModeThrift{
    AbsoluteTime =1,
    RelativeTime =2,
}

struct ServiceMetadataThrift {
     1: string serviceName,
     2: ServiceStatusThrift serviceStatus,
     3: i32 pid,
     4: i32 pmpid,
     5: string version,
     6: string errorCause
}

struct UpgradeInfoThrift {
     1: bool upgrading,
     2: optional string curentVersion,
     3: optional string latestVersion
}
struct DriverKeyThrift {
     1: i64 driverContainerId,
     2: i64 volumeId,
     3: i32 snapshotId,
     4: DriverTypeThrift driverType,

}

struct  ServiceIpStatusThrift {
    1:string hostname,
    2:string status,
}

enum WriteUnitResultThrift {
    OK=1,
    OutOfRange=2,
    InputHasNoData=3,
    ChecksumMismatched=4,
}

enum ReadUnitResultThrift {
    OK=1,
    OutOfRange=2,
    ChecksumMismatched=3,
}

enum WriteMemberThrift {
    Primary=1,
    Secondary=2,
    JoiningSecondary=3,
}

enum DbTableNameThrift {
    Domain=1,
    StoragePool=2,
    VolumeRuleRelate=3,
    AccessRule=4,
    CapacityRecord=5,
}

enum AccessRuleStatusBindingVolumeThrift {
    FREE=1,
    APPLING=2,
    APPLIED=3,
    CANCELING=4,
}
struct Tag {
   1: string key,
   2: string value
}

enum ArchiveStatusThrift {
    GOOD=1,
    DEGRADED=2,
    BROKEN=3,
    CONFIG_MISMATCH=4,
    OFFLINING=5,
    OFFLINED=6,
    EJECTED=7,
    INPROPERLY_EJECTED=8,
    UNKNOWN=9,
    SEPARATED=10,
}

enum ArchiveTypeThrift {
    RAW_DISK=0,
    UNSETTLED_DISK=6,
}

enum StorageTypeThrift {
    SATA=1,
    SAS=2,
    SSD=3,
    PCIE=4,
}

enum SegmentUnitStatusConflictCauseThrift {
    VolumeDeleted=1,
    VolumeRecycled=2,
    StaleSnapshotVersion=3,
    RollbackToSnapshot=4,
    VolumeExtendFailed=5,
}

enum NextActionThrift {
    KEEP=1,
    NEWALLOC=2,
    FREEMYSELF=3,
    CHANGE=4,
}

enum StatusThrift {
    Available=1,
    Deleting=2,
}

enum SnapshotStatusThrift {
    Available = 1,
    Unavailable = 2, // the snapshot may be unavailable for lack of space of shadow page
    Deleting = 3,    // snapshot is in deleting, in this status, the shadow pages of snapshot is deleting. This status is just in data node
    Deleted = 4,
}

enum MigrationStrategyThrift {
     Smart = 1,
     Manual = 2
}

enum CloneTypeThrift{
    NONE=1
}

enum ReadWriteTypeThrift{
    READONLY=1,
    READWRITE=2
}

enum AccessPermissionTypeThrift {
    READ=1,
    WRITE=2,
    READWRITE=3
}

struct SegIdThrift{
   1: i64 volumeId,
   2: i32 segmentIndex
}


struct SegmentMembershipThrift {
   1:i64 volumeId, 
   2:i32 segIndex,
   3:i32 epoch,
   4:i32 generation, 
   6:i64 primary,
   7:set<i64> secondaries,
   8:set<i64> arbiters,
   9:optional set<i64> joiningSecondaries,
   10:optional set<i64> inactiveSecondaries,
   11:optional i32 lease, // for how long the membership can be valid
   12:optional i64 tempPrimary,
   13:optional i64 secondaryCanaidate,
   14:optional i64 primaryCandidate
}

struct SegmentMembershipSwitchThrift {
   1:i16 volumeIdSwitch,
   2:i32 segIndex,
   3:i32 epoch,
   4:i32 generation,
   6:i16 primarySwitch,
   7:set<i16> secondariesSwitch,
   8:set<i16> arbitersSwitch,
   9:optional set<i16> joiningSecondariesSwitch,
   10:optional set<i16> inactiveSecondariesSwitch,
   11:optional i32 lease, // for how long the membership can be valid
   12:optional i64 tempPrimary,
   13:optional i64 secondaryCanaidate,
   14:optional i64 primaryCandidate
}

struct ArchiveMetadataThrift {
   1: string devName,  // the device name
   2: i64 archiveId, 
   3: ArchiveStatusThrift status, // whether the disk is good to use
   4: ArchiveTypeThrift type //
   5: optional string slotNo,
   6: optional string serialNumber,
   7: optional i64 createdTime,
   8: optional i64 updatedTime,
   9: optional string updatedBy,
   10: optional string createdBy,
   11:optional i64 logicalSpace,     // logical space which can be allocated for segment unit,
   12:optional i64 logicalFreeSpace, // logical free space remain
   13:optional i64 storagePoolId,
   14:bool overloaded,
   15:StorageTypeThrift storagetype, //storage type
   16:optional i64 totalPageToMigrate,
   17:optional i64 alreadyMigratedPage,
   18:optional i64 migrationSpeed,
   19:optional i64 maxMigrationSpeed,
   20:optional list<SegIdThrift> migrateFailedSegIdList,
   21:optional i32 freeFlexibleSegmentUnitCount,
   22:optional list<ArchiveTypeThrift> archiveTypes,
   23:optional i32 weight,
   24:optional i32 dataSizeMb,
   25:optional i64 rate,
   26:optional i64 logicalUsedSpace
}


struct SegmentUnitMetadataThrift {
   1:i64 volumeId, 
   2:i32 segIndex,
   3:i64 offset,
   4:SegmentMembershipThrift membership,
   5:SegmentUnitStatusThrift status,
   6:SegmentUnitTypeThrift segmentUnitType
   7:i64 lastUpdated,
   9:optional double ratioFreePages,
   10:optional double ratioMigration,
   11:optional string volumeType, // by default, it is REGULAR
   12:optional i64 instanceId,
   13:optional string volumeMetadataJson,
   14:optional string accountMetadataJson,
   15:optional string diskName, // disk name on which the segment unit located
   16:optional i64 archiveId, // archive id of the disk
   20:optional i64 totalPageToMigrate,
   21:optional i64 alreadyMigratedPage,
   22:optional i64 migrationSpeed,
   23:optional i64 minMigrationSpeed,
   24:optional i64 maxMigrationSpeed,
   25:optional bool innerMigrating,
   29: bool enableLaunchMultiDrivers,
   30: VolumeSourceThrift volumeSource,
   32: optional i64 sourceVolumeId,
}

struct SegmentUnitMetadataSwitchThrift {
   1:i16 volumeIdSwitch,
   2:i32 segIndex,
   3:i64 offset,
   4:SegmentMembershipSwitchThrift membership,
   5:SegmentUnitStatusThrift status,
   6:SegmentUnitTypeThrift segmentUnitType
   7:i64 lastUpdated,
   9:optional double ratioFreePages,
   10:optional double ratioMigration,
   11:optional string volumeType, // by default, it is REGULAR
   12:optional i16 instanceIdSwitch,
   13:optional string volumeMetadataJson,
   14:optional string accountMetadataJson,
   15:optional string diskName, // disk name on which the segment unit located
   16:optional i16 archiveIdSwitch, // archive id of the disk
   20:optional i64 totalPageToMigrate,
   21:optional i64 alreadyMigratedPage,
   22:optional i64 migrationSpeed,
   23:optional i64 minMigrationSpeed,
   24:optional i64 maxMigrationSpeed,
   25:optional bool innerMigrating,
   29: bool enableLaunchMultiDrivers,
   30: VolumeSourceThrift volumeSource,
   32: optional i64 sourceVolumeId,
}

struct SegmentMetadataThrift {
   1:i64 volumeId, 
   2:i32 segId,
   3:list<SegmentUnitMetadataThrift> segmentUnits,
   4:i32 indexInVolume,
   5:double freeSpaceRatio
}

struct SegmentMetadataSwitchThrift {
   1:i16 volumeIdSwitch,
   2:i32 segId,
   3:list<SegmentUnitMetadataSwitchThrift> segmentUnits,
   4:i32 indexInVolume,
   5:double freeSpaceRatio
}

struct GroupThrift {
    1:i32 groupId
    // TODO: other fields e.g. "location", "area"
}

struct InstanceDomainThrift {
    1: i64 domianId
}

enum DatanodeStatusThrift {
    OK = 1,
    UNKNOWN = 2,
    SEPARATED = 3,
}

//datanode type:
//normal datanode: can be used to create normal segment unit or arbiter segment unit(when no enough simple datanode)
//simple datanode: only can be used to create arbiter segment unit
enum DatanodeTypeThrift {
    NORMAL = 1,
    SIMPLE = 2
}

struct InstanceMetadataThrift{
   1: i64 instanceId, 
   2: string endpoint,
   3: i64 capacity,
   4: i64 freeSpace,
   5: i64 logicalCapacity,
   6: list<ArchiveMetadataThrift> archiveMetadata,
   7: GroupThrift group,
   8: InstanceDomainThrift instanceDomain,
   9: optional DatanodeStatusThrift datanodeStatus,
   10: DatanodeTypeThrift datanodeType
}

enum MigrationRuleStatusBindingPoolsThrift {
    FREE=1,
    APPLING=2,
    APPLIED=3,
    CANCELING=4,
}

struct MigrationRuleRelationShipThrift {
    1:i64 relationshipId,
    2:i64 storagePoolId,
    3:i64 ruleId,
    4:MigrationRuleStatusBindingPoolsThrift migrationRuleStatusBindingPools
}

enum MigrationRuleStatusThrift {
    FREE=1,
    APPLING=2,
    APPLIED=3,
    CANCELING=4,
    DELETING=5,
    AVAILABLE=6
}

struct MigrationRuleThrift {
    1:i64 ruleId,
    2:string migrationRuleName,
    3:i64 maxMigrationSpeed,
    4:MigrationStrategyThrift migrationStrategy,
    5:MigrationRuleStatusThrift migrationRuleStatus,
    6:CheckSecondaryInactiveThresholdModeThrift mode,
    7:optional i64 startTime,
    8:optional i64 endTime,
    9:optional i64 waitTime,
    10:bool ignoreMissPagesAndLogs,
    11:bool builtInRule
}

struct DomainThrift {
    1:i64 domainId,
    2:string domainName,
    3:string domainDescription,
    4:set<i64> datanodes,
    5:set<i64> storagePoolIds,
    6:StatusThrift status,
    7:i64 lastUpdateTime,
    8: i64 logicalSpace,
    9: i64 freeSpace
}

struct StoragePoolThrift {
    1:i64 poolId,
    2:optional i64 domainId,
    3:optional string domainName,
    4:string poolName,
    5:optional string description,
    6:StoragePoolStrategyThrift strategy,
    7:map<i64, set<i64>> archivesInDatanode,
    8:set<i64> volumeIds,
    9:StatusThrift status,
    10:i64 lastUpdateTime,
    11: i64 migrationSpeed,
    12: double migrationRatio,
    13: i64 totalSpace,
    14: i64 freeSpace,
    15: i64 logicalPssFreeSpace,
    16: i64 logicalPsaFreeSpace,
    17: string storagePoolLevel,
    18: optional MigrationRuleThrift migrationRule,
    19: i64 totalMigrateDataSizeMb
}

struct TotalAndUsedCapacityThrift {
    1:i64 totalCapacity,
    2:i64 usedCapacity
}

struct CapacityRecordThrift {
    1:map<string, TotalAndUsedCapacityThrift> capacityRecordMap
}

struct VolumeRuleRelationshipThrift {
    1:i64 relationshipId,
    2:i64 volumeId,
    3:i64 ruleId,
    4:AccessRuleStatusBindingVolumeThrift accessRuleStatusBindingVolume
}

struct VolumeMetadataThrift {
   1: i64 volumeId,
   2: i64 rootVolumeId,
   3: string name,
   4: string endpoint,
   5: i64 volumeSize,
   6: i64 segmentSize,
   7: i64 extendingSize,
   8: VolumeTypeThrift volumeType,
   10: VolumeStatusThrift volumeStatus,
   11: i64 accountId,
   12: list<SegmentMetadataThrift> segmentsMetadata,
   13: optional i64 deadTime,  // for integration test
   14: i64 domainId,
   15: bool simpleConfiguration,
   16: i32 leastSegmentUnitAtBeginning,
   18: i64 storagePoolId,
   19: i32 segmentNumToCreateEachTime,
   20: string volumeLayout,
   21: double freeSpaceRatio,
   22: i64 volumeCreatedTime, // new add 2017.03.03
   23: i64 lastExtendedTime,  // new add 2017.03.03
   24: VolumeSourceThrift volumeSource,
   25: ReadWriteTypeThrift readWrite,
   26: VolumeInActionThrift inAction,
   27: i32 pageWrappCount,
   28: i32 segmentWrappCount,
   29: optional i64 totalPageToMigrate,
   30: optional i64 alreadyMigratedPage,
   31: i64 migrationSpeed,
   32: double migrationRatio,
   33: bool enableLaunchMultiDrivers,
   35: double rebalanceRatio,
   36: i64 rebalanceVersion,
   37: i64 stableTime,
   38: map<i64, i16> switchStructValue,
   39: list<SegmentMetadataSwitchThrift> segmentsMetadataSwitch,
   41: i64 totalPhysicalSpace,
   42: string srcVolumeNameWithClone,
   43: string srcSnapshotNameWithClone,
   45: string eachTimeExtendVolumeSize,
   48: bool markDelete,
   49: i32 csiLaunchCount,
   50: optional string volumeDescription,
   51: i64 clientLastConnectTime,
   52: optional bool readOnlyForCsi,
   53: optional i64 usedSpaceForCsi,
   54: i64 totalSpaceFroCsi,
   55: i32 formatStep
}

struct VolumeDeleteDelayInformationThrift{
   1:i64 timeForDelay,
   2:bool stopDelay,
   3:i64 volumeId
}

struct VolumeRecycleInformationThrift{
   1:i64 volumeId,
   2:i64 timeInRecycle
}

struct NextActionInfoThrift {
   1: NextActionThrift nextAction,
   2: optional i64 newId
}

enum RebalanceTaskTypeThrift {
   NormalRebalance=1,
   PrimaryRebalance=2
}

struct RebalanceTaskThrift {
   1: i64 taskId,
   2: i64 destInstanceId,
   3: SegmentUnitMetadataThrift sourceSegmentUnit,
   4: RebalanceTaskTypeThrift taskType,
}

struct PrimaryMigrateThrift {
   1: SegIdThrift segId,
   2: i64 srcInstanceId,
   3: i64 targetInstanceId
}

struct SecondaryMigrateThrift {
   1: SegIdThrift segId,
   2: i64 srcInstanceId,
   3: i64 targetInstanceId,
   4: VolumeTypeThrift volumeType,
   5: CacheTypeThrift cacheType,
   6: optional string volumeMetadataJson,
   7: optional string accountMetadataJson,
   8: optional SegmentMembershipThrift initMembership, // the initial membership, used by a new node trying to join an existing group
   9: optional list<i64> initMembers, // the initial members, used by new nodes to create a brand new volume. If initMembership is set too,
   // then initMembership has higher preference to initMembers.
   10: optional binary initSnapshotManagerInBinary, // the initial snapshot manager in byte array
   11: optional SegmentMembershipThrift srcMembership, // the membership for src volume from which the clone volume copy page
   12: optional i32 srcSnapshotId, // the snapshot id from which the new segment unit in clone volume copy page
   13: optional CloneTypeThrift cloneType,
   14: i64 storagePoolId,
   15: SegmentUnitTypeThrift segmentUnitType,
   16: i32 segmentWrapSize,
   18: bool enableLaunchMultiDrivers,
   19: VolumeSourceThrift volumeSource
}

struct ArbiterMigrateThrift {
   1: SegIdThrift segId,
   2: i64 srcInstanceId,
   3: i64 targetInstanceId,
   4: VolumeTypeThrift volumeType,
   5: CacheTypeThrift cacheType,
   6: optional string volumeMetadataJson,
   7: optional string accountMetadataJson,
   8: optional SegmentMembershipThrift initMembership, // the initial membership, used by a new node trying to join an existing group
   9: optional list<i64> initMembers, // the initial members, used by new nodes to create a brand new volume. If initMembership is set too,
   // then initMembership has higher preference to initMembers.
   10: optional binary initSnapshotManagerInBinary, // the initial snapshot manager in byte array
   11: optional SegmentMembershipThrift srcMembership, // the membership for src volume from which the clone volume copy page
   12: optional i32 srcSnapshotId, // the snapshot id from which the new segment unit in clone volume copy page
   13: optional CloneTypeThrift cloneType,
   14: i64 storagePoolId,
   15: SegmentUnitTypeThrift segmentUnitType,
   16: i32 segmentWrapSize,
   18: bool enableLaunchMultiDrivers,
   19: VolumeSourceThrift volumeSource
}

struct RebalanceTaskListThrift {
   1: optional list<PrimaryMigrateThrift> primaryMigrateList,
   2: optional list<SecondaryMigrateThrift> secondaryMigrateList,
   3: optional list<ArbiterMigrateThrift> arbiterMigrateList,
}

struct InstanceIdAndEndPointThrift {
   1: i64 instanceId,
   2: string endPoint,
   3: optional i32 groupId
}

//********** Driver Qos begin**************/
enum IoLimitationStatusThrift {
    FREE=1,
    APPLING=2,
    APPLIED=3,
    CANCELING=4,
    DELETING=5,
    AVAILABLE=6
}

struct IoLimitationEntryThrift {
   1: i32 upperLimitedIoPs,
   2: i32 lowerLimitedIoPs,
   3: i64 upperLimitedThroughput,
   4: i64 lowerLimitedThroughput,
   5: string startTime,
   6: string endTime,
   7: i64 entryId;
}

struct IoLimitationThrift {
   1: i64 limitationId,
   2: string limitationName,
   3: LimitTypeThrift limitType,
   4: IoLimitationStatusThrift status,
   5: list<IoLimitationEntryThrift> entries;
}

struct DriverMetadataThrift {
   1: i64 driverContainerId,
   2: i64 volumeId,
   3: optional string volumeName,
   4: DriverTypeThrift driverType,
   5: string hostName,
   6: i32 port,
   7: DriverStatusThrift driverStatus,
   8: map<string,AccessPermissionTypeThrift> clientHostAccessRule,
   9: i32 coordinatorPort,
   10: i32 snapshotId,
   11: string nbdDevice,
   12: i64 instanceId,
   13: i32 processId,
   //*** driver qos id represent the relationship with IoLimitation
   //*** one driver only hava one dynamic and static IoLimitation
   14: i64 staticIoLimitationId,
   15: i64 dynamicIoLimitationId,
   16: string queryServerIp,
   17: i32 queryServerPort,
   18: string driverName,
   19: i32 chapControl,
   20: string ipv6Addr,
   21: string netIfaceName,
   22: PortalTypeThrift portalType,
   23: optional bool makeUnmountForCsi,
   24: i64 createTime
}

struct DriverClientInfoThrift {
   1: i64 driverContainerId,
   2: i64 volumeId,
   3: i32 snapshotId,
   4: DriverTypeThrift driverType,
   5: string clientInfo,
   6: i64 time,
   7: string driverName,
   8: string hostName,
   9: bool status,
   10: string volumeName,
   11: optional string volumeDescription
}

enum IoLimitationStatusBindingDriversThrift {
    FREE=1,
    APPLING=2,
    APPLIED=3,
    CANCELING=4,
}

struct  IoLimitationRelationShipThrift {
    1:i64 relationshipId,
    2:i64 ruleId,
    3: i64 driverContainerId,
    4: i64 volumeId,
    5: DriverTypeThrift driverType,
    6: i32 snapshotId,
    7:IoLimitationStatusBindingDriversThrift ioLimitationStatusBindingDrivers
}

struct ListIoLimitationsRequest {
    1:i64 requestId,
    2:i64 accountId;
}

struct ListIoLimitationsResponse {
    1:i64 requestId,
    2:list<IoLimitationThrift> ioLimitations;
}

struct ListIoLimitationsByDriverKeysRequest {
    1:i64 requestId,
    2:set<DriverKeyThrift> DriverKeys;
}

struct ListIoLimitationsByDriverKeysResponse {
    1:i64 requestId,
    2:map<DriverKeyThrift, list<IoLimitationThrift>> mapDriver2ItsIoLimitations
}

struct GetIoLimitationsRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:DriverKeyThrift driverKey;
}

struct GetIoLimitationsResponse {
    1:i64 requestId,
    2:list<IoLimitationThrift> ioLimitations
}

struct CreateIoLimitationsRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: IoLimitationThrift ioLimitation;
}

struct CreateIoLimitationsResponse {
    1:i64 requestId
}

struct ApplyIoLimitationsRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<DriverKeyThrift> driverKeys,
    4: i64 ruleId,
    5: bool commit;
}

struct ApplyIoLimitationsResponse {
    1: i64 requestId,
    2: optional list<DriverMetadataThrift> airDriverKeyList,
    3: string ioLimitationName,
    4: list<string> appliedDriverNames
}

struct CancelIoLimitationsRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<DriverKeyThrift> driverKeys,
    4: i64 ruleId,
    5: bool commit;
}

struct CancelIoLimitationsResponse {
    1:i64 requestId,
    //*** current status of access rule is not allowed to cancel from some driver
    2:optional list<DriverMetadataThrift> airDriverKeyList,
    3: string ioLimitationName,
    4: list<string> canceledDriverNames
}

struct DeleteIoLimitationsRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:list<i64> ruleIds,
    4:bool commit;
}

struct DeleteIoLimitationsResponse {
    1:i64 requestId,
    //*** current status of Io Limitations is not allowed to delete from system
    2:optional list<IoLimitationThrift> airIoLimitationList,
    3: list<string> deletedIoLimitationNames
}

struct UpdateIoLimitationsRequest {
   1: i64 requestId,
   2: i64 accountId,
   3: i64 volumeId,
   4: i64 driverContainerId,
   5: DriverTypeThrift driverType,
   6: i32 snapshotId,
   7: IoLimitationThrift ioLimitation
}

struct UpdateIoLimitationRulesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: IoLimitationThrift ioLimitation;
}

struct UpdateIoLimitationsResponse {
   1: i64 requestId
}

struct GetIoLimitationAppliedDriversRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:i64 ruleId;
}

struct GetIoLimitationAppliedDriversResponse {
    1: i64 requestId,
    2: list<DriverMetadataThrift> driverList
}

exception IoLimitationsDuplicateThrift {
  1: optional string detail
}


exception IoLimitationIsDeleting{
  1: optional string detail
}

exception IoLimitationsAlreadyAppliedError {
  1: optional string detail
}

exception IoLimitationTimeInterLeavingThrift {
  1: optional string detail
}

exception IoLimitationsNotExists{
  1: optional string detail
}
//********** Driver Qos end*****************/



struct ListMigrationRulesRequest {
    1:i64 requestId,
    2:i64 accountId;
}

struct ListMigrationRulesResponse {
    1:i64 requestId,
    2:list<MigrationRuleThrift> migrationRules;
}

struct ListMigrationRulesByStoragePoolIdsRequest {
    1:i64 requestId,
    2:set<i64> storagePoolIds;
}

struct ListMigrationRulesByStoragePoolIdsResponse {
    1:i64 requestId,
    2:map<i64, list<MigrationRuleThrift>> migrationRulesTable;
}

struct GetMigrationRulesRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:i64 storagePoolId;
}

struct GetMigrationRulesResponse {
    1:i64 requestId,
    2:list<MigrationRuleThrift> accessRules
}

struct ApplyMigrationRulesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<i64> storagePoolIds,
    4: i64 ruleId,
    5: bool commit
}

struct ApplyMigrationRulesResponse {
    1: i64 requestId,
    //*** current status of access rule is not allowed to apply to some volume
    2: optional list<StoragePoolThrift> airStoragePoolList,
    3: string ruleName,
    4: list<string> appliedStoragePoolNames
}

struct CancelMigrationRulesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<i64> storagePoolIds,
    4: i64 ruleId,
    5: bool commit
}

struct CancelMigrationRulesResponse {
    1: i64 requestId,
    //*** current status of access rule is not allowed to cancel from some volume
    2: optional list<StoragePoolThrift> airStoragePoolList
    3: string ruleName,
    4: list<string> canceledStoragePoolNames
}

struct GetAppliedStoragePoolsRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: i64 ruleId;
}

struct GetAppliedStoragePoolsResponse {
    1: i64 requestId,
    2: list<StoragePoolThrift> StoragePoolList;
}

exception MigrationRuleDuplicateThrift {
  1: optional string detail
}

exception MigrationRuleIsDeleting{
  1: optional string detail
}

exception MigrationRuleAlreadyAppliedError {
  1: optional string detail
}

exception MigrationRuleNotExists{
  1: optional string detail
}

//********** Launch Driver Request *************/
struct LaunchDriverRequestThrift {
    1: i64 requestId,
    2: string driverName,
    3: i64 accountId,
    4: i64 volumeId,
    5: i32 snapshotId,
    6: DriverTypeThrift driverType,
    //***the amount of driver to launch for a volume
    //***driver amount is required due to multiple path to access driver is allowed
    7: i32 driverAmount,
    8: optional string hostName //could launch on special driver host, one path
    9: optional bool volumeCanNotLaunchMultiDriversThisTime //
}

struct LaunchDriverResponseThrift {
    1: i64 requestId,
    2: set<i64> relatedDriverContainerIds,
    3: optional set<string> driverNameLaunchThisTime;
}

struct LaunchScsiDriverRequestThrift {
    1: i64 requestId,
    2: i64 accountId,
    3: map<i64, i32> volumesForLaunch,
    4: DriverTypeThrift driverType,
    //***the amount of driver to launch for a volume
    //***driver amount is required due to multiple path to access driver is allowed
    5: i32 driverAmount,
    6: optional string hostName, //could launch on special driver host, one path
    7: string scsiIp
}
//*********** End *****************************/

struct ListIscsiAppliedAccessRulesRequestThrift{
    1: i64 requestId,
    2: DriverKeyThrift driverKey
}

struct ListIscsiAppliedAccessRulesResponseThrift{
    1: i64 requestId,
    2: list<string> initiatorNames
}

enum BroadcastLogStatusThrift {
    Creating=1,
    Created=2,
    Committed=3,
    Abort=4,
    AbortConfirmed=5
}

struct BroadcastLogThrift {
    1: i64 logUuid,
    2: i64 logId,
    3: i64 offset,
    4: i64 checksum,
    5: i32 length,
    6: BroadcastLogStatusThrift logStatus,
    7: i32 snapshotVersion,
}

struct GetLatestLogsRequestThrift {
    1: i64 requestId,
    2: list<SegIdThrift> segIdList,
    3: bool needRemoveLogsInSecondary
}

struct GetLatestLogsResponseThrift {
    1: i64 requestId,
    2: map<SegIdThrift, list<BroadcastLogThrift>> mapSegIdToLogs
}

struct CommitLogsRequestThrift {
    1: i64 requestId,
    2: SegmentMembershipThrift membership,
    3: map<i64, list<BroadcastLogThrift>> mapRequestIdToLogs
}

struct CommitLogsResponseThrift {
    1: i64 requestId,
    2: i32 segIndex,
    3: string endPoint,
    4: map<i64, list<BroadcastLogThrift>> mapRequestIdToLogs,
    5: optional WriteMemberThrift writeMember,
    6: optional bool onError
}

struct ConfirmAbortLogsRequestThrift {
    1: i64 requestId,
    2: SegIdThrift segId,
    3: i64 fromLogId,
    4: i64 toLogId
}

struct ConfirmAbortLogsResponseThrift {
    1: i64 requestId,
    2: bool success,
    3: optional i64 fromLogId
}

//********** Access rules begin              ********/
//********** Get Volume Access Rules Request ********/
enum AccessRuleStatusThrift {
    FREE=1,
    APPLING=2,
    APPLIED=3,
    CANCELING=4,
    DELETING=5,
    AVAILABLE=6
}

struct VolumeAccessRuleThrift {
    1: i64 ruleId,
    2: string incomingHostName,
    3: AccessPermissionTypeThrift permission,
    4: AccessRuleStatusThrift status
}

struct ListVolumeAccessRulesRequest {
    1:i64 requestId,
    2:i64 accountId;
}

struct ListVolumeAccessRulesResponse {
    1:i64 requestId,
    2:list<VolumeAccessRuleThrift> accessRules
}

struct ListVolumeAccessRulesByVolumeIdsRequest {
    1:i64 requestId,
    2:set<i64> volumeIds
}

struct ListVolumeAccessRulesByVolumeIdsResponse {
    1:i64 requestId,
    2:map<i64, list<VolumeAccessRuleThrift>> accessRulesTable
}

struct GetVolumeAccessRulesRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:i64 volumeId;
}

struct GetVolumeAccessRulesResponse {
    1:i64 requestId,
    2:list<VolumeAccessRuleThrift> accessRules
}

struct CreateVolumeAccessRulesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<VolumeAccessRuleThrift> accessRules,
    4: bool forScsiClien
}

struct CreateVolumeAccessRulesResponse {
    1:i64 requestId,
    2:i64 ruleId
}

struct ApplyVolumeAccessRulesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: i64 volumeId,
    4: list<i64> ruleIds,
    5: bool commit;
}

struct ApplyVolumeAccessRulesResponse {
    1:i64 requestId,
    //*** current status of access rule is not allowed to apply to some volume
    2:optional list<VolumeAccessRuleThrift> airAccessRuleList;
}

struct ApplyVolumeAccessRuleOnVolumesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<i64> volumeIds,
    4: i64 ruleId,
    5: bool commit;
}

struct ApplyVolumeAccessRuleOnVolumesResponse {
    1:i64 requestId,
    2:optional list<VolumeMetadataThrift> airVolumeList;
}

struct CancelVolumeAccessRulesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: i64 volumeId,
    4: list<i64> ruleIds,
    5: bool commit;
}

struct CancelVolumeAccessRulesResponse {
    1:i64 requestId,
    //*** current status of access rule is not allowed to cancel from some volume
    2:optional list<VolumeAccessRuleThrift> airAccessRuleList;
}


struct CancelVolAccessRuleAllAppliedRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<i64> volumeIds,
    4: i64 ruleId,
    5: bool commit;
}

struct CancelVolAccessRuleAllAppliedResponse {
    1:i64 requestId,
    2:optional list<i64> airVolumeIds;
}

struct ApplyVolumeAccessRulesToDriverRequest {
    1:i64 requestId,
    2:list<VolumeAccessRuleThrift> applyVolumeAccessRules;
}

struct ApplyVolumeAccessRulesToDriverResponse {
    1:i64 requestId,
}

struct CancelVolumeAccessRulesToDriverRequest {
    1:i64 requestId,
    2:list<VolumeAccessRuleThrift> cancelVolumeAccessRules;
}

struct CancelVolumeAccessRulesToDriverResponse {
    1:i64 requestId,
}

struct DeleteVolumeAccessRulesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<i64> ruleIds,
    4: bool commit;
}

struct DeleteVolumeAccessRulesResponse {
    1: i64 requestId,
    //*** current status of access rule is not allowed to delete from system
    2: optional list<VolumeAccessRuleThrift> airAccessRuleList
}

struct GetAppliedVolumesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: i64 ruleId;
}

struct GetAppliedVolumesResponse {
    1: i64 requestId,
    2: list<i64> volumeIdList
}

exception AccessRuleNotAppliedThrift {
    1: optional string detail
}

exception AccessRuleNotFoundThrift {
    1: optional string detail
}

exception AccessRuleUnderOperationThrift {
    1: optional string detail
}

//********** Get Iscsi Volume Access Rules Request ********/
struct IscsiAccessRuleThrift {
    1: i64 ruleId,
    2: string ruleNotes,
    3: string initiatorName,
    4: string user,
    5: string passed,
    6: string outUser,
    7: string outPassed,
    8: AccessPermissionTypeThrift permission,
    9: AccessRuleStatusThrift status
}

struct IscsiRuleRelationshipThrift {
    1:i64 relationshipId,
    2:DriverKeyThrift driverKey,
    3:i64 ruleId,
    4:AccessRuleStatusBindingVolumeThrift accessRuleStatusBindingVolume
}


struct ListIscsiAccessRulesRequest {
    1:i64 requestId,
    2:i64 accountId,
}

struct ListIscsiAccessRulesResponse {
    1:i64 requestId,
    2:list<IscsiAccessRuleThrift> accessRules
}

struct ListIscsiAccessRulesByDriverKeysRequest {
    1:i64 requestId,
    2:set<DriverKeyThrift> DriverKeys
}

struct ListIscsiAccessRulesByDriverKeysResponse {
    1:i64 requestId,
    2:map<DriverKeyThrift, list<IscsiAccessRuleThrift>> accessRulesTable
}

struct GetIscsiAccessRulesRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:DriverKeyThrift driverKey
}

struct GetIscsiAccessRulesResponse {
    1:i64 requestId,
    2:list<IscsiAccessRuleThrift> accessRules
}

struct ReportIscsiAccessRulesRequest {
   1:i64 requestId,
   2:DriverKeyThrift driverKey,
   3:list<IscsiAccessRuleThrift> accessRules
}

struct ReportIscsiAccessRulesResponse {
   1:i64 requestId,
}

struct CreateIscsiAccessRulesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<IscsiAccessRuleThrift> accessRules
}

struct CreateIscsiAccessRulesResponse {
    1:i64 requestId
}

struct ApplyIscsiAccessRulesRequest {
    1: i64 requestId,
    2:i64 accountId,
    3: DriverKeyThrift driverKey,
    4: list<i64> ruleIds,
    5: bool commit
}

struct ApplyIscsiAccessRulesResponse {
    1:i64 requestId,
    //*** current status of access rule is not allowed to apply to some volume
    2:optional list<IscsiAccessRuleThrift> airAccessRuleList;
}


struct ApplyIscsiAccessRuleOnIscsisRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:list<DriverKeyThrift> driverKeys,
    4:i64 ruleId,
    5:bool commit
}

struct ApplyIscsiAccessRuleOnIscsisResponse {
    1:i64 requestId,
    2:optional list<DriverKeyThrift> airDriverKeyList;
}


struct CancelDriversRulesRequest {
    1:i64 requestId,
    2:DriverKeyThrift driverKey;
}

struct CancelDriversRulesResponse {
    1:i64 requestId;
}


struct CancelIscsiAccessRulesRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:DriverKeyThrift driverKey,
    4:list<i64> ruleIds,
    5:bool commit
}

struct CancelIscsiAccessRulesResponse {
    1:i64 requestId,
    //*** current status of access rule is not allowed to cancel from some driver
    2:optional list<IscsiAccessRuleThrift> airAccessRuleList;
}

struct CancelIscsiAccessRuleAllAppliedRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:list<DriverKeyThrift> driverKeys,
    4:i64 ruleId,
    5:bool commit
}

struct CancelIscsiAccessRuleAllAppliedResponse {
    1:i64 requestId,
    2:optional list<DriverKeyThrift> airDriverKeyList;
}

struct ApplyIscsiAccessRulesToDriverRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:list<IscsiAccessRuleThrift> applyIscsiAccessRules;
}

struct ApplyIscsiAccessRulesToDriverResponse {
    1:i64 requestId,
}

struct CancelIscsiAccessRulesToDriverRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:list<IscsiAccessRuleThrift> cancelIscsiAccessRules;
}

struct CancelIscsiAccessRulesToDriverResponse {
    1:i64 requestId,
}

struct DeleteIscsiAccessRulesRequest {
    1: i64 requestId,
    2:i64 accountId,
    3: list<i64> ruleIds,
    4: bool commit
}

struct DeleteIscsiAccessRulesResponse {
    1: i64 requestId,
    //*** current status of access rule is not allowed to delete from system
    2: optional list<IscsiAccessRuleThrift> airAccessRuleList
}


struct GetAppliedIscsisRequest {
    1: i64 requestId,
    2:i64 accountId,
    3: i64 ruleId;
}

struct GetAppliedIscsisResponse {
    1: i64 requestId,
    2: list<DriverMetadataThrift> driverList
    //*** 2: list<DriverKeyThrift> driverKeyList
//    2:list<i64> volumeIdList
}

enum AccessRuleStatusBindingIscsiThrift {
    FREE=1,
    APPLING=2,
    APPLIED=3,
    CANCELING=4,
}

exception IscsiBeingDeletedExceptionThrift {
  1: optional string detail
}

exception RootIscsiBeingDeletedExceptionThrift {
  1: optional string detail
}


exception IscsiAccessRuleDuplicateThrift {
  1: optional string detail
}

exception IscsiAccessRuleFormatErrorThrift {
  1: optional string detail
}

exception ChapSameUserPasswdErrorThrift {
  1: optional string detail
}

exception IscsiAccessRuleNotFoundThrift {
  1: optional string detail
}

exception IscsiAccessRuleUnderOperationThrift {
  1: optional string detail
}

exception IscsiNotFoundExceptionThrift {
  1: optional string detail
}

exception IscsiUnderOperationExceptionThrift {
  1: optional string detail
}
//**********  Access rules end  **********/

//**********  SCSI start *****************/
enum ScsiDeviceStatusThrift {
    CREATING=1,
    NORMAL=2,
    RECOVERY=3,
    UMOUNT=4,
    ERROR=5,
    CONNECTEXCEPTIONRECOVERING = 6,
    LAUNCHING = 7,
    UNKNOWN = 8,
    REMOVING = 9,
    CONNECTING = 10,
    DISCONNECTING = 11

}

struct MountScsiDeviceRequest {
    1:i64 requestId,
    2:i64 volumeId,
    3:i32 snapshotId,
    4:string driverIp;
}

struct MountScsiDeviceResponse {
    1:i64 requestId,
    2:i64 driverContainerIdForScsi
}

struct UmountScsiDeviceRequest {
    1:i64 requestId,
    2:i64 volumeId,
    3:i32 snapshotId,
    4:string driverIp;
}

struct UmountScsiDeviceResponse {
    1:i64 requestId;
}

/****/
exception NoEnoughPydDeviceExceptionThrift {
    1: optional string detail
}

exception ConnectPydDeviceOperationExceptionThrift {
    1: optional string detail
}

exception CreateBackstoresOperationExceptionThrift {
    1: optional string detail
}

exception CreateLoopbackOperationExceptionThrift {
    1: optional string detail
}

exception CreateLoopbackLunsOperationExceptionThrift {
    1: optional string detail
}

exception GetScsiDeviceOperationExceptionThrift {
    1: optional string detail
}

exception ScsiDeviceIsLaunchExceptionThrift {
    1: optional string detail
}

exception InfocenterServerExceptionThrift {
    1: optional string detail
}

exception CreateVolumeAccessRulesExceptionThrift {
    1: optional string detail
}

exception ApplyVolumeAccessRuleExceptionThrift {
    1: optional string detail
}

exception GetPydDriverStatusExceptionThrift {
    1: optional string detail
}

exception GetScsiClientExceptionThrift {
    1: optional string detail
}

exception CanNotGetPydDriverExceptionThrift {
    1: optional string detail
}

//**********  SCSI end *****************/

struct GetConnectClientInfoRequest {
    1:i64 requestId,
    2:i64 volumeId;
}

struct GetConnectClientInfoResponse {
    1:i64 requestId,
    2:map<string, AccessPermissionTypeThrift> connectClientAndAccessType;
}


struct GetCapacityRequest {
    1:i64 requestId,
    2:i64 accountId;
}

struct GetCapacityResponse {
    1:i64 requestId,
    2:i64 capacity,
    3:i64 freeSpace,
    4:i64 logicalCapacity
}



//********** end ***********/
//************** fix volume ******************/
enum SegmentUnitRoleThrift {
   Primary=1,
   Secondary=2,
   JoiningSecondary=3,
   Arbiter=4,
}

struct FixVolumeRequestThrift {
   1:i64 requestId,
   2:i64 volumeId,
   3:i64 accountId,
}

exception VolumeFixingOperationExceptionThrift {
  1: optional string detail
}

struct FixVolumeResponseThrift {
   1:i64 requestId,
   2:bool needFixVolume,
   3:bool fixVolumeCompletely,
   4:set<i64> lostDatanodes,
}

struct CreateSegmentUnitInfo {
   1:SegmentUnitRoleThrift segmentUnitRole,
   2:map<InstanceIdAndEndPointThrift,SegmentMembershipThrift> segmentMembershipMap;
}

struct ConfirmFixVolumeRequestThrift {
   1:i64 requestId,
   2:i64 volumeId,
   3:i64 accountId,
   4:optional set<i64> lostDatanodes,
}

struct ConfirmFixVolumeResponseThrift {
   1:i64 responseId,
   2:bool confirmFixVolumeSucess,
}

struct ConfirmFixVolumeResponse{
   1:i64 responseId,
   2:i64 storagePoolId,
   3:VolumeTypeThrift volumeType,
   4:CacheTypeThrift cacheType,
   5:map<SegIdThrift, list<CreateSegmentUnitInfo>> createSegmentUnits,
   6:VolumeSourceThrift volumeSource
}

//************** fix volume end **************/
struct DriverIpTargetThrift {
        1:i32 snapshotId,
        2:string driverIp,
        3:DriverTypeThrift driverType,
        4:i64 driverContainerId
}

struct UmountDriverRequestThrift {
    1:i64 requestId,
    2:i64 accountId,
    3:i64 volumeId,
    4:optional list<DriverIpTargetThrift> driverIpTargetList     // If the scope is used, then umount drivers with specified ips
                                                                                                       // Otherwise, umount all drivers binding to the volume
    5:optional bool forceUmount //for csi
}
struct UmountDriverResponseThrift {
    1:i64 requestId,
    2:list<DriverIpTargetThrift> driverIpTarget
}

enum ScsiClientOperationExceptionThrift {
    ScsiClientHaveLaunchedVolumeExceptionThrift = 1,
    NetworkExceptionThrift = 2,
    VolumeLaunchingExceptionThrift = 3,
    VolumeUmountingExceptionThrift = 4
}

struct UmountScsiDriverRequestThrift {
    1:i64 requestId,
    2:i64 accountId,
    3:map<i64, i32> volumesForUmount,
    5:string scsiClientIp
}

struct UmountScsiDriverResponseThrift {
    1:i64 requestId,
    2: map<string, ScsiClientOperationExceptionThrift> error
}

struct ChangeDriverBoundVolumeRequest {
    1: i64 requestId,
    2: DriverKeyThrift driver,
    3: i64 newVolumeId
}
struct ChangeDriverBoundVolumeResponse {
    1: i64 requestId
}

struct GetPerformanceParameterRequestThrift {
   1: i64 requestId,
   2: i64 volumeId,
   3: i32 snapshotId,
   4: DriverTypeThrift driverType
}

struct GetPerformanceFromPyMetricsResponseThrift {
   1: i64 requestId,
   2: i64 volumeId,
   3: map<i64, i64> writeThroughput,
   4: map<i64, i64> readThroughput,
   5: map<i64, i64> readIoPs,
   6: map<i64, i64> writeIoPs,
   7: i64 writeLatency,
   8: i64 readLatency,
}

struct GetStoragePerformanceParameterRequestThrift {
   1: i64 requestId,
   2: i64 domainId,
   3: i64 storageId
}

struct GetStoragePerformanceFromPyMetricsResponseThrift {
   1: i64 requestId,
   2: i64 storageId,
   3: i64 domainId,
   4: map<i64, i64> writeThroughput,
   5: map<i64, i64> readThroughput,
   6: map<i64, i64> readIoPs,
   7: map<i64, i64> writeIoPs,
   8: i64 writeLatency,
   9: i64 readLatency
}

struct GetPerformanceResponseThrift {
   1: i64 requestId,
   2: i64 volumeId,
   3: i64 writeThroughput,
   4: i64 readThroughput,
   5: i64 readIoPs,
   6: i64 writeIoPs,
   7: i64 writeLatency,
   8: i64 readLatency,
}

struct GetPerformanceParameterResponseThrift {
   1: i64 requestId,
   2: i64 volumeId,
   3: i64 readCounter,
   4: i64 writeCounter,
   5: i64 readDataSizeBytes,
   6: i64 writeDataSizeBytes,
   7: i64 readLatencyNs,
   8: i64 writeLatencyNs,
   9: i64 recordTimeIntervalMs,
}

struct GetCapacityRecordRequestThrift {
   1: i64 requestId,
   2: i64 accountId;
}

struct GetCapacityRecordResponseThrift {
   1: i64 requestId,
   2: CapacityRecordThrift capacityRecord
}

struct CreateDefaultDomainAndStoragePoolRequestThrift {
   1: i64 requestId,
   2: i64 accountId
}

struct CreateDefaultDomainAndStoragePoolResponseThrift {
   1: i64 requestId
}


//********** Start of setting configuration ************/
struct SetConfigurationsRequest {
  1:i64 requestId,
  2:map<string, string> configurations
}

struct SetConfigurationsResponse {
  1:i64 requestId,
  // if a configuration is set successfully, the value of the map is "ok", otherwise the value is "the failure reason"
  2:map<string, string> results
}

//********** Start of getting configuration ************/
struct GetConfigurationsRequest {
  1:i64 requestId,
  2:optional set<string> keys
}

struct GetConfigurationsResponse {
  1:i64 requestId,
  // if a configuration is set successfully, the value of the map is "ok", otherwise the value is "the failure reason"
  2:map<string, string> results
}



//******** start of disk lauching ********************/
struct OnlineDiskRequest {
  1: i64 requestId,
  2: i64 accountId,
  3: InstanceMetadataThrift instance
  4: ArchiveMetadataThrift onlineArchive
}
struct OnlineDiskResponse {
  1: i64 requestId
}

struct DegradeDiskRequest {
  1: i64 requestId,
  2: i64 archiveId;
}

struct DegradeDiskResponse {
  1: i64 requestId;
}

struct OfflineDiskRequest {
  1: i64 requestId,
  2: i64 accountId,
  3: InstanceMetadataThrift instance,
  4: ArchiveMetadataThrift offlineArchive
}
struct OfflineDiskResponse {
  1: i64 requestId
}

struct SettleArchiveTypeRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: i64 archiveId,
    4: string devName,  // the device name
    5: InstanceMetadataThrift instance,
    6: list<ArchiveTypeThrift> archiveTypes
}
struct SettleArchiveTypeResponse {
    1: i64 requestId
}
//********** for test only***************************/
struct SetIoErrorRequest {
  1: i64 requestId,
  2: i64 archiveId,
  3: i32 errorCount,
  4: optional ArchiveTypeThrift archiveType
}

struct SetIoErrorResponse {
  1: i64 requestId
}

struct SetArchiveConfigRequest {
  1: i64 archiveId,
  2: optional i64 instanceId,
  3: optional i32 groupId,
  4: optional i64 segmentSize,
  5: optional i32 pageSize,
  6: i64 requestId
}


struct SetArchiveConfigResponse {
  1: i64 requestId
}
//********* end of disk launching *****************/


//******** domain begin **********************/
struct CreateDomainRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:DomainThrift domain;
}
struct CreateDomainResponse {
    1:i64 requestId,
    2:DomainThrift domainThrift,
    3:optional list<i64> addedDatanodes
}
struct UpdateDomainRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:DomainThrift domain;
}
struct UpdateDomainResponse {
    1:i64 requestId,
    2:optional list<i64> addedDatanodes
}
struct RemoveDatanodeFromDomainRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:i64 domainId,
    4:i64 datanodeInstanceId
}
struct RemoveDatanodeFromDomainResponse {
    1:i64 requestId,
    2:string domainName
}
struct DeleteDomainRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:i64 domainId;
}
struct DeleteDomainResponse {
    1:i64 requestId,
    2:string domainName,
    3:optional list<i64> removedDatanode
}
struct ListDomainRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:optional list<i64> domainIds
}
struct OneDomainDisplayThrift {
    1: DomainThrift domainThrift,
    2: list<InstanceMetadataThrift> datanodes
}
struct ListDomainResponse {
    1:i64 requestId,
    2:list<OneDomainDisplayThrift> domainDisplays
}
//******* domain end ************************/


//******* storagepool begin *****************/
struct CreateStoragePoolRequestThrift {
    1:i64 requestId,
    2:i64 accountId,
    3:StoragePoolThrift storagePool
}
struct CreateStoragePoolResponseThrift {
    1:i64 requestId,
    2:StoragePoolThrift storagePoolThrift,
    3:optional map<i64, list<i64>> datanodeMapAddedArchives
}
struct UpdateStoragePoolRequestThrift {
    1:i64 requestId,
    2:i64 accountId,
    3:StoragePoolThrift storagePool
}
struct UpdateStoragePoolResponseThrift {
    1:i64 requestId,
    2:optional map<i64, list<i64>> datanodeMapAddedArchives
}
struct RemoveArchiveFromStoragePoolRequestThrift {
    1:i64 requestId,
    2:i64 accountId,
    3:i64 datanodeInstanceId,
    4:i64 archiveId,
    5:i64 domainId,
    6:i64 storagePoolId
}
struct RemoveArchiveFromStoragePoolResponseThrift {
    1:i64 requestId,
    2:string storagePoolName
}
struct DeleteStoragePoolRequestThrift {
    1:i64 requestId,
    2:i64 accountId,
    3:i64 domainId,
    4:i64 storagePoolId
}
struct DeleteStoragePoolResponseThrift {
    1:i64 requestId,
    2:string storagePoolName,
    3:optional map<i64, list<i64>> datanodeMapRemovedArchiveIds
}
struct ListStoragePoolRequestThrift {
    1:i64 requestId,
    2:i64 accountId,
    3:optional i64 domainId,
    4:optional list<i64> storagePoolIds
}
struct OneStoragePoolDisplayThrift {
    1: StoragePoolThrift storagePoolThrift,
    2: list<ArchiveMetadataThrift> archiveThrifts
}
struct ListStoragePoolResponseThrift {
    1:i64 requestId,
    2:list<OneStoragePoolDisplayThrift> storagePoolDisplays
}
//****** storagepool end ******************/

//****** add set or free archives and datanode ******/
struct SetDatanodeDomainRequestThrift {
    1:i64 requestId,
    2:i64 domainId
}
struct SetDatanodeDomainResponseThrift {
    1:i64 requestId
}
struct FreeDatanodeDomainRequestThrift {
    1:i64 requestId
}
struct FreeDatanodeDomainResponseThrift {
    1:i64 requestId
}

struct SetArchiveStoragePoolRequestThrift {
    1:i64 requestId,
    2:map<i64, i64> archiveIdMapStoragePoolId
}
struct SetArchiveStoragePoolResponseThrift {
    1:i64 requestId
}
struct FreeArchiveStoragePoolRequestThrift {
    1:i64 requestId,
    2:list<i64> freeArchiveList
}
struct FreeArchiveStoragePoolResponseThrift {
    1:i64 requestId
}
//****** end set or free archives and datanode ******/


//******************** storage pool capacity begin ****************/
struct StoragePoolCapacityThrift {
    1:i64 domainId,
    2:i64 storagePoolId,
    3:string storagePoolName,
    4:i64 freeSpace,
    5:i64 totalSpace,
    6:i64 usedSpace
}

struct ListStoragePoolCapacityRequestThrift {
    1:i64 requestId,
    2:i64 accountId,
    3:i64 domainId,
    4:optional list<i64> storagePoolIdList
}
struct ListStoragePoolCapacityResponseThrift {
    1:i64 requestId,
    2:list<StoragePoolCapacityThrift> storagePoolCapacityList
}

//******************** storage pool capacity end ******************/


//******************** operation begin ****************/
struct OperationThrift {
    1:  i64 operationId,
    2:  i64 targetId,
    3:  string operationTarget,
    4:  i64 startTime,
    5:  i64 endTime,
    6:  string description,
    7:  string status,
    8:  i64 progress,
    9:  string errorMessage,
    10: i64 accountId,
    11: string operationType,
    12: string targetName,
    13: i64 targetSourceSize,
    14: list<string> endPointListString,
    15: i32 snapshotId,
    16: string accountName,
    17: string operationObject
}

struct ListOperationsRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: optional list<i64> operationIds,
    4: optional string accountName,
    5: optional string operationType,
    6: optional string targetType,
    7: optional string targetName,
    8: optional string status,
    9: optional i64 startTime,
    10: optional i64 endTime
}
struct ListOperationsResponse {
    1:i64 requestId,
    2:list<OperationThrift> operationList
}

//******************** operation end ******************/
struct DiskSmartInfoThrift{
    1: string id,
    2: string attributeNameEn,
    3: string attributeNameCn,
    4: string flag,
    5: string value,
    6: string worst,
    7: string thresh,
    8: string type,
    9: string updated,
    10: string whenFailed,
    11: string rawValue;
}

struct HardDiskInfoThrift{
    1: string name,
    2: optional string ssdOrHdd,
    3: optional string vendor,
    4: optional string model,
    5: optional string sn,
    6: optional i64 rate,
    7: optional string size,
    8: optional string wwn,
    9: optional string controllerId,
    10: optional string slotNumber,
    11: optional string enclosureId,
    12: optional string cardType,
    13: optional string swith,
    14: optional string serialNumber,
    15: optional string id,
    16: optional list<DiskSmartInfoThrift> smartInfo,
}

struct SensorInfoThrift{
    1: string name,
    2: string value,
    3: string status
}

struct ServerNodeThrift{
    1: string serverId,
    2: string hostName,
    3: string modelInfo,
    4: string cpuInfo,
    5: string memoryInfo,
    6: string diskInfo,
    7: string networkCardInfo,
    8: string networkCardInfoName,
    9: string manageIp,
    10: string gatewayIp,
    11: string storeIp,
    12: string rackNo,
    13: string slotNo,
    14: string status,
    15: string childFramNo,
    16: set<HardDiskInfoThrift> diskInfoSet,
    17: DatanodeStatusThrift datanodeStatus,
    18: set<SensorInfoThrift> sensorInfos
}

struct ReportServerNodeInfoRequestThrift{
    1: i64 requestId,
    2: string serverId,
    3: string hostName,
    4: optional string modelInfo,
    5: optional string cpuInfo,
    6: optional string memoryInfo,
    7: optional string diskInfo,
    8: optional string networkCardInfo,
    9: optional string networkCardInfoName,
    10: optional set<HardDiskInfoThrift> hardDisks,
    11: optional string manageIp,
    12: optional string gatewayIp,
    13: optional string storeIp,
    14: optional string rackNo,
    15: optional string slotNo,
    16: optional set<SensorInfoThrift> sensorInfos,
}

struct ReportServerNodeInfoResponseThrift{
    1: i64 responseId
}

struct UpdateServerNodeRequestThrift {
    1: i64 requestId,
    2: string serverId,
    3: optional string modelInfo,
    4: optional string cpuInfo,
    5: optional string memoryInfo,
    6: optional string diskInfo,
    7: optional string networkCardInfo,
    8: optional string networkCardInfoName,
    9: optional string manageIp,
    10: optional string gatewayIp,
    11: optional string storeIp,
    12: optional string rackNo,
    13: optional string slotNo,
    14: optional string childFramNo,
    15: i64 accountId,
    16: string hostname
}

struct UpdateServerNodeResponseThrift {
    1: i64 responseId
}

struct DeleteServerNodesRequestThrift {
    1: i64 accountId,
    2: i64 requestId,
    3: list<string> serverIds
}

struct DeleteServerNodesResponseThrift {
    1: i64 responseId,
    2: list<string> deletedServerNodeHostnames
}

struct ListServerNodesRequestThrift {
    1: i64 requestId,
    2: i32 limit,
    3: optional i32 page,
    4: optional string sortField,
    5: optional string sortDirection,
    6: optional string hostName,
    7: optional string modelInfo,
    8: optional string cpuInfo,
    9: optional string memoryInfo,
    10: optional string diskInfo,
    11: optional string networkCardInfo,
    12: optional string manageIp,
    13: optional string gatewayIp,
    14: optional string storeIp,
    15: optional string rackNo,
    16: optional string slotNo,
    17: i64 accountId
}
struct ListServerNodesResponseThrift {
    1: i64 responseId
    2: i32 recordsTotal,
    3: i32 recordsAfterFilter,
    4: list<ServerNodeThrift> serverNodesList
}

struct ListServerNodeByIdRequestThrift {
    1: i64 requestId,
    2: string serverId
}
struct ListServerNodeByIdResponseThrift {
    1: i64 responseId,
    2: ServerNodeThrift serverNode
}

struct GetDiskSmartInfoRequestThrift {
    1: i64 requestId,
    2: string serverId,
    3: string diskName,
}

struct GetDiskSmartInfoResponseThrift {
    1: i64 requestId,
    2: list<DiskSmartInfoThrift> smartInfo
}

struct UpdateDiskLightStatusByIdRequestThrift {
    1: i64 requestId,
    2: string diskId,
    3: string status
}
struct UpdateDiskLightStatusByIdResponseThrift {
    1: i64 responseId
}

struct TurnOffAllDiskLightByServerIdRequestThrift {
    1: i64 requestId,
    2: string serverId
}

struct TurnOffAllDiskLightByServerIdResponseThrift {
    1: i64 responseId,
}

struct GetIoLimitationRequestThrift {
    1: i64 requestId,
    2: i64 driverContainerId,
}
struct GetIoLimitationResponseThrift {
    1: i64 requestId,
    2: i64 driverContainerId,
    3: map<DriverKeyThrift, list<IoLimitationThrift>> mapDriver2ItsIoLimitations,
}

struct GetIoLimitationByDriverRequestThrift {
    1: i64 requestId,
    2: DriverKeyThrift driverKeyThrift,
}
struct GetIoLimitationByDriverResponseThrift {
    1: i64 requestId,
    2: list<IoLimitationThrift> ioLimitationsList,
}

enum WeekDaythrift {
    SUN=0,
    MON=1,
    TUE=2,
    WED=3,
    THU=4,
    FRI=5,
    SAT=6,
}

struct AbsoluteTimethrift {
    1: i64 id,
    2: i64 beginTime,
    3: i64 endTime,
    4: set<WeekDaythrift> weekDay,
}

struct RelativeTimethrift {
    1: i64 waitTime,
}

struct RebalanceRulethrift {
    1: i64 ruleId,
    2: string ruleName,
    3: list<AbsoluteTimethrift> absoluteTimeList,          //can set (0-n) absolute time
    4: RelativeTimethrift relativeTime,                    //can set up at most one relative time, and waitTime must >= 1min
}

struct AddRebalanceRuleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: RebalanceRulethrift rule,
}

struct UpdateRebalanceRuleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: RebalanceRulethrift rule,
}

struct ApplyRebalanceRuleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: RebalanceRulethrift rule,
    4: list<i64> storagePoolIdList,
}

struct UnApplyRebalanceRuleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: RebalanceRulethrift rule,
    4: list<i64> storagePoolIdList,
}

struct GetRebalanceRuleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<i64> ruleIdList,
}
struct GetRebalanceRuleResponse {
    1: i64 requestId,
    2: list<RebalanceRulethrift> rules,
}
struct GetAppliedRebalanceRulePoolRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: i64 ruleId,
}
struct GetAppliedRebalanceRulePoolResponse {
    1: i64 requestId,
    2: list<StoragePoolThrift> StoragePoolList;
}
struct GetUnAppliedRebalanceRulePoolRequest {
    1: i64 requestId,
    2: i64 accountId,
}
struct GetUnAppliedRebalanceRulePoolResponse {
    1: i64 requestId,
    2: list<StoragePoolThrift> StoragePoolList;
}
struct DeleteRebalanceRuleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<i64> ruleIdList,
}
struct DeleteRebalanceRuleResponse {
    1: i64 requestId,
    2: list<RebalanceRulethrift> failedRuleIdList,
}

//******just for test begin *****//
struct CleanOperationInfoRequest {
    1: i64 requestId,
}
struct CleanOperationInfoResponse {
    1: i64 requestId,
}

struct InstanceIncludeVolumeInfoRequest {
    1: i64 requestId,
}
struct InstanceIncludeVolumeInfoResponse {
    1: i64 requestId,
    2: map<i64, set<i64>> instanceIncludeVolumeInfo
}

struct EquilibriumVolumeRequest {
    1: i64 requestId,
    2: bool status
}
struct EquilibriumVolumeResponse {
    1: i64 requestId,
}

//******just for test  end *****//

// All general exceptions
exception GenericExceptionThrift {
  1: bool isClientIssue,
  2: string reason
}

exception TransportExceptionThrift {
  1: string detail
}

// Client side issues
exception InvalidParameterValueExceptionThrift {
  1: optional byte errorCode,
  2: optional string detail
}

exception ChecksumMismatchedExceptionThrift {
  1: optional string detail
}

exception StaleMembershipExceptionThrift {
  1: SegmentMembershipThrift latestMembership,
  2: optional string detail
}

exception InvalidMembershipExceptionThrift {
  1: SegmentMembershipThrift latestMembership,
  2: optional string detail
}

exception ReceiverStaleMembershipExceptionThrift {
  1: optional string detail
}

exception SnapshotVersionMismatchExceptionThrift {
  1: binary mySnapshotManagerInBinary,
  2: optional string detail
}

exception VolumeSizeNotMultipleOfSegmentSizeThrift {
  1: i64 segmentSize,
  2: optional string detail
}

exception VolumeSizeIllegalExceptionThrift {
  1: optional string detail
}

exception LeaseExpiredExceptionThrift {
  1: optional string detail
}

exception PrimaryExistsExceptionThrift {
  1: SegmentMembershipThrift membership,
  2: optional string detail
}

exception NotPrimaryExceptionThrift {
  1: SegmentMembershipThrift membership,
  2: optional SegmentUnitStatusThrift myStatus,
  3: optional string detail
}

exception NotSecondaryExceptionThrift {
  1: SegmentMembershipThrift membership,
  2: optional SegmentUnitStatusThrift myStatus,
  3: optional string detail
}

exception YouAreNotInMembershipExceptionThrift {
  1: SegmentMembershipThrift membership,
  2: optional string detail
}

exception YouAreNotInRightPositionExceptionThrift {
  1: SegmentMembershipThrift membership,
  2: optional string detail
}

exception YouAreNotReadyExceptionThrift {
  1: i64 logId,
  2: optional string detail
}

exception LogIdTooSmallExceptionThrift {
  1: i64 latestLogId,
  2: SegmentMembershipThrift membership,
  3: optional string detail
}

exception NotEnoughSpaceExceptionThrift {
  1: optional string detail
}

exception NotEnoughGroupExceptionThrift {
    1: i32 minGroupsNumber,
    2: optional string detail
}
exception NotEnoughNormalGroupExceptionThrift {
    1: i32 minGroupsNumber,
    2: optional string detail
}

exception MemberShipChangedExceptionThrift {
  1: optional string detail
}

exception SegmentExistingExceptionThrift {
  1: optional string detail
}

exception SegmentOfflinedExceptionThrift {
  1: optional string detail
}

exception SegmentUnitBeingDeletedExceptionThrift {
  1: optional string detail
}

exception NoMemberExceptionThrift {
  1: optional string detail
}

exception VolumeNotFoundExceptionThrift {
  1: optional string detail
}

exception VolumeInDeleteVolumeDelayExceptionThrift {
  1: optional string detail
}

exception VolumeUnderOperationExceptionThrift {
  1: optional string detail
}


exception SnapshotRollingBackExceptionThrift {
  1: optional string detail
}

exception DriverLaunchingExceptionThrift {
  1: optional string detail
}

exception DriverUnmountingExceptionThrift {
  1: optional string detail
}

exception VolumeDeletingExceptionThrift {
  1: optional string detail
}

exception VolumeCyclingExceptionThrift {
  1: optional string detail
}

exception VolumeMarkReadWriteExceptionThrift {
  1: optional string detail
}

exception VolumeExtendExceptionThrift {
  1: optional string detail
}

exception VolumeInMoveExceptionThrift {
  1: optional string detail
}

exception VolumeInMoveOnlineExceptionThrift {
  1: optional string detail
}

exception VolumeInCopyExceptionThrift {
  1: optional string detail
}

exception VolumeInCloneExceptionThrift {
  1: optional string detail
}

exception VolumeInUpdateActionExceptionThrift {
  1: optional string detail
}

exception VolumeInReportExceptionThrift {
  1: optional string detail
}

exception CoordinatorSyncExceptionThrift {
  1: optional string detail
}

exception NotRootVolumeExceptionThrift {
  1: optional string detail
}

exception ServiceHavingBeenShutdownThrift {
  1: optional string detail
}

exception ResourceExhaustedExceptionThrift{
  1: optional string detail
}

exception OperationNotFoundExceptionThrift {
    1: optional string detail
}

exception DriverFromRequestNotFoundExceptionThrift {
    1: optional string detail
}

exception VolumeInMoveOnlineDoNotHaveOperationExceptionThrift {
    1: optional string detail
}

/* when the service has an unknown internal error.
 * TException is supposed to be used, but the client throws IoException when the service returns TException.
 * Therefore, we explicitly define this exception.
 */
exception InternalErrorThrift {
  1: optional string detail
}

exception VolumeNotAvailableExceptionThrift {
  1: optional string detail
}

/**
 * When launch driver with specified amount which is lagger than amount of existing available driver containers,
 * drivers cannot be launched because lack of driver containers, exception {@link TooManyDriversExceptionThrift}
 * should be thrown out.
 */
exception TooManyDriversExceptionThrift {
  1: optional string detail
}

exception NoDriverLaunchExceptionThrift {
  1: optional string detail
}

exception InvalidInputExceptionThrift {
  1: optional string detail
}

exception VolumeExistingExceptionThrift {
  1: optional string detail
}

exception AccessDeniedExceptionThrift {
  1: optional string detail
}

exception OlderPasswordIncorrectExceptionThrift {
    1: optional string detail
}

exception InsufficientPrivilegeExceptionThrift {
    1: optional string detail
}

exception VolumeWasLaunchingExceptionThrift {
  1: optional string detail
}

exception VolumeWasRollbackingExceptionThrift {
  1: optional string detail
}

exception VolumeWasCloneingExceptionThrift {
  1: optional string detail
}

exception StorageEmptyExceptionThrift {
  1: optional string detail
}

/**
 * This exception throws when send a launching driver request to
 * launch driver over volume which is already binding a driver
 * before or delete volume still binding a driver. In a word, when
 * process some operation with no existing driver, but the driver existing
 *
 */
exception ExistsDriverExceptionThrift {
  1: optional string detail
}

/**
 * When request to umount driver and exists some client using the driver, throws this exception
 * to refuse the request. Of course other operation depends on no clients would be refused if
 * there are some clients by throw this exception.
 */
exception ExistsClientExceptionThrift {
  1: optional string detail
}

/**
 * When request to launch driver with driver type different from
 * driver type of existing drivers, throw this exception to refuse
 * the request because the case is not allowed in system.
 */
exception DriverTypeConflictExceptionThrift {
  1: optional string detail
}

/**
 *system memory is not enough for doing something
 */
exception SystemMemoryIsNotEnoughThrift {
  1: optional string detail
}

/**
 *system cpu is not enough for doing something
 */
exception SystemCpuIsNotEnoughThrift {
  1: optional string detail
}

/**
 *set driver host error
 */
exception DriverAmountAndHostNotFitThrift{
 1: optional string detail
}

exception DriverHostCannotUseThrift{
 1: optional string detail
}

/**
 * When request to umount driver which is still launching, refuse the request
 * by throwing this exception.
 */
exception DriverIsLaunchingExceptionThrift {
  1: optional string detail
}

exception DriverLaunchFailedExceptionThrift {
  1: optional string detail
}

exception UnknownIpv4HostExceptionThrift {
  1: optional string detail
}

exception UnknownIpv6HostExceptionThrift {
  1: optional string detail
}

exception DriverIsUpgradingExceptionThrift {
  1: optional string detail
}

exception DriverStillReportExceptionThrift {
  1: optional string detail
}

exception ChangeDriverBoundVolumeFailedThrift {
  1: optional string detail
}

/**
* The exception throws when driverType from launchRequest conflict with exist driverType in driverStore.
* At a volume ,iscsi type driver with pyd type driver (iscsi with iscsi ,pyd with pyd) is conflict.
**/
exception DriverTypeIsConflictExceptionThrift {
  1: optional string detail
}

exception DriverNameExistsExceptionThrift {
  1: optional string detail
}


exception DriverContainerIsIncExceptionThrift {
  1: optional string detail
}

exception FailedToUmountDriverExceptionThrift {
  1: optional string detail,
}

exception InstanceNotExistsExceptionThrift {
  1: optional string detail
}

exception InstanceHasFailedAleadyExceptionThrift {
  1: optional string detail
}

exception ExceedUserMaxCapacityExceptionThrift {
  1: i64 userMaxCapacityBytes,
  2: optional string detail
}

exception VolumeHasNotBeenLaunchedExceptionThrift {
  1: optional string detail
}

exception VolumeLaunchMultiDriversExceptionThrift {
  1: optional string detail
}

exception VolumeCanNotLaunchMultiDriversThisTimeExceptionThrift {
  1: optional string detail
}

exception ReadPerformanceParameterFromFileExceptionThrift {
  1: optional string detail
}

exception VolumeBeingDeletedExceptionThrift {
  1: optional string detail
}

exception RootVolumeBeingDeletedExceptionThrift {
  1: optional string detail
}

exception RootVolumeNotFoundExceptionThrift {
  1: optional string detail
}

exception VolumeNameExistedExceptionThrift {
  1: optional string detail
}

exception VolumeAccessRuleDuplicateThrift {
  1: optional string detail
}

exception VolumeInExtendingExceptionThrift {
  1: optional string detail
}

exception VolumeOriginalSizeNotMatchExceptionThrift {
  1: optional string detail
}

exception InvalidGroupExceptionThrift {
  1: optional string detail
}

exception DomainExistedExceptionThrift {
  1: optional string detail
}

exception DomainNameExistedExceptionThrift {
  1: optional string detail
}

exception DomainNotExistedExceptionThrift {
  1: optional string detail
}

exception DomainIsDeletingExceptionThrift {
  1: optional string detail
}

exception InstanceIsSubHealthExceptionThrift {
   1:optional list<InstanceMetadataThrift> instanceMetadata,
   2: optional string detail
}
exception DatanodeNotFreeToUseExceptionThrift {
  1: optional string detail
}

exception DatanodeNotFoundExceptionThrift {
  1: optional string detail
}

exception DatanodeTypeNotSetExceptionThrift {
  1: optional string detail
}

exception StillHaveStoragePoolExceptionThrift {
  1: optional string detail
}

exception FailToRemoveDatanodeFromDomainExceptionThrift {
  1: optional string detail
}

exception StoragePoolExistedExceptionThrift {
  1: optional string detail
}

exception StoragePoolNameExistedExceptionThrift {
  1: optional string detail
}

exception StoragePoolNotExistedExceptionThrift {
  1: optional string detail
}

exception StoragePoolIsDeletingExceptionThrift {
  1: optional string detail
}

exception ArchiveNotFreeToUseExceptionThrift {
  1: optional string detail
}

exception ArchiveNotFoundExceptionThrift {
  1: optional string detail
}

exception StillHaveVolumeExceptionThrift {
  1: optional string detail
}

exception FailToRemoveArchiveFromStoragePoolExceptionThrift {
  1: optional string detail
}

exception DatanodeIsUsingExceptionThrift {
  1: optional string detail
}

exception LackDatanodeExceptionThrift{
    1:optional string detail,
    2:i64   instanceId
}

exception FrequentFixVolumeRequestThrift{
    1:optional string detail,
}

exception ArchiveIsUsingExceptionThrift {
  1: optional string detail
}

exception StoragePoolNotExistInDoaminExceptionThrift {
  1: optional string detail
}

exception LaunchedVolumeCannotBeDeletedExceptionThrift {
  1: optional string detail,
  2: bool isDriverUnknown
}

exception LaunchedVolumeCannotRollbackExceptionThrift {
  1: optional string detail
}

exception VolumeCannotBeRecycledExceptionThrift {
  1: optional string detail
}

exception VolumeIsCloningExceptionThrift {
  1: optional string detail
}

exception OriVolumeCanNotFoundExceptionThrift {
  1: optional string detail
}

exception DestVolumeCanNotFoundExceptionThrift {
  1: optional string detail
}

exception OriVolumeNotAvailableExceptionThrift {
  1: optional string detail
}

exception DestVolumeNotAvailableExceptionThrift {
  1: optional string detail
}

exception DestVolumeSmallerThanOriVolumeExceptionThrift {
  1: optional string detail
}

exception DestVolumeIsCopyingExceptionThrift {
  1: optional string detail
}

exception ServerNodeIsUnknownThrift {
    1: optional string detail
}

exception ServerNodeNotExistExceptionThrift {
    1: optional string detail
}

exception DiskSizeCanNotSupportArchiveTypesThrift {
        1: optional string detail
}

exception DiskNameIllegalExceptionThrift {
    1: optional string detail
}

/**    exception for move volume **/
exception VolumeIsBeginMovedExceptionThrift {
  1: optional string detail
}

exception VolumeIsMovingExceptionThrift {
  1: optional string detail
}

/**    exception for scsi volume **/
exception ScsiClientIsExistExceptionThrift {
  1: optional string detail
}

exception ScsiClientIsNotOkExceptionThrift {
  1: optional string detail
}

exception ScsiVolumeLockExceptionThrift {
  1: optional string detail
}

/**    exception for volume Recycle table **/
exception VolumeInRecycleTableExceptionThrift {
  1: optional string detail
}

/*
 * dynamic set parameters
 */
struct ConfigServiceRequestThrift {
    1: i64 requestId,
    2: map<string, string> configuration
}

struct ConfigServiceResponseThrift {
    1: i64 requestId,
    2: map<string, string> invalidConfiguration
}

struct ViewServiceConfigurationRequestThrift {
    1: i64 requestId
}

struct ViewServiceConfigurationResponseThrift {
    1: i64 requestId,
    2: map<string, string> configuration
}

struct HeartbeatDisableRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i32 segIndex
}

struct HeartbeatDisableResponse {
   1: i64 requestId
}


struct WriteMutationLogsDisableRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i32 segIndex
}

struct RemoveUncommittedLogsExceptForThoseGivenRequest {
   1: i64 requestId,
   2: SegIdThrift segId,
   3: list<i64> givenLogIds
}

struct RemoveUncommittedLogsExceptForThoseGivenResponse {
   1: i64 requestId,
   2: SegIdThrift segId,
   3: list<i64> deletedLogIds
}

struct WriteMutationLogsDisableResponse {
   1: i64 requestId
}

/* check driver connect permission begin */
struct GetDriverConnectPermissionRequestThrift {
   1: i64 requestId,
   2: i64 driverContainerId,
   3: i64 volumeId,
   4: i32 snapshotId,
   5: DriverTypeThrift driverType;
}

struct GetDriverConnectPermissionResponseThrift {
   1: i64 requestId,
   2: map<string, AccessPermissionTypeThrift> connectPermissionMap;
}
/* check driver connect permission end */

/* iscsi chap control begin */
struct SetIscsiChapControlRequestThrift {
   1: i64 requestId,
   /* use driverkey */
   2: i64 driverContainerId,
   3: i64 volumeId,
   4: i32 snapshotId,
   5: DriverTypeThrift driverType,
   /* 0:disable  1:enable */
   6: i32 chapControl;
}

struct SetIscsiChapControlResponseThrift {
   1: i64 requestId;
}
/* iscsi chap control end */

struct ShowIoRequestThrift {
   1:i64 requestId,
}

struct IoInformationThrift {
   1:i64 oriId,
   2:i32 sendCount,
   3:i32 responseCount,
   4:i64 spendTime,
   5:i32 sendTimes;
}

struct PageMigrationSpeedInfoThrift {
   1: i64 maxMigrationSpeed
}

struct ShowIoResponseThrift {
   1:i64 requestId,
   2:list<IoInformationThrift> readNotResponseList,
   3:list<IoInformationThrift> writeNotResponseList;
}

// account manager begin
enum AccountTypeThrift {
   SuperAdmin = 1,
   Admin = 2,
   Regular = 3
}

struct ApiToAuthorizeThrift {
    1:string apiName,
    2:string category,
    3:string chineseText,
    4:string englishText;
}

struct RoleThrift {
    1: i64 id,
    2: string name,
    3: string description,
    4: set<ApiToAuthorizeThrift> permissions,
    5: bool builtIn,
    6: bool superAdmin;
}

struct ResourceThrift {
    1: i64 resourceId,
    2: string resourceName,
    3: string resourceType,
}

struct AccountMetadataThrift {
    1: i64 accountId,
    2: string accountName,
    3: AccountTypeThrift accountType,
    4: set<RoleThrift> roles,
    5: set<ResourceThrift> resources;
}

struct AccountMetadataBackupThrift {
    1: i64 accountId,
    2: string accountName,
    3: string hashedPassword,
    4: string salt,
    5: string accountType,
    6: set<RoleThrift> roles,
    7: set<ResourceThrift> resources,
    8: i64 createdAt;
}

struct CreateAccountRequest {
   1: string accountName,
   2: string password,
   3: AccountTypeThrift accountType,
   4: i64 accountId,
   5: optional i64 creatingAccountId,
   6: set<i64> roleIds;
}
struct CreateAccountResponse {
    1: i64 accountId,
    2: string accountName
}

struct DeleteAccountsRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: set<i64> deletingAccountIds;
}
struct DeleteAccountsResponse {
    1: i64 requestId,
    2: set<i64> deletedAccountIds;
}

struct UpdatePasswordRequest {
   1:string accountName,
   2:string oldPassword,
   3:string newPassword,
   4:i64 accountId;
}
struct UpdatePasswordResponse {
   1:i64 accountId,
}

struct ListAccountsRequest {
    1: i64 accountId,
    2: optional set<i64> listAccountIds;
}
struct ListAccountsResponse {
    1: list<AccountMetadataThrift> accounts;
}

struct AuthenticateAccountRequest {
    1:string accountName,
    2:string password
}
struct AuthenticateAccountResponse {
    1:i64 accountId,
    2:string accountName,
    3:AccountTypeThrift accountType,
    4:list<RoleThrift> roles,
    5:list<ApiToAuthorizeThrift> apis
}

struct GetAccountRequest {
    1:i64 requestId,
    2:i64 accountId
}
struct GetAccountResponse {
    1:i64 requestId,
    2:AccountMetadataThrift accountMetadata
}

struct ResetAccountPasswordRequest {
	1:i64 requestId,
	2:i64 accountId,
	3:i64 targetAccountId,
	4:AccountTypeThrift accountType
}
struct ResetAccountPasswordResponse {
	1:i64 requestId,
	2:string password
}

struct ListResourcesRequest {
	1: i64 requestId,
	2: i64 accountId,
	3: optional set<i64> listResourceIds;
}
struct ListResourcesResponse {
	1: i64 requestId,
	2: list<ResourceThrift> resources;
}

struct AssignResourcesRequest {
	1: i64 requestId,
	2: i64 accountId,
	3: i64 targetAccountId,
	4: set<i64> resourceIds;
}
struct AssignResourcesResponse {
	1: i64 requestId;
}



struct listZookeeperServiceStatusRequest{
   1: i64 requestId,
   2: i64 accountId;
}

struct listZookeeperServiceStatusResponse{
   1:i64 requestId,
   2:list<ServiceIpStatusThrift> zookeeperStatusList
}

//********** report DB request & reponse *******/

struct ReportDbRequestThrift {
   1:i64 sequenceId,
   2:i64 instanceId,
   3:string endpoint,
   4:GroupThrift group,
   5:optional list<DomainThrift> domainThriftList,
   6:optional list<StoragePoolThrift> storagePoolThriftList,
   7:optional list<VolumeRuleRelationshipThrift> volume2RuleThriftList,
   8:optional list<VolumeAccessRuleThrift> accessRuleThriftList,
   9:optional list<IscsiRuleRelationshipThrift> iscsi2RuleThriftList,
   10:optional list<IscsiAccessRuleThrift> iscsiAccessRuleThriftList,
   11:optional list<CapacityRecordThrift> capacityRecordThriftList,
   14: optional list<AccountMetadataBackupThrift> accountMetadataBackupThriftList,
   15: optional list<RoleThrift> roleThriftList,
   16:optional list<ApiToAuthorizeThrift> apiThriftList,
   17:optional list<ResourceThrift> resourceThriftList,
   18:optional list<IoLimitationRelationShipThrift> ioLimitationRelationShipThriftList,
   19:optional list<IoLimitationThrift> ioLimitationThriftList,
   20:optional list<MigrationRuleRelationShipThrift> migrationRuleRelationShipThriftList,
   21:optional list<MigrationRuleThrift> migrationRuleThriftList,
   22:optional list<RebalanceRulethrift> rebalanceRuleThriftList,

   26:optional list<VolumeRecycleInformationThrift> volumeRecycleInformationThriftList,
   28:optional list<VolumeDeleteDelayInformationThrift> volumeDeleteDelayInformationThriftList

}

struct ReportDbResponseThrift {
   1:i64 sequenceId,
   2:optional list<DomainThrift> domainThriftList,
   3:optional list<StoragePoolThrift> storagePoolThriftList,
   4:optional list<VolumeRuleRelationshipThrift> volume2RuleThriftList,
   5:optional list<VolumeAccessRuleThrift> accessRuleThriftList,
   6:optional list<IscsiRuleRelationshipThrift> iscsi2RuleThriftList,
   7:optional list<IscsiAccessRuleThrift> iscsiAccessRuleThriftList,
   8:optional list<CapacityRecordThrift> capacityRecordThriftList,
   9:optional list<VolumeRecycleInformationThrift> volumeRecycleInformationThriftList,
   10:optional list<VolumeDeleteDelayInformationThrift> volumeDeleteDelayInformationThriftList,
   11:optional list<AccountMetadataBackupThrift> accountMetadataBackupThriftList,
   12: optional list<RoleThrift> roleThriftList,
   13:optional list<ApiToAuthorizeThrift> apiThriftList,
   14:optional list<ResourceThrift> resourceThriftList;
   15:optional list<IoLimitationRelationShipThrift> ioLimitationRelationShipThriftList,
   16:optional list<IoLimitationThrift> ioLimitationThriftList,
   17:optional list<MigrationRuleRelationShipThrift> migrationSpeedRelationShipThriftList,
   18:optional list<MigrationRuleThrift> migrationSpeedThriftList,
   19:optional list<RebalanceRulethrift> rebalanceRuleThriftList,
}
//*********** End *****************************/

//********** get database info ****************/
struct GetDbInfoRequestThrift {
   1:i64 requestId,
}

struct GetDbInfoResponseThrift {
   1:i64 requestId,
   2:ReportDbRequestThrift dbInfo,
}
//*********** End *****************************/

//*******let Inactive Second leave start**/

struct CheckSecondaryInactiveThresholdThrift{
   1:CheckSecondaryInactiveThresholdModeThrift mode;
   2:optional i64 startTime;
   3:optional i64 endTime;
   4:optional i64 waitTime;
   5:bool ignoreMissPagesAndLogs;
}


//*******let Inactive Second leave end**/

struct ChangeIoPathRequestThrift {
   1:i64 requestId,
   2:i64 newVolumeId,
   3:i32 snapshotId,
}

struct ChangeIoPathResponseThrift {
   1:i64 requestId,
}

struct ForceUpdateMembershipRequest {
  1:i64 requestId,
  2:SegIdThrift segId,
  3:SegmentMembershipThrift newMembership;
}

struct ForceUpdateMembershipResponse {
  1:i64 requestId,
}

exception AccountNotFoundExceptionThrift {
    1: optional string detail
}
exception AuthenticationFailedExceptionThrift {
    1: optional string detail
}
exception RoleNotExistedExceptionThrift {
    1: optional string detail
}
exception CrudBuiltInRoleExceptionThrift {
    1: optional string detail
}
exception CrudSuperAdminAccountExceptionThrift {
    1: optional string detail
}
exception ResourceNotExistsExceptionThrift {
    1: optional string detail
}
exception RoleIsAssignedToAccountsExceptionThrift {
    1: optional string detail
}
exception DeleteRoleExceptionThrift {
    1: map<string, string> failedRoleName2Cause
}
exception DeleteLoginAccountExceptionThrift {
    1: optional string detail
}

// account manager end

exception InvalidLicenseFileExceptionThrift {
    1: optional string detail
}

exception LicenseExistedExceptionThrift {
    1: optional string detail
}

exception NoLicenseExceptionThrift{
    1: optional string detail
}

exception BadLicenseTokenExceptionThrift {
    1: optional string detail
}

exception UselessLicenseExceptionThrift {
    1: optional string detail
}

exception NotEnoughLicenseTokenExceptionThrift {
    1: optional string detail
}

exception DiskNotFoundExceptionThrift {
    1: optional string detail
}

exception ArchiveTypeNotSupportExceptionThrift{
    1:optional string detail
}

exception DiskHasBeenOnlineThrift {
    1: optional string detail
}

exception DiskHasBeenOfflineThrift {
    1: optional string detail
}

exception DiskNotBrokenThrift {
    1: optional string detail
}

exception DiskNotMismatchConfigThrift {
    1: optional string detail
}

exception DiskIsBusyThrift {
    1: optional string detail
}

/**
 * Service is not available when its state is suspend,inc...
 * Any request sent to this service would receive this exception.
 */
exception ServiceIsNotAvailableThrift {
    1: optional string detail
}

exception ParametersIsErrorExceptionThrift {
    1:optional string detail
}


exception LimitationNotExistExceptionThrift {
    1: optional string detail
}

exception LimitationAlreadyExistExceptionThrift {
    1: optional string detail
}

exception AlreadyExistStaticLimitationExceptionThrift {
    1: optional string detail
}

exception DynamicIoLimitationTimeInterleavingExceptionThrift {
    1: optional string detail
}

exception ModificationTooLateExistExceptionThrift {
    1: optional string detail
}

exception DriverNotFoundExceptionThrift {
    1: optional string detail
}

exception TimeoutExceptionThrift {
    1: optional string detail
}

exception LoadVolumeExceptionThrift {
    1: optional string detail
}

exception ConnectionRefusedExceptionThrift {
    1: optional string detail
}

exception VolumeIsMarkWriteExceptionThrift {
    1: optional string detail
}

exception VolumeIsAppliedWriteAccessRuleExceptionThrift {
    1: optional string detail
}

exception VolumeIsConnectedByWritePermissionClientExceptionThrift {
    1: optional string detail
}

exception ApplyFailedDueToVolumeIsReadOnlyExceptionThrift {
    1: optional string detail
}

exception ApplyFailedDueToConflictExceptionThrift {
    1: optional string detail
}

exception PermissionNotGrantExceptionThrift {
    1: optional string detail
}

exception AccountAlreadyExistsExceptionThrift {
   1: optional string detail
}

exception ServerNodePositionIsRepeatExceptionThrift {
    1: optional string detail
}

exception PrimaryCandidateCantBePrimaryExceptionThrift {
  1: optional string deatil
}

exception SrcVolumeHaveDriverExceptionThrift {
  1: optional string detail
}

exception SrcVolumeDoesNotHaveExactOneDriverExceptionThrift {
  1: optional string detail
}

exception OriVolumeHasDriverWhenCopyExceptionThrift {
  1: optional string detail
}

exception DestVolumeHasDriverWhenCopyExceptionThrift {
  1: optional string detail
}

exception SegmentUnitCloningExceptionThrift {
    1: optional string detail
}

exception ArchiveManagerNotSupportExceptionThrift {
    1:ArchiveTypeThrift archiveType,
    2:optional string detail,
}

exception VolumeIsCopingExceptionThrift {
  1: optional string detail
}

exception EndPointNotFoundExceptionThrift {
  1: optional string detail
}

exception TooManyEndPointFoundExceptionThrift {
  1: optional string detail
}

exception NetworkErrorExceptionThrift {
  1: optional string detail
}

exception LicenseExceptionThrift {
  1: optional string detail
}

exception UnsupportedEncodingExceptionThrift {
  1: optional string detail
}

//********** end ***********/

//********** move online ***********/
exception MoveOnlineTheVolumeHasInitExceptionThrift {
  1: optional string detail
}

exception BuiltInMigrationRuleNotAllowedDeletedExceptionThrift{
  1: optional string detail
}

exception BuiltInMigrationRuleNotAllowedUpdatedExceptionThrift{
  1: optional string detail
}

//********** end ***********/

//********** rebalance ***********/
exception PoolAlreadyAppliedRebalanceRuleExceptionThrift {
  1: optional string detail,
  2: optional RebalanceRulethrift rebalanceRule,       //already applied rule
}

exception RebalanceRuleNotExistExceptionThrift {
  1: optional string detail,
}

exception RebalanceRuleExistingExceptionThrift {
  1: optional string detail,
}

//********** end ***********/
service DebugConfigurator{
   // Set new configuration values. There is a map within the request which store the existing configuration keys and their new value
   SetConfigurationsResponse setConfigurations(1:SetConfigurationsRequest request),
   // Get new configuration values. There is an optional list within the request which store the requested existing configuration keys
   // If the optional list is null or empty then all configurations are returned
   GetConfigurationsResponse getConfigurations(1:GetConfigurationsRequest request),

}
