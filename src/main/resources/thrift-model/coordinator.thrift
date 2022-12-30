
include "shared.thrift"
include "icshared.thrift"

/**
 * This thrift file defines coordinator service and its client
 */
namespace java py.thrift.coordinator.service

/**
 * Request coordinator to update volume information once done extending volume.
 */
struct UpdateVolumeOnExtendingRequest {
    1: i64 requestId,
    2: i64 volumeId,
    3: optional i64 accountId,
    4: optional i64 extendingSize,
}

struct UpdateVolumeOnExtendingResponse {
    1: i64 requestId
}

struct AddOrModifyLimitationRequest {
    1: i64 requestId,
    2: i64 volumeId,
    3: shared.IoLimitationThrift ioLimitation
}

struct AddOrModifyLimitationResponse {
    1: i64 requestId,
}

struct DeleteLimitationRequest {
    1: i64 requestId,
    2: i64 volumeId,
    3: i64 ioLimitationId
}

struct DeleteLimitationResponse {
    1: i64 requestId
}

/**
 * Slow down if you are not the coordinator of the volume with the given volume id
 */
struct SlowDownRequest {
    1: i64 requestId,
    2: i32 slowDownLevel,
    3: i64 volumeId
}

struct SlowDownResponse {
    1: i64 requestId,
}

struct ResetSlowLevelRequest {
    1: i64 requestId,
    2: i64 volumeId
}

struct ResetSlowLevelResponse {
    1: i64 requestId
}

struct ShutdownRequest {
    1: i64 requestId,
    2: bool graceful,
}

exception VersionTooOldExceptionThrift {
    1: i32 currentVersion
}

exception UnstableLeaderExceptionThrift {
}
struct GetStartupStatusRequest {
    1: i64 requestId,
    2: i64 volumeId,
    3: i32 snapshotId
}

struct GetStartupStatusResponse {
    1: i64 requestId,
    2: bool startupStatus
}

service Coordinator extends shared.DebugConfigurator {

   // Healthy?
   void ping(),

   //  Shutdown graceful or not
   void shutdown(1: ShutdownRequest request) throws (
                                             1:shared.ServiceHavingBeenShutdownThrift shbsd),


   // update volume information once done extending volume
   UpdateVolumeOnExtendingResponse updateVolumeOnExtending(1: UpdateVolumeOnExtendingRequest request),

   // modify limitation
   AddOrModifyLimitationResponse addOrModifyLimitation(1: AddOrModifyLimitationRequest request),

   // delete an limitation item
   DeleteLimitationResponse deleteLimitation(1: DeleteLimitationRequest request),

   // Slow down if you are not the coordinator of the volume with the given volume id
   SlowDownResponse slowDownExceptFor(1: SlowDownRequest request),

   // Reset the slow level
   ResetSlowLevelResponse resetSlowLevel(1: ResetSlowLevelRequest request),

   shared.ApplyVolumeAccessRulesToDriverResponse applyVolumeAccessRules(1:shared.ApplyVolumeAccessRulesToDriverRequest request) throws (
                                                                       1:shared.ServiceHavingBeenShutdownThrift shbsd),

   shared.CancelVolumeAccessRulesToDriverResponse cancelVolumeAccessRules(1:shared.CancelVolumeAccessRulesToDriverRequest request) throws (
                                                                          1:shared.ServiceHavingBeenShutdownThrift shbsd),

   shared.GetConnectClientInfoResponse getConnectClientInfo(1:shared.GetConnectClientInfoRequest request) throws (
                                                                          1:shared.ServiceHavingBeenShutdownThrift shbsd),

   shared.GetDriverConnectPermissionResponseThrift  getDriverConnectPermission(1:shared.GetDriverConnectPermissionRequestThrift request) throws (1:shared.ServiceHavingBeenShutdownThrift shbsd),

   GetStartupStatusResponse getStartupStatus(1:GetStartupStatusRequest request) throws (1:shared.ServiceHavingBeenShutdownThrift shbsd),
}

