;(function(undefined){
  'use strict';
  
  //var Module = {};
  
  // https://github.com/emscripten-core/emscripten/issues/4479
  Module['preInit'] = function() {
    if (ENVIRONMENT_IS_NODE) {
      exit = Module['exit'] = function(status) {
        ABORT = true;
        EXITSTATUS = status;
        //STACKTOP = initialStackTop;
        //exitRuntime();
        if (Module['onExit']) {
          Module['onExit'](status);
        }
        throw new ExitStatus(status);
      };
    }
  }
})();
