/**
 * This thrift defines a service interface for testing performance 
 */

namespace java py.thrift.testing.service

struct PerformanceTestRequestThrift {
    1: i64 requestId,
    2: optional binary data
}

struct PerformanceTestResponseThrift {
    1: i64 requestId,
    2: optional binary data
}

exception PerformanceTestExceptionThrift {
  1: optional string detail
}

service PerformanceTestService {
     PerformanceTestResponseThrift testPingPang(1: PerformanceTestRequestThrift request) throws (
        1: PerformanceTestExceptionThrift pte
        ),
        
     PerformanceTestResponseThrift testRead(1: PerformanceTestRequestThrift request) throws (
        1: PerformanceTestExceptionThrift pte
        ),
        
     PerformanceTestResponseThrift testWrite(1: PerformanceTestRequestThrift request) throws (
        1: PerformanceTestExceptionThrift pte
        ),
}
