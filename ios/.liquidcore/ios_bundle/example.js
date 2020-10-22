var __BUNDLE_START_TIME__=this.nativePerformanceNow?nativePerformanceNow():Date.now(),__DEV__=false,process=this.process||{};process.env=process.env||{};process.env.NODE_ENV=process.env.NODE_ENV||"production";
(function (global) {
  "use strict";

  global.__non_webpack_require__ = LiquidCore.require;
  global.__webpack_require__ = metroRequire;
  global.__r = metroRequire;
  global.__d = define;
  global.__c = clear;
  global.__registerSegment = registerSegment;
  var modules = clear();
  const EMPTY = {};
  const _ref = {},
        hasOwnProperty = _ref.hasOwnProperty;

  function clear() {
    modules = Object.create(null);
    return modules;
  }

  function define(factory, moduleId, dependencyMap) {
    if (modules[moduleId] != null) {
      return;
    }

    const mod = {
      dependencyMap,
      factory,
      hasError: false,
      importedAll: EMPTY,
      importedDefault: EMPTY,
      isInitialized: false,
      isCyclic: false,
      publicModule: {
        exports: {}
      }
    };
    modules[moduleId] = mod;
  }

  function proxyModuleExports(module) {
    module.exports = function () {};

    const handler = {
      get: (t, p, r) => Reflect.get(module.exports, p, r),
      set: (t, p, v, r) => Reflect.set(module.exports, p, v, r),
      setPrototypeOf: (t, p) => Reflect.setPrototypeOf(module.exports, p),
      getPrototypeOf: t => Reflect.getPrototypeOf(module.exports),
      getOwnPropertyDescriptor: (t, p) => Reflect.getOwnPropertyDescriptor(module.exports, p),
      defineProperty: (t, p, d) => Reflect.defineProperty(module.exports, p, d),
      has: (t, p) => Reflect.has(module.exports, p),
      deleteProperty: (t, p) => Reflect.deleteProperty(module.exports, p),
      ownKeys: t => Reflect.ownKeys(module.exports),
      apply: (t, z, a) => Reflect.apply(module.exports, z, a),
      construct: (t, a, n) => Reflect.construct(module.exports, a, n),
      preventExtensions: t => Reflect.preventExtensions(module.exports),
      isExtensible: t => Reflect.isExtensible(module.exports)
    };
    return new Proxy(function () {}, handler);
  }

  function metroRequire(moduleId) {
    const moduleIdReallyIsNumber = moduleId;
    const module = modules[moduleIdReallyIsNumber];
    return module && module.isCyclic ? proxyModuleExports(module) : module && module.isInitialized ? module.publicModule.exports : guardedLoadModule(moduleIdReallyIsNumber, module);
  }

  function metroImportDefault(moduleId) {
    const moduleIdReallyIsNumber = moduleId;

    if (modules[moduleIdReallyIsNumber] && modules[moduleIdReallyIsNumber].importedDefault !== EMPTY) {
      return modules[moduleIdReallyIsNumber].importedDefault;
    }

    const exports = metroRequire(moduleIdReallyIsNumber);
    const importedDefault = exports && exports.__esModule ? exports.default : exports;
    return modules[moduleIdReallyIsNumber].importedDefault = importedDefault;
  }

  metroRequire.importDefault = metroImportDefault;

  function metroImportAll(moduleId) {
    const moduleIdReallyIsNumber = moduleId;

    if (modules[moduleIdReallyIsNumber] && modules[moduleIdReallyIsNumber].importedAll !== EMPTY) {
      return modules[moduleIdReallyIsNumber].importedAll;
    }

    const exports = metroRequire(moduleIdReallyIsNumber);
    let importedAll;

    if (exports && exports.__esModule) {
      importedAll = exports;
    } else {
      importedAll = {};

      if (exports) {
        for (const key in exports) {
          if (hasOwnProperty.call(exports, key)) {
            importedAll[key] = exports[key];
          }
        }
      }

      importedAll.default = exports;
    }

    return modules[moduleIdReallyIsNumber].importedAll = importedAll;
  }

  metroRequire.importAll = metroImportAll;
  let inGuard = false;

  function guardedLoadModule(moduleId, module) {
    if (!inGuard && global.ErrorUtils) {
      inGuard = true;
      let returnValue;

      try {
        returnValue = loadModuleImplementation(moduleId, module);
      } catch (e) {
        global.ErrorUtils.reportFatalError(e);
      }

      inGuard = false;
      return returnValue;
    } else {
      return loadModuleImplementation(moduleId, module);
    }
  }

  const ID_MASK_SHIFT = 16;
  const LOCAL_ID_MASK = 65535;

  function unpackModuleId(moduleId) {
    const segmentId = moduleId >>> ID_MASK_SHIFT;
    const localId = moduleId & LOCAL_ID_MASK;
    return {
      segmentId,
      localId
    };
  }

  metroRequire.unpackModuleId = unpackModuleId;

  function packModuleId(value) {
    return (value.segmentId << ID_MASK_SHIFT) + value.localId;
  }

  metroRequire.packModuleId = packModuleId;
  const moduleDefinersBySegmentID = [];

  function registerSegment(segmentID, moduleDefiner) {
    moduleDefinersBySegmentID[segmentID] = moduleDefiner;
  }

  function loadModuleImplementation(moduleId, module) {
    if (!module && moduleDefinersBySegmentID.length > 0) {
      const _unpackModuleId = unpackModuleId(moduleId),
            segmentId = _unpackModuleId.segmentId,
            localId = _unpackModuleId.localId;

      const definer = moduleDefinersBySegmentID[segmentId];

      if (definer != null) {
        definer(localId);
        module = modules[moduleId];
      }
    }

    const nativeRequire = global.nativeRequire;

    if (!module && nativeRequire) {
      const _unpackModuleId2 = unpackModuleId(moduleId),
            segmentId = _unpackModuleId2.segmentId,
            localId = _unpackModuleId2.localId;

      nativeRequire(localId, segmentId);
      module = modules[moduleId];
    }

    if (!module) {
      throw unknownModuleError(moduleId);
    }

    if (module.hasError) {
      throw moduleThrewError(moduleId, module.error);
    }

    module.isInitialized = true;
    module.isCyclic = true;
    const _module = module,
          factory = _module.factory,
          dependencyMap = _module.dependencyMap;

    try {
      const moduleObject = module.publicModule;
      moduleObject.id = moduleId;
      factory(global, metroRequire, metroImportDefault, metroImportAll, moduleObject, moduleObject.exports, dependencyMap);
      {
        module.factory = undefined;
        module.dependencyMap = undefined;
      }
      module.isCyclic = false;
      return moduleObject.exports;
    } catch (e) {
      module.hasError = true;
      module.error = e;
      module.isInitialized = false;
      module.isCyclic = false;
      module.publicModule.exports = undefined;
      throw e;
    } finally {}
  }

  function unknownModuleError(id) {
    let message = 'Requiring unknown module "' + id + '".';
    return Error(message);
  }

  function moduleThrewError(id, error) {
    const displayName = id;
    return Error('Requiring module "' + displayName + '", which threw an exception: ' + error);
  }
})(typeof globalThis !== 'undefined' ? globalThis : typeof global !== 'undefined' ? global : typeof window !== 'undefined' ? window : this);
__d(function (global, _$$_REQUIRE, _$$_IMPORT_DEFAULT, _$$_IMPORT_ALL, module, exports, _dependencyMap) {
  "use strict";

  const {
    LiquidCore
  } = _$$_REQUIRE(_dependencyMap[0]);

  setInterval(() => {}, 1000);
  console.log('Hello, World!');
  LiquidCore.on('ping', () => {
    LiquidCore.emit('pong', {
      message: 'Hello, World from LiquidCore!'
    });
    process.exit(0);
  });
  LiquidCore.emit('ready');
},0,[1]);
__d(function (global, _$$_REQUIRE, _$$_IMPORT_DEFAULT, _$$_IMPORT_ALL, module, exports, _dependencyMap) {
  "use strict";

  const events = _$$_REQUIRE(_dependencyMap[0]);

  const fs = _$$_REQUIRE(_dependencyMap[1]);

  const path = _$$_REQUIRE(_dependencyMap[2]);

  const join = path.join;
  let lc = global && global.LiquidCore;

  if (!lc) {
    class LiquidCore extends events {}

    lc = new LiquidCore();
    const native_require = global.require;
    const defaults = {
      arrow: process.env.NODE_BINDINGS_ARROW || ' → ',
      compiled: process.env.NODE_BINDINGS_COMPILED_DIR || 'compiled',
      platform: process.platform,
      arch: process.arch,
      version: process.versions.node,
      bindings: 'bindings.node',
      bindingsjs: 'bindings.node.js',
      try: [['module_root', 'build', 'bindings'], ['module_root', 'build', 'Debug', 'bindings'], ['module_root', 'build', 'Release', 'bindings'], ['module_root', 'out', 'Debug', 'bindings'], ['module_root', 'Debug', 'bindings'], ['module_root', 'out', 'Release', 'bindings'], ['module_root', 'Release', 'bindings'], ['module_root', 'build', 'default', 'bindings'], ['module_root', 'compiled', 'version', 'platform', 'arch', 'bindings'], ['module_root', 'mocks', 'bindingsjs']]
    };

    function bindings(opts) {
      if (typeof opts == 'string') {
        opts = {
          bindings: opts
        };
      } else if (!opts) {
        opts = {};
      }

      Object.keys(defaults).map(function (i) {
        if (!(i in opts)) opts[i] = defaults[i];
      });

      if (path.extname(opts.bindings) != '.node') {
        opts.bindings += '.node';
      }

      opts.bindingsjs = opts.bindings + '.js';
      var requireFunc = native_require;
      var tries = [],
          i = 0,
          l = opts.try.length,
          n,
          b,
          err;
      let modules = [];
      let mods = fs.readdirSync(path.resolve('.', 'node_modules'));
      mods.forEach(m => m.startsWith('@') ? modules = modules.concat(fs.readdirSync(path.resolve('.', 'node_modules', m)).map(f => m + '/' + f)) : modules.push(m));

      for (var j = 0; j < modules.length; j++) {
        opts.module_root = modules[j];

        for (i = 0; i < l; i++) {
          n = join.apply(null, opts.try[i].map(function (p) {
            return opts[p] || p;
          }));
          tries.push(n);

          try {
            b = opts.path ? requireFunc.resolve(n) : requireFunc(n);

            if (!opts.path) {
              b.path = n;
            }

            return b;
          } catch (e) {
            if (!/not find/i.test(e.message)) {
              throw e;
            }
          }
        }
      }

      err = new Error('Could not locate the bindings file. Tried:\n' + tries.map(function (a) {
        return opts.arrow + a;
      }).join('\n'));
      err.tries = tries;
      throw err;
    }

    lc.require = module => {
      if (path.extname(module) == '.node') {
        console.warn('WARN: Attempting to bind native module ' + path.basename(module));
        console.warn('WARN: Consider using a browser implementation or make sure you have a LiquidCore addon.');
        return bindings(path.basename(module));
      }

      return native_require(module);
    };

    lc.require.__proto__ = native_require.__proto__;

    if (global) {
      global.LiquidCore = lc;
    }
  }

  module.exports = {
    LiquidCore: lc
  };
},1,[2,3,4]);
__d(function (global, _$$_REQUIRE, _$$_IMPORT_DEFAULT, _$$_IMPORT_ALL, module, exports, _dependencyMap) {
  "use strict";

  module.exports = LiquidCore.require('events');
},2,[]);
__d(function (global, _$$_REQUIRE, _$$_IMPORT_DEFAULT, _$$_IMPORT_ALL, module, exports, _dependencyMap) {
  "use strict";

  module.exports = LiquidCore.require('fs');
},3,[]);
__d(function (global, _$$_REQUIRE, _$$_IMPORT_DEFAULT, _$$_IMPORT_ALL, module, exports, _dependencyMap) {
  "use strict";

  module.exports = LiquidCore.require('path');
},4,[]);
__r(0);