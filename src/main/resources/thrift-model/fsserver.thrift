include "shared.thrift"

namespace java py.thrift.fsserver.service

struct PageIdThrift {
    1: i64 pageOffset
}

struct FsAttributeThrift {
    1: i32 pageSize    
}

struct AttributeThrift {
    /* dev name, for instance, /dev/sdb1, no necessary */
    1: i64 dev,
    /*  for implementing hard-link */
    2: i64 ino,
    /* permission, u-id, directory/file, special */
    3: i64 mode,
    /*  the number of hard links */
    4: i64 nlink,
    /* user name at the local file system */
    5: string user,
    /* group name  at the local file system*/
    6: string group,
    /* special dev name, for instance, /dev/sdb1, no necessary */
    7: i64 rdev,
    /* file size. Dir size is 4096 */
    8: i64 size,
    /* local os's block size */
    9: i64 blksize,
    /* size of blksize */
    10: i64 blocks,
    /* access time */
    11: i64 atime,
    /* modified time */
    12: i64 mtime,
    /* creation time */
    13: i64 ctime,
}

struct GetAttributeRequest {
    1: i64 requestId,
    2: string path
}

struct GetAttributeResponse {
    1: i64 requestId,
    2: AttributeThrift attribute
}

struct ListDirRequest {
    1: i64 requestId,
    2: string path
}

struct ListDirResponse {
    1: i64 requestId,
    2: list<string> entries
}

struct MkdirRequest {
    1: i64 requestId,
    2: string path,
    /**
     * The directory representation bit should be set.
     */
    3: optional i64 mode,
    4: string user,
    5: string group
}

struct MkdirResponse {
    1: i64 requestId,
    2: AttributeThrift attribute
}

struct CreateFileRequest {
    1: i64 requestId,
    2: string path,
    /**
     * The file representation bit should be set.
     */
    3: optional i64 mode,
    /**
     * The flags were set by fuse client. It is not necessary for this field existing in request.
     */
    4: optional i64 flags,
    5: string user,
    6: string group
}

struct CreateFileResponse {
    1: i64 requestId,
    2: AttributeThrift attribute
}

struct RmdirRequest {
    1: i64 requestId,
    2: string path
}

struct RmdirResponse {
    1: i64 requestId
}

struct UnlinkRequest {
    1: i64 requestId,
    2: string path
}

struct UnlinkResponse {
    1: i64 requestId
}

struct RenameRequest {
    1: i64 requestId,
    2: string currentPath,
    3: string newPath
}

struct RenameResponse {
    1: i64 requestId
}

struct GetFilePagesRequest {
    1: i64 requestId,
    2: string path,
    /**
     * Offset in the given file.
     */
    3: i64 offset, 
    /**
     * Total bytes since the offset in the given file.
     */
    4: i64 length
}

struct GetFilePagesResponse {
    1: i64 requestId,
    2: list<PageIdThrift> pageIds,
}

struct NewSessionRequest {
    1: i64 requestId,
    2: optional i64 sessionId
}

struct NewSessionResponse {
    1: i64 requestId,
    2: i64 sessionId,
    3: FsAttributeThrift fsAttr,
}

struct CloseSessionRequest {
    1: i64 requestId,
    2: i64 sessionId
}

struct CloseSessionResponse {
    1: i64 requestId
}

struct PreallocatePagesRequest {
    1: i64 requestId,
    2: i64 desiredSize, // the desired size that a client requests for
    /**
     * Id of old session.
     */
    3: i64 sessionId,
    /**
     * The client requires exactly the given space from server if the field was set true. And if the server cannot allocate
     * the given space to client, an exception will be thrown up.
     * 
     * If the filed was set false, the server allocates the given space to client if has enough space or all remaining 
     * space if not.
     */
    4: optional bool strict
}

struct PreallocatePagesResponse {
    1: i64 requestId,
    2: list<PageIdThrift> pages
}

struct RenewSessionRequest {
    1: i64 requestId,
    2: i64 sessionId,    // a client continues to use the same session id until it exists or crash
}
    
struct RenewSessionResponse {
    1: i64 requestId,
}

struct CommitFilePagesRequest {
    1: i64 requestId,
    2: i64 sessionId,
    3: string path,
    /**
     * List of pages relative to the given offset and length.
     */
    4: list<PageIdThrift> pageIds, // a list of ids of pages to be committed
    5: i64 pos,
    6: i64 length
}

struct CommitFilePagesResponse {
    1: i64 requestId
}

struct TruncateRequest {
    1: i64 requestId,
    2: string path,
    /**
     * After truncating, the given file should be the given size.
     */
    3: i64 size
}

struct TruncateResponse {
    1: i64 requestId
}

struct ChmodRequest {
    1: i64 requestId,
    2: string path,
    3: i64 mode
}

struct ChmodResponse {
    1: i64 requestId
}

struct ChownRequest {
    1: i64 requestId,
    2: string path,
    3: string user,
    4: string group
}

struct ChownResponse {
    1: i64 requestId
}

struct ReclaimSessionRequest {
	1: i64 sessionId
}

struct SupplySpaceRequest {
	1: i64 volumeSizeBeforeExtending,
	2: i64 volumeSizeAfterExtending
}

struct GetLatestImageRequest {
    1: i64 requestId
}

struct GetLatestImageResponse {
	1: i64 requestId,
	2: string imageFileName,
	3: i64 imageFileSize
}

struct GetImageBytesReqeust {
	1: i64 requestId,
	2: string imageFileName,
	3: bool newStream,
	4: i32 length,
	5: optional bool onlineMinimal,
}

struct GetImageBytesResponse {
	1: i64 requestId,
	2: binary bytes,
	3: i32 length
}

struct GetLatestLogRequest {
	1: i64 requestId,
	2: i64 lastLogId
}

struct GetLatestLogResponse {
	1: i64 requestId,
	2: string logFileName,
	3: i32 logFileSize
}

struct GetLogBytesRequest {
	1: i64 requestId,
	2: string logFileName,
	3: bool newStream,
	4: i32 length
}

struct GetLogBytesResponse {
	1: i64 requestId,
	2: binary bytes,
	3: i32 length
}

struct PutImageBytesRequest {
	1: i64 requestId,
	2: string imageFilename,
	3: bool newStream,
	4: bool hasRemaining,
	5: binary bytes
}

struct PutImageBytesResponse {
	1: i64 requestId,
}

exception FileOpExceptionThrift {
    1: optional byte errorCode,
    2: optional string detail
}

/**
 * After one page in preallocated blocks being used, the client should commit it to server. This page 
 * should not be used before (neither other client nor current client). Otherwise, the server will throw 
 * up this exception.
 */
exception PageUsedExceptionThrift {
    1: optional string detail
}

/**
 * When client ask for exactly some space from server and the server doesn't have enough space, the server
 * will throw up this exception.
 */
exception SpaceNotAvailableExceptionThrift {
    1: optional string detail
}

/**
 * When creating a new file or directory on a specified path, and a file or directory exists on the path, the server
 * will throw up this exception.
 */
exception PathExistExceptionThrift {
    1: optional string detail
}

/**
 * When accessing a file or directory on a specified path, and the path doesn't exist, the server will throw up
 * this exception.
 */
exception PathNotExistExceptionThrift {
    1: optional string detail
}

/**
 * When accessing a file, and the given path is not file, the server will throw up this exception.
 */
exception PathNotFileExceptionThrift {
    1: optional string detail
}

/**
 * When accessing a directory, and the given path is not directory, the server will throw up this exception.
 */
exception PathNotDirExceptionThrift {
    1: optional string detail
} 

/**
 * When deleting a directory and the directory has sub-entries, the server will throw up this exception.
 */
exception DirNotEmptyExceptionThrift {
    1: optional string detail
}

/**
 * When create file or directory under some given path, and the path is not directory, the server will throw up this
 * exception.
 */
exception ParentPathNotDirExceptionThrift {
    1: optional string detail
}

exception NoSuchSessionExceptionThrift {
    1: optional string detail
}

exception IoExceptionThrift {
	1: optional string detail
}

/**
 * throw this exception when page(s) in commit request is(are) not in given session
 */
exception NoSuchPageInSessionExceptionThrift {
    1: optional string detail
}

exception NotReadyForServingThrift {
    1: optional string detail
}

service FileSystemService extends shared.DebugConfigurator {
    /**
     * Get attribute of a file or directory.
     */
    GetAttributeResponse getAttribute(1: GetAttributeRequest request) throws (1: PathNotExistExceptionThrift e,
                                                                              2: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                              3: NotReadyForServingThrift nrfs),


    /**
     * List all files and directories under the given directory in request.
     */
    ListDirResponse listDir(1: ListDirRequest request) throws (1: PathNotExistExceptionThrift pnee, 
                                                               2: PathNotDirExceptionThrift pnde,
                                                               3: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                               4: NotReadyForServingThrift nrfs),

    /**
     * Create a directory on the given path in request.
     */
    MkdirResponse mkdir(1:MkdirRequest request) throws (1: PathExistExceptionThrift pee,
                                                        2: PathNotExistExceptionThrift pnee, 
                                                        3: ParentPathNotDirExceptionThrift ppnde,
                                                        4: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                        5: NotReadyForServingThrift nrfs),

    /**
     * Create a file on the given path in request.
     */
    CreateFileResponse createFile(1:CreateFileRequest request) throws (1: PathExistExceptionThrift pee, 
                                                                       2: PathNotExistExceptionThrift pnee,
                                                                       3: ParentPathNotDirExceptionThrift ppnde,
                                                                       4: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                       5: NotReadyForServingThrift nrfs),

    /**
     * Get all file pages in request.
     * 
     * When read data from the given file or write data to the given file, we know the offset from which we read or 
     * write data and length of the data. Sice the data is stored in pages, it is necessary to get these relative
     * pages to access the data.
     */
    GetFilePagesResponse getFilePages(1:GetFilePagesRequest request) throws (1: PathNotExistExceptionThrift pnee,
                                                                             2: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                             3: NotReadyForServingThrift nrfs),

    /**
     * Before writing data to file, client asks some pages from server to store data. After some of these pages being written,
     * it is necessary for client to tell server those pages were written.
     * 
     * Page is relative to an offset and a fixed length of file. 
     */
    CommitFilePagesResponse commitFilePages(1:CommitFilePagesRequest request) throws (1:PageUsedExceptionThrift e,
                                                                                      2:NoSuchSessionExceptionThrift nsse,
                                                                                      3:NoSuchPageInSessionExceptionThrift nspise,
                                                                                      4:shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                      5:NotReadyForServingThrift nrfs),

    /**
     * Remove directory no recursively. It is not allowed to remove a directory which is not empty.
     */
    RmdirResponse rmdir(1:RmdirRequest request) throws (1: PathNotExistExceptionThrift pnee, 
                                                        2: PathNotDirExceptionThrift pnde, 
                                                        3: DirNotEmptyExceptionThrift dnee,
                                                        4: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                        5: NotReadyForServingThrift nrfs),

    /**
     * This api is essentially a operation to remove a file. Since a file might have hard links, so this api is called unlink.
     */
    UnlinkResponse unlink(1:UnlinkRequest request) throws (1: PathNotExistExceptionThrift pnee, 
                                                           2: PathNotFileExceptionThrift pnfe,
                                                           3: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                           4: NotReadyForServingThrift nrfs),

    /**
     * Rename a file or directory. Both pathes are absolute. 
     */
    RenameResponse rename(1: RenameRequest request) throws (1: PathNotExistExceptionThrift pnee, 
                                                            2: PathNotFileExceptionThrift pnfe,
                                                            3: PathNotDirExceptionThrift pnde, 
                                                            4: DirNotEmptyExceptionThrift dnee,
                                                            5: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                            6: NotReadyForServingThrift nrfs,
                                                            7: PathExistExceptionThrift pee),

    /** 
     * Require some space from server.
     */
    PreallocatePagesResponse preallocatePages(1: PreallocatePagesRequest request) throws (1: SpaceNotAvailableExceptionThrift bna,
                                                                                          2: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                          3: NoSuchSessionExceptionThrift nsse,
                                                                                          4: NotReadyForServingThrift nrfs),

    /**
     * keep session with server
     */
    RenewSessionResponse renewSession(1: RenewSessionRequest request) throws (1: shared.ServiceHavingBeenShutdownThrift shbsd, 
                                                                              2: NoSuchSessionExceptionThrift nsse,
                                                                              3: NotReadyForServingThrift nrfs), 

    /**
     * Truncate the given file to the given size.
     */
    TruncateResponse truncate(1:TruncateRequest request) throws (1: PathNotExistExceptionThrift pnee, 
                                                                 2: PathNotFileExceptionThrift pnfe,
                                                                 3: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                 4: NotReadyForServingThrift nrfs),
    
    /**
     * Change mode of the given file or directory.
     */
    ChmodResponse chmod(1: ChmodRequest request) throws (1: PathNotExistExceptionThrift pnee,
                                                         2: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                         3: NotReadyForServingThrift nrfs),
    
    /**
     * Change owner of the given file or directory.
     */
    ChownResponse chown(1: ChownRequest request) throws (1: PathNotExistExceptionThrift pnee,
                                                         2: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                         3: NotReadyForServingThrift nrfs),
    
    NewSessionResponse newSession(1: NewSessionRequest request) throws (1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                        2: NotReadyForServingThrift nrfs),
    
    CloseSessionResponse closeSession(1: CloseSessionRequest request) throws (1: shared.ServiceHavingBeenShutdownThrift shbsd, 
                                                                              2: NoSuchSessionExceptionThrift nsse,
                                                                              3: NotReadyForServingThrift nrfs),
                                                                              
    GetLatestImageResponse getLatestImage(1: GetLatestImageRequest request) throws (1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                                    2: NotReadyForServingThrift nrfs),
    
    GetImageBytesResponse getImageBytes(1: GetImageBytesReqeust request) throws (1: shared.ServiceHavingBeenShutdownThrift shbsd, 
                                                                                 2: IoExceptionThrift ioe,
                                                                                 3: NotReadyForServingThrift nrfs),
                                                                                 
    GetLatestLogResponse getLatestLog(1: GetLatestLogRequest request) throws (1: shared.ServiceHavingBeenShutdownThrift shbsd,
                                                                              2: NotReadyForServingThrift nrfs),
    
    GetLogBytesResponse getLogBytes(1: GetLogBytesRequest request) throws (1: shared.ServiceHavingBeenShutdownThrift shbsd, 
                                                                           2: IoExceptionThrift ioe,
                                                                           3: NotReadyForServingThrift nrfs),
    
 	PutImageBytesResponse putImageBytes(1: PutImageBytesRequest request) throws (1: shared.ServiceHavingBeenShutdownThrift shbsd, 
 	                                                                             2: IoExceptionThrift ioe,
 	                                                                             3: NotReadyForServingThrift nrfs),
    
    void ping(),

    //Shutdown 
    void shutdown(),
    
}
