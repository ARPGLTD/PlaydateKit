#pragma once
#include "pd_api.h"

static inline void logToConsole(const struct playdate_sys* system, const char *message) {
    system->logToConsole("%s", message);
}
