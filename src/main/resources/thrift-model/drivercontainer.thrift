
include "shared.thrift"
include "icshared.thrift"

namespace java py.thrift.drivercontainer.service

exception FailedToApplyVolumeAccessRulesExceptionThrift {
	1: optional string detail
}

exception FailedToCancelVolumeAccessRulesExceptionThrift {
	1: optional string detail
}

exception FailedToApplyIscsiAccessRulesExceptionThrift {
	1: optional string detail
}

exception FailedToCancelIscsiAccessRulesExceptionThrift {
	1: optional string detail
}

service DriverContainer extends shared.DebugConfigurator {
    void ping(),
    
    //shutdown
    void shutdown(),
    
    shared.LaunchDriverResponseThrift launchDriver(1:shared.LaunchDriverRequestThrift request) throws (
    					1:shared.ExistsDriverExceptionThrift ede,
                        2:shared.DriverLaunchFailedExceptionThrift dlfe,
                        3:shared.ServiceHavingBeenShutdownThrift shbsd
                        4:shared.SystemMemoryIsNotEnoughThrift smie,
                        5:shared.DriverIsUpgradingExceptionThrift diug,
                        6:shared.DriverNameExistsExceptionThrift dneet,
                        7:shared.DriverTypeIsConflictExceptionThrift dcie,
                        8:shared.SystemCpuIsNotEnoughThrift scine,
                        9:shared.UnknownIpv4HostExceptionThrift ui4he,
                        10:shared.UnknownIpv6HostExceptionThrift ui6he)
    
    shared.UmountDriverResponseThrift umountDriver(1:shared.UmountDriverRequestThrift request) throws (
    					1:shared.ServiceHavingBeenShutdownThrift shbsd,
    					2:shared.FailedToUmountDriverExceptionThrift ftde,
    					3:shared.ExistsClientExceptionThrift ece,
    					4:shared.DriverIsLaunchingExceptionThrift dile,
    					5:shared.DriverIsUpgradingExceptionThrift diug)

    shared.ChangeDriverBoundVolumeResponse changeDriverBoundVolume(1:shared.ChangeDriverBoundVolumeRequest request) throws (
                                                                                                    1:shared.ServiceHavingBeenShutdownThrift shbsd,
   																									2:shared.ServiceIsNotAvailableThrift sina,
   																									3:shared.ChangeDriverBoundVolumeFailedThrift cdbv),

    shared.GetPerformanceParameterResponseThrift pullPerformanceParameter(1:shared.GetPerformanceParameterRequestThrift request) throws (
                        1:shared.VolumeHasNotBeenLaunchedExceptionThrift vhnble,
                        2:shared.ReadPerformanceParameterFromFileExceptionThrift gppffe)
    
    shared.GetPerformanceFromPyMetricsResponseThrift pullPerformanceFromPyMetrics(1:shared.GetPerformanceParameterRequestThrift request) throws (
                        1:shared.VolumeHasNotBeenLaunchedExceptionThrift vhnble,
                        2:shared.ReadPerformanceParameterFromFileExceptionThrift gppffe)

    shared.ApplyVolumeAccessRulesResponse applyVolumeAccessRules(1:shared.ApplyVolumeAccessRulesRequest request) throws (1:FailedToApplyVolumeAccessRulesExceptionThrift ftavare), 
    
    shared.CancelVolumeAccessRulesResponse cancelVolumeAccessRules(1:shared.CancelVolumeAccessRulesRequest request) throws (1:FailedToCancelVolumeAccessRulesExceptionThrift ftcvare),

    shared.ListVolumeAccessRulesByVolumeIdsResponse listVolumeAccessRulesByVolumeIds(1:shared.ListVolumeAccessRulesByVolumeIdsRequest request) throws (1:shared.ServiceIsNotAvailableThrift sina),

    shared.ApplyIscsiAccessRulesResponse applyIscsiAccessRules(1:shared.ApplyIscsiAccessRulesRequest request) throws (1:FailedToApplyIscsiAccessRulesExceptionThrift ftavare),

    shared.CancelIscsiAccessRulesResponse cancelIscsiAccessRules(1:shared.CancelIscsiAccessRulesRequest request) throws (1:FailedToCancelIscsiAccessRulesExceptionThrift ftcvare),

    shared.ListIscsiAccessRulesByDriverKeysResponse listIscsiAccessRulesByDriverKeys(1:shared.ListIscsiAccessRulesByDriverKeysRequest request) throws (1:shared.ServiceIsNotAvailableThrift sina),

    shared.ListIscsiAppliedAccessRulesResponseThrift listIscsiAppliedAccessRules(1:shared.ListIscsiAppliedAccessRulesRequestThrift request) throws (1:shared.ServiceHavingBeenShutdownThrift shbsd),

    icshared.ReportDriverMetadataResponse reportDriverMetadata(1:icshared.ReportDriverMetadataRequest request) throws (1:shared.ServiceIsNotAvailableThrift sina,
                                                                                                                       2:shared.DriverFromRequestNotFoundExceptionThrift drnf),
    shared.GetDriverConnectPermissionResponseThrift  getDriverConnectPermission(1:shared.GetDriverConnectPermissionRequestThrift request) throws (1:shared.ServiceHavingBeenShutdownThrift shbsd),
    
    shared.GetIoLimitationByDriverResponseThrift getIoLimitationsByDriver(1:shared.GetIoLimitationByDriverRequestThrift request) throws(1:shared.ServiceHavingBeenShutdownThrift shbs,
                                                                                            2:shared.ServiceIsNotAvailableThrift sina),

    //********** iscsi chap control begin **********/
    shared.SetIscsiChapControlResponseThrift  setIscsiChapControl(1:shared.SetIscsiChapControlRequestThrift request) throws (1:shared.ServiceHavingBeenShutdownThrift shbsd),
    //********** iscsi chap control end   **********/

    shared.MountScsiDeviceResponse mountScsiDevice(1:shared.MountScsiDeviceRequest request) throws (
                        1:shared.NoEnoughPydDeviceExceptionThrift nepde,
                        2:shared.ConnectPydDeviceOperationExceptionThrift cpdoe,
                        3:shared.CreateBackstoresOperationExceptionThrift cboe,
                        4:shared.CreateLoopbackOperationExceptionThrift cloe,
                        5:shared.CreateLoopbackLunsOperationExceptionThrift clloe,
                        6:shared.GetScsiDeviceOperationExceptionThrift gsdoe),

    shared.UmountScsiDeviceResponse umountScsiDevice(1:shared.UmountScsiDeviceRequest request) throws (),

}


