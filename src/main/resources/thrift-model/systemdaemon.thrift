include "shared.thrift"
/**
 * This thrift defines a service interface for daemoncommon server
 */

namespace java py.thrift.systemdaemon.service

/**
 * ----------------------------------------------------requests&responses----------------------------------------------------
 */

struct QueryAllDisksRequest {
    1: i64 requestId;
}

struct DiskInfoThrift {
    1: string devName,
    2: string wwn,
    3: string controllerId,
    4: string slotNumber,
    5: string enclosureId,
    6: string cardType,
    7: string serialNumber,
    8: string diskType;
}

struct QueryAllDisksResponse{
    1: i64 responseId,
    2: set<DiskInfoThrift> disk;
}

struct QueryDesignateDiskRequest {
    1: i64 requestId,
    2: string diskName;
}

struct QueryDesignateDiskResponse{
    1: i64 responseId,
    2: DiskInfoThrift disk;
}

struct LightDesignateDiskOnRequest {
    1: i64 requestId,
    2: string diskName;
}

struct DiskLightReturnStatus {
    1: i32 retCode,
    2: string retMessage;
}

struct LightDesignateDiskOnResponse {
    1: i64 responseId,
    2: DiskLightReturnStatus returnStatus;
}

struct LightDesignateDiskOffRequest {
    1: i64 requestId,
    2: string diskName;
}

struct LightDesignateDiskOffResponse {
    1: i64 responseId,
    2: DiskLightReturnStatus returnStatus;
}

struct NetCardChangeRequest {
    1: i64 requestId,
    2: string ifaceName,
    3: string activePort;
}

struct NetCardChangeResponse {
    1: i64 responseId,
}

struct RecoverNetSubHealthRequest{
    1: i64 requestId,
    2: string ifaceName,
    3: bool force;
}

struct RecoverNetSubHealthResponse{
    1: i64 responseId
}

/**
 * ----------------------------------------------------exceptions----------------------------------------------------
 */
exception IllegalParameterExceptionThrift {
  1: optional string detail
}

exception TimeoutExceptionThrift {
  1: optional string detail
}

exception FaceNotFoundExceptionThrift {
  1: optional string detail
}

exception NetCardChangeFailedExceptionThrift {
  1: optional string detail
}

exception NetCardStartFailedExceptionThrift {
  1: optional string detail
}

exception NetCardOftenChangeExceptionThrift {
  1: optional string detail
}

exception NetCardCannotRecoveryYetExceptionThrift {
  1: optional string detail
}

 /**
 * ----------------------------------------------------service----------------------------------------------------
 */

service SystemDaemon extends shared.DebugConfigurator{

    void ping(),

    void shutdown(),

    LightDesignateDiskOnResponse lightDesignateDiskOn(1:LightDesignateDiskOnRequest request)
                                                    throws(1:shared.ServiceHavingBeenShutdownThrift shbsd,
                                                           2: shared.ServiceIsNotAvailableThrift sina,
                                                           3: IllegalParameterExceptionThrift ipe,
                                                           4: TimeoutExceptionThrift toe),

    LightDesignateDiskOffResponse lightDesignateDiskOff(1:LightDesignateDiskOffRequest request)
                                                    throws(1:shared.ServiceHavingBeenShutdownThrift shbsd,
                                                           2: shared.ServiceIsNotAvailableThrift sina,
                                                           3: IllegalParameterExceptionThrift ipe,
                                                           4: TimeoutExceptionThrift toe),

    NetCardChangeResponse netCardChange(1:NetCardChangeRequest request)
                                                    throws(1: NetCardChangeFailedExceptionThrift nccfe,
                                                           2: NetCardOftenChangeExceptionThrift ncoce),

    RecoverNetSubHealthResponse recoverNetSubHealth(1:RecoverNetSubHealthRequest request)
                                                    throws(1: NetCardCannotRecoveryYetExceptionThrift nccrye),

    shared.GetDiskSmartInfoResponseThrift getDiskSmartInfo(1:shared.GetDiskSmartInfoRequestThrift request)
                        throws(
                            1:shared.DiskNameIllegalExceptionThrift dnie
                        ),


}