include "shared.thrift"

namespace java py.thrift.deploymentdaemon
namespace perl deploymentdaemon
struct PutTarRequest {
	1: i64 requestId,
	2: string serviceName,
	3: string serviceVersion,
	4: binary tarFile,
	5: bool append,
	6: optional string coorTimestamp,
	7: optional string fsTimestamp,
}

struct PutTarResponse {
	1: i64 requestId
}

struct BackupKeyRequest {
	1: i64 requestId,
	2: string serviceName,
	3: string serviceVersion,
}

struct BackupKeyResponse {
	1: i64 requestId
}

struct UseBackupKeyRequest {
	1: i64 requestId,
	2: string serviceName,
	3: string serviceVersion,
}

struct UseBackupKeyResponse {
	1: i64 requestId
}

struct ActivateRequest {
	1: i64 requestId,
	2: string serviceName,
	3: string serviceVersion,
	4: optional list<string> cmdParams
    5: optional string coorTimestamp,
    6: optional string fsTimestamp,
}

struct ActivateResponse {
	1: i64 requestId
}

struct GetStatusRequest {
	1: i64 requestId,
	2: optional string serviceName
	
}

struct GetStatusResponse {
	1: i64 requestId,
	2: shared.ServiceMetadataThrift serviceMetadataThrift
}

struct GetUpgradeStatusRequest {
	1: i64 requestId,
	2: string serviceName

}

struct GetUpgradeStatusResponse {
	1: i64 requestId,
	2: shared.UpgradeInfoThrift  upgradeInfoThrift
}

struct UpdateLatestVersionRequest {
	1: i64 requestId,
	2: string serviceName,
	3: string version,
	4: optional string coorTimestamp,
    5: optional string fsTimestamp

}

struct UpdateLatestVersionResponse {
	1: i64 requestId
}

struct DeactivateRequest {
	1: i64 requestId,
	2: string serviceName,
	3: bool sync,
	4: i32 servicePort
}

struct DeactivateResponse {
	1: i64 requestId
}

struct ChangeConfigurationRequest {
    1: i64 requestId,
    2: string serviceName,
    3: optional string serviceVersion,
    4: string configFile,
    5: map<string, string> changingConfigurations,
    // change configuration in tar file if not preserve, or change configuration in running path
    6: bool preserve,
    7: optional string coorTimestamp,
    8: optional string fsTimestamp
}

struct ChangeConfigurationResponse {
    1: i64 requestId
}

struct WipeoutRequest {
    1: i64 requestId,
    2: optional string serviceName,
    3: optional string coorTimestamp,
    4: optional string fsTimestamp,
    5: optional string timestamp,
    6: optional string serviceVersion,
    7: optional bool ignoreConfig
}

struct WipeoutResponse {
    1: i64 requestId
}

struct RestartRequest {
	1: i64 requestId,
	2: string serviceName,
	3: string serviceVersion,
	4: optional list<string> cmdParams,
	5: i32 servicePort
}

struct RestartResponse {
	1: i64 requestId
}

struct StartRequest {
	1: i64 requestId,
	2: string serviceName,
	3: optional list<string> cmdParams
}

struct StartResponse {
	1: i64 requestId
}

struct DestroyRequest {
	1: i64 requestId,
	2: string serviceName
}

struct DestroyResponse {
	1: i64 requestId
}

struct PrepareWorkspaceRequest {
	1: i64 requestId,
	2: string serviceVersion,
	3: string serviceName,
    4: optional string coorTimestamp,
    5: optional string fsTimestamp
}

struct PrepareWorkspaceResponse {
	1: i64 requestId
}

exception ServiceNotFoundExceptionThrift {
    1: optional string detail
}

exception ServiceIsBusyExceptionThrift {
	1: optional string detail
}

exception ServiceNotRunnableExceptionThrift {
	1: optional string detail
}

exception FailedToActivateServiceExceptionThrift {
    1: optional string detail
}

exception FailedToDeactivateServiceExceptionThrift {
    1: optional string detail
}

exception ConfigurationNotFoundExceptionThrift {
    1: optional string detail
}

exception FailedToChangeConfigurationExceptionThrift {
    1: optional string detail
}

exception FailedToWipeoutExceptionThrift {
    1: optional string detail
}

exception FailedToRestartServiceExceptionThrift {
	1: optional string detail
}

exception FailedToDestroyServiceExceptionThrift {
	1: optional string detail
}

exception FailedToStartServiceExceptionThrift {
	1: optional string detail
}

exception DriverIsAliveExceptionThrift {
    1: optional string detail
}

exception ServiceStatusIsErrorExceptionThrift {
    1: optional string detail
}

exception FailedToPrepareWorkspaceThrift {
	1: optional string detail
}
exception DriverUpgradeExceptionThrift {
    1: string detail
}


service DeploymentDaemon extends shared.DebugConfigurator{
    void ping(),
    BackupKeyResponse backupKey(1: BackupKeyRequest request),
    UseBackupKeyResponse useBackupKey(1: UseBackupKeyRequest request),
	PutTarResponse putTar(1: PutTarRequest request),
	ActivateResponse activate(1: ActivateRequest request) throws (1: FailedToActivateServiceExceptionThrift ftase, 
	                                                              2: ServiceIsBusyExceptionThrift sibe, 
																  3: ServiceNotRunnableExceptionThrift snre,
																  4: ServiceStatusIsErrorExceptionThrift ssie),
	GetStatusResponse getStatus(1: GetStatusRequest request) throws (1: ServiceNotFoundExceptionThrift snf, 
	                                                                 2: ServiceNotRunnableExceptionThrift snre),

	GetUpgradeStatusResponse getUpgradeStatus(1: GetUpgradeStatusRequest request) throws (1: ServiceNotFoundExceptionThrift snf,
                                                                     	                  2: ServiceNotRunnableExceptionThrift snre),

	UpdateLatestVersionResponse updateLatestVersion(1: UpdateLatestVersionRequest request) throws (1: ServiceNotFoundExceptionThrift snf,
                                                                     	                  2: ServiceNotRunnableExceptionThrift snre),

	DeactivateResponse deactivate(1: DeactivateRequest request) throws (1: FailedToDeactivateServiceExceptionThrift ftdse, 2: ServiceIsBusyExceptionThrift sibe, 
																		3: ServiceNotRunnableExceptionThrift snre,4:ServiceStatusIsErrorExceptionThrift ssie),
	ChangeConfigurationResponse changeConfiguration(1: ChangeConfigurationRequest request) throws (1: ServiceNotFoundExceptionThrift sne, 
	                                                                                               2: ConfigurationNotFoundExceptionThrift cnf,
	                                                                                               3: FailedToChangeConfigurationExceptionThrift ftce),
    WipeoutResponse wipeout(1: WipeoutRequest request) throws (1: FailedToWipeoutExceptionThrift ftwe,2: DriverIsAliveExceptionThrift diae),
    // delete the restart interface for after calling it, can not get the right service status
    // can be imitate restart by deactive and then active service
    // RestartResponse restart(1: RestartRequest request) throws (1: FailedToRestartServiceExceptionThrift ftrse, 2: ServiceIsBusyExceptionThrift sibe,
    															  // 3: ServiceNotRunnableExceptionThrift snre),
    DestroyResponse destroy(1: DestroyRequest request) throws (1: FailedToDestroyServiceExceptionThrift ftdse, 
    							                               2: ServiceIsBusyExceptionThrift sibe, 
    														   3: ServiceNotRunnableExceptionThrift snre),
    														   
    StartResponse start(1: StartRequest request) throws (1: FailedToStartServiceExceptionThrift ftsse, 2: ServiceIsBusyExceptionThrift sibe, 
    													 3: ServiceNotRunnableExceptionThrift snre,4:ServiceStatusIsErrorExceptionThrift ssie),

   	PrepareWorkspaceResponse prepareWorkspace(1: PrepareWorkspaceRequest request) throws (1:FailedToPrepareWorkspaceThrift ftpwe,
   	                                                                                      2:DriverUpgradeExceptionThrift due),
}
