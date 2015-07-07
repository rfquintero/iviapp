#ifndef StoppingPower_DebugLog_h
#define StoppingPower_DebugLog_h

#ifdef DEBUG
#define TFLog(s, ...) NSLog(s, ##__VA_ARGS__)
#else
#define TFLog(s, ...)
#endif

#endif
