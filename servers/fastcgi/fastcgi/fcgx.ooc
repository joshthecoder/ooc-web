include fcgiapp

FCGXStream: cover from struct FCGX_Stream {}

FCGXRequest: cover from struct FCGX_Request {
    requestId: extern Int
    role: extern Int
    envp: extern Pointer

    in: extern FCGXStream*
    out: extern FCGXStream*
    err: extern FCGXStream*
}

FCGX: cover {
    init: extern(FCGX_Init) static func -> Int
    isCGI: extern(FCGX_IsCGI) static func -> Int
    openSocket: extern(FCGX_OpenSocket) static func(String, Int) -> Int
    initRequest: extern(FCGX_InitRequest) static func(FCGXRequest*, Int, Int) -> Int
    accept: extern(FCGX_Accept_r) static func(FCGXRequest*) -> Int
    finish: extern(FCGX_Finish_r) static func(FCGXRequest*)
    free: extern(FCGX_Free) static func(FCGXRequest*, Int)
    flush: extern(FCGX_FFlush) static func(FCGXStream*) -> Int

    getChar: extern(FCGX_GetChar) static func(FCGXStream*) -> Char
    unGetChar: extern(FCGX_UnGetChar) static func(Char, FCGXStream*) -> Char
    getString: extern(FCGX_GetStr) static func(String, Int, FCGXStream*) -> Int
    getLine: extern(FCGX_GetLine) static func(String, Int, FCGXStream*) -> String
    putChar: extern(FCGX_PutChar) static func(Char, FCGXStream*) -> Int
    putStringWithLength: extern(FCGX_PutStr) static func(String, Int, FCGXStream*) -> Int
    putString: extern(FCGX_PutS) static func(String, FCGXStream*) -> Int
    getParam: extern(FCGX_GetParam) static func(String, Pointer) -> String

    hasSeenEOF: extern(FCGX_HasSeenEOF) static func(FCGXStream*) -> Int
    getError: extern(FCGX_GetError) static func(FCGXStream*) -> Int
    clearError: extern(FCGX_ClearError) static func(FCGXStream*)
    startFilterData: extern(FCGX_StartFilterData) static func(FCGXStream*) -> Int
    setExitStatus: extern(FCGX_SetExitStatus) static func(Int, FCGXStream*)

    shutdownPending: extern(FCGX_ShutdownPending) static func

    failAcceptOnInterrupt: extern(FCGI_FAIL_ACCEPT_ON_INTR) static Int
}

