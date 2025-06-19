// sinon@20.0.0 downloaded from https://ga.jspm.io/npm:sinon@20.0.0/pkg/sinon-esm.js

/* Sinon.JS 20.0.0, 2025-03-24, @license BSD-3 */let e;(function(){function r(e,t,n){function o(a,s){if(!t[a]){if(!e[a]){var c="function"==typeof require&&require;if(!s&&c)return c(a,!0);if(i)return i(a,!0);var l=new Error("Cannot find module '"+a+"'");throw l.code="MODULE_NOT_FOUND",l}var u=t[a]={exports:{}};e[a][0].call(u.exports,(function(t){var n=e[a][1][t];return o(n||t)}),u,u.exports,r,e,t,n)}return t[a].exports}for(var i="function"==typeof require&&require,a=0;a<n.length;a++)o(n[a]);return o}return r})()({1:[function(e,t,n){const i=e("./sinon/behavior");const a=e("./sinon/create-sandbox");const s=e("./sinon/util/core/extend");const c=e("./sinon/util/fake-timers");const l=e("./sinon/sandbox");const u=e("./sinon/stub");const p=e("./sinon/promise");
/**
 * @returns {object} a configured sandbox
 */t.exports=function createApi(){const t={createSandbox:a,match:e("@sinonjs/samsam").createMatcher,restoreObject:e("./sinon/restore-object"),expectation:e("./sinon/mock-expectation"),timers:c.timers,addBehavior:function(e,t){i.addBehavior(u,e,t)},promise:p};const n=new l;return s(n,t)}},{"./sinon/behavior":5,"./sinon/create-sandbox":8,"./sinon/mock-expectation":12,"./sinon/promise":14,"./sinon/restore-object":19,"./sinon/sandbox":20,"./sinon/stub":23,"./sinon/util/core/extend":26,"./sinon/util/fake-timers":40,"@sinonjs/samsam":87}],2:[function(t,n,i){e=t("./sinon")},{"./sinon":3}],3:[function(e,t,n){const i=e("./create-sinon-api");t.exports=i()},{"./create-sinon-api":1}],4:[function(e,t,n){const i=e("@sinonjs/commons").prototypes.array;const a=e("@sinonjs/commons").calledInOrder;const s=e("@sinonjs/samsam").createMatcher;const c=e("@sinonjs/commons").orderByFirstCall;const l=e("./util/core/times-in-words");const u=e("util").inspect;const p=e("@sinonjs/commons").prototypes.string.slice;const h=e("@sinonjs/commons").global;const d=i.slice;const m=i.concat;const y=i.forEach;const g=i.join;const v=i.splice;function applyDefaults(e,t){for(const n of Object.keys(t)){const i=e[n];i!==null&&typeof i!=="undefined"||(e[n]=t[n])}}
/**
 * @typedef {object} CreateAssertOptions
 * @global
 *
 * @property {boolean} [shouldLimitAssertionLogs] default is false
 * @property {number}  [assertionLogLimit] default is 10K
 */
/**
 * Create an assertion object that exposes several methods to invoke
 *
 * @param {CreateAssertOptions}  [opts] options bag
 * @returns {object} object with multiple assertion methods
 */function createAssertObject(e){const t=e||{};applyDefaults(t,{shouldLimitAssertionLogs:false,assertionLogLimit:1e4});const n={failException:"AssertError",fail:function fail(e){let i=e;t.shouldLimitAssertionLogs&&(i=e.substring(0,t.assertionLogLimit));const a=new Error(i);a.name=this.failException||n.failException;throw a},pass:function pass(){},callOrder:function assertCallOrder(){verifyIsStub.apply(null,arguments);let e="";let t="";if(a(arguments))n.pass("callOrder");else{try{e=g(arguments,", ");const n=d(arguments);let i=n.length;while(i)n[--i].called||v(n,i,1);t=g(c(n),", ")}catch(e){}failAssertion(this,`expected ${e} to be called in order but were called as ${t}`)}},callCount:function assertCallCount(e,t){verifyIsStub(e);let i;if(typeof t!=="number"){i=`expected ${u(t)} to be a number but was of type `+typeof t;failAssertion(this,i)}else if(e.callCount!==t){i=`expected %n to be called ${l(t)} but was called %c%C`;failAssertion(this,e.printf(i))}else n.pass("callCount")},expose:function expose(e,t){if(!e)throw new TypeError("target is null or undefined");const n=t||{};const i=typeof n.prefix==="undefined"?"assert":n.prefix;const a=typeof n.includeFail==="undefined"||Boolean(n.includeFail);const s=this;y(Object.keys(s),(function(t){t==="expose"||!a&&/^(fail)/.test(t)||(e[exposedName(i,t)]=s[t])}));return e},match:function match(e,t){const i=s(t);if(i.test(e))n.pass("match");else{const n=["expected value to match",`    expected = ${u(t)}`,`    actual = ${u(e)}`];failAssertion(this,g(n,"\n"))}}};function verifyIsStub(){const e=d(arguments);y(e,(function(e){e||n.fail("fake is not a spy");if(e.proxy&&e.proxy.isSinonProxy)verifyIsStub(e.proxy);else{typeof e!=="function"&&n.fail(`${e} is not a function`);typeof e.getCall!=="function"&&n.fail(`${e} is not stubbed`)}}))}function verifyIsValidAssertion(e,t){switch(e){case"notCalled":case"called":case"calledOnce":case"calledTwice":case"calledThrice":t.length!==0&&n.fail(`${e} takes 1 argument but was called with ${t.length+1} arguments`);break;default:break}}function failAssertion(e,t){const i=e||h;const a=i.fail||n.fail;a.call(i,t)}function mirrorPropAsAssertion(e,t,i){let a=i;let s=t;if(arguments.length===2){a=t;s=e}n[e]=function(t){verifyIsStub(t);const i=d(arguments,1);let c=false;verifyIsValidAssertion(e,i);c=typeof s==="function"?!s(t):typeof t[s]==="function"?!t[s].apply(t,i):!t[s];c?failAssertion(this,(t.printf||t.proxy.printf).apply(t,m([a],i))):n.pass(e)}}function exposedName(e,t){return!e||/^fail/.test(t)?t:e+p(t,0,1).toUpperCase()+p(t,1)}mirrorPropAsAssertion("called","expected %n to have been called at least once but was never called");mirrorPropAsAssertion("notCalled",(function(e){return!e.called}),"expected %n to not have been called but was called %c%C");mirrorPropAsAssertion("calledOnce","expected %n to be called once but was called %c%C");mirrorPropAsAssertion("calledTwice","expected %n to be called twice but was called %c%C");mirrorPropAsAssertion("calledThrice","expected %n to be called thrice but was called %c%C");mirrorPropAsAssertion("calledOn","expected %n to be called with %1 as this but was called with %t");mirrorPropAsAssertion("alwaysCalledOn","expected %n to always be called with %1 as this but was called with %t");mirrorPropAsAssertion("calledWithNew","expected %n to be called with new");mirrorPropAsAssertion("alwaysCalledWithNew","expected %n to always be called with new");mirrorPropAsAssertion("calledWith","expected %n to be called with arguments %D");mirrorPropAsAssertion("calledWithMatch","expected %n to be called with match %D");mirrorPropAsAssertion("alwaysCalledWith","expected %n to always be called with arguments %D");mirrorPropAsAssertion("alwaysCalledWithMatch","expected %n to always be called with match %D");mirrorPropAsAssertion("calledWithExactly","expected %n to be called with exact arguments %D");mirrorPropAsAssertion("calledOnceWithExactly","expected %n to be called once and with exact arguments %D");mirrorPropAsAssertion("calledOnceWithMatch","expected %n to be called once and with match %D");mirrorPropAsAssertion("alwaysCalledWithExactly","expected %n to always be called with exact arguments %D");mirrorPropAsAssertion("neverCalledWith","expected %n to never be called with arguments %*%C");mirrorPropAsAssertion("neverCalledWithMatch","expected %n to never be called with match %*%C");mirrorPropAsAssertion("threw","%n did not throw exception%C");mirrorPropAsAssertion("alwaysThrew","%n did not always throw exception%C");return n}t.exports=createAssertObject();t.exports.createAssertObject=createAssertObject},{"./util/core/times-in-words":36,"@sinonjs/commons":47,"@sinonjs/samsam":87,util:91}],5:[function(e,t,n){const i=e("@sinonjs/commons").prototypes.array;const a=e("./util/core/extend");const s=e("@sinonjs/commons").functionName;const c=e("./util/core/next-tick");const l=e("@sinonjs/commons").valueToString;const u=e("./util/core/export-async-behaviors");const p=i.concat;const h=i.join;const d=i.reverse;const m=i.slice;const y=-1;const g=-2;function getCallback(e,t){const n=e.callArgAt;if(n>=0)return t[n];let i;n===y&&(i=t);n===g&&(i=d(m(t)));const a=e.callArgProp;for(let e=0,t=i.length;e<t;++e){if(!a&&typeof i[e]==="function")return i[e];if(a&&i[e]&&typeof i[e][a]==="function")return i[e][a]}return null}function getCallbackError(e,t,n){if(e.callArgAt<0){let t;t=e.callArgProp?`${s(e.stub)} expected to yield to '${l(e.callArgProp)}', but no object with such a property was passed.`:`${s(e.stub)} expected to yield, but no callback was passed.`;n.length>0&&(t+=` Received [${h(n,", ")}]`);return t}return`argument at index ${e.callArgAt} is not a function: ${t}`}function ensureArgs(e,t,n){const i=e.replace(/sArg/,"ArgAt");const a=t[i];if(a>=n.length)throw new TypeError(`${e} failed: ${a+1} arguments required but only ${n.length} present`)}function callCallback(e,t){if(typeof e.callArgAt==="number"){ensureArgs("callsArg",e,t);const n=getCallback(e,t);if(typeof n!=="function")throw new TypeError(getCallbackError(e,n,t));if(!e.callbackAsync)return n.apply(e.callbackContext,e.callbackArguments);c((function(){n.apply(e.callbackContext,e.callbackArguments)}))}}const v={create:function create(e){const t=a({},v);delete t.create;delete t.addBehavior;delete t.createBehavior;t.stub=e;e.defaultBehavior&&e.defaultBehavior.promiseLibrary&&(t.promiseLibrary=e.defaultBehavior.promiseLibrary);return t},isPresent:function isPresent(){return typeof this.callArgAt==="number"||this.exception||this.exceptionCreator||typeof this.returnArgAt==="number"||this.returnThis||typeof this.resolveArgAt==="number"||this.resolveThis||typeof this.throwArgAt==="number"||this.fakeFn||this.returnValueDefined},invoke:function invoke(e,t){const n=callCallback(this,t);if(this.exception)throw this.exception;if(this.exceptionCreator){this.exception=this.exceptionCreator();this.exceptionCreator=void 0;throw this.exception}if(typeof this.returnArgAt==="number"){ensureArgs("returnsArg",this,t);return t[this.returnArgAt]}if(this.returnThis)return e;if(typeof this.throwArgAt==="number"){ensureArgs("throwsArg",this,t);throw t[this.throwArgAt]}if(this.fakeFn)return this.fakeFn.apply(e,t);if(typeof this.resolveArgAt==="number"){ensureArgs("resolvesArg",this,t);return(this.promiseLibrary||Promise).resolve(t[this.resolveArgAt])}if(this.resolveThis)return(this.promiseLibrary||Promise).resolve(e);if(this.resolve)return(this.promiseLibrary||Promise).resolve(this.returnValue);if(this.reject)return(this.promiseLibrary||Promise).reject(this.returnValue);if(this.callsThrough){const n=this.effectiveWrappedMethod();return n.apply(e,t)}if(this.callsThroughWithNew){const e=this.effectiveWrappedMethod();const n=m(t);const i=e.bind.apply(e,p([null],n));return new i}return typeof this.returnValue!=="undefined"?this.returnValue:typeof this.callArgAt==="number"?n:this.returnValue},effectiveWrappedMethod:function effectiveWrappedMethod(){for(let e=this.stub;e;e=e.parent)if(e.wrappedMethod)return e.wrappedMethod;throw new Error("Unable to find wrapped method")},onCall:function onCall(e){return this.stub.onCall(e)},onFirstCall:function onFirstCall(){return this.stub.onFirstCall()},onSecondCall:function onSecondCall(){return this.stub.onSecondCall()},onThirdCall:function onThirdCall(){return this.stub.onThirdCall()},withArgs:function withArgs(){throw new Error('Defining a stub by invoking "stub.onCall(...).withArgs(...)" is not supported. Use "stub.withArgs(...).onCall(...)" to define sequential behavior for calls with certain arguments.')}};function createBehavior(e){return function(){this.defaultBehavior=this.defaultBehavior||v.create(this);this.defaultBehavior[e].apply(this.defaultBehavior,arguments);return this}}function addBehavior(e,t,n){v[t]=function(){n.apply(this,p([this],m(arguments)));return this.stub||this};e[t]=createBehavior(t)}v.addBehavior=addBehavior;v.createBehavior=createBehavior;const b=u(v);t.exports=a.nonEnum({},v,b)},{"./util/core/export-async-behaviors":25,"./util/core/extend":26,"./util/core/next-tick":34,"@sinonjs/commons":47}],6:[function(e,t,n){const i=e("./util/core/walk");const a=e("./util/core/get-property-descriptor");const s=e("@sinonjs/commons").prototypes.object.hasOwnProperty;const c=e("@sinonjs/commons").prototypes.array.push;function collectMethod(e,t,n,i){typeof a(i,n).value==="function"&&s(t,n)&&c(e,t[n])}function collectOwnMethods(e){const t=[];i(e,collectMethod.bind(null,t,e));return t}t.exports=collectOwnMethods},{"./util/core/get-property-descriptor":29,"./util/core/walk":38,"@sinonjs/commons":47}],7:[function(e,t,n){t.exports=class Colorizer{constructor(t=e("supports-color")){this.supportsColor=t}colorize(e,t){return this.supportsColor.stdout===false?e:`[${t}m${e}[0m`}red(e){return this.colorize(e,31)}green(e){return this.colorize(e,32)}cyan(e){return this.colorize(e,96)}white(e){return this.colorize(e,39)}bold(e){return this.colorize(e,1)}}},{"supports-color":94}],8:[function(e,t,n){const i=e("@sinonjs/commons").prototypes.array;const a=e("./sandbox");const s=i.forEach;const c=i.push;function prepareSandboxFromConfig(e){const t=new a({assertOptions:e.assertOptions});e.useFakeTimers&&(typeof e.useFakeTimers==="object"?t.useFakeTimers(e.useFakeTimers):t.useFakeTimers());return t}function exposeValue(e,t,n,i){if(i)if(t.injectInto&&!(n in t.injectInto)){t.injectInto[n]=i;c(e.injectedKeys,n)}else c(e.args,i)}
/**
 * Options to customize a sandbox
 *
 * The sandbox's methods can be injected into another object for
 * convenience. The `injectInto` configuration option can name an
 * object to add properties to.
 *
 * @typedef {object} SandboxConfig
 * @property {string[]} properties The properties of the API to expose on the sandbox. Examples: ['spy', 'fake', 'restore']
 * @property {object} injectInto an object in which to inject properties from the sandbox (a facade). This is mostly an integration feature (sinon-test being one).
 * @property {boolean} useFakeTimers  whether timers are faked by default
 * @property {object} [assertOptions] see CreateAssertOptions in ./assert
 *
 * This type def is really suffering from JSDoc not having standardized
 * how to reference types defined in other modules :(
 */
/**
 * A configured sinon sandbox (private type)
 *
 * @typedef {object} ConfiguredSinonSandboxType
 * @private
 * @augments Sandbox
 * @property {string[]} injectedKeys the keys that have been injected (from config.injectInto)
 * @property {*[]} args the arguments for the sandbox
 */
/**
 * Create a sandbox
 *
 * As of Sinon 5 the `sinon` instance itself is a Sandbox, so you
 * hardly ever need to create additional instances for the sake of testing
 *
 * @param config {SandboxConfig}
 * @returns {Sandbox}
 */function createSandbox(e){if(!e)return new a;const t=prepareSandboxFromConfig(e);t.args=t.args||[];t.injectedKeys=[];t.injectInto=e.injectInto;const n=t.inject({});e.properties?s(e.properties,(function(i){const a=n[i]||i==="sandbox"&&t;exposeValue(t,e,i,a)})):exposeValue(t,e,"sandbox");return t}t.exports=createSandbox},{"./sandbox":20,"@sinonjs/commons":47}],9:[function(e,t,n){const i=e("./stub");const a=e("./util/core/sinon-type");const s=e("@sinonjs/commons").prototypes.array.forEach;function isStub(e){return a.get(e)==="stub"}t.exports=function createStubInstance(e,t){if(typeof e!=="function")throw new TypeError("The constructor should be a function.");const n=Object.create(e.prototype);a.set(n,"stub-instance");const c=i(n);s(Object.keys(t||{}),(function(e){if(!(e in c))throw new Error(`Cannot stub ${e}. Property does not exist!`);{const n=t[e];isStub(n)?c[e]=n:c[e].returns(n)}}));return c}},{"./stub":23,"./util/core/sinon-type":35,"@sinonjs/commons":47}],10:[function(e,t,n){const i=e("@sinonjs/commons").prototypes.array;const a=e("./util/core/is-property-configurable");const s=e("./util/core/export-async-behaviors");const c=e("./util/core/extend");const l=i.slice;const u=-1;const p=-2;function throwsException(e,t,n){typeof t==="function"?e.exceptionCreator=t:typeof t==="string"?e.exceptionCreator=function(){const e=new Error(n||`Sinon-provided ${t}`);e.name=t;return e}:t?e.exception=t:e.exceptionCreator=function(){return new Error("Error")}}const h={callsFake:function callsFake(e,t){e.fakeFn=t;e.exception=void 0;e.exceptionCreator=void 0;e.callsThrough=false},callsArg:function callsArg(e,t){if(typeof t!=="number")throw new TypeError("argument index is not number");e.callArgAt=t;e.callbackArguments=[];e.callbackContext=void 0;e.callArgProp=void 0;e.callbackAsync=false;e.callsThrough=false},callsArgOn:function callsArgOn(e,t,n){if(typeof t!=="number")throw new TypeError("argument index is not number");e.callArgAt=t;e.callbackArguments=[];e.callbackContext=n;e.callArgProp=void 0;e.callbackAsync=false;e.callsThrough=false},callsArgWith:function callsArgWith(e,t){if(typeof t!=="number")throw new TypeError("argument index is not number");e.callArgAt=t;e.callbackArguments=l(arguments,2);e.callbackContext=void 0;e.callArgProp=void 0;e.callbackAsync=false;e.callsThrough=false},callsArgOnWith:function callsArgWith(e,t,n){if(typeof t!=="number")throw new TypeError("argument index is not number");e.callArgAt=t;e.callbackArguments=l(arguments,3);e.callbackContext=n;e.callArgProp=void 0;e.callbackAsync=false;e.callsThrough=false},yields:function(e){e.callArgAt=u;e.callbackArguments=l(arguments,1);e.callbackContext=void 0;e.callArgProp=void 0;e.callbackAsync=false;e.fakeFn=void 0;e.callsThrough=false},yieldsRight:function(e){e.callArgAt=p;e.callbackArguments=l(arguments,1);e.callbackContext=void 0;e.callArgProp=void 0;e.callbackAsync=false;e.callsThrough=false;e.fakeFn=void 0},yieldsOn:function(e,t){e.callArgAt=u;e.callbackArguments=l(arguments,2);e.callbackContext=t;e.callArgProp=void 0;e.callbackAsync=false;e.callsThrough=false;e.fakeFn=void 0},yieldsTo:function(e,t){e.callArgAt=u;e.callbackArguments=l(arguments,2);e.callbackContext=void 0;e.callArgProp=t;e.callbackAsync=false;e.callsThrough=false;e.fakeFn=void 0},yieldsToOn:function(e,t,n){e.callArgAt=u;e.callbackArguments=l(arguments,3);e.callbackContext=n;e.callArgProp=t;e.callbackAsync=false;e.fakeFn=void 0},throws:throwsException,throwsException:throwsException,returns:function returns(e,t){e.callsThrough=false;e.returnValue=t;e.resolve=false;e.reject=false;e.returnValueDefined=true;e.exception=void 0;e.exceptionCreator=void 0;e.fakeFn=void 0},returnsArg:function returnsArg(e,t){if(typeof t!=="number")throw new TypeError("argument index is not number");e.callsThrough=false;e.returnArgAt=t},throwsArg:function throwsArg(e,t){if(typeof t!=="number")throw new TypeError("argument index is not number");e.callsThrough=false;e.throwArgAt=t},returnsThis:function returnsThis(e){e.returnThis=true;e.callsThrough=false},resolves:function resolves(e,t){e.returnValue=t;e.resolve=true;e.resolveThis=false;e.reject=false;e.returnValueDefined=true;e.exception=void 0;e.exceptionCreator=void 0;e.fakeFn=void 0;e.callsThrough=false},resolvesArg:function resolvesArg(e,t){if(typeof t!=="number")throw new TypeError("argument index is not number");e.resolveArgAt=t;e.returnValue=void 0;e.resolve=true;e.resolveThis=false;e.reject=false;e.returnValueDefined=false;e.exception=void 0;e.exceptionCreator=void 0;e.fakeFn=void 0;e.callsThrough=false},rejects:function rejects(e,t,n){let i;if(typeof t==="string"){i=new Error(n||"");i.name=t}else i=t||new Error("Error");e.returnValue=i;e.resolve=false;e.resolveThis=false;e.reject=true;e.returnValueDefined=true;e.exception=void 0;e.exceptionCreator=void 0;e.fakeFn=void 0;e.callsThrough=false;return e},resolvesThis:function resolvesThis(e){e.returnValue=void 0;e.resolve=false;e.resolveThis=true;e.reject=false;e.returnValueDefined=false;e.exception=void 0;e.exceptionCreator=void 0;e.fakeFn=void 0;e.callsThrough=false},callThrough:function callThrough(e){e.callsThrough=true},callThroughWithNew:function callThroughWithNew(e){e.callsThroughWithNew=true},get:function get(e,t){const n=e.stub||e;Object.defineProperty(n.rootObj,n.propName,{get:t,configurable:a(n.rootObj,n.propName)});return e},set:function set(e,t){const n=e.stub||e;Object.defineProperty(n.rootObj,n.propName,{set:t,configurable:a(n.rootObj,n.propName)});return e},value:function value(e,t){const n=e.stub||e;Object.defineProperty(n.rootObj,n.propName,{value:t,enumerable:true,writable:true,configurable:n.shadowsPropOnPrototype||a(n.rootObj,n.propName)});return e}};const d=s(h);t.exports=c({},h,d)},{"./util/core/export-async-behaviors":25,"./util/core/extend":26,"./util/core/is-property-configurable":32,"@sinonjs/commons":47}],11:[function(e,t,n){const i=e("@sinonjs/commons").prototypes.array;const a=e("./proxy");const s=e("./util/core/next-tick");const c=i.slice;t.exports=fake;
/**
 * Returns a `fake` that records all calls, arguments and return values.
 *
 * When an `f` argument is supplied, this implementation will be used.
 *
 * @example
 * // create an empty fake
 * var f1 = sinon.fake();
 *
 * f1();
 *
 * f1.calledOnce()
 * // true
 *
 * @example
 * function greet(greeting) {
 *   console.log(`Hello ${greeting}`);
 * }
 *
 * // create a fake with implementation
 * var f2 = sinon.fake(greet);
 *
 * // Hello world
 * f2("world");
 *
 * f2.calledWith("world");
 * // true
 *
 * @param {Function|undefined} f
 * @returns {Function}
 * @namespace
 */function fake(e){if(arguments.length>0&&typeof e!=="function")throw new TypeError("Expected f argument to be a Function");return wrapFunc(e)}
/**
 * Creates a `fake` that returns the provided `value`, as well as recording all
 * calls, arguments and return values.
 *
 * @example
 * var f1 = sinon.fake.returns(42);
 *
 * f1();
 * // 42
 *
 * @memberof fake
 * @param {*} value
 * @returns {Function}
 */fake.returns=function returns(e){function f(){return e}return wrapFunc(f)};
/**
 * Creates a `fake` that throws an Error.
 * If the `value` argument does not have Error in its prototype chain, it will
 * be used for creating a new error.
 *
 * @example
 * var f1 = sinon.fake.throws("hello");
 *
 * f1();
 * // Uncaught Error: hello
 *
 * @example
 * var f2 = sinon.fake.throws(new TypeError("Invalid argument"));
 *
 * f2();
 * // Uncaught TypeError: Invalid argument
 *
 * @memberof fake
 * @param {*|Error} value
 * @returns {Function}
 */fake.throws=function throws(e){function f(){throw getError(e)}return wrapFunc(f)};
/**
 * Creates a `fake` that returns a promise that resolves to the passed `value`
 * argument.
 *
 * @example
 * var f1 = sinon.fake.resolves("apple pie");
 *
 * await f1();
 * // "apple pie"
 *
 * @memberof fake
 * @param {*} value
 * @returns {Function}
 */fake.resolves=function resolves(e){function f(){return Promise.resolve(e)}return wrapFunc(f)};
/**
 * Creates a `fake` that returns a promise that rejects to the passed `value`
 * argument. When `value` does not have Error in its prototype chain, it will be
 * wrapped in an Error.
 *
 * @example
 * var f1 = sinon.fake.rejects(":(");
 *
 * try {
 *   await f1();
 * } catch (error) {
 *   console.log(error);
 *   // ":("
 * }
 *
 * @memberof fake
 * @param {*} value
 * @returns {Function}
 */fake.rejects=function rejects(e){function f(){return Promise.reject(getError(e))}return wrapFunc(f)};
/**
 * Returns a `fake` that calls the callback with the defined arguments.
 *
 * @example
 * function callback() {
 *   console.log(arguments.join("*"));
 * }
 *
 * const f1 = sinon.fake.yields("apple", "pie");
 *
 * f1(callback);
 * // "apple*pie"
 *
 * @memberof fake
 * @returns {Function}
 */fake.yields=function yields(){const e=c(arguments);function f(){const t=arguments[arguments.length-1];if(typeof t!=="function")throw new TypeError("Expected last argument to be a function");t.apply(null,e)}return wrapFunc(f)};
/**
 * Returns a `fake` that calls the callback **asynchronously** with the
 * defined arguments.
 *
 * @example
 * function callback() {
 *   console.log(arguments.join("*"));
 * }
 *
 * const f1 = sinon.fake.yields("apple", "pie");
 *
 * f1(callback);
 *
 * setTimeout(() => {
 *   // "apple*pie"
 * });
 *
 * @memberof fake
 * @returns {Function}
 */fake.yieldsAsync=function yieldsAsync(){const e=c(arguments);function f(){const t=arguments[arguments.length-1];if(typeof t!=="function")throw new TypeError("Expected last argument to be a function");s((function(){t.apply(null,e)}))}return wrapFunc(f)};let l=0;
/**
 * Creates a proxy (sinon concept) from the passed function.
 *
 * @private
 * @param  {Function} f
 * @returns {Function}
 */function wrapFunc(e){const fakeInstance=function(){let n,i;if(arguments.length>0){n=arguments[0];i=arguments[arguments.length-1]}const a=i&&typeof i==="function"?i:void 0;t.firstArg=n;t.lastArg=i;t.callback=a;return e&&e.apply(this,arguments)};const t=a(fakeInstance,e||fakeInstance);t.displayName="fake";t.id="fake#"+l++;return t}
/**
 * Returns an Error instance from the passed value, if the value is not
 * already an Error instance.
 *
 * @private
 * @param  {*} value [description]
 * @returns {Error}       [description]
 */function getError(e){return e instanceof Error?e:new Error(e)}},{"./proxy":18,"./util/core/next-tick":34,"@sinonjs/commons":47}],12:[function(e,t,n){const i=e("@sinonjs/commons").prototypes.array;const a=e("./proxy-invoke");const s=e("./proxy-call").toString;const c=e("./util/core/times-in-words");const l=e("./util/core/extend");const u=e("@sinonjs/samsam").createMatcher;const p=e("./stub");const h=e("./assert");const d=e("@sinonjs/samsam").deepEqual;const m=e("util").inspect;const y=e("@sinonjs/commons").valueToString;const g=i.every;const v=i.forEach;const b=i.push;const w=i.slice;function callCountInWords(e){return e===0?"never called":`called ${c(e)}`}function expectedCallCountInWords(e){const t=e.minCalls;const n=e.maxCalls;if(typeof t==="number"&&typeof n==="number"){let e=c(t);t!==n&&(e=`at least ${e} and at most ${c(n)}`);return e}return typeof t==="number"?`at least ${c(t)}`:`at most ${c(n)}`}function receivedMinCalls(e){const t=typeof e.minCalls==="number";return!t||e.callCount>=e.minCalls}function receivedMaxCalls(e){return typeof e.maxCalls==="number"&&e.callCount===e.maxCalls}function verifyMatcher(e,t){const n=u.isMatcher(e);return n&&e.test(t)||true}const x={minCalls:1,maxCalls:1,create:function create(e){const t=l.nonEnum(p(),x);delete t.create;t.method=e;return t},invoke:function invoke(e,t,n){this.verifyCallAllowed(t,n);return a.apply(this,arguments)},atLeast:function atLeast(e){if(typeof e!=="number")throw new TypeError(`'${y(e)}' is not number`);if(!this.limitsSet){this.maxCalls=null;this.limitsSet=true}this.minCalls=e;return this},atMost:function atMost(e){if(typeof e!=="number")throw new TypeError(`'${y(e)}' is not number`);if(!this.limitsSet){this.minCalls=null;this.limitsSet=true}this.maxCalls=e;return this},never:function never(){return this.exactly(0)},once:function once(){return this.exactly(1)},twice:function twice(){return this.exactly(2)},thrice:function thrice(){return this.exactly(3)},exactly:function exactly(e){if(typeof e!=="number")throw new TypeError(`'${y(e)}' is not a number`);this.atLeast(e);return this.atMost(e)},met:function met(){return!this.failed&&receivedMinCalls(this)},verifyCallAllowed:function verifyCallAllowed(e,t){const n=this.expectedArguments;if(receivedMaxCalls(this)){this.failed=true;x.fail(`${this.method} already called ${c(this.maxCalls)}`)}"expectedThis"in this&&this.expectedThis!==e&&x.fail(`${this.method} called with ${y(e)} as thisValue, expected ${y(this.expectedThis)}`);if("expectedArguments"in this){t||x.fail(`${this.method} received no arguments, expected ${m(n)}`);t.length<n.length&&x.fail(`${this.method} received too few arguments (${m(t)}), expected ${m(n)}`);this.expectsExactArgCount&&t.length!==n.length&&x.fail(`${this.method} received too many arguments (${m(t)}), expected ${m(n)}`);v(n,(function(e,i){verifyMatcher(e,t[i])||x.fail(`${this.method} received wrong arguments ${m(t)}, didn't match ${String(n)}`);d(t[i],e)||x.fail(`${this.method} received wrong arguments ${m(t)}, expected ${m(n)}`)}),this)}},allowsCall:function allowsCall(e,t){const n=this.expectedArguments;if(this.met()&&receivedMaxCalls(this))return false;if("expectedThis"in this&&this.expectedThis!==e)return false;if(!("expectedArguments"in this))return true;const i=t||[];return!(i.length<n.length)&&((!this.expectsExactArgCount||i.length===n.length)&&g(n,(function(e,t){return!!verifyMatcher(e,i[t])&&!!d(i[t],e)})))},withArgs:function withArgs(){this.expectedArguments=w(arguments);return this},withExactArgs:function withExactArgs(){this.withArgs.apply(this,arguments);this.expectsExactArgCount=true;return this},on:function on(e){this.expectedThis=e;return this},toString:function(){const e=w(this.expectedArguments||[]);this.expectsExactArgCount||b(e,"[...]");const t=s.call({proxy:this.method||"anonymous mock expectation",args:e});const n=`${t.replace(", [...","[, ...")} ${expectedCallCountInWords(this)}`;return this.met()?`Expectation met: ${n}`:`Expected ${n} (${callCountInWords(this.callCount)})`},verify:function verify(){this.met()?x.pass(String(this)):x.fail(String(this));return true},pass:function pass(e){h.pass(e)},fail:function fail(e){const t=new Error(e);t.name="ExpectationError";throw t}};t.exports=x},{"./assert":4,"./proxy-call":16,"./proxy-invoke":17,"./stub":23,"./util/core/extend":26,"./util/core/times-in-words":36,"@sinonjs/commons":47,"@sinonjs/samsam":87,util:91}],13:[function(e,t,n){const i=e("@sinonjs/commons").prototypes.array;const a=e("./mock-expectation");const s=e("./proxy-call").toString;const c=e("./util/core/extend");const l=e("@sinonjs/samsam").deepEqual;const u=e("./util/core/wrap-method");const p=i.concat;const h=i.filter;const d=i.forEach;const m=i.every;const y=i.join;const g=i.push;const v=i.slice;const b=i.unshift;function mock(e){return e&&typeof e!=="string"?mock.create(e):a.create(e||"Anonymous mock")}function each(e,t){const n=e||[];d(n,t)}function arrayEquals(e,t,n){return(!n||e.length===t.length)&&m(e,(function(e,n){return l(t[n],e)}))}c(mock,{create:function create(e){if(!e)throw new TypeError("object is null");const t=c.nonEnum({},mock,{object:e});delete t.create;return t},expects:function expects(e){if(!e)throw new TypeError("method is falsy");if(!this.expectations){this.expectations={};this.proxies=[];this.failures=[]}if(!this.expectations[e]){this.expectations[e]=[];const t=this;u(this.object,e,(function(){return t.invokeMethod(e,this,arguments)}));g(this.proxies,e)}const t=a.create(e);t.wrappedMethod=this.object[e].wrappedMethod;g(this.expectations[e],t);return t},restore:function restore(){const e=this.object;each(this.proxies,(function(t){typeof e[t].restore==="function"&&e[t].restore()}))},verify:function verify(){const e=this.expectations||{};const t=this.failures?v(this.failures):[];const n=[];each(this.proxies,(function(i){each(e[i],(function(e){e.met()?g(n,String(e)):g(t,String(e))}))}));this.restore();t.length>0?a.fail(y(p(t,n),"\n")):n.length>0&&a.pass(y(p(t,n),"\n"));return true},invokeMethod:function invokeMethod(e,t,n){const i=this.expectations&&this.expectations[e]?this.expectations[e]:[];const c=n||[];let l;const u=h(i,(function(e){const t=e.expectedArguments||[];return arrayEquals(t,c,e.expectsExactArgCount)}));const p=h(u,(function(e){return!e.met()&&e.allowsCall(t,n)}));if(p.length>0)return p[0].apply(t,n);const m=[];let v=0;d(u,(function(e){e.allowsCall(t,n)?l=l||e:v+=1}));if(l&&v===0)return l.apply(t,n);d(i,(function(e){g(m,`    ${String(e)}`)}));b(m,`Unexpected call: ${s.call({proxy:e,args:n})}`);const w=new Error;if(!w.stack)try{throw w}catch(e){}g(this.failures,`Unexpected call: ${s.call({proxy:e,args:n,stack:w.stack})}`);a.fail(y(m,"\n"))}});t.exports=mock},{"./mock-expectation":12,"./proxy-call":16,"./util/core/extend":26,"./util/core/wrap-method":39,"@sinonjs/commons":47,"@sinonjs/samsam":87}],14:[function(e,t,n){const i=e("./fake");const a=e("./util/core/is-restorable");const s="pending";const c="resolved";const l="rejected";
/**
 * Returns a fake for a given function or undefined. If no function is given, a
 * new fake is returned. If the given function is already a fake, it is
 * returned as is. Otherwise the given function is wrapped in a new fake.
 *
 * @param {Function} [executor] The optional executor function.
 * @returns {Function}
 */function getFakeExecutor(e){return a(e)?e:e?i(e):i()}
/**
 * Returns a new promise that exposes it's internal `status`, `resolvedValue`
 * and `rejectedValue` and can be resolved or rejected from the outside by
 * calling `resolve(value)` or `reject(reason)`.
 *
 * @param {Function} [executor] The optional executor function.
 * @returns {Promise}
 */function promise(e){const t=getFakeExecutor(e);const n=new Promise(t);n.status=s;n.then((function(e){n.status=c;n.resolvedValue=e})).catch((function(e){n.status=l;n.rejectedValue=e}));
/**
     * Resolves or rejects the promise with the given status and value.
     *
     * @param {string} status
     * @param {*} value
     * @param {Function} callback
     */function finalize(e,t,i){if(n.status!==s)throw new Error(`Promise already ${n.status}`);n.status=e;i(t)}n.resolve=function(e){finalize(c,e,t.firstCall.args[0]);return n};n.reject=function(e){finalize(l,e,t.firstCall.args[1]);return new Promise((function(e){n.catch((()=>e()))}))};return n}t.exports=promise},{"./fake":11,"./util/core/is-restorable":33}],15:[function(e,t,n){const i=e("@sinonjs/commons").prototypes.array.push;n.incrementCallCount=function incrementCallCount(e){e.called=true;e.callCount+=1;e.notCalled=false;e.calledOnce=e.callCount===1;e.calledTwice=e.callCount===2;e.calledThrice=e.callCount===3};n.createCallProperties=function createCallProperties(e){e.firstCall=e.getCall(0);e.secondCall=e.getCall(1);e.thirdCall=e.getCall(2);e.lastCall=e.getCall(e.callCount-1)};n.delegateToCalls=function delegateToCalls(e,t,n,a,s,c,l){e[t]=function(){if(!this.called)return!!c&&c.apply(this,arguments);if(l!==void 0&&this.callCount!==l)return false;let e;let u=0;const p=[];for(let s=0,c=this.callCount;s<c;s+=1){e=this.getCall(s);const c=e[a||t].apply(e,arguments);i(p,c);if(c){u+=1;if(n)return true}}return s?p:u===this.callCount}}},{"@sinonjs/commons":47}],16:[function(e,t,n){const i=e("@sinonjs/commons").prototypes.array;const a=e("@sinonjs/samsam").createMatcher;const s=e("@sinonjs/samsam").deepEqual;const c=e("@sinonjs/commons").functionName;const l=e("util").inspect;const u=e("@sinonjs/commons").valueToString;const p=i.concat;const h=i.filter;const d=i.join;const m=i.map;const y=i.reduce;const g=i.slice;
/**
 * @param proxy
 * @param text
 * @param args
 */function throwYieldError(e,t,n){let i=c(e)+t;n.length&&(i+=` Received [${d(g(n),", ")}]`);throw new Error(i)}const v={calledOn:function calledOn(e){return a.isMatcher(e)?e.test(this.thisValue):this.thisValue===e},calledWith:function calledWith(){const e=this;const t=g(arguments);return!(t.length>e.args.length)&&y(t,(function(t,n,i){return t&&s(e.args[i],n)}),true)},calledWithMatch:function calledWithMatch(){const e=this;const t=g(arguments);return!(t.length>e.args.length)&&y(t,(function(t,n,i){const s=e.args[i];return t&&a(n).test(s)}),true)},calledWithExactly:function calledWithExactly(){return arguments.length===this.args.length&&this.calledWith.apply(this,arguments)},notCalledWith:function notCalledWith(){return!this.calledWith.apply(this,arguments)},notCalledWithMatch:function notCalledWithMatch(){return!this.calledWithMatch.apply(this,arguments)},returned:function returned(e){return s(this.returnValue,e)},threw:function threw(e){return typeof e!=="undefined"&&this.exception?this.exception===e||this.exception.name===e:Boolean(this.exception)},calledWithNew:function calledWithNew(){return this.proxy.prototype&&this.thisValue instanceof this.proxy},calledBefore:function(e){return this.callId<e.callId},calledAfter:function(e){return this.callId>e.callId},calledImmediatelyBefore:function(e){return this.callId===e.callId-1},calledImmediatelyAfter:function(e){return this.callId===e.callId+1},callArg:function(e){this.ensureArgIsAFunction(e);return this.args[e]()},callArgOn:function(e,t){this.ensureArgIsAFunction(e);return this.args[e].apply(t)},callArgWith:function(e){return this.callArgOnWith.apply(this,p([e,null],g(arguments,1)))},callArgOnWith:function(e,t){this.ensureArgIsAFunction(e);const n=g(arguments,2);return this.args[e].apply(t,n)},throwArg:function(e){if(e>this.args.length)throw new TypeError(`Not enough arguments: ${e} required but only ${this.args.length} present`);throw this.args[e]},yield:function(){return this.yieldOn.apply(this,p([null],g(arguments,0)))},yieldOn:function(e){const t=g(this.args);const n=h(t,(function(e){return typeof e==="function"}))[0];n||throwYieldError(this.proxy," cannot yield since no callback was passed.",t);return n.apply(e,g(arguments,1))},yieldTo:function(e){return this.yieldToOn.apply(this,p([e,null],g(arguments,1)))},yieldToOn:function(e,t){const n=g(this.args);const i=h(n,(function(t){return t&&typeof t[e]==="function"}))[0];const a=i&&i[e];a||throwYieldError(this.proxy,` cannot yield to '${u(e)}' since no callback was passed.`,n);return a.apply(t,g(arguments,2))},toString:function(){if(!this.args)return":(";let e=this.proxy?`${String(this.proxy)}(`:"";const t=m(this.args,(function(e){return l(e)}));e=`${e+d(t,", ")})`;typeof this.returnValue!=="undefined"&&(e+=` => ${l(this.returnValue)}`);if(this.exception){e+=` !${this.exception.name}`;this.exception.message&&(e+=`(${this.exception.message})`)}this.stack&&(e+=(this.stack.split("\n")[3]||"unknown").replace(/^\s*(?:at\s+|@)?/," at "));return e},ensureArgIsAFunction:function(e){if(typeof this.args[e]!=="function")throw new TypeError(`Expected argument at position ${e} to be a Function, but was ${typeof this.args[e]}`)}};Object.defineProperty(v,"stack",{enumerable:true,configurable:true,get:function(){return this.errorWithCallStack&&this.errorWithCallStack.stack||""}});v.invokeCallback=v.yield;
/**
 * @param proxy
 * @param thisValue
 * @param args
 * @param returnValue
 * @param exception
 * @param id
 * @param errorWithCallStack
 *
 * @returns {object} proxyCall
 */function createProxyCall(e,t,n,i,a,s,c){if(typeof s!=="number")throw new TypeError("Call id is not a number");let l,u;if(n.length>0){l=n[0];u=n[n.length-1]}const p=Object.create(v);const h=u&&typeof u==="function"?u:void 0;p.proxy=e;p.thisValue=t;p.args=n;p.firstArg=l;p.lastArg=u;p.callback=h;p.returnValue=i;p.exception=a;p.callId=s;p.errorWithCallStack=c;return p}createProxyCall.toString=v.toString;t.exports=createProxyCall},{"@sinonjs/commons":47,"@sinonjs/samsam":87,util:91}],17:[function(e,t,n){const i=e("@sinonjs/commons").prototypes.array;const a=e("./proxy-call-util");const s=i.push;const c=i.forEach;const l=i.concat;const u=Error.prototype.constructor;const p=Function.prototype.bind;let h=0;t.exports=function invoke(e,t,n){const i=this.matchingFakes(n);const d=h++;let m,y;a.incrementCallCount(this);s(this.thisValues,t);s(this.args,n);s(this.callIds,d);c(i,(function(e){a.incrementCallCount(e);s(e.thisValues,t);s(e.args,n);s(e.callIds,d)}));a.createCallProperties(this);c(i,a.createCallProperties);try{this.invoking=true;const i=this.getCall(this.callCount-1);if(i.calledWithNew()){y=new(p.apply(this.func||e,l([t],n)));typeof y!=="object"&&typeof y!=="function"&&(y=t)}else y=(this.func||e).apply(t,n)}catch(e){m=e}finally{delete this.invoking}s(this.exceptions,m);s(this.returnValues,y);c(i,(function(e){s(e.exceptions,m);s(e.returnValues,y)}));const g=new u;try{throw g}catch(e){}s(this.errorsWithCallStack,g);c(i,(function(e){s(e.errorsWithCallStack,g)}));a.createCallProperties(this);c(i,a.createCallProperties);if(m!==void 0)throw m;return y}},{"./proxy-call-util":15,"@sinonjs/commons":47}],18:[function(e,t,n){const i=e("@sinonjs/commons").prototypes.array;const a=e("./util/core/extend");const s=e("./util/core/function-to-string");const c=e("./proxy-call");const l=e("./proxy-call-util");const u=e("./proxy-invoke");const p=e("util").inspect;const h=i.push;const d=i.forEach;const m=i.slice;const y=Object.freeze([]);const g={toString:s,named:function named(e){this.displayName=e;const t=Object.getOwnPropertyDescriptor(this,"name");if(t&&t.configurable){t.value=e;Object.defineProperty(this,"name",t)}return this},invoke:u,matchingFakes:function(){return y},getCall:function getCall(e){let t=e;t<0&&(t+=this.callCount);return t<0||t>=this.callCount?null:c(this,this.thisValues[t],this.args[t],this.returnValues[t],this.exceptions[t],this.callIds[t],this.errorsWithCallStack[t])},getCalls:function(){const e=[];let t;for(t=0;t<this.callCount;t++)h(e,this.getCall(t));return e},calledBefore:function calledBefore(e){return!!this.called&&(!e.called||this.callIds[0]<e.callIds[e.callIds.length-1])},calledAfter:function calledAfter(e){return!(!this.called||!e.called)&&this.callIds[this.callCount-1]>e.callIds[0]},calledImmediatelyBefore:function calledImmediatelyBefore(e){return!(!this.called||!e.called)&&this.callIds[this.callCount-1]===e.callIds[e.callCount-1]-1},calledImmediatelyAfter:function calledImmediatelyAfter(e){return!(!this.called||!e.called)&&this.callIds[this.callCount-1]===e.callIds[e.callCount-1]+1},formatters:e("./spy-formatters"),printf:function(e){const t=this;const n=m(arguments,1);let i;return(e||"").replace(/%(.)/g,(function(e,a){i=g.formatters[a];return typeof i==="function"?String(i(t,n)):isNaN(parseInt(a,10))?`%${a}`:p(n[a-1])}))},resetHistory:function(){if(this.invoking){const e=new Error("Cannot reset Sinon function while invoking it. Move the call to .resetHistory outside of the callback.");e.name="InvalidResetException";throw e}this.called=false;this.notCalled=true;this.calledOnce=false;this.calledTwice=false;this.calledThrice=false;this.callCount=0;this.firstCall=null;this.secondCall=null;this.thirdCall=null;this.lastCall=null;this.args=[];this.firstArg=null;this.lastArg=null;this.returnValues=[];this.thisValues=[];this.exceptions=[];this.callIds=[];this.errorsWithCallStack=[];this.fakes&&d(this.fakes,(function(e){e.resetHistory()}));return this}};const v=l.delegateToCalls;v(g,"calledOn",true);v(g,"alwaysCalledOn",false,"calledOn");v(g,"calledWith",true);v(g,"calledOnceWith",true,"calledWith",false,void 0,1);v(g,"calledWithMatch",true);v(g,"alwaysCalledWith",false,"calledWith");v(g,"alwaysCalledWithMatch",false,"calledWithMatch");v(g,"calledWithExactly",true);v(g,"calledOnceWithExactly",true,"calledWithExactly",false,void 0,1);v(g,"calledOnceWithMatch",true,"calledWithMatch",false,void 0,1);v(g,"alwaysCalledWithExactly",false,"calledWithExactly");v(g,"neverCalledWith",false,"notCalledWith",false,(function(){return true}));v(g,"neverCalledWithMatch",false,"notCalledWithMatch",false,(function(){return true}));v(g,"threw",true);v(g,"alwaysThrew",false,"threw");v(g,"returned",true);v(g,"alwaysReturned",false,"returned");v(g,"calledWithNew",true);v(g,"alwaysCalledWithNew",false,"calledWithNew");function createProxy(e,t){const n=wrapFunction(e,t);a(n,e);n.prototype=e.prototype;a.nonEnum(n,g);return n}function wrapFunction(e,t){const n=t.length;let i;switch(n){case 0:i=function proxy(){return i.invoke(e,this,m(arguments))};break;case 1:i=function proxy(t){return i.invoke(e,this,m(arguments))};break;case 2:i=function proxy(t,n){return i.invoke(e,this,m(arguments))};break;case 3:i=function proxy(t,n,a){return i.invoke(e,this,m(arguments))};break;case 4:i=function proxy(t,n,a,s){return i.invoke(e,this,m(arguments))};break;case 5:i=function proxy(t,n,a,s,c){return i.invoke(e,this,m(arguments))};break;case 6:i=function proxy(t,n,a,s,c,l){return i.invoke(e,this,m(arguments))};break;case 7:i=function proxy(t,n,a,s,c,l,u){return i.invoke(e,this,m(arguments))};break;case 8:i=function proxy(t,n,a,s,c,l,u,p){return i.invoke(e,this,m(arguments))};break;case 9:i=function proxy(t,n,a,s,c,l,u,p,h){return i.invoke(e,this,m(arguments))};break;case 10:i=function proxy(t,n,a,s,c,l,u,p,h,d){return i.invoke(e,this,m(arguments))};break;case 11:i=function proxy(t,n,a,s,c,l,u,p,h,d,y){return i.invoke(e,this,m(arguments))};break;case 12:i=function proxy(t,n,a,s,c,l,u,p,h,d,y,g){return i.invoke(e,this,m(arguments))};break;default:i=function proxy(){return i.invoke(e,this,m(arguments))};break}const s=Object.getOwnPropertyDescriptor(t,"name");s&&s.configurable&&Object.defineProperty(i,"name",s);a.nonEnum(i,{isSinonProxy:true,called:false,notCalled:true,calledOnce:false,calledTwice:false,calledThrice:false,callCount:0,firstCall:null,firstArg:null,secondCall:null,thirdCall:null,lastCall:null,lastArg:null,args:[],returnValues:[],thisValues:[],exceptions:[],callIds:[],errorsWithCallStack:[]});return i}t.exports=createProxy},{"./proxy-call":16,"./proxy-call-util":15,"./proxy-invoke":17,"./spy-formatters":21,"./util/core/extend":26,"./util/core/function-to-string":27,"@sinonjs/commons":47,util:91}],19:[function(e,t,n){const i=e("./util/core/walk-object");function filter(e,t){return e[t].restore&&e[t].restore.sinon}function restore(e,t){e[t].restore()}function restoreObject(e){return i(restore,e,filter)}t.exports=restoreObject},{"./util/core/walk-object":37}],20:[function(e,t,n){const i=e("@sinonjs/commons").prototypes.array;const a=e("@sinonjs/commons").deprecated;const s=e("./collect-own-methods");const c=e("./util/core/get-property-descriptor");const l=e("./util/core/is-property-configurable");const u=e("@sinonjs/samsam").createMatcher;const p=e("./assert");const h=e("./util/fake-timers");const d=e("./mock");const m=e("./spy");const y=e("./stub");const g=e("./create-stub-instance");const v=e("./fake");const b=e("@sinonjs/commons").valueToString;const w=1e4;const x=i.filter;const k=i.forEach;const j=i.push;const C=i.reverse;function applyOnEach(e,t){const n=x(e,(function(e){return typeof e[t]==="function"}));k(n,(function(e){e[t]()}))}function throwOnAccessors(e){if(typeof e.get==="function")throw new Error("Use sandbox.replaceGetter for replacing getters");if(typeof e.set==="function")throw new Error("Use sandbox.replaceSetter for replacing setters")}function verifySameType(e,t,n){if(typeof e[t]!==typeof n)throw new TypeError(`Cannot replace ${typeof e[t]} with ${typeof n}`)}function checkForValidArguments(e,t,n){if(typeof e==="undefined")throw new TypeError(`Cannot replace non-existent property ${b(t)}. Perhaps you meant sandbox.define()?`);if(typeof n==="undefined")throw new TypeError("Expected replacement argument to be defined")}
/**
 * A sinon sandbox
 *
 * @param opts
 * @param {object} [opts.assertOptions] see the CreateAssertOptions in ./assert
 * @class
 */function Sandbox(e={}){const t=this;const n=e.assertOptions||{};let i=[];let x=[];let T=false;t.leakThreshold=w;function addToCollection(e){if(j(x,e)>t.leakThreshold&&!T){a.printWarning("Potential memory leak detected; be sure to call restore() to clean up your sandbox. To suppress this warning, modify the leakThreshold property of your sandbox.");T=true}}t.assert=p.createAssertObject(n);t.getFakes=function getFakes(){return x};t.createStubInstance=function createStubInstance(){const e=g.apply(null,arguments);const t=s(e);k(t,(function(e){addToCollection(e)}));return e};t.inject=function inject(e){e.spy=function(){return t.spy.apply(null,arguments)};e.stub=function(){return t.stub.apply(null,arguments)};e.mock=function(){return t.mock.apply(null,arguments)};e.createStubInstance=function(){return t.createStubInstance.apply(t,arguments)};e.fake=function(){return t.fake.apply(null,arguments)};e.define=function(){return t.define.apply(null,arguments)};e.replace=function(){return t.replace.apply(null,arguments)};e.replaceSetter=function(){return t.replaceSetter.apply(null,arguments)};e.replaceGetter=function(){return t.replaceGetter.apply(null,arguments)};t.clock&&(e.clock=t.clock);e.match=u;return e};t.mock=function mock(){const e=d.apply(null,arguments);addToCollection(e);return e};t.reset=function reset(){applyOnEach(x,"reset");applyOnEach(x,"resetHistory")};t.resetBehavior=function resetBehavior(){applyOnEach(x,"resetBehavior")};t.resetHistory=function resetHistory(){function privateResetHistory(e){const t=e.resetHistory||e.reset;t&&t.call(e)}k(x,privateResetHistory)};t.restore=function restore(){if(arguments.length)throw new Error("sandbox.restore() does not take any parameters. Perhaps you meant stub.restore()");C(x);applyOnEach(x,"restore");x=[];k(i,(function(e){e()}));i=[];t.restoreContext()};t.restoreContext=function restoreContext(){if(t.injectedKeys){k(t.injectedKeys,(function(e){delete t.injectInto[e]}));t.injectedKeys.length=0}};
/**
     * Creates a restorer function for the property
     *
     * @param {object|Function} object
     * @param {string} property
     * @param {boolean} forceAssignment
     * @returns {Function} restorer function
     */function getFakeRestorer(e,t,n=false){const i=c(e,t);const a=n&&e[t];function restorer(){n?e[t]=a:i?.isOwn?Object.defineProperty(e,t,i):delete e[t]}restorer.object=e;restorer.property=t;return restorer}function verifyNotReplaced(e,t){k(i,(function(n){if(n.object===e&&n.property===t)throw new TypeError(`Attempted to replace ${t} which is already replaced`)}))}
/**
     * Replace an existing property
     *
     * @param {object|Function} object
     * @param {string} property
     * @param {*} replacement a fake, stub, spy or any other value
     * @returns {*}
     */t.replace=function replace(e,t,n){const a=c(e,t);checkForValidArguments(a,t,n);throwOnAccessors(a);verifySameType(e,t,n);verifyNotReplaced(e,t);j(i,getFakeRestorer(e,t));e[t]=n;return n};t.replace.usingAccessor=function replaceUsingAccessor(e,t,n){const a=c(e,t);checkForValidArguments(a,t,n);verifySameType(e,t,n);verifyNotReplaced(e,t);j(i,getFakeRestorer(e,t,true));e[t]=n;return n};t.define=function define(e,t,n){const a=c(e,t);if(a)throw new TypeError(`Cannot define the already existing property ${b(t)}. Perhaps you meant sandbox.replace()?`);if(typeof n==="undefined")throw new TypeError("Expected value argument to be defined");verifyNotReplaced(e,t);j(i,getFakeRestorer(e,t));e[t]=n;return n};t.replaceGetter=function replaceGetter(e,t,n){const a=c(e,t);if(typeof a==="undefined")throw new TypeError(`Cannot replace non-existent property ${b(t)}`);if(typeof n!=="function")throw new TypeError("Expected replacement argument to be a function");if(typeof a.get!=="function")throw new Error("`object.property` is not a getter");verifyNotReplaced(e,t);j(i,getFakeRestorer(e,t));Object.defineProperty(e,t,{get:n,configurable:l(e,t)});return n};t.replaceSetter=function replaceSetter(e,t,n){const a=c(e,t);if(typeof a==="undefined")throw new TypeError(`Cannot replace non-existent property ${b(t)}`);if(typeof n!=="function")throw new TypeError("Expected replacement argument to be a function");if(typeof a.set!=="function")throw new Error("`object.property` is not a setter");verifyNotReplaced(e,t);j(i,getFakeRestorer(e,t));Object.defineProperty(e,t,{set:n,configurable:l(e,t)});return n};function commonPostInitSetup(e,t){const[n,i,a]=e;const c=typeof i==="undefined"&&typeof n==="object";if(c){const e=s(t);k(e,(function(e){addToCollection(e)}))}else if(Array.isArray(a))for(const e of a)addToCollection(t[e]);else addToCollection(t);return t}t.spy=function spy(){const e=m.apply(m,arguments);return commonPostInitSetup(arguments,e)};t.stub=function stub(){const e=y.apply(y,arguments);return commonPostInitSetup(arguments,e)};t.fake=function fake(e){const t=v.apply(v,arguments);addToCollection(t);return t};k(Object.keys(v),(function(e){const n=v[e];typeof n==="function"&&(t.fake[e]=function(){const e=n.apply(n,arguments);addToCollection(e);return e})}));t.useFakeTimers=function useFakeTimers(e){const n=h.useFakeTimers.call(null,e);t.clock=n;addToCollection(n);return n};t.verify=function verify(){applyOnEach(x,"verify")};t.verifyAndRestore=function verifyAndRestore(){let e;try{t.verify()}catch(t){e=t}t.restore();if(e)throw e}}Sandbox.prototype.match=u;t.exports=Sandbox},{"./assert":4,"./collect-own-methods":6,"./create-stub-instance":9,"./fake":11,"./mock":13,"./spy":22,"./stub":23,"./util/core/get-property-descriptor":29,"./util/core/is-property-configurable":32,"./util/fake-timers":40,"@sinonjs/commons":47,"@sinonjs/samsam":87}],21:[function(e,t,n){const i=e("@sinonjs/commons").prototypes.array;const a=e("./colorizer");const s=new a;const c=e("@sinonjs/samsam").createMatcher;const l=e("./util/core/times-in-words");const u=e("util").inspect;const p=e("diff");const h=i.join;const d=i.map;const m=i.push;const y=i.slice;
/**
 *
 * @param matcher
 * @param calledArg
 * @param calledArgMessage
 *
 * @returns {string} the colored text
 */function colorSinonMatchText(e,t,n){let i=n;let a=e.message;if(!e.test(t)){a=s.red(e.message);i&&(i=s.green(i))}return`${i} ${a}`}
/**
 * @param diff
 *
 * @returns {string} the colored diff
 */function colorDiffText(e){const t=d(e,(function(t){let n=t.value;t.added?n=s.green(n):t.removed&&(n=s.red(n));e.length===2&&(n+=" ");return n}));return h(t,"")}
/**
 *
 * @param value
 * @returns {string} a quoted string
 */function quoteStringValue(e){return typeof e==="string"?JSON.stringify(e):e}t.exports={c:function(e){return l(e.callCount)},n:function(e){return e.toString()},D:function(e,t){let n="";for(let i=0,a=e.callCount;i<a;++i){a>1&&(n+=`\nCall ${i+1}:`);const s=e.getCall(i).args;const l=y(t);for(let e=0;e<s.length||e<l.length;++e){let t=s[e];let i=l[e];t&&(t=quoteStringValue(t));i&&(i=quoteStringValue(i));n+="\n";const a=e<s.length?u(t):"";if(c.isMatcher(i))n+=colorSinonMatchText(i,t,a);else{const t=e<l.length?u(i):"";const s=p.diffJson(a,t);n+=colorDiffText(s)}}}return n},C:function(e){const t=[];for(let n=0,i=e.callCount;n<i;++n){let i=`    ${e.getCall(n).toString()}`;/\n/.test(t[n-1])&&(i=`\n${i}`);m(t,i)}return t.length>0?`\n${h(t,"\n")}`:""},t:function(e){const t=[];for(let n=0,i=e.callCount;n<i;++n)m(t,u(e.thisValues[n]));return h(t,", ")},"*":function(e,t){return h(d(t,(function(e){return u(e)})),", ")}}},{"./colorizer":7,"./util/core/times-in-words":36,"@sinonjs/commons":47,"@sinonjs/samsam":87,diff:92,util:91}],22:[function(e,t,n){const i=e("@sinonjs/commons").prototypes.array;const a=e("./proxy");const s=e("./util/core/extend");const c=e("@sinonjs/commons").functionName;const l=e("./util/core/get-property-descriptor");const u=e("@sinonjs/samsam").deepEqual;const p=e("./util/core/is-es-module");const h=e("./proxy-call-util");const d=e("./util/core/walk-object");const m=e("./util/core/wrap-method");const y=e("@sinonjs/commons").valueToString;const g=i.forEach;const v=i.pop;const b=i.push;const w=i.slice;const x=Array.prototype.filter;let k=0;function matches(e,t,n){const i=e.matchingArguments;return!!(i.length<=t.length&&u(w(t,0,i.length),i))&&(!n||i.length===t.length)}const j={withArgs:function(){const e=w(arguments);const t=v(this.matchingFakes(e,true));if(t)return t;const n=this;const i=this.instantiateFake();i.matchingArguments=e;i.parent=this;b(this.fakes,i);i.withArgs=function(){return n.withArgs.apply(n,arguments)};g(n.args,(function(e,t){if(matches(i,e)){h.incrementCallCount(i);b(i.thisValues,n.thisValues[t]);b(i.args,e);b(i.returnValues,n.returnValues[t]);b(i.exceptions,n.exceptions[t]);b(i.callIds,n.callIds[t])}}));h.createCallProperties(i);return i},matchingFakes:function(e,t){return x.call(this.fakes,(function(n){return matches(n,e,t)}))}};const C=h.delegateToCalls;C(j,"callArg",false,"callArgWith",true,(function(){throw new Error(`${this.toString()} cannot call arg since it was not yet invoked.`)}));j.callArgWith=j.callArg;C(j,"callArgOn",false,"callArgOnWith",true,(function(){throw new Error(`${this.toString()} cannot call arg since it was not yet invoked.`)}));j.callArgOnWith=j.callArgOn;C(j,"throwArg",false,"throwArg",false,(function(){throw new Error(`${this.toString()} cannot throw arg since it was not yet invoked.`)}));C(j,"yield",false,"yield",true,(function(){throw new Error(`${this.toString()} cannot yield since it was not yet invoked.`)}));j.invokeCallback=j.yield;C(j,"yieldOn",false,"yieldOn",true,(function(){throw new Error(`${this.toString()} cannot yield since it was not yet invoked.`)}));C(j,"yieldTo",false,"yieldTo",true,(function(e){throw new Error(`${this.toString()} cannot yield to '${y(e)}' since it was not yet invoked.`)}));C(j,"yieldToOn",false,"yieldToOn",true,(function(e){throw new Error(`${this.toString()} cannot yield to '${y(e)}' since it was not yet invoked.`)}));function createSpy(e){let t;let n=e;typeof n!=="function"?n=function(){}:t=c(n);const i=a(n,n);s.nonEnum(i,j);s.nonEnum(i,{displayName:t||"spy",fakes:[],instantiateFake:createSpy,id:"spy#"+k++});return i}function spy(e,t,n){if(p(e))throw new TypeError("ES Modules cannot be spied");if(!t&&typeof e==="function")return createSpy(e);if(!t&&typeof e==="object")return d(spy,e);if(!e&&!t)return createSpy((function(){}));if(!n)return m(e,t,createSpy(e[t]));const i={};const a=l(e,t);g(n,(function(e){i[e]=createSpy(a[e])}));return m(e,t,i)}s(spy,j);t.exports=spy},{"./proxy":18,"./proxy-call-util":15,"./util/core/extend":26,"./util/core/get-property-descriptor":29,"./util/core/is-es-module":30,"./util/core/walk-object":37,"./util/core/wrap-method":39,"@sinonjs/commons":47,"@sinonjs/samsam":87}],23:[function(e,t,n){const i=e("@sinonjs/commons").prototypes.array;const a=e("./behavior");const s=e("./default-behaviors");const c=e("./proxy");const l=e("@sinonjs/commons").functionName;const u=e("@sinonjs/commons").prototypes.object.hasOwnProperty;const p=e("./util/core/is-non-existent-property");const h=e("./spy");const d=e("./util/core/extend");const m=e("./util/core/get-property-descriptor");const y=e("./util/core/is-es-module");const g=e("./util/core/sinon-type");const v=e("./util/core/wrap-method");const b=e("./throw-on-falsy-object");const w=e("@sinonjs/commons").valueToString;const x=e("./util/core/walk-object");const k=i.forEach;const j=i.pop;const C=i.slice;const T=i.sort;let A=0;function createStub(e){let t;function functionStub(){const e=C(arguments);const n=t.matchingFakes(e);const i=j(T(n,(function(e,t){return e.matchingArguments.length-t.matchingArguments.length})))||t;return getCurrentBehavior(i).invoke(this,arguments)}t=c(functionStub,e||functionStub);d.nonEnum(t,h);d.nonEnum(t,stub);const n=e?l(e):null;d.nonEnum(t,{fakes:[],instantiateFake:createStub,displayName:n||"stub",defaultBehavior:null,behaviors:[],id:"stub#"+A++});g.set(t,"stub");return t}function stub(e,t){if(arguments.length>2)throw new TypeError("stub(obj, 'meth', fn) has been removed, see documentation");if(y(e))throw new TypeError("ES Modules cannot be stubbed");b.apply(null,arguments);if(p(e,t))throw new TypeError(`Cannot stub non-existent property ${w(t)}`);const n=m(e,t);assertValidPropertyDescriptor(n,t);const i=typeof e==="object"||typeof e==="function";const a=typeof t==="undefined"&&i;const s=!e&&typeof t==="undefined";const c=i&&typeof t!=="undefined"&&(typeof n==="undefined"||typeof n.value!=="function");if(a)return x(stub,e);if(s)return createStub();const l=typeof n.value==="function"?n.value:null;const u=createStub(l);d.nonEnum(u,{rootObj:e,propName:t,shadowsPropOnPrototype:!n.isOwn,restore:function restore(){n!==void 0&&n.isOwn?Object.defineProperty(e,t,n):delete e[t]}});return c?u:v(e,t,u)}function assertValidPropertyDescriptor(e,t){if(e&&t){if(e.isOwn&&!e.configurable&&!e.writable)throw new TypeError(`Descriptor for property ${t} is non-configurable and non-writable`);if((e.get||e.set)&&!e.configurable)throw new TypeError(`Descriptor for accessor property ${t} is non-configurable`);if(isDataDescriptor(e)&&!e.writable)throw new TypeError(`Descriptor for data property ${t} is non-writable`)}}function isDataDescriptor(e){return!e.value&&!e.writable&&!e.set&&!e.get}function getParentBehaviour(e){return e.parent&&getCurrentBehavior(e.parent)}function getDefaultBehavior(e){return e.defaultBehavior||getParentBehaviour(e)||a.create(e)}function getCurrentBehavior(e){const t=e.behaviors[e.callCount-1];return t&&t.isPresent()?t:getDefaultBehavior(e)}const S={resetBehavior:function(){this.defaultBehavior=null;this.behaviors=[];delete this.returnValue;delete this.returnArgAt;delete this.throwArgAt;delete this.resolveArgAt;delete this.fakeFn;this.returnThis=false;this.resolveThis=false;k(this.fakes,(function(e){e.resetBehavior()}))},reset:function(){this.resetHistory();this.resetBehavior()},onCall:function onCall(e){this.behaviors[e]||(this.behaviors[e]=a.create(this));return this.behaviors[e]},onFirstCall:function onFirstCall(){return this.onCall(0)},onSecondCall:function onSecondCall(){return this.onCall(1)},onThirdCall:function onThirdCall(){return this.onCall(2)},withArgs:function withArgs(){const e=h.withArgs.apply(this,arguments);if(this.defaultBehavior&&this.defaultBehavior.promiseLibrary){e.defaultBehavior=e.defaultBehavior||a.create(e);e.defaultBehavior.promiseLibrary=this.defaultBehavior.promiseLibrary}return e}};k(Object.keys(a),(function(e){u(a,e)&&!u(S,e)&&e!=="create"&&e!=="invoke"&&(S[e]=a.createBehavior(e))}));k(Object.keys(s),(function(e){u(s,e)&&!u(S,e)&&a.addBehavior(stub,e,s[e])}));d(stub,S);t.exports=stub},{"./behavior":5,"./default-behaviors":10,"./proxy":18,"./spy":22,"./throw-on-falsy-object":24,"./util/core/extend":26,"./util/core/get-property-descriptor":29,"./util/core/is-es-module":30,"./util/core/is-non-existent-property":31,"./util/core/sinon-type":35,"./util/core/walk-object":37,"./util/core/wrap-method":39,"@sinonjs/commons":47}],24:[function(e,t,n){const i=e("@sinonjs/commons").valueToString;function throwOnFalsyObject(e,t){if(t&&!e){const n=e===null?"null":"undefined";throw new Error(`Trying to stub property '${i(t)}' of ${n}`)}}t.exports=throwOnFalsyObject},{"@sinonjs/commons":47}],25:[function(e,t,n){const i=e("@sinonjs/commons").prototypes.array;const a=i.reduce;t.exports=function exportAsyncBehaviors(e){return a(Object.keys(e),(function(t,n){n.match(/^(callsArg|yields)/)&&!n.match(/Async/)&&(t[`${n}Async`]=function(){const t=e[n].apply(this,arguments);this.callbackAsync=true;return t});return t}),{})}},{"@sinonjs/commons":47}],26:[function(e,t,n){const i=e("@sinonjs/commons").prototypes.array;const a=e("@sinonjs/commons").prototypes.object.hasOwnProperty;const s=i.join;const c=i.push;const l=function(){const e={constructor:function(){return"0"},toString:function(){return"1"},valueOf:function(){return"2"},toLocaleString:function(){return"3"},prototype:function(){return"4"},isPrototypeOf:function(){return"5"},propertyIsEnumerable:function(){return"6"},hasOwnProperty:function(){return"7"},length:function(){return"8"},unique:function(){return"9"}};const t=[];for(const n in e)a(e,n)&&c(t,e[n]());return s(t,"")!=="0123456789"}();
/**
 *
 * @param target
 * @param sources
 * @param doCopy
 * @returns {*} target
 */function extendCommon(e,t,n){let i,s,c;for(s=0;s<t.length;s++){i=t[s];for(c in i)a(i,c)&&n(e,i,c);l&&a(i,"toString")&&i.toString!==e.toString&&(e.toString=i.toString)}return e}
/**
 * Public: Extend target in place with all (own) properties, except 'name' when [[writable]] is false,
 *         from sources in-order. Thus, last source will override properties in previous sources.
 *
 * @param {object} target - The Object to extend
 * @param {object[]} sources - Objects to copy properties from.
 * @returns {object} the extended target
 */t.exports=function extend(e,...t){return extendCommon(e,t,(function copyValue(e,t,n){const i=Object.getOwnPropertyDescriptor(e,n);const s=Object.getOwnPropertyDescriptor(t,n);if(n==="name"&&!i.writable)return;const c={configurable:s.configurable,enumerable:s.enumerable};if(a(s,"writable")){c.writable=s.writable;c.value=s.value}else{s.get&&(c.get=s.get.bind(e));s.set&&(c.set=s.set.bind(e))}Object.defineProperty(e,n,c)}))};
/**
 * Public: Extend target in place with all (own) properties from sources in-order. Thus, last source will
 *         override properties in previous sources. Define the properties as non enumerable.
 *
 * @param {object} target - The Object to extend
 * @param {object[]} sources - Objects to copy properties from.
 * @returns {object} the extended target
 */t.exports.nonEnum=function extendNonEnum(e,...t){return extendCommon(e,t,(function copyProperty(e,t,n){Object.defineProperty(e,n,{value:t[n],enumerable:false,configurable:true,writable:true})}))}},{"@sinonjs/commons":47}],27:[function(e,t,n){t.exports=function toString(){let e,t,n;if(this.getCall&&this.callCount){e=this.callCount;while(e--){n=this.getCall(e).thisValue;for(t in n)try{if(n[t]===this)return t}catch(e){}}}return this.displayName||"sinon fake"}},{}],28:[function(e,t,n){function nextTick(e){setTimeout(e,0)}t.exports=function getNextTick(e,t){return typeof e==="object"&&typeof e.nextTick==="function"?e.nextTick:typeof t==="function"?t:nextTick}},{}],29:[function(e,t,n){
/**
 * @typedef {object} PropertyDescriptor
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty#description
 * @property {boolean} configurable defaults to false
 * @property {boolean} enumerable   defaults to false
 * @property {boolean} writable     defaults to false
 * @property {*} value defaults to undefined
 * @property {Function} get defaults to undefined
 * @property {Function} set defaults to undefined
 */
/**
 * @typedef {{isOwn: boolean} & PropertyDescriptor} SinonPropertyDescriptor
 * a slightly enriched property descriptor
 * @property {boolean} isOwn true if the descriptor is owned by this object, false if it comes from the prototype
 */
/**
 * Returns a slightly modified property descriptor that one can tell is from the object or the prototype
 *
 * @param {*} object
 * @param {string} property
 * @returns {SinonPropertyDescriptor}
 */
function getPropertyDescriptor(e,t){let n=e;let i;const a=Boolean(e&&Object.getOwnPropertyDescriptor(e,t));while(n&&!(i=Object.getOwnPropertyDescriptor(n,t)))n=Object.getPrototypeOf(n);i&&(i.isOwn=a);return i}t.exports=getPropertyDescriptor},{}],30:[function(e,t,n){
/**
 * Verify if an object is a ECMAScript Module
 *
 * As the exports from a module is immutable we cannot alter the exports
 * using spies or stubs. Let the consumer know this to avoid bug reports
 * on weird error messages.
 *
 * @param {object} object The object to examine
 * @returns {boolean} true when the object is a module
 */
t.exports=function(e){return e&&typeof Symbol!=="undefined"&&e[Symbol.toStringTag]==="Module"&&Object.isSealed(e)}},{}],31:[function(e,t,n){
/**
 * @param {*} object
 * @param {string} property
 * @returns {boolean} whether a prop exists in the prototype chain
 */
function isNonExistentProperty(e,t){return Boolean(e&&typeof t!=="undefined"&&!(t in e))}t.exports=isNonExistentProperty},{}],32:[function(e,t,n){const i=e("./get-property-descriptor");function isPropertyConfigurable(e,t){const n=i(e,t);return!n||n.configurable}t.exports=isPropertyConfigurable},{"./get-property-descriptor":29}],33:[function(e,t,n){function isRestorable(e){return typeof e==="function"&&typeof e.restore==="function"&&e.restore.sinon}t.exports=isRestorable},{}],34:[function(e,t,n){const i=e("@sinonjs/commons").global;const a=e("./get-next-tick");t.exports=a(i.process,i.setImmediate)},{"./get-next-tick":28,"@sinonjs/commons":47}],35:[function(e,t,n){const i=Symbol("SinonType");t.exports={
/**
     * Set the type of a Sinon object to make it possible to identify it later at runtime
     *
     * @param {object|Function} object  object/function to set the type on
     * @param {string} type the named type of the object/function
     */
set(e,t){Object.defineProperty(e,i,{value:t,configurable:false,enumerable:false})},get(e){return e&&e[i]}}},{}],36:[function(e,t,n){const i=[null,"once","twice","thrice"];t.exports=function timesInWords(e){return i[e]||`${e||0} times`}},{}],37:[function(e,t,n){const i=e("@sinonjs/commons").functionName;const a=e("./get-property-descriptor");const s=e("./walk");
/**
 * A utility that allows traversing an object, applying mutating functions on the properties
 *
 * @param {Function} mutator called on each property
 * @param {object} object the object we are walking over
 * @param {Function} filter a predicate (boolean function) that will decide whether or not to apply the mutator to the current property
 * @returns {void} nothing
 */function walkObject(e,t,n){let c=false;const l=i(e);if(!t)throw new Error(`Trying to ${l} object but received ${String(t)}`);s(t,(function(i,s){if(s!==Object.prototype&&i!=="constructor"&&typeof a(s,i).value==="function")if(n){if(n(t,i)){c=true;e(t,i)}}else{c=true;e(t,i)}}));if(!c)throw new Error("Found no methods on object to which we could apply mutations");return t}t.exports=walkObject},{"./get-property-descriptor":29,"./walk":38,"@sinonjs/commons":47}],38:[function(e,t,n){const i=e("@sinonjs/commons").prototypes.array.forEach;function walkInternal(e,t,n,a,s){let c;const l=Object.getPrototypeOf(e);if(typeof Object.getOwnPropertyNames==="function"){i(Object.getOwnPropertyNames(e),(function(i){if(s[i]!==true){s[i]=true;const c=typeof Object.getOwnPropertyDescriptor(e,i).get==="function"?a:e;t.call(n,i,c)}}));l&&walkInternal(l,t,n,a,s)}else for(c in e)t.call(n,e[c],c,e)}t.exports=function walk(e,t,n){return walkInternal(e,t,n,e,{})}},{"@sinonjs/commons":47}],39:[function(e,t,n){const noop=()=>{};const i=e("./get-property-descriptor");const a=e("./extend");const s=e("./sinon-type");const c=e("@sinonjs/commons").prototypes.object.hasOwnProperty;const l=e("@sinonjs/commons").valueToString;const u=e("@sinonjs/commons").prototypes.array.push;function isFunction(e){return typeof e==="function"||Boolean(e&&e.constructor&&e.call&&e.apply)}function mirrorProperties(e,t){for(const n in t)c(e,n)||(e[n]=t[n])}function getAccessor(e,t,n){const a=["get","set"];const s=i(e,t);for(let e=0;e<a.length;e++)if(s[a[e]]&&s[a[e]].name===n.name)return a[e];return null}const p="keys"in Object;t.exports=function wrapMethod(e,t,n){if(!e)throw new TypeError("Should wrap property of object");if(typeof n!=="function"&&typeof n!=="object")throw new TypeError("Method wrapper should be a function or a property descriptor");function checkWrappedMethod(e){let n;if(isFunction(e)){if(e.restore&&e.restore.sinon)n=new TypeError(`Attempted to wrap ${l(t)} which is already wrapped`);else if(e.calledBefore){const i=e.returns?"stubbed":"spied on";n=new TypeError(`Attempted to wrap ${l(t)} which is already ${i}`)}}else n=new TypeError(`Attempted to wrap ${typeof e} property ${l(t)} as function`);if(n){e&&e.stackTraceError&&(n.stack+=`\n--------------\n${e.stackTraceError.stack}`);throw n}}let h,d,m,y,g,v;const b=[];function simplePropertyAssignment(){d=e[t];checkWrappedMethod(d);e[t]=n;n.displayName=t}const w=e.hasOwnProperty?e.hasOwnProperty(t):c(e,t);if(p){const a=typeof n==="function"?{value:n}:n;y=i(e,t);y?y.restore&&y.restore.sinon&&(h=new TypeError(`Attempted to wrap ${t} which is already wrapped`)):h=new TypeError(`Attempted to wrap ${typeof d} property ${t} as function`);if(h){y&&y.stackTraceError&&(h.stack+=`\n--------------\n${y.stackTraceError.stack}`);throw h}const s=Object.keys(a);for(m=0;m<s.length;m++){d=y[s[m]];checkWrappedMethod(d);u(b,d)}mirrorProperties(a,y);for(m=0;m<s.length;m++)mirrorProperties(a[s[m]],y[s[m]]);w||(a.configurable=true);Object.defineProperty(e,t,a);if(typeof n==="function"&&e[t]!==n){delete e[t];simplePropertyAssignment()}}else simplePropertyAssignment();extendObjectWithWrappedMethods();function extendObjectWithWrappedMethods(){for(m=0;m<b.length;m++){v=getAccessor(e,t,b[m]);g=v?n[v]:n;a.nonEnum(g,{displayName:t,wrappedMethod:b[m],stackTraceError:new Error("Stack Trace for original"),restore:restore});g.restore.sinon=true;p||mirrorProperties(g,d)}}function restore(){v=getAccessor(e,t,this.wrappedMethod);let n;if(v){if(w){if(p){n=i(e,t);n[v]=y[v];Object.defineProperty(e,t,n)}}else try{delete e[t][v]}catch(e){}if(p){n=i(e,t);n&&n.value===g&&(e[t][v]=this.wrappedMethod)}else e[t][v]===g&&(e[t][v]=this.wrappedMethod)}else{if(w)p&&Object.defineProperty(e,t,y);else try{delete e[t]}catch(e){}if(p){n=i(e,t);n&&n.value===g&&(e[t]=this.wrappedMethod)}else e[t]===g&&(e[t]=this.wrappedMethod)}s.get(e)==="stub-instance"&&(e[t]=noop)}return n}},{"./extend":26,"./get-property-descriptor":29,"./sinon-type":35,"@sinonjs/commons":47}],40:[function(e,t,n){const i=e("./core/extend");const a=e("@sinonjs/fake-timers");const s=e("@sinonjs/commons").global;
/**
 *
 * @param config
 * @param globalCtx
 *
 * @returns {object} the clock, after installing it on the global context, if given
 */function createClock(e,t){let n=a;t!==null&&typeof t==="object"&&(n=a.withGlobal(t));const i=n.install(e);i.restore=i.uninstall;return i}
/**
 *
 * @param obj
 * @param globalPropName
 */function addIfDefined(e,t){const n=s[t];typeof n!=="undefined"&&(e[t]=n)}
/**
 * @param {number|Date|object} dateOrConfig The unix epoch value to install with (default 0)
 * @returns {object} Returns a lolex clock instance
 */n.useFakeTimers=function(e){const t=typeof e!=="undefined";const n=(typeof e==="number"||e instanceof Date)&&arguments.length===1;const a=e!==null&&typeof e==="object"&&arguments.length===1;if(!t)return createClock({now:0});if(n)return createClock({now:e});if(a){const t=i.nonEnum({},e);const n=t.global;delete t.global;return createClock(t,n)}throw new TypeError("useFakeTimers expected epoch or config object. See https://github.com/sinonjs/sinon")};n.clock={create:function(e){return a.createClock(e)}};const c={setTimeout:setTimeout,clearTimeout:clearTimeout,setInterval:setInterval,clearInterval:clearInterval,Date:Date};addIfDefined(c,"setImmediate");addIfDefined(c,"clearImmediate");n.timers=c},{"./core/extend":26,"@sinonjs/commons":47,"@sinonjs/fake-timers":60}],41:[function(e,t,n){var i=e("./prototypes/array").every;function hasCallsLeft(e,t){e[t.id]===void 0&&(e[t.id]=0);return e[t.id]<t.callCount}function checkAdjacentCalls(e,t,n,i){var a=true;n!==i.length-1&&(a=t.calledBefore(i[n+1]));if(hasCallsLeft(e,t)&&a){e[t.id]+=1;return true}return false}
/**
 * A Sinon proxy object (fake, spy, stub)
 * @typedef {object} SinonProxy
 * @property {Function} calledBefore - A method that determines if this proxy was called before another one
 * @property {string} id - Some id
 * @property {number} callCount - Number of times this proxy has been called
 */
/**
 * Returns true when the spies have been called in the order they were supplied in
 * @param  {SinonProxy[] | SinonProxy} spies An array of proxies, or several proxies as arguments
 * @returns {boolean} true when spies are called in order, false otherwise
 */function calledInOrder(e){var t={};var n=arguments.length>1?arguments:e;return i(n,checkAdjacentCalls.bind(null,t))}t.exports=calledInOrder},{"./prototypes/array":49}],42:[function(e,t,n){
/**
 * Returns a display name for a value from a constructor
 * @param  {object} value A value to examine
 * @returns {(string|null)} A string or null
 */
function className(e){const t=e.constructor&&e.constructor.name;return t||null}t.exports=className},{}],43:[function(e,t,n){
/**
 * Returns a function that will invoke the supplied function and print a
 * deprecation warning to the console each time it is called.
 * @param  {Function} func
 * @param  {string} msg
 * @returns {Function}
 */
n.wrap=function(e,t){var wrapped=function(){n.printWarning(t);return e.apply(this,arguments)};e.prototype&&(wrapped.prototype=e.prototype);return wrapped};
/**
 * Returns a string which can be supplied to `wrap()` to notify the user that a
 * particular part of the sinon API has been deprecated.
 * @param  {string} packageName
 * @param  {string} funcName
 * @returns {string}
 */n.defaultMsg=function(e,t){return`${e}.${t} is deprecated and will be removed from the public API in a future version of ${e}.`};
/**
 * Prints a warning on the console, when it exists
 * @param  {string} msg
 * @returns {undefined}
 */n.printWarning=function(e){typeof process==="object"&&process.emitWarning?process.emitWarning(e):console.info?console.info(e):console.log(e)}},{}],44:[function(e,t,n){
/**
 * Returns true when fn returns true for all members of obj.
 * This is an every implementation that works for all iterables
 * @param  {object}   obj
 * @param  {Function} fn
 * @returns {boolean}
 */
t.exports=function every(e,t){var n=true;try{e.forEach((function(){if(!t.apply(this,arguments))throw new Error}))}catch(e){n=false}return n}},{}],45:[function(e,t,n){
/**
 * Returns a display name for a function
 * @param  {Function} func
 * @returns {string}
 */
t.exports=function functionName(e){if(!e)return"";try{return e.displayName||e.name||(String(e).match(/function ([^\s(]+)/)||[])[1]}catch(e){return""}}},{}],46:[function(e,t,n){
/**
 * A reference to the global object
 * @type {object} globalObject
 */
var i;i=typeof global!=="undefined"?global:typeof window!=="undefined"?window:self;t.exports=i},{}],47:[function(e,t,n){t.exports={global:e("./global"),calledInOrder:e("./called-in-order"),className:e("./class-name"),deprecated:e("./deprecated"),every:e("./every"),functionName:e("./function-name"),orderByFirstCall:e("./order-by-first-call"),prototypes:e("./prototypes"),typeOf:e("./type-of"),valueToString:e("./value-to-string")}},{"./called-in-order":41,"./class-name":42,"./deprecated":43,"./every":44,"./function-name":45,"./global":46,"./order-by-first-call":48,"./prototypes":52,"./type-of":58,"./value-to-string":59}],48:[function(e,t,n){var i=e("./prototypes/array").sort;var a=e("./prototypes/array").slice;function comparator(e,t){var n=e.getCall(0);var i=t.getCall(0);var a=n&&n.callId||-1;var s=i&&i.callId||-1;return a<s?-1:1}
/**
 * A Sinon proxy object (fake, spy, stub)
 * @typedef {object} SinonProxy
 * @property {Function} getCall - A method that can return the first call
 */
/**
 * Sorts an array of SinonProxy instances (fake, spy, stub) by their first call
 * @param  {SinonProxy[] | SinonProxy} spies
 * @returns {SinonProxy[]}
 */function orderByFirstCall(e){return i(a(e),comparator)}t.exports=orderByFirstCall},{"./prototypes/array":49}],49:[function(e,t,n){var i=e("./copy-prototype-methods");t.exports=i(Array.prototype)},{"./copy-prototype-methods":50}],50:[function(e,t,n){var i=Function.call;var a=e("./throws-on-proto");var s=["size","caller","callee","arguments"];a&&s.push("__proto__");t.exports=function copyPrototypeMethods(e){return Object.getOwnPropertyNames(e).reduce((function(t,n){if(s.includes(n))return t;if(typeof e[n]!=="function")return t;t[n]=i.bind(e[n]);return t}),Object.create(null))}},{"./throws-on-proto":57}],51:[function(e,t,n){var i=e("./copy-prototype-methods");t.exports=i(Function.prototype)},{"./copy-prototype-methods":50}],52:[function(e,t,n){t.exports={array:e("./array"),function:e("./function"),map:e("./map"),object:e("./object"),set:e("./set"),string:e("./string")}},{"./array":49,"./function":51,"./map":53,"./object":54,"./set":55,"./string":56}],53:[function(e,t,n){var i=e("./copy-prototype-methods");t.exports=i(Map.prototype)},{"./copy-prototype-methods":50}],54:[function(e,t,n){var i=e("./copy-prototype-methods");t.exports=i(Object.prototype)},{"./copy-prototype-methods":50}],55:[function(e,t,n){var i=e("./copy-prototype-methods");t.exports=i(Set.prototype)},{"./copy-prototype-methods":50}],56:[function(e,t,n){var i=e("./copy-prototype-methods");t.exports=i(String.prototype)},{"./copy-prototype-methods":50}],57:[function(e,t,n){
/**
 * Is true when the environment causes an error to be thrown for accessing the
 * __proto__ property.
 * This is necessary in order to support `node --disable-proto=throw`.
 *
 * See https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/proto
 * @type {boolean}
 */
let i;try{const e={};e.__proto__;i=false}catch(e){i=true}t.exports=i},{}],58:[function(e,t,n){var i=e("type-detect");
/**
 * Returns the lower-case result of running type from type-detect on the value
 * @param  {*} value
 * @returns {string}
 */t.exports=function typeOf(e){return i(e).toLowerCase()}},{"type-detect":95}],59:[function(e,t,n){
/**
 * Returns a string representation of the value
 * @param  {*} value
 * @returns {string}
 */
function valueToString(e){return e&&e.toString?e.toString():String(e)}t.exports=valueToString},{}],60:[function(e,t,n){const i=e("@sinonjs/commons").global;let a,s;if(typeof e==="function"&&typeof t==="object"){try{a=e("timers")}catch(e){}try{s=e("timers/promises")}catch(e){}}
/**
 * @typedef {object} IdleDeadline
 * @property {boolean} didTimeout - whether or not the callback was called before reaching the optional timeout
 * @property {function():number} timeRemaining - a floating-point value providing an estimate of the number of milliseconds remaining in the current idle period
 */
/**
 * Queues a function to be called during a browser's idle periods
 *
 * @callback RequestIdleCallback
 * @param {function(IdleDeadline)} callback
 * @param {{timeout: number}} options - an options object
 * @returns {number} the id
 */
/**
 * @callback NextTick
 * @param {VoidVarArgsFunc} callback - the callback to run
 * @param {...*} args - optional arguments to call the callback with
 * @returns {void}
 */
/**
 * @callback SetImmediate
 * @param {VoidVarArgsFunc} callback - the callback to run
 * @param {...*} args - optional arguments to call the callback with
 * @returns {NodeImmediate}
 */
/**
 * @callback VoidVarArgsFunc
 * @param {...*} callback - the callback to run
 * @returns {void}
 */
/**
 * @typedef RequestAnimationFrame
 * @property {function(number):void} requestAnimationFrame
 * @returns {number} - the id
 */
/**
 * @typedef Performance
 * @property {function(): number} now
 */
/**
 * @typedef {object} Clock
 * @property {number} now - the current time
 * @property {Date} Date - the Date constructor
 * @property {number} loopLimit - the maximum number of timers before assuming an infinite loop
 * @property {RequestIdleCallback} requestIdleCallback
 * @property {function(number):void} cancelIdleCallback
 * @property {setTimeout} setTimeout
 * @property {clearTimeout} clearTimeout
 * @property {NextTick} nextTick
 * @property {queueMicrotask} queueMicrotask
 * @property {setInterval} setInterval
 * @property {clearInterval} clearInterval
 * @property {SetImmediate} setImmediate
 * @property {function(NodeImmediate):void} clearImmediate
 * @property {function():number} countTimers
 * @property {RequestAnimationFrame} requestAnimationFrame
 * @property {function(number):void} cancelAnimationFrame
 * @property {function():void} runMicrotasks
 * @property {function(string | number): number} tick
 * @property {function(string | number): Promise<number>} tickAsync
 * @property {function(): number} next
 * @property {function(): Promise<number>} nextAsync
 * @property {function(): number} runAll
 * @property {function(): number} runToFrame
 * @property {function(): Promise<number>} runAllAsync
 * @property {function(): number} runToLast
 * @property {function(): Promise<number>} runToLastAsync
 * @property {function(): void} reset
 * @property {function(number | Date): void} setSystemTime
 * @property {function(number): void} jump
 * @property {Performance} performance
 * @property {function(number[]): number[]} hrtime - process.hrtime (legacy)
 * @property {function(): void} uninstall Uninstall the clock.
 * @property {Function[]} methods - the methods that are faked
 * @property {boolean} [shouldClearNativeTimers] inherited from config
 * @property {{methodName:string, original:any}[] | undefined} timersModuleMethods
 * @property {{methodName:string, original:any}[] | undefined} timersPromisesModuleMethods
 * @property {Map<function(): void, AbortSignal>} abortListenerMap
 */
/**
 * Configuration object for the `install` method.
 *
 * @typedef {object} Config
 * @property {number|Date} [now] a number (in milliseconds) or a Date object (default epoch)
 * @property {string[]} [toFake] names of the methods that should be faked.
 * @property {number} [loopLimit] the maximum number of timers that will be run when calling runAll()
 * @property {boolean} [shouldAdvanceTime] tells FakeTimers to increment mocked time automatically (default false)
 * @property {number} [advanceTimeDelta] increment mocked time every <<advanceTimeDelta>> ms (default: 20ms)
 * @property {boolean} [shouldClearNativeTimers] forwards clear timer calls to native functions if they are not fakes (default: false)
 * @property {boolean} [ignoreMissingTimers] default is false, meaning asking to fake timers that are not present will throw an error
 */
/**
 * The internal structure to describe a scheduled fake timer
 *
 * @typedef {object} Timer
 * @property {Function} func
 * @property {*[]} args
 * @property {number} delay
 * @property {number} callAt
 * @property {number} createdAt
 * @property {boolean} immediate
 * @property {number} id
 * @property {Error} [error]
 */
/**
 * A Node timer
 *
 * @typedef {object} NodeImmediate
 * @property {function(): boolean} hasRef
 * @property {function(): NodeImmediate} ref
 * @property {function(): NodeImmediate} unref
 */
/**
 * Mocks available features in the specified global namespace.
 *
 * @param {*} _global Namespace to mock (e.g. `window`)
 * @returns {FakeTimers}
 */function withGlobal(t){const n=Math.pow(2,31)-1;const c=1e12;const NOOP=function(){};const NOOP_ARRAY=function(){return[]};const l={};let u,p=false;if(t.setTimeout){l.setTimeout=true;u=t.setTimeout(NOOP,0);p=typeof u==="object"}l.clearTimeout=Boolean(t.clearTimeout);l.setInterval=Boolean(t.setInterval);l.clearInterval=Boolean(t.clearInterval);l.hrtime=t.process&&typeof t.process.hrtime==="function";l.hrtimeBigint=l.hrtime&&typeof t.process.hrtime.bigint==="function";l.nextTick=t.process&&typeof t.process.nextTick==="function";const h=t.process&&e("util").promisify;l.performance=t.performance&&typeof t.performance.now==="function";const d=t.Performance&&(typeof t.Performance).match(/^(function|object)$/);const m=t.performance&&t.performance.constructor&&t.performance.constructor.prototype;l.queueMicrotask=t.hasOwnProperty("queueMicrotask");l.requestAnimationFrame=t.requestAnimationFrame&&typeof t.requestAnimationFrame==="function";l.cancelAnimationFrame=t.cancelAnimationFrame&&typeof t.cancelAnimationFrame==="function";l.requestIdleCallback=t.requestIdleCallback&&typeof t.requestIdleCallback==="function";l.cancelIdleCallbackPresent=t.cancelIdleCallback&&typeof t.cancelIdleCallback==="function";l.setImmediate=t.setImmediate&&typeof t.setImmediate==="function";l.clearImmediate=t.clearImmediate&&typeof t.clearImmediate==="function";l.Intl=t.Intl&&typeof t.Intl==="object";t.clearTimeout&&t.clearTimeout(u);const y=t.Date;const g=t.Intl;let v=c;if(y===void 0)throw new Error("The global scope doesn't have a `Date` object (see https://github.com/sinonjs/sinon/issues/1852#issuecomment-419622780)");l.Date=true;class FakePerformanceEntry{constructor(e,t,n,i){this.name=e;this.entryType=t;this.startTime=n;this.duration=i}toJSON(){return JSON.stringify({...this})}}
/**
     * @param {number} num
     * @returns {boolean}
     */function isNumberFinite(e){return Number.isFinite?Number.isFinite(e):isFinite(e)}let b=false;
/**
     * @param {Clock} clock
     * @param {number} i
     */function checkIsNearInfiniteLimit(e,t){e.loopLimit&&t===e.loopLimit-1&&(b=true)}function resetIsNearInfiniteLimit(){b=false}
/**
     * Parse strings like "01:10:00" (meaning 1 hour, 10 minutes, 0 seconds) into
     * number of milliseconds. This is used to support human-readable strings passed
     * to clock.tick()
     *
     * @param {string} str
     * @returns {number}
     */function parseTime(e){if(!e)return 0;const t=e.split(":");const n=t.length;let i=n;let a=0;let s;if(n>3||!/^(\d\d:){0,2}\d\d?$/.test(e))throw new Error("tick only understands numbers, 'm:s' and 'h:m:s'. Each part must be two digits");while(i--){s=parseInt(t[i],10);if(s>=60)throw new Error(`Invalid time ${e}`);a+=s*Math.pow(60,n-i-1)}return a*1e3}
/**
     * Get the decimal part of the millisecond value as nanoseconds
     *
     * @param {number} msFloat the number of milliseconds
     * @returns {number} an integer number of nanoseconds in the range [0,1e6)
     *
     * Example: nanoRemainer(123.456789) -> 456789
     */function nanoRemainder(e){const t=1e6;const n=e*1e6%t;const i=n<0?n+t:n;return Math.floor(i)}
/**
     * Used to grok the `now` parameter to createClock.
     *
     * @param {Date|number} epoch the system time
     * @returns {number}
     */function getEpoch(e){if(!e)return 0;if(typeof e.getTime==="function")return e.getTime();if(typeof e==="number")return e;throw new TypeError("now should be milliseconds since UNIX epoch")}
/**
     * @param {number} from
     * @param {number} to
     * @param {Timer} timer
     * @returns {boolean}
     */function inRange(e,t,n){return n&&n.callAt>=e&&n.callAt<=t}
/**
     * @param {Clock} clock
     * @param {Timer} job
     */function getInfiniteLoopError(e,t){const n=new Error(`Aborting after running ${e.loopLimit} timers, assuming an infinite loop!`);if(!t.error)return n;const i=/target\.*[<|(|[].*?[>|\]|)]\s*/;let a=new RegExp(String(Object.keys(e).join("|")));p&&(a=new RegExp(`\\s+at (Object\\.)?(?:${Object.keys(e).join("|")})\\s+`));let s=-1;t.error.stack.split("\n").some((function(e,t){const n=e.match(i);if(n){s=t;return true}const c=e.match(a);if(c){s=t;return false}return s>=0}));const c=`${n}\n${t.type||"Microtask"} - ${t.func.name||"anonymous"}\n${t.error.stack.split("\n").slice(s+1).join("\n")}`;try{Object.defineProperty(n,"stack",{value:c})}catch(e){}return n}function createDate(){class ClockDate extends y{
/**
             * @param {number} year
             * @param {number} month
             * @param {number} date
             * @param {number} hour
             * @param {number} minute
             * @param {number} second
             * @param {number} ms
             * @returns void
             */
constructor(e,t,n,i,a,s,c){arguments.length===0?super(ClockDate.clock.now):super(...arguments);Object.defineProperty(this,"constructor",{value:y,enumerable:false})}static[Symbol.hasInstance](e){return e instanceof y}}ClockDate.isFake=true;y.now&&(ClockDate.now=function now(){return ClockDate.clock.now});y.toSource&&(ClockDate.toSource=function toSource(){return y.toSource()});ClockDate.toString=function toString(){return y.toString()};
/**
         * A normal Class constructor cannot be called without `new`, but Date can, so we need
         * to wrap it in a Proxy in order to ensure this functionality of Date is kept intact
         *
         * @type {ClockDate}
         */const e=new Proxy(ClockDate,{apply(){if(this instanceof ClockDate)throw new TypeError("A Proxy should only capture `new` calls with the `construct` handler. This is not supposed to be possible, so check the logic.");return new y(ClockDate.clock.now).toString()}});return e}
/**
     * Mirror Intl by default on our fake implementation
     *
     * Most of the properties are the original native ones,
     * but we need to take control of those that have a
     * dependency on the current clock.
     *
     * @returns {object} the partly fake Intl implementation
     */function createIntl(){const e={};Object.getOwnPropertyNames(g).forEach((t=>e[t]=g[t]));e.DateTimeFormat=function(...t){const n=new g.DateTimeFormat(...t);const i={};["formatRange","formatRangeToParts","resolvedOptions"].forEach((e=>{i[e]=n[e].bind(n)}));["format","formatToParts"].forEach((t=>{i[t]=function(i){return n[t](i||e.clock.now)}}));return i};e.DateTimeFormat.prototype=Object.create(g.DateTimeFormat.prototype);e.DateTimeFormat.supportedLocalesOf=g.DateTimeFormat.supportedLocalesOf;return e}function enqueueJob(e,t){e.jobs||(e.jobs=[]);e.jobs.push(t)}function runJobs(e){if(e.jobs){for(let t=0;t<e.jobs.length;t++){const n=e.jobs[t];n.func.apply(null,n.args);checkIsNearInfiniteLimit(e,t);if(e.loopLimit&&t>e.loopLimit)throw getInfiniteLoopError(e,n)}resetIsNearInfiniteLimit();e.jobs=[]}}
/**
     * @param {Clock} clock
     * @param {Timer} timer
     * @returns {number} id of the created timer
     */function addTimer(e,t){if(t.func===void 0)throw new Error("Callback must be provided to timer calls");if(p&&typeof t.func!=="function")throw new TypeError(`[ERR_INVALID_CALLBACK]: Callback must be a function. Received ${t.func} of type ${typeof t.func}`);b&&(t.error=new Error);t.type=t.immediate?"Immediate":"Timeout";if(t.hasOwnProperty("delay")){typeof t.delay!=="number"&&(t.delay=parseInt(t.delay,10));isNumberFinite(t.delay)||(t.delay=0);t.delay=t.delay>n?1:t.delay;t.delay=Math.max(0,t.delay)}if(t.hasOwnProperty("interval")){t.type="Interval";t.interval=t.interval>n?1:t.interval}if(t.hasOwnProperty("animation")){t.type="AnimationFrame";t.animation=true}if(t.hasOwnProperty("idleCallback")){t.type="IdleCallback";t.idleCallback=true}e.timers||(e.timers={});t.id=v++;t.createdAt=e.now;t.callAt=e.now+(parseInt(t.delay)||(e.duringTick?1:0));e.timers[t.id]=t;if(p){const n={refed:true,ref:function(){this.refed=true;return n},unref:function(){this.refed=false;return n},hasRef:function(){return this.refed},refresh:function(){t.callAt=e.now+(parseInt(t.delay)||(e.duringTick?1:0));e.timers[t.id]=t;return n},[Symbol.toPrimitive]:function(){return t.id}};return n}return t.id}
/**
     * Timer comparitor
     *
     * @param {Timer} a
     * @param {Timer} b
     * @returns {number}
     */function compareTimers(e,t){return e.callAt<t.callAt?-1:e.callAt>t.callAt?1:e.immediate&&!t.immediate?-1:!e.immediate&&t.immediate?1:e.createdAt<t.createdAt?-1:e.createdAt>t.createdAt?1:e.id<t.id?-1:e.id>t.id?1:void 0}
/**
     * @param {Clock} clock
     * @param {number} from
     * @param {number} to
     * @returns {Timer}
     */function firstTimerInRange(e,t,n){const i=e.timers;let a=null;let s,c;for(s in i)if(i.hasOwnProperty(s)){c=inRange(t,n,i[s]);!c||a&&compareTimers(a,i[s])!==1||(a=i[s])}return a}
/**
     * @param {Clock} clock
     * @returns {Timer}
     */function firstTimer(e){const t=e.timers;let n=null;let i;for(i in t)t.hasOwnProperty(i)&&(n&&compareTimers(n,t[i])!==1||(n=t[i]));return n}
/**
     * @param {Clock} clock
     * @returns {Timer}
     */function lastTimer(e){const t=e.timers;let n=null;let i;for(i in t)t.hasOwnProperty(i)&&(n&&compareTimers(n,t[i])!==-1||(n=t[i]));return n}
/**
     * @param {Clock} clock
     * @param {Timer} timer
     */function callTimer(e,t){typeof t.interval==="number"?e.timers[t.id].callAt+=t.interval:delete e.timers[t.id];if(typeof t.func==="function")t.func.apply(null,t.args);else{const e=eval;(function(){e(t.func)})()}}
/**
     * Gets clear handler name for a given timer type
     *
     * @param {string} ttype
     */function getClearHandler(e){return e==="IdleCallback"||e==="AnimationFrame"?`cancel${e}`:`clear${e}`}
/**
     * Gets schedule handler name for a given timer type
     *
     * @param {string} ttype
     */function getScheduleHandler(e){return e==="IdleCallback"||e==="AnimationFrame"?`request${e}`:`set${e}`}function createWarnOnce(){let e=0;return function(t){!e++&&console.warn(t)}}const w=createWarnOnce();
/**
     * @param {Clock} clock
     * @param {number} timerId
     * @param {string} ttype
     */function clearTimer(e,t,n){if(!t)return;e.timers||(e.timers={});const i=Number(t);if(Number.isNaN(i)||i<c){const i=getClearHandler(n);if(e.shouldClearNativeTimers===true){const n=e[`_${i}`];return typeof n==="function"?n(t):void 0}w(`FakeTimers: ${i} was invoked to clear a native timer instead of one created by this library.\nTo automatically clean-up native timers, use \`shouldClearNativeTimers\`.`)}if(e.timers.hasOwnProperty(i)){const t=e.timers[i];if(!(t.type===n||t.type==="Timeout"&&n==="Interval"||t.type==="Interval"&&n==="Timeout")){const e=getClearHandler(n);const i=getScheduleHandler(t.type);throw new Error(`Cannot clear timer: timer created with ${i}() but cleared with ${e}()`)}delete e.timers[i]}}
/**
     * @param {Clock} clock
     * @param {Config} config
     * @returns {Timer[]}
     */function uninstall(e,n){let i,c,l;const u="_hrtime";const p="_nextTick";for(c=0,l=e.methods.length;c<l;c++){i=e.methods[c];if(i==="hrtime"&&t.process)t.process.hrtime=e[u];else if(i==="nextTick"&&t.process)t.process.nextTick=e[p];else if(i==="performance"){const n=Object.getOwnPropertyDescriptor(e,`_${i}`);n&&n.get&&!n.set?Object.defineProperty(t,i,n):n.configurable&&(t[i]=e[`_${i}`])}else if(t[i]&&t[i].hadOwnProperty)t[i]=e[`_${i}`];else try{delete t[i]}catch(e){}if(e.timersModuleMethods!==void 0)for(let t=0;t<e.timersModuleMethods.length;t++){const n=e.timersModuleMethods[t];a[n.methodName]=n.original}if(e.timersPromisesModuleMethods!==void 0)for(let t=0;t<e.timersPromisesModuleMethods.length;t++){const n=e.timersPromisesModuleMethods[t];s[n.methodName]=n.original}}n.shouldAdvanceTime===true&&t.clearInterval(e.attachedInterval);e.methods=[];for(const[t,n]of e.abortListenerMap.entries()){n.removeEventListener("abort",t);e.abortListenerMap.delete(t)}return e.timers?Object.keys(e.timers).map((function mapper(t){return e.timers[t]})):[]}
/**
     * @param {object} target the target containing the method to replace
     * @param {string} method the keyname of the method on the target
     * @param {Clock} clock
     */function hijackMethod(e,t,n){n[t].hadOwnProperty=Object.prototype.hasOwnProperty.call(e,t);n[`_${t}`]=e[t];if(t==="Date")e[t]=n[t];else if(t==="Intl")e[t]=n[t];else if(t==="performance"){const i=Object.getOwnPropertyDescriptor(e,t);if(i&&i.get&&!i.set){Object.defineProperty(n,`_${t}`,i);const a=Object.getOwnPropertyDescriptor(n,t);Object.defineProperty(e,t,a)}else e[t]=n[t]}else{e[t]=function(){return n[t].apply(n,arguments)};Object.defineProperties(e[t],Object.getOwnPropertyDescriptors(n[t]))}e[t].clock=n}
/**
     * @param {Clock} clock
     * @param {number} advanceTimeDelta
     */function doIntervalTick(e,t){e.tick(t)}
/**
     * @typedef {object} Timers
     * @property {setTimeout} setTimeout
     * @property {clearTimeout} clearTimeout
     * @property {setInterval} setInterval
     * @property {clearInterval} clearInterval
     * @property {Date} Date
     * @property {Intl} Intl
     * @property {SetImmediate=} setImmediate
     * @property {function(NodeImmediate): void=} clearImmediate
     * @property {function(number[]):number[]=} hrtime
     * @property {NextTick=} nextTick
     * @property {Performance=} performance
     * @property {RequestAnimationFrame=} requestAnimationFrame
     * @property {boolean=} queueMicrotask
     * @property {function(number): void=} cancelAnimationFrame
     * @property {RequestIdleCallback=} requestIdleCallback
     * @property {function(number): void=} cancelIdleCallback
     */
/** @type {Timers} */const x={setTimeout:t.setTimeout,clearTimeout:t.clearTimeout,setInterval:t.setInterval,clearInterval:t.clearInterval,Date:t.Date};l.setImmediate&&(x.setImmediate=t.setImmediate);l.clearImmediate&&(x.clearImmediate=t.clearImmediate);l.hrtime&&(x.hrtime=t.process.hrtime);l.nextTick&&(x.nextTick=t.process.nextTick);l.performance&&(x.performance=t.performance);l.requestAnimationFrame&&(x.requestAnimationFrame=t.requestAnimationFrame);l.queueMicrotask&&(x.queueMicrotask=t.queueMicrotask);l.cancelAnimationFrame&&(x.cancelAnimationFrame=t.cancelAnimationFrame);l.requestIdleCallback&&(x.requestIdleCallback=t.requestIdleCallback);l.cancelIdleCallback&&(x.cancelIdleCallback=t.cancelIdleCallback);l.Intl&&(x.Intl=t.Intl);const k=t.setImmediate||t.setTimeout;
/**
     * @param {Date|number} [start] the system time - non-integer values are floored
     * @param {number} [loopLimit] maximum number of timers that will be run when calling runAll()
     * @returns {Clock}
     */function createClock(e,n){e=Math.floor(getEpoch(e));n=n||1e3;let i=0;const a=[0,0];const s={now:e,Date:createDate(),loopLimit:n};s.Date.clock=s;function getTimeToNextFrame(){return 16-(s.now-e)%16}function hrtime(t){const n=s.now-a[0]-e;const c=Math.floor(n/1e3);const l=1e6*(n-c*1e3)+i-a[1];if(Array.isArray(t)){if(t[1]>1e9)throw new TypeError("Number of nanoseconds can't exceed a billion");const e=t[0];let n=l-t[1];let i=c-e;if(n<0){n+=1e9;i-=1}return[i,n]}return[c,l]}
/**
         * A high resolution timestamp in milliseconds.
         *
         * @typedef {number} DOMHighResTimeStamp
         */
/**
         * performance.now()
         *
         * @returns {DOMHighResTimeStamp}
         */function fakePerformanceNow(){const e=hrtime();const t=e[0]*1e3+e[1]/1e6;return t}l.hrtimeBigint&&(hrtime.bigint=function(){const e=hrtime();return BigInt(e[0])*BigInt(1e9)+BigInt(e[1])});if(l.Intl){s.Intl=createIntl();s.Intl.clock=s}s.requestIdleCallback=function requestIdleCallback(e,t){let n=0;s.countTimers()>0&&(n=50);const i=addTimer(s,{func:e,args:Array.prototype.slice.call(arguments,2),delay:typeof t==="undefined"?n:Math.min(t,n),idleCallback:true});return Number(i)};s.cancelIdleCallback=function cancelIdleCallback(e){return clearTimer(s,e,"IdleCallback")};s.setTimeout=function setTimeout(e,t){return addTimer(s,{func:e,args:Array.prototype.slice.call(arguments,2),delay:t})};typeof t.Promise!=="undefined"&&h&&(s.setTimeout[h.custom]=function promisifiedSetTimeout(e,n){return new t.Promise((function setTimeoutExecutor(t){addTimer(s,{func:t,args:[n],delay:e})}))});s.clearTimeout=function clearTimeout(e){return clearTimer(s,e,"Timeout")};s.nextTick=function nextTick(e){return enqueueJob(s,{func:e,args:Array.prototype.slice.call(arguments,1),error:b?new Error:null})};s.queueMicrotask=function queueMicrotask(e){return s.nextTick(e)};s.setInterval=function setInterval(e,t){t=parseInt(t,10);return addTimer(s,{func:e,args:Array.prototype.slice.call(arguments,2),delay:t,interval:t})};s.clearInterval=function clearInterval(e){return clearTimer(s,e,"Interval")};if(l.setImmediate){s.setImmediate=function setImmediate(e){return addTimer(s,{func:e,args:Array.prototype.slice.call(arguments,1),immediate:true})};typeof t.Promise!=="undefined"&&h&&(s.setImmediate[h.custom]=function promisifiedSetImmediate(e){return new t.Promise((function setImmediateExecutor(t){addTimer(s,{func:t,args:[e],immediate:true})}))});s.clearImmediate=function clearImmediate(e){return clearTimer(s,e,"Immediate")}}s.countTimers=function countTimers(){return Object.keys(s.timers||{}).length+(s.jobs||[]).length};s.requestAnimationFrame=function requestAnimationFrame(e){const t=addTimer(s,{func:e,delay:getTimeToNextFrame(),get args(){return[fakePerformanceNow()]},animation:true});return Number(t)};s.cancelAnimationFrame=function cancelAnimationFrame(e){return clearTimer(s,e,"AnimationFrame")};s.runMicrotasks=function runMicrotasks(){runJobs(s)};
/**
         * @param {number|string} tickValue milliseconds or a string parseable by parseTime
         * @param {boolean} isAsync
         * @param {Function} resolve
         * @param {Function} reject
         * @returns {number|undefined} will return the new `now` value or nothing for async
         */function doTick(e,t,n,a){const c=typeof e==="number"?e:parseTime(e);const l=Math.floor(c);const u=nanoRemainder(c);let p=i+u;let h=s.now+l;if(c<0)throw new TypeError("Negative ticks are not supported");if(p>=1e6){h+=1;p-=1e6}i=p;let d=s.now;let m=s.now;let y,g,v,b,w,x;s.duringTick=true;v=s.now;runJobs(s);if(v!==s.now){d+=s.now-v;h+=s.now-v}function doTickInner(){y=firstTimerInRange(s,d,h);while(y&&d<=h){if(s.timers[y.id]){d=y.callAt;s.now=y.callAt;v=s.now;try{runJobs(s);callTimer(s,y)}catch(e){g=g||e}if(t){k(b);return}w()}x()}v=s.now;runJobs(s);if(v!==s.now){d+=s.now-v;h+=s.now-v}s.duringTick=false;y=firstTimerInRange(s,d,h);if(y)try{s.tick(h-s.now)}catch(e){g=g||e}else{s.now=h;i=p}if(g)throw g;if(!t)return s.now;n(s.now)}b=t&&function(){try{w();x();doTickInner()}catch(e){a(e)}};w=function(){if(v!==s.now){d+=s.now-v;h+=s.now-v;m+=s.now-v}};x=function(){y=firstTimerInRange(s,m,h);m=d};return doTickInner()}
/**
         * @param {string|number} tickValue number of milliseconds or a human-readable value like "01:11:15"
         * @returns {number} will return the new `now` value
         */s.tick=function tick(e){return doTick(e,false)};typeof t.Promise!=="undefined"&&(
/**
             * @param {string|number} tickValue number of milliseconds or a human-readable value like "01:11:15"
             * @returns {Promise}
             */
s.tickAsync=function tickAsync(e){return new t.Promise((function(t,n){k((function(){try{doTick(e,true,t,n)}catch(e){n(e)}}))}))});s.next=function next(){runJobs(s);const e=firstTimer(s);if(!e)return s.now;s.duringTick=true;try{s.now=e.callAt;callTimer(s,e);runJobs(s);return s.now}finally{s.duringTick=false}};typeof t.Promise!=="undefined"&&(s.nextAsync=function nextAsync(){return new t.Promise((function(e,t){k((function(){try{const n=firstTimer(s);if(!n){e(s.now);return}let i;s.duringTick=true;s.now=n.callAt;try{callTimer(s,n)}catch(e){i=e}s.duringTick=false;k((function(){i?t(i):e(s.now)}))}catch(e){t(e)}}))}))});s.runAll=function runAll(){let e,t;runJobs(s);for(t=0;t<s.loopLimit;t++){if(!s.timers){resetIsNearInfiniteLimit();return s.now}e=Object.keys(s.timers).length;if(e===0){resetIsNearInfiniteLimit();return s.now}s.next();checkIsNearInfiniteLimit(s,t)}const n=firstTimer(s);throw getInfiniteLoopError(s,n)};s.runToFrame=function runToFrame(){return s.tick(getTimeToNextFrame())};typeof t.Promise!=="undefined"&&(s.runAllAsync=function runAllAsync(){return new t.Promise((function(e,t){let n=0;function doRun(){k((function(){try{runJobs(s);let i;if(n<s.loopLimit){if(!s.timers){resetIsNearInfiniteLimit();e(s.now);return}i=Object.keys(s.timers).length;if(i===0){resetIsNearInfiniteLimit();e(s.now);return}s.next();n++;doRun();checkIsNearInfiniteLimit(s,n);return}const a=firstTimer(s);t(getInfiniteLoopError(s,a))}catch(e){t(e)}}))}doRun()}))});s.runToLast=function runToLast(){const e=lastTimer(s);if(!e){runJobs(s);return s.now}return s.tick(e.callAt-s.now)};typeof t.Promise!=="undefined"&&(s.runToLastAsync=function runToLastAsync(){return new t.Promise((function(e,t){k((function(){try{const t=lastTimer(s);if(!t){runJobs(s);e(s.now)}e(s.tickAsync(t.callAt-s.now))}catch(e){t(e)}}))}))});s.reset=function reset(){i=0;s.timers={};s.jobs=[];s.now=e};s.setSystemTime=function setSystemTime(e){const t=getEpoch(e);const n=t-s.now;let c,l;a[0]=a[0]+n;a[1]=a[1]+i;s.now=t;i=0;for(c in s.timers)if(s.timers.hasOwnProperty(c)){l=s.timers[c];l.createdAt+=n;l.callAt+=n}};
/**
         * @param {string|number} tickValue number of milliseconds or a human-readable value like "01:11:15"
         * @returns {number} will return the new `now` value
         */s.jump=function jump(e){const t=typeof e==="number"?e:parseTime(e);const n=Math.floor(t);for(const e of Object.values(s.timers))s.now+n>e.callAt&&(e.callAt=s.now+n);s.tick(n)};if(l.performance){s.performance=Object.create(null);s.performance.now=fakePerformanceNow}l.hrtime&&(s.hrtime=hrtime);return s}
/**
     * @param {Config=} [config] Optional config
     * @returns {Clock}
     */function install(e){if(arguments.length>1||e instanceof Date||Array.isArray(e)||typeof e==="number")throw new TypeError(`FakeTimers.install called with ${String(e)} install requires an object parameter`);if(t.Date.isFake===true)throw new TypeError("Can't install fake timers twice on the same global object.");e=typeof e!=="undefined"?e:{};e.shouldAdvanceTime=e.shouldAdvanceTime||false;e.advanceTimeDelta=e.advanceTimeDelta||20;e.shouldClearNativeTimers=e.shouldClearNativeTimers||false;if(e.target)throw new TypeError("config.target is no longer supported. Use `withGlobal(target)` instead.");
/**
         * @param {string} timer/object the name of the thing that is not present
         * @param timer
         */function handleMissingTimer(t){if(!e.ignoreMissingTimers)throw new ReferenceError(`non-existent timers and/or objects cannot be faked: '${t}'`)}let n,c;const u=createClock(e.now,e.loopLimit);u.shouldClearNativeTimers=e.shouldClearNativeTimers;u.uninstall=function(){return uninstall(u,e)};u.abortListenerMap=new Map;u.methods=e.toFake||[];u.methods.length===0&&(u.methods=Object.keys(x));if(e.shouldAdvanceTime===true){const n=doIntervalTick.bind(null,u,e.advanceTimeDelta);const i=t.setInterval(n,e.advanceTimeDelta);u.attachedInterval=i}if(u.methods.includes("performance")){const n=(()=>m?t.performance.constructor.prototype:d?t.Performance.prototype:void 0)();if(n){Object.getOwnPropertyNames(n).forEach((function(e){e!=="now"&&(u.performance[e]=e.indexOf("getEntries")===0?NOOP_ARRAY:NOOP)}));u.performance.mark=e=>new FakePerformanceEntry(e,"mark",0,0);u.performance.measure=e=>new FakePerformanceEntry(e,"measure",0,100)}else if((e.toFake||[]).includes("performance"))return handleMissingTimer("performance")}t===i&&a&&(u.timersModuleMethods=[]);t===i&&s&&(u.timersPromisesModuleMethods=[]);for(n=0,c=u.methods.length;n<c;n++){const e=u.methods[n];if(l[e]){e==="hrtime"?t.process&&typeof t.process.hrtime==="function"&&hijackMethod(t.process,e,u):e==="nextTick"?t.process&&typeof t.process.nextTick==="function"&&hijackMethod(t.process,e,u):hijackMethod(t,e,u);if(u.timersModuleMethods!==void 0&&a[e]){const n=a[e];u.timersModuleMethods.push({methodName:e,original:n});a[e]=t[e]}if(u.timersPromisesModuleMethods!==void 0)if(e==="setTimeout"){u.timersPromisesModuleMethods.push({methodName:"setTimeout",original:s.setTimeout});s.setTimeout=(e,t,n={})=>new Promise(((i,a)=>{const abort=()=>{n.signal.removeEventListener("abort",abort);u.abortListenerMap.delete(abort);u.clearTimeout(s);a(n.signal.reason)};const s=u.setTimeout((()=>{if(n.signal){n.signal.removeEventListener("abort",abort);u.abortListenerMap.delete(abort)}i(t)}),e);if(n.signal)if(n.signal.aborted)abort();else{n.signal.addEventListener("abort",abort);u.abortListenerMap.set(abort,n.signal)}}))}else if(e==="setImmediate"){u.timersPromisesModuleMethods.push({methodName:"setImmediate",original:s.setImmediate});s.setImmediate=(e,t={})=>new Promise(((n,i)=>{const abort=()=>{t.signal.removeEventListener("abort",abort);u.abortListenerMap.delete(abort);u.clearImmediate(a);i(t.signal.reason)};const a=u.setImmediate((()=>{if(t.signal){t.signal.removeEventListener("abort",abort);u.abortListenerMap.delete(abort)}n(e)}));if(t.signal)if(t.signal.aborted)abort();else{t.signal.addEventListener("abort",abort);u.abortListenerMap.set(abort,t.signal)}}))}else if(e==="setInterval"){u.timersPromisesModuleMethods.push({methodName:"setInterval",original:s.setInterval});s.setInterval=(e,t,n={})=>({[Symbol.asyncIterator]:()=>{const createResolvable=()=>{let e,t;const n=new Promise(((n,i)=>{e=n;t=i}));n.resolve=e;n.reject=t;return n};let i=false;let a=false;let s;let c=0;const l=[];const p=u.setInterval((()=>{l.length>0?l.shift().resolve():c++}),e);const abort=()=>{n.signal.removeEventListener("abort",abort);u.abortListenerMap.delete(abort);u.clearInterval(p);i=true;for(const e of l)e.resolve()};if(n.signal)if(n.signal.aborted)i=true;else{n.signal.addEventListener("abort",abort);u.abortListenerMap.set(abort,n.signal)}return{next:async()=>{if(n.signal?.aborted&&!a){a=true;throw n.signal.reason}if(i)return{done:true,value:void 0};if(c>0){c--;return{done:false,value:t}}const e=createResolvable();l.push(e);await e;s&&l.length===0&&s.resolve();if(n.signal?.aborted&&!a){a=true;throw n.signal.reason}return i?{done:true,value:void 0}:{done:false,value:t}},return:async()=>{if(i)return{done:true,value:void 0};if(l.length>0){s=createResolvable();await s}u.clearInterval(p);i=true;if(n.signal){n.signal.removeEventListener("abort",abort);u.abortListenerMap.delete(abort)}return{done:true,value:void 0}}}}})}}else handleMissingTimer(e)}return u}return{timers:x,createClock:createClock,install:install,withGlobal:withGlobal}}
/**
 * @typedef {object} FakeTimers
 * @property {Timers} timers
 * @property {createClock} createClock
 * @property {Function} install
 * @property {withGlobal} withGlobal
 */
/** @type {FakeTimers} */const c=withGlobal(i);n.timers=c.timers;n.createClock=c.createClock;n.install=c.install;n.withGlobal=withGlobal},{"@sinonjs/commons":47,timers:void 0,"timers/promises":void 0,util:91}],61:[function(e,t,n){var i=[Array,Int8Array,Uint8Array,Uint8ClampedArray,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array];t.exports=i},{}],62:[function(e,t,n){var i=e("@sinonjs/commons").prototypes.array;var a=e("./deep-equal").use(createMatcher);var s=e("@sinonjs/commons").every;var c=e("@sinonjs/commons").functionName;var l=e("lodash.get");var u=e("./iterable-to-string");var p=e("@sinonjs/commons").prototypes.object;var h=e("@sinonjs/commons").typeOf;var d=e("@sinonjs/commons").valueToString;var m=e("./create-matcher/assert-matcher");var y=e("./create-matcher/assert-method-exists");var g=e("./create-matcher/assert-type");var v=e("./create-matcher/is-iterable");var b=e("./create-matcher/is-matcher");var w=e("./create-matcher/matcher-prototype");var x=i.indexOf;var k=i.some;var j=p.hasOwnProperty;var C=p.toString;var T=e("./create-matcher/type-map")(createMatcher);
/**
 * Creates a matcher object for the passed expectation
 *
 * @alias module:samsam.createMatcher
 * @param {*} expectation An expecttation
 * @param {string} message A message for the expectation
 * @returns {object} A matcher object
 */function createMatcher(e,t){var n=Object.create(w);var i=h(e);if(t!==void 0&&typeof t!=="string")throw new TypeError("Message should be a string");if(arguments.length>2)throw new TypeError(`Expected 1 or 2 arguments, received ${arguments.length}`);i in T?T[i](n,e,t):n.test=function(t){return a(t,e)};n.message||(n.message=`match(${d(e)})`);Object.defineProperty(n,"message",{configurable:false,writable:false,value:n.message});return n}createMatcher.isMatcher=b;createMatcher.any=createMatcher((function(){return true}),"any");createMatcher.defined=createMatcher((function(e){return e!==null&&e!==void 0}),"defined");createMatcher.truthy=createMatcher((function(e){return Boolean(e)}),"truthy");createMatcher.falsy=createMatcher((function(e){return!e}),"falsy");createMatcher.same=function(e){return createMatcher((function(t){return e===t}),`same(${d(e)})`)};createMatcher.in=function(e){if(h(e)!=="array")throw new TypeError("array expected");return createMatcher((function(t){return k(e,(function(e){return e===t}))}),`in(${d(e)})`)};createMatcher.typeOf=function(e){g(e,"string","type");return createMatcher((function(t){return h(t)===e}),`typeOf("${e}")`)};createMatcher.instanceOf=function(e){typeof Symbol==="undefined"||typeof Symbol.hasInstance==="undefined"?g(e,"function","type"):y(e,Symbol.hasInstance,"type","[Symbol.hasInstance]");return createMatcher((function(t){return t instanceof e}),`instanceOf(${c(e)||C(e)})`)};
/**
 * Creates a property matcher
 *
 * @private
 * @param {Function} propertyTest A function to test the property against a value
 * @param {string} messagePrefix A prefix to use for messages generated by the matcher
 * @returns {object} A matcher
 */function createPropertyMatcher(e,t){return function(n,i){g(n,"string","property");var s=arguments.length===1;var c=`${t}("${n}"`;s||(c+=`, ${d(i)}`);c+=")";return createMatcher((function(t){return!(t===void 0||t===null||!e(t,n))&&(s||a(t[n],i))}),c)}}createMatcher.has=createPropertyMatcher((function(e,t){return typeof e==="object"?t in e:e[t]!==void 0}),"has");createMatcher.hasOwn=createPropertyMatcher((function(e,t){return j(e,t)}),"hasOwn");createMatcher.hasNested=function(e,t){g(e,"string","property");var n=arguments.length===1;var i=`hasNested("${e}"`;n||(i+=`, ${d(t)}`);i+=")";return createMatcher((function(i){return i!==void 0&&i!==null&&l(i,e)!==void 0&&(n||a(l(i,e),t))}),i)};var A={null:true,boolean:true,number:true,string:true,object:true,array:true};createMatcher.json=function(e){if(!A[h(e)])throw new TypeError("Value cannot be the result of JSON.parse");var t=`json(${JSON.stringify(e,null,"  ")})`;return createMatcher((function(t){var n;try{n=JSON.parse(t)}catch(e){return false}return a(n,e)}),t)};createMatcher.every=function(e){m(e);return createMatcher((function(t){return h(t)==="object"?s(Object.keys(t),(function(n){return e.test(t[n])})):v(t)&&s(t,(function(t){return e.test(t)}))}),`every(${e.message})`)};createMatcher.some=function(e){m(e);return createMatcher((function(t){return h(t)==="object"?!s(Object.keys(t),(function(n){return!e.test(t[n])})):v(t)&&!s(t,(function(t){return!e.test(t)}))}),`some(${e.message})`)};createMatcher.array=createMatcher.typeOf("array");createMatcher.array.deepEquals=function(e){return createMatcher((function(t){var n=t.length===e.length;return h(t)==="array"&&n&&s(t,(function(t,n){var i=e[n];return h(i)==="array"&&h(t)==="array"?createMatcher.array.deepEquals(i).test(t):a(i,t)}))}),`deepEquals([${u(e)}])`)};createMatcher.array.startsWith=function(e){return createMatcher((function(t){return h(t)==="array"&&s(e,(function(e,n){return t[n]===e}))}),`startsWith([${u(e)}])`)};createMatcher.array.endsWith=function(e){return createMatcher((function(t){var n=t.length-e.length;return h(t)==="array"&&s(e,(function(e,i){return t[n+i]===e}))}),`endsWith([${u(e)}])`)};createMatcher.array.contains=function(e){return createMatcher((function(t){return h(t)==="array"&&s(e,(function(e){return x(t,e)!==-1}))}),`contains([${u(e)}])`)};createMatcher.map=createMatcher.typeOf("map");createMatcher.map.deepEquals=function mapDeepEquals(e){return createMatcher((function(t){var n=t.size===e.size;return h(t)==="map"&&n&&s(t,(function(t,n){return e.has(n)&&e.get(n)===t}))}),`deepEquals(Map[${u(e)}])`)};createMatcher.map.contains=function mapContains(e){return createMatcher((function(t){return h(t)==="map"&&s(e,(function(e,n){return t.has(n)&&t.get(n)===e}))}),`contains(Map[${u(e)}])`)};createMatcher.set=createMatcher.typeOf("set");createMatcher.set.deepEquals=function setDeepEquals(e){return createMatcher((function(t){var n=t.size===e.size;return h(t)==="set"&&n&&s(t,(function(t){return e.has(t)}))}),`deepEquals(Set[${u(e)}])`)};createMatcher.set.contains=function setContains(e){return createMatcher((function(t){return h(t)==="set"&&s(e,(function(e){return t.has(e)}))}),`contains(Set[${u(e)}])`)};createMatcher.bool=createMatcher.typeOf("boolean");createMatcher.number=createMatcher.typeOf("number");createMatcher.string=createMatcher.typeOf("string");createMatcher.object=createMatcher.typeOf("object");createMatcher.func=createMatcher.typeOf("function");createMatcher.regexp=createMatcher.typeOf("regexp");createMatcher.date=createMatcher.typeOf("date");createMatcher.symbol=createMatcher.typeOf("symbol");t.exports=createMatcher},{"./create-matcher/assert-matcher":63,"./create-matcher/assert-method-exists":64,"./create-matcher/assert-type":65,"./create-matcher/is-iterable":66,"./create-matcher/is-matcher":67,"./create-matcher/matcher-prototype":69,"./create-matcher/type-map":70,"./deep-equal":71,"./iterable-to-string":85,"@sinonjs/commons":47,"lodash.get":93}],63:[function(e,t,n){var i=e("./is-matcher");
/**
 * Throws a TypeError when `value` is not a matcher
 *
 * @private
 * @param {*} value The value to examine
 */function assertMatcher(e){if(!i(e))throw new TypeError("Matcher expected")}t.exports=assertMatcher},{"./is-matcher":67}],64:[function(e,t,n){
/**
 * Throws a TypeError when expected method doesn't exist
 *
 * @private
 * @param {*} value A value to examine
 * @param {string} method The name of the method to look for
 * @param {name} name A name to use for the error message
 * @param {string} methodPath The name of the method to use for error messages
 * @throws {TypeError} When the method doesn't exist
 */
function assertMethodExists(e,t,n,i){if(e[t]===null||e[t]===void 0)throw new TypeError(`Expected ${n} to have method ${i}`)}t.exports=assertMethodExists},{}],65:[function(e,t,n){var i=e("@sinonjs/commons").typeOf;
/**
 * Ensures that value is of type
 *
 * @private
 * @param {*} value A value to examine
 * @param {string} type A basic JavaScript type to compare to, e.g. "object", "string"
 * @param {string} name A string to use for the error message
 * @throws {TypeError} If value is not of the expected type
 * @returns {undefined}
 */function assertType(e,t,n){var a=i(e);if(a!==t)throw new TypeError(`Expected type of ${n} to be ${t}, but was ${a}`)}t.exports=assertType},{"@sinonjs/commons":47}],66:[function(e,t,n){var i=e("@sinonjs/commons").typeOf;
/**
 * Returns `true` for iterables
 *
 * @private
 * @param {*} value A value to examine
 * @returns {boolean} Returns `true` when `value` looks like an iterable
 */function isIterable(e){return Boolean(e)&&i(e.forEach)==="function"}t.exports=isIterable},{"@sinonjs/commons":47}],67:[function(e,t,n){var i=e("@sinonjs/commons").prototypes.object.isPrototypeOf;var a=e("./matcher-prototype");
/**
 * Returns `true` when `object` is a matcher
 *
 * @private
 * @param {*} object A value to examine
 * @returns {boolean} Returns `true` when `object` is a matcher
 */function isMatcher(e){return i(a,e)}t.exports=isMatcher},{"./matcher-prototype":69,"@sinonjs/commons":47}],68:[function(e,t,n){var i=e("@sinonjs/commons").prototypes.array.every;var a=e("@sinonjs/commons").prototypes.array.concat;var s=e("@sinonjs/commons").typeOf;var c=e("../deep-equal").use;var l=e("../identical");var u=e("./is-matcher");var p=Object.keys;var h=Object.getOwnPropertySymbols;
/**
 * Matches `actual` with `expectation`
 *
 * @private
 * @param {*} actual A value to examine
 * @param {object} expectation An object with properties to match on
 * @param {object} matcher A matcher to use for comparison
 * @returns {boolean} Returns true when `actual` matches all properties in `expectation`
 */function matchObject(e,t,n){var d=c(n);if(e===null||e===void 0)return false;var m=p(t);s(h)==="function"&&(m=a(m,h(t)));return i(m,(function(i){var a=t[i];var c=e[i];if(u(a)){if(!a.test(c))return false}else if(s(a)==="object"){if(l(a,c))return true;if(!matchObject(c,a,n))return false}else if(!d(c,a))return false;return true}))}t.exports=matchObject},{"../deep-equal":71,"../identical":73,"./is-matcher":67,"@sinonjs/commons":47}],69:[function(e,t,n){var i={toString:function(){return this.message}};i.or=function(t){var n=e("../create-matcher");var a=n.isMatcher;if(!arguments.length)throw new TypeError("Matcher expected");var s=a(t)?t:n(t);var c=this;var l=Object.create(i);l.test=function(e){return c.test(e)||s.test(e)};l.message=`${c.message}.or(${s.message})`;return l};i.and=function(t){var n=e("../create-matcher");var a=n.isMatcher;if(!arguments.length)throw new TypeError("Matcher expected");var s=a(t)?t:n(t);var c=this;var l=Object.create(i);l.test=function(e){return c.test(e)&&s.test(e)};l.message=`${c.message}.and(${s.message})`;return l};t.exports=i},{"../create-matcher":62}],70:[function(e,t,n){var i=e("@sinonjs/commons").functionName;var a=e("@sinonjs/commons").prototypes.array.join;var s=e("@sinonjs/commons").prototypes.array.map;var c=e("@sinonjs/commons").prototypes.string.indexOf;var l=e("@sinonjs/commons").valueToString;var u=e("./match-object");var createTypeMap=function(e){return{function:function(e,t,n){e.test=t;e.message=n||`match(${i(t)})`},number:function(e,t){e.test=function(e){return t==e}},object:function(t,n){var c=[];if(typeof n.test==="function"){t.test=function(e){return n.test(e)===true};t.message=`match(${i(n.test)})`;return t}c=s(Object.keys(n),(function(e){return`${e}: ${l(n[e])}`}));t.test=function(t){return u(t,n,e)};t.message=`match(${a(c,", ")})`;return t},regexp:function(e,t){e.test=function(e){return typeof e==="string"&&t.test(e)}},string:function(e,t){e.test=function(e){return typeof e==="string"&&c(e,t)!==-1};e.message=`match("${t}")`}}};t.exports=createTypeMap},{"./match-object":68,"@sinonjs/commons":47}],71:[function(e,t,n){var i=e("@sinonjs/commons").valueToString;var a=e("@sinonjs/commons").className;var s=e("@sinonjs/commons").typeOf;var c=e("@sinonjs/commons").prototypes.array;var l=e("@sinonjs/commons").prototypes.object;var u=e("@sinonjs/commons").prototypes.map.forEach;var p=e("./get-class");var h=e("./identical");var d=e("./is-arguments");var m=e("./is-array-type");var y=e("./is-date");var g=e("./is-element");var v=e("./is-iterable");var b=e("./is-map");var w=e("./is-nan");var x=e("./is-object");var k=e("./is-set");var j=e("./is-subset");var C=c.concat;var T=c.every;var A=c.push;var S=Date.prototype.getTime;var O=l.hasOwnProperty;var E=c.indexOf;var P=Object.keys;var M=Object.getOwnPropertySymbols;
/**
 * Deep equal comparison. Two values are "deep equal" when:
 *
 *   - They are equal, according to samsam.identical
 *   - They are both date objects representing the same time
 *   - They are both arrays containing elements that are all deepEqual
 *   - They are objects with the same set of properties, and each property
 *     in ``actual`` is deepEqual to the corresponding property in ``expectation``
 *
 * Supports cyclic objects.
 *
 * @alias module:samsam.deepEqual
 * @param {*} actual The object to examine
 * @param {*} expectation The object actual is expected to be equal to
 * @param {object} match A value to match on
 * @returns {boolean} Returns true when actual and expectation are considered equal
 */function deepEqualCyclic(e,t,n){var c=[];var l=[];var I=[];var L=[];var $={};return function deepEqual(e,t,F,N){if(n&&n.isMatcher(t))return n.isMatcher(e)?e===t:t.test(e);var D=typeof e;var W=typeof t;if(e===t||w(e)||w(t)||e===null||t===null||e===void 0||t===void 0||D!=="object"||W!=="object")return h(e,t);if(g(e)||g(t))return false;var _=y(e);var H=y(t);if((_||H)&&(!_||!H||S.call(e)!==S.call(t)))return false;if(e instanceof RegExp&&t instanceof RegExp&&i(e)!==i(t))return false;if(e instanceof Promise&&t instanceof Promise)return e===t;if(e instanceof Error&&t instanceof Error)return e===t;var B=p(e);var q=p(t);var R=P(e);var z=P(t);var V=a(e);var U=a(t);var J=s(M)==="function"?M(t):[];var G=C(z,J);if(d(e)||d(t)){if(e.length!==t.length)return false}else if(D!==W||B!==q||R.length!==z.length||V&&U&&V!==U)return false;if(k(e)||k(t))return!(!k(e)||!k(t)||e.size!==t.size)&&j(e,t,deepEqual);if(b(e)||b(t)){if(!b(e)||!b(t)||e.size!==t.size)return false;var K=true;u(e,(function(e,n){K=K&&deepEqualCyclic(e,t.get(n))}));return K}if(e.constructor&&e.constructor.name==="jQuery"&&typeof e.is==="function")return e.is(t);var Z=v(e)&&!m(e)&&!d(e);var Q=v(t)&&!m(t)&&!d(t);if(Z||Q){var X=Array.from(e);var Y=Array.from(t);if(X.length!==Y.length)return false;var ee=true;T(X,(function(e){ee=ee&&deepEqualCyclic(X[e],Y[e])}));return ee}return T(G,(function(n){if(!O(e,n))return false;var i=e[n];var a=t[n];var s=x(i);var u=x(a);var p=s?E(c,i):-1;var h=u?E(l,a):-1;var d=p!==-1?I[p]:`${F}[${JSON.stringify(n)}]`;var m=h!==-1?L[h]:`${N}[${JSON.stringify(n)}]`;var y=d+m;if($[y])return true;if(p===-1&&s){A(c,i);A(I,d)}if(h===-1&&u){A(l,a);A(L,m)}s&&u&&($[y]=true);return deepEqual(i,a,d,m)}))}(e,t,"$1","$2")}deepEqualCyclic.use=function(e){return function deepEqual(t,n){return deepEqualCyclic(t,n,e)}};t.exports=deepEqualCyclic},{"./get-class":72,"./identical":73,"./is-arguments":74,"./is-array-type":75,"./is-date":76,"./is-element":77,"./is-iterable":78,"./is-map":79,"./is-nan":80,"./is-object":82,"./is-set":83,"./is-subset":84,"@sinonjs/commons":47}],72:[function(e,t,n){var i=e("@sinonjs/commons").prototypes.object.toString;
/**
 * Returns the internal `Class` by calling `Object.prototype.toString`
 * with the provided value as `this`. Return value is a `String`, naming the
 * internal class, e.g. "Array"
 *
 * @private
 * @param  {*} value - Any value
 * @returns {string} - A string representation of the `Class` of `value`
 */function getClass(e){return i(e).split(/[ \]]/)[1]}t.exports=getClass},{"@sinonjs/commons":47}],73:[function(e,t,n){var i=e("./is-nan");var a=e("./is-neg-zero");
/**
 * Strict equality check according to EcmaScript Harmony's `egal`.
 *
 * **From the Harmony wiki:**
 * > An `egal` function simply makes available the internal `SameValue` function
 * > from section 9.12 of the ES5 spec. If two values are egal, then they are not
 * > observably distinguishable.
 *
 * `identical` returns `true` when `===` is `true`, except for `-0` and
 * `+0`, where it returns `false`. Additionally, it returns `true` when
 * `NaN` is compared to itself.
 *
 * @alias module:samsam.identical
 * @param {*} obj1 The first value to compare
 * @param {*} obj2 The second value to compare
 * @returns {boolean} Returns `true` when the objects are *egal*, `false` otherwise
 */function identical(e,t){return!!(e===t||i(e)&&i(t))&&(e!==0||a(e)===a(t))}t.exports=identical},{"./is-nan":80,"./is-neg-zero":81}],74:[function(e,t,n){var i=e("./get-class");
/**
 * Returns `true` when `object` is an `arguments` object, `false` otherwise
 *
 * @alias module:samsam.isArguments
 * @param  {*}  object - The object to examine
 * @returns {boolean} `true` when `object` is an `arguments` object
 */function isArguments(e){return i(e)==="Arguments"}t.exports=isArguments},{"./get-class":72}],75:[function(e,t,n){var i=e("@sinonjs/commons").functionName;var a=e("@sinonjs/commons").prototypes.array.indexOf;var s=e("@sinonjs/commons").prototypes.array.map;var c=e("./array-types");var l=e("type-detect");
/**
 * Returns `true` when `object` is an array type, `false` otherwise
 *
 * @param  {*}  object - The object to examine
 * @returns {boolean} `true` when `object` is an array type
 * @private
 */function isArrayType(e){return a(s(c,i),l(e))!==-1}t.exports=isArrayType},{"./array-types":61,"@sinonjs/commons":47,"type-detect":88}],76:[function(e,t,n){
/**
 * Returns `true` when `value` is an instance of Date
 *
 * @private
 * @param  {Date}  value The value to examine
 * @returns {boolean}     `true` when `value` is an instance of Date
 */
function isDate(e){return e instanceof Date}t.exports=isDate},{}],77:[function(e,t,n){var i=typeof document!=="undefined"&&document.createElement("div");
/**
 * Returns `true` when `object` is a DOM element node.
 *
 * Unlike Underscore.js/lodash, this function will return `false` if `object`
 * is an *element-like* object, i.e. a regular object with a `nodeType`
 * property that holds the value `1`.
 *
 * @alias module:samsam.isElement
 * @param {object} object The object to examine
 * @returns {boolean} Returns `true` for DOM element nodes
 */function isElement(e){if(!e||e.nodeType!==1||!i)return false;try{e.appendChild(i);e.removeChild(i)}catch(e){return false}return true}t.exports=isElement},{}],78:[function(e,t,n){
/**
 * Returns `true` when the argument is an iterable, `false` otherwise
 *
 * @alias module:samsam.isIterable
 * @param  {*}  val - A value to examine
 * @returns {boolean} Returns `true` when the argument is an iterable, `false` otherwise
 */
function isIterable(e){return typeof e==="object"&&typeof e[Symbol.iterator]==="function"}t.exports=isIterable},{}],79:[function(e,t,n){
/**
 * Returns `true` when `value` is a Map
 *
 * @param {*} value A value to examine
 * @returns {boolean} `true` when `value` is an instance of `Map`, `false` otherwise
 * @private
 */
function isMap(e){return typeof Map!=="undefined"&&e instanceof Map}t.exports=isMap},{}],80:[function(e,t,n){
/**
 * Compares a `value` to `NaN`
 *
 * @private
 * @param {*} value A value to examine
 * @returns {boolean} Returns `true` when `value` is `NaN`
 */
function isNaN(e){return typeof e==="number"&&e!==e}t.exports=isNaN},{}],81:[function(e,t,n){
/**
 * Returns `true` when `value` is `-0`
 *
 * @alias module:samsam.isNegZero
 * @param {*} value A value to examine
 * @returns {boolean} Returns `true` when `value` is `-0`
 */
function isNegZero(e){return e===0&&1/e===-Infinity}t.exports=isNegZero},{}],82:[function(e,t,n){
/**
 * Returns `true` when the value is a regular Object and not a specialized Object
 *
 * This helps speed up deepEqual cyclic checks
 *
 * The premise is that only Objects are stored in the visited array.
 * So if this function returns false, we don't have to do the
 * expensive operation of searching for the value in the the array of already
 * visited objects
 *
 * @private
 * @param  {object}   value The object to examine
 * @returns {boolean}       `true` when the object is a non-specialised object
 */
function isObject(e){return typeof e==="object"&&e!==null&&!(e instanceof Boolean)&&!(e instanceof Date)&&!(e instanceof Error)&&!(e instanceof Number)&&!(e instanceof RegExp)&&!(e instanceof String)}t.exports=isObject},{}],83:[function(e,t,n){
/**
 * Returns `true` when the argument is an instance of Set, `false` otherwise
 *
 * @alias module:samsam.isSet
 * @param  {*}  val - A value to examine
 * @returns {boolean} Returns `true` when the argument is an instance of Set, `false` otherwise
 */
function isSet(e){return typeof Set!=="undefined"&&e instanceof Set||false}t.exports=isSet},{}],84:[function(e,t,n){var i=e("@sinonjs/commons").prototypes.set.forEach;
/**
 * Returns `true` when `s1` is a subset of `s2`, `false` otherwise
 *
 * @private
 * @param  {Array|Set}  s1      The target value
 * @param  {Array|Set}  s2      The containing value
 * @param  {Function}  compare A comparison function, should return `true` when
 *                             values are considered equal
 * @returns {boolean} Returns `true` when `s1` is a subset of `s2`, `false`` otherwise
 */function isSubset(e,t,n){var a=true;i(e,(function(e){var s=false;i(t,(function(t){n(t,e)&&(s=true)}));a=a&&s}));return a}t.exports=isSubset},{"@sinonjs/commons":47}],85:[function(e,t,n){var i=e("@sinonjs/commons").prototypes.string.slice;var a=e("@sinonjs/commons").typeOf;var s=e("@sinonjs/commons").valueToString;
/**
 * Creates a string represenation of an iterable object
 *
 * @private
 * @param   {object} obj The iterable object to stringify
 * @returns {string}     A string representation
 */function iterableToString(e){return a(e)==="map"?mapToString(e):genericIterableToString(e)}
/**
 * Creates a string representation of a Map
 *
 * @private
 * @param   {Map} map    The map to stringify
 * @returns {string}     A string representation
 */function mapToString(e){var t="";e.forEach((function(e,n){t+=`[${stringify(n)},${stringify(e)}],`}));t=i(t,0,-1);return t}
/**
 * Create a string represenation for an iterable
 *
 * @private
 * @param   {object} iterable The iterable to stringify
 * @returns {string}          A string representation
 */function genericIterableToString(e){var t="";e.forEach((function(e){t+=`${stringify(e)},`}));t=i(t,0,-1);return t}
/**
 * Creates a string representation of the passed `item`
 *
 * @private
 * @param  {object} item The item to stringify
 * @returns {string}      A string representation of `item`
 */function stringify(e){return typeof e==="string"?`'${e}'`:s(e)}t.exports=iterableToString},{"@sinonjs/commons":47}],86:[function(e,t,n){var i=e("@sinonjs/commons").valueToString;var a=e("@sinonjs/commons").prototypes.string.indexOf;var s=e("@sinonjs/commons").prototypes.array.forEach;var c=e("type-detect");var l=typeof Array.from==="function";var u=e("./deep-equal").use(match);var p=e("./is-array-type");var h=e("./is-subset");var d=e("./create-matcher");
/**
 * Returns true when `array` contains all of `subset` as defined by the `compare`
 * argument
 *
 * @param  {Array} array   An array to search for a subset
 * @param  {Array} subset  The subset to find in the array
 * @param  {Function} compare A comparison function
 * @returns {boolean}         [description]
 * @private
 */function arrayContains(e,t,n){if(t.length===0)return true;var i,a,s,c;for(i=0,a=e.length;i<a;++i)if(n(e[i],t[0])){for(s=0,c=t.length;s<c;++s){if(i+s>=a)return false;if(!n(e[i+s],t[s]))return false}return true}return false}
/**
 * Matches an object with a matcher (or value)
 *
 * @alias module:samsam.match
 * @param {object} object The object candidate to match
 * @param {object} matcherOrValue A matcher or value to match against
 * @returns {boolean} true when `object` matches `matcherOrValue`
 */function match(e,t){if(t&&typeof t.test==="function")return t.test(e);switch(c(t)){case"bigint":case"boolean":case"number":case"symbol":return t===e;case"function":return t(e)===true;case"string":var n=typeof e==="string"||Boolean(e);return n&&a(i(e).toLowerCase(),t.toLowerCase())>=0;case"null":return e===null;case"undefined":return typeof e==="undefined";case"Date":if(c(e)==="Date")return e.getTime()===t.getTime();break;case"Array":case"Int8Array":case"Uint8Array":case"Uint8ClampedArray":case"Int16Array":case"Uint16Array":case"Int32Array":case"Uint32Array":case"Float32Array":case"Float64Array":return p(t)&&arrayContains(e,t,match);case"Map":if(!l)throw new Error("The JavaScript engine does not support Array.from and cannot reliably do value comparison of Map instances");return c(e)==="Map"&&arrayContains(Array.from(e),Array.from(t),match);default:break}switch(c(e)){case"null":return false;case"Set":return h(t,e,match);default:break}if(t&&typeof t==="object"){if(t===e)return true;if(typeof e!=="object")return false;var s;for(s in t){var d=e[s];typeof d==="undefined"&&typeof e.getAttribute==="function"&&(d=e.getAttribute(s));if(t[s]===null||typeof t[s]==="undefined"){if(d!==t[s])return false}else if(typeof d==="undefined"||!u(d,t[s]))return false}return true}throw new Error("Matcher was an unknown or unsupported type")}s(Object.keys(d),(function(e){match[e]=d[e]}));t.exports=match},{"./create-matcher":62,"./deep-equal":71,"./is-array-type":75,"./is-subset":84,"@sinonjs/commons":47,"type-detect":88}],87:[function(e,t,n){var i=e("./identical");var a=e("./is-arguments");var s=e("./is-element");var c=e("./is-neg-zero");var l=e("./is-set");var u=e("./is-map");var p=e("./match");var h=e("./deep-equal").use(p);var d=e("./create-matcher");t.exports={createMatcher:d,deepEqual:h,identical:i,isArguments:a,isElement:s,isMap:u,isNegZero:c,isSet:l,match:p}},{"./create-matcher":62,"./deep-equal":71,"./identical":73,"./is-arguments":74,"./is-element":77,"./is-map":79,"./is-neg-zero":81,"./is-set":83,"./match":86}],88:[function(e,t,n){(function(e,i){typeof n==="object"&&typeof t!=="undefined"?t.exports=i():typeof define==="function"&&define.amd?define(i):(e=typeof globalThis!=="undefined"?globalThis:e||self,e.typeDetect=i())})(this,(function(){var e=typeof Promise==="function";var t=function(e){if(typeof globalThis==="object")return globalThis;Object.defineProperty(e,"typeDetectGlobalObject",{get:function get(){return this},configurable:true});var t=typeDetectGlobalObject;delete e.typeDetectGlobalObject;return t}(Object.prototype);var n=typeof Symbol!=="undefined";var i=typeof Map!=="undefined";var a=typeof Set!=="undefined";var s=typeof WeakMap!=="undefined";var c=typeof WeakSet!=="undefined";var l=typeof DataView!=="undefined";var u=n&&typeof Symbol.iterator!=="undefined";var p=n&&typeof Symbol.toStringTag!=="undefined";var h=a&&typeof Set.prototype.entries==="function";var d=i&&typeof Map.prototype.entries==="function";var m=h&&Object.getPrototypeOf((new Set).entries());var y=d&&Object.getPrototypeOf((new Map).entries());var g=u&&typeof Array.prototype[Symbol.iterator]==="function";var v=g&&Object.getPrototypeOf([][Symbol.iterator]());var b=u&&typeof String.prototype[Symbol.iterator]==="function";var w=b&&Object.getPrototypeOf(""[Symbol.iterator]());var x=8;var k=-1;function typeDetect(n){var u=typeof n;if(u!=="object")return u;if(n===null)return"null";if(n===t)return"global";if(Array.isArray(n)&&(p===false||!(Symbol.toStringTag in n)))return"Array";if(typeof window==="object"&&window!==null){if(typeof window.location==="object"&&n===window.location)return"Location";if(typeof window.document==="object"&&n===window.document)return"Document";if(typeof window.navigator==="object"){if(typeof window.navigator.mimeTypes==="object"&&n===window.navigator.mimeTypes)return"MimeTypeArray";if(typeof window.navigator.plugins==="object"&&n===window.navigator.plugins)return"PluginArray"}if((typeof window.HTMLElement==="function"||typeof window.HTMLElement==="object")&&n instanceof window.HTMLElement){if(n.tagName==="BLOCKQUOTE")return"HTMLQuoteElement";if(n.tagName==="TD")return"HTMLTableDataCellElement";if(n.tagName==="TH")return"HTMLTableHeaderCellElement"}}var h=p&&n[Symbol.toStringTag];if(typeof h==="string")return h;var d=Object.getPrototypeOf(n);return d===RegExp.prototype?"RegExp":d===Date.prototype?"Date":e&&d===Promise.prototype?"Promise":a&&d===Set.prototype?"Set":i&&d===Map.prototype?"Map":c&&d===WeakSet.prototype?"WeakSet":s&&d===WeakMap.prototype?"WeakMap":l&&d===DataView.prototype?"DataView":i&&d===y?"Map Iterator":a&&d===m?"Set Iterator":g&&d===v?"Array Iterator":b&&d===w?"String Iterator":d===null?"Object":Object.prototype.toString.call(n).slice(x,k)}return typeDetect}))},{}],89:[function(e,t,n){typeof Object.create==="function"?t.exports=function inherits(e,t){e.super_=t;e.prototype=Object.create(t.prototype,{constructor:{value:e,enumerable:false,writable:true,configurable:true}})}:t.exports=function inherits(e,t){e.super_=t;var TempCtor=function(){};TempCtor.prototype=t.prototype;e.prototype=new TempCtor;e.prototype.constructor=e}},{}],90:[function(e,t,n){t.exports=function isBuffer(e){return e&&typeof e==="object"&&typeof e.copy==="function"&&typeof e.fill==="function"&&typeof e.readUInt8==="function"}},{}],91:[function(e,t,n){var i=/%[sdj%]/g;n.format=function(e){if(!isString(e)){var t=[];for(var n=0;n<arguments.length;n++)t.push(inspect(arguments[n]));return t.join(" ")}n=1;var a=arguments;var s=a.length;var c=String(e).replace(i,(function(e){if(e==="%%")return"%";if(n>=s)return e;switch(e){case"%s":return String(a[n++]);case"%d":return Number(a[n++]);case"%j":try{return JSON.stringify(a[n++])}catch(e){return"[Circular]"}default:return e}}));for(var l=a[n];n<s;l=a[++n])isNull(l)||!isObject(l)?c+=" "+l:c+=" "+inspect(l);return c};n.deprecate=function(e,t){if(isUndefined(global.process))return function(){return n.deprecate(e,t).apply(this,arguments)};if(process.noDeprecation===true)return e;var i=false;function deprecated(){if(!i){if(process.throwDeprecation)throw new Error(t);process.traceDeprecation?console.trace(t):console.error(t);i=true}return e.apply(this,arguments)}return deprecated};var a={};var s;n.debuglog=function(e){isUndefined(s)&&(s=process.env.NODE_DEBUG||"");e=e.toUpperCase();if(!a[e])if(new RegExp("\\b"+e+"\\b","i").test(s)){var t=process.pid;a[e]=function(){var i=n.format.apply(n,arguments);console.error("%s %d: %s",e,t,i)}}else a[e]=function(){};return a[e]};
/**
 * Echos the value of a value. Trys to print the value out
 * in the best way possible given the different types.
 *
 * @param {Object} obj The object to print out.
 * @param {Object} opts Optional options object that alters the output.
 */function inspect(e,t){var i={seen:[],stylize:stylizeNoColor};arguments.length>=3&&(i.depth=arguments[2]);arguments.length>=4&&(i.colors=arguments[3]);isBoolean(t)?i.showHidden=t:t&&n._extend(i,t);isUndefined(i.showHidden)&&(i.showHidden=false);isUndefined(i.depth)&&(i.depth=2);isUndefined(i.colors)&&(i.colors=false);isUndefined(i.customInspect)&&(i.customInspect=true);i.colors&&(i.stylize=stylizeWithColor);return formatValue(i,e,i.depth)}n.inspect=inspect;inspect.colors={bold:[1,22],italic:[3,23],underline:[4,24],inverse:[7,27],white:[37,39],grey:[90,39],black:[30,39],blue:[34,39],cyan:[36,39],green:[32,39],magenta:[35,39],red:[31,39],yellow:[33,39]};inspect.styles={special:"cyan",number:"yellow",boolean:"yellow",undefined:"grey",null:"bold",string:"green",date:"magenta",regexp:"red"};function stylizeWithColor(e,t){var n=inspect.styles[t];return n?"["+inspect.colors[n][0]+"m"+e+"["+inspect.colors[n][1]+"m":e}function stylizeNoColor(e,t){return e}function arrayToHash(e){var t={};e.forEach((function(e,n){t[e]=true}));return t}function formatValue(e,t,i){if(e.customInspect&&t&&isFunction(t.inspect)&&t.inspect!==n.inspect&&!(t.constructor&&t.constructor.prototype===t)){var a=t.inspect(i,e);isString(a)||(a=formatValue(e,a,i));return a}var s=formatPrimitive(e,t);if(s)return s;var c=Object.keys(t);var l=arrayToHash(c);e.showHidden&&(c=Object.getOwnPropertyNames(t));if(isError(t)&&(c.indexOf("message")>=0||c.indexOf("description")>=0))return formatError(t);if(c.length===0){if(isFunction(t)){var u=t.name?": "+t.name:"";return e.stylize("[Function"+u+"]","special")}if(isRegExp(t))return e.stylize(RegExp.prototype.toString.call(t),"regexp");if(isDate(t))return e.stylize(Date.prototype.toString.call(t),"date");if(isError(t))return formatError(t)}var p="",h=false,d=["{","}"];if(isArray(t)){h=true;d=["[","]"]}if(isFunction(t)){var m=t.name?": "+t.name:"";p=" [Function"+m+"]"}isRegExp(t)&&(p=" "+RegExp.prototype.toString.call(t));isDate(t)&&(p=" "+Date.prototype.toUTCString.call(t));isError(t)&&(p=" "+formatError(t));if(c.length===0&&(!h||t.length==0))return d[0]+p+d[1];if(i<0)return isRegExp(t)?e.stylize(RegExp.prototype.toString.call(t),"regexp"):e.stylize("[Object]","special");e.seen.push(t);var y;y=h?formatArray(e,t,i,l,c):c.map((function(n){return formatProperty(e,t,i,l,n,h)}));e.seen.pop();return reduceToSingleString(y,p,d)}function formatPrimitive(e,t){if(isUndefined(t))return e.stylize("undefined","undefined");if(isString(t)){var n="'"+JSON.stringify(t).replace(/^"|"$/g,"").replace(/'/g,"\\'").replace(/\\"/g,'"')+"'";return e.stylize(n,"string")}return isNumber(t)?e.stylize(""+t,"number"):isBoolean(t)?e.stylize(""+t,"boolean"):isNull(t)?e.stylize("null","null"):void 0}function formatError(e){return"["+Error.prototype.toString.call(e)+"]"}function formatArray(e,t,n,i,a){var s=[];for(var c=0,l=t.length;c<l;++c)hasOwnProperty(t,String(c))?s.push(formatProperty(e,t,n,i,String(c),true)):s.push("");a.forEach((function(a){a.match(/^\d+$/)||s.push(formatProperty(e,t,n,i,a,true))}));return s}function formatProperty(e,t,n,i,a,s){var c,l,u;u=Object.getOwnPropertyDescriptor(t,a)||{value:t[a]};u.get?l=u.set?e.stylize("[Getter/Setter]","special"):e.stylize("[Getter]","special"):u.set&&(l=e.stylize("[Setter]","special"));hasOwnProperty(i,a)||(c="["+a+"]");if(!l)if(e.seen.indexOf(u.value)<0){l=isNull(n)?formatValue(e,u.value,null):formatValue(e,u.value,n-1);l.indexOf("\n")>-1&&(l=s?l.split("\n").map((function(e){return"  "+e})).join("\n").substr(2):"\n"+l.split("\n").map((function(e){return"   "+e})).join("\n"))}else l=e.stylize("[Circular]","special");if(isUndefined(c)){if(s&&a.match(/^\d+$/))return l;c=JSON.stringify(""+a);if(c.match(/^"([a-zA-Z_][a-zA-Z_0-9]*)"$/)){c=c.substr(1,c.length-2);c=e.stylize(c,"name")}else{c=c.replace(/'/g,"\\'").replace(/\\"/g,'"').replace(/(^"|"$)/g,"'");c=e.stylize(c,"string")}}return c+": "+l}function reduceToSingleString(e,t,n){var i=0;var a=e.reduce((function(e,t){i++;t.indexOf("\n")>=0&&i++;return e+t.replace(/\u001b\[\d\d?m/g,"").length+1}),0);return a>60?n[0]+(t===""?"":t+"\n ")+" "+e.join(",\n  ")+" "+n[1]:n[0]+t+" "+e.join(", ")+" "+n[1]}function isArray(e){return Array.isArray(e)}n.isArray=isArray;function isBoolean(e){return typeof e==="boolean"}n.isBoolean=isBoolean;function isNull(e){return e===null}n.isNull=isNull;function isNullOrUndefined(e){return e==null}n.isNullOrUndefined=isNullOrUndefined;function isNumber(e){return typeof e==="number"}n.isNumber=isNumber;function isString(e){return typeof e==="string"}n.isString=isString;function isSymbol(e){return typeof e==="symbol"}n.isSymbol=isSymbol;function isUndefined(e){return e===void 0}n.isUndefined=isUndefined;function isRegExp(e){return isObject(e)&&objectToString(e)==="[object RegExp]"}n.isRegExp=isRegExp;function isObject(e){return typeof e==="object"&&e!==null}n.isObject=isObject;function isDate(e){return isObject(e)&&objectToString(e)==="[object Date]"}n.isDate=isDate;function isError(e){return isObject(e)&&(objectToString(e)==="[object Error]"||e instanceof Error)}n.isError=isError;function isFunction(e){return typeof e==="function"}n.isFunction=isFunction;function isPrimitive(e){return e===null||typeof e==="boolean"||typeof e==="number"||typeof e==="string"||typeof e==="symbol"||typeof e==="undefined"}n.isPrimitive=isPrimitive;n.isBuffer=e("./support/isBuffer");function objectToString(e){return Object.prototype.toString.call(e)}function pad(e){return e<10?"0"+e.toString(10):e.toString(10)}var c=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];function timestamp(){var e=new Date;var t=[pad(e.getHours()),pad(e.getMinutes()),pad(e.getSeconds())].join(":");return[e.getDate(),c[e.getMonth()],t].join(" ")}n.log=function(){console.log("%s - %s",timestamp(),n.format.apply(n,arguments))};
/**
 * Inherit the prototype methods from one constructor into another.
 *
 * The Function.prototype.inherits from lang.js rewritten as a standalone
 * function (not on Function.prototype). NOTE: If this file is to be loaded
 * during bootstrapping this function needs to be rewritten using some native
 * functions as prototype setup using normal JavaScript does not work as
 * expected during bootstrapping (see mirror.js in r114903).
 *
 * @param {function} ctor Constructor function which needs to inherit the
 *     prototype.
 * @param {function} superCtor Constructor function to inherit prototype from.
 */n.inherits=e("inherits");n._extend=function(e,t){if(!t||!isObject(t))return e;var n=Object.keys(t);var i=n.length;while(i--)e[n[i]]=t[n[i]];return e};function hasOwnProperty(e,t){return Object.prototype.hasOwnProperty.call(e,t)}},{"./support/isBuffer":90,inherits:89}],92:[function(e,t,n){
/*!

 diff v7.0.0

BSD 3-Clause License

Copyright (c) 2009-2015, Kevin Decker <kpdecker@gmail.com>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

@license
*/
(function(e,i){typeof n==="object"&&typeof t!=="undefined"?i(n):typeof define==="function"&&define.amd?define(["exports"],i):(e=typeof globalThis!=="undefined"?globalThis:e||self,i(e.Diff={}))})(this,(function(e){function Diff(){}Diff.prototype={diff:function diff(e,t){var n;var i=arguments.length>2&&arguments[2]!==void 0?arguments[2]:{};var a=i.callback;if(typeof i==="function"){a=i;i={}}var s=this;function done(e){e=s.postProcess(e,i);if(a){setTimeout((function(){a(e)}),0);return true}return e}e=this.castInput(e,i);t=this.castInput(t,i);e=this.removeEmpty(this.tokenize(e,i));t=this.removeEmpty(this.tokenize(t,i));var c=t.length,l=e.length;var u=1;var p=c+l;i.maxEditLength!=null&&(p=Math.min(p,i.maxEditLength));var h=(n=i.timeout)!==null&&n!==void 0?n:Infinity;var d=Date.now()+h;var m=[{oldPos:-1,lastComponent:void 0}];var y=this.extractCommon(m[0],t,e,0,i);if(m[0].oldPos+1>=l&&y+1>=c)return done(buildValues(s,m[0].lastComponent,t,e,s.useLongestToken));var g=-Infinity,v=Infinity;function execEditLength(){for(var n=Math.max(g,-u);n<=Math.min(v,u);n+=2){var a=void 0;var p=m[n-1],h=m[n+1];p&&(m[n-1]=void 0);var d=false;if(h){var b=h.oldPos-n;d=h&&0<=b&&b<c}var w=p&&p.oldPos+1<l;if(d||w){a=!w||d&&p.oldPos<h.oldPos?s.addToPath(h,true,false,0,i):s.addToPath(p,false,true,1,i);y=s.extractCommon(a,t,e,n,i);if(a.oldPos+1>=l&&y+1>=c)return done(buildValues(s,a.lastComponent,t,e,s.useLongestToken));m[n]=a;a.oldPos+1>=l&&(v=Math.min(v,n-1));y+1>=c&&(g=Math.max(g,n+1))}else m[n]=void 0}u++}if(a)(function exec(){setTimeout((function(){if(u>p||Date.now()>d)return a();execEditLength()||exec()}),0)})();else while(u<=p&&Date.now()<=d){var b=execEditLength();if(b)return b}},addToPath:function addToPath(e,t,n,i,a){var s=e.lastComponent;return s&&!a.oneChangePerToken&&s.added===t&&s.removed===n?{oldPos:e.oldPos+i,lastComponent:{count:s.count+1,added:t,removed:n,previousComponent:s.previousComponent}}:{oldPos:e.oldPos+i,lastComponent:{count:1,added:t,removed:n,previousComponent:s}}},extractCommon:function extractCommon(e,t,n,i,a){var s=t.length,c=n.length,l=e.oldPos,u=l-i,p=0;while(u+1<s&&l+1<c&&this.equals(n[l+1],t[u+1],a)){u++;l++;p++;a.oneChangePerToken&&(e.lastComponent={count:1,previousComponent:e.lastComponent,added:false,removed:false})}p&&!a.oneChangePerToken&&(e.lastComponent={count:p,previousComponent:e.lastComponent,added:false,removed:false});e.oldPos=l;return u},equals:function equals(e,t,n){return n.comparator?n.comparator(e,t):e===t||n.ignoreCase&&e.toLowerCase()===t.toLowerCase()},removeEmpty:function removeEmpty(e){var t=[];for(var n=0;n<e.length;n++)e[n]&&t.push(e[n]);return t},castInput:function castInput(e){return e},tokenize:function tokenize(e){return Array.from(e)},join:function join(e){return e.join("")},postProcess:function postProcess(e){return e}};function buildValues(e,t,n,i,a){var s=[];var c;while(t){s.push(t);c=t.previousComponent;delete t.previousComponent;t=c}s.reverse();var l=0,u=s.length,p=0,h=0;for(;l<u;l++){var d=s[l];if(d.removed){d.value=e.join(i.slice(h,h+d.count));h+=d.count}else{if(!d.added&&a){var m=n.slice(p,p+d.count);m=m.map((function(e,t){var n=i[h+t];return n.length>e.length?n:e}));d.value=e.join(m)}else d.value=e.join(n.slice(p,p+d.count));p+=d.count;d.added||(h+=d.count)}}return s}var t=new Diff;function diffChars(e,n,i){return t.diff(e,n,i)}function longestCommonPrefix(e,t){var n;for(n=0;n<e.length&&n<t.length;n++)if(e[n]!=t[n])return e.slice(0,n);return e.slice(0,n)}function longestCommonSuffix(e,t){var n;if(!e||!t||e[e.length-1]!=t[t.length-1])return"";for(n=0;n<e.length&&n<t.length;n++)if(e[e.length-(n+1)]!=t[t.length-(n+1)])return e.slice(-n);return e.slice(-n)}function replacePrefix(e,t,n){if(e.slice(0,t.length)!=t)throw Error("string ".concat(JSON.stringify(e)," doesn't start with prefix ").concat(JSON.stringify(t),"; this is a bug"));return n+e.slice(t.length)}function replaceSuffix(e,t,n){if(!t)return e+n;if(e.slice(-t.length)!=t)throw Error("string ".concat(JSON.stringify(e)," doesn't end with suffix ").concat(JSON.stringify(t),"; this is a bug"));return e.slice(0,-t.length)+n}function removePrefix(e,t){return replacePrefix(e,t,"")}function removeSuffix(e,t){return replaceSuffix(e,t,"")}function maximumOverlap(e,t){return t.slice(0,overlapCount(e,t))}function overlapCount(e,t){var n=0;e.length>t.length&&(n=e.length-t.length);var i=t.length;e.length<t.length&&(i=e.length);var a=Array(i);var s=0;a[0]=0;for(var c=1;c<i;c++){t[c]==t[s]?a[c]=a[s]:a[c]=s;while(s>0&&t[c]!=t[s])s=a[s];t[c]==t[s]&&s++}s=0;for(var l=n;l<e.length;l++){while(s>0&&e[l]!=t[s])s=a[s];e[l]==t[s]&&s++}return s}function hasOnlyWinLineEndings(e){return e.includes("\r\n")&&!e.startsWith("\n")&&!e.match(/[^\r]\n/)}function hasOnlyUnixLineEndings(e){return!e.includes("\r\n")&&e.includes("\n")}var n="a-zA-Z0-9_\\u{C0}-\\u{FF}\\u{D8}-\\u{F6}\\u{F8}-\\u{2C6}\\u{2C8}-\\u{2D7}\\u{2DE}-\\u{2FF}\\u{1E00}-\\u{1EFF}";var i=new RegExp("[".concat(n,"]+|\\s+|[^").concat(n,"]"),"ug");var a=new Diff;a.equals=function(e,t,n){if(n.ignoreCase){e=e.toLowerCase();t=t.toLowerCase()}return e.trim()===t.trim()};a.tokenize=function(e){var t=arguments.length>1&&arguments[1]!==void 0?arguments[1]:{};var n;if(t.intlSegmenter){if(t.intlSegmenter.resolvedOptions().granularity!="word")throw new Error('The segmenter passed must have a granularity of "word"');n=Array.from(t.intlSegmenter.segment(e),(function(e){return e.segment}))}else n=e.match(i)||[];var a=[];var s=null;n.forEach((function(e){/\s/.test(e)?s==null?a.push(e):a.push(a.pop()+e):/\s/.test(s)?a[a.length-1]==s?a.push(a.pop()+e):a.push(s+e):a.push(e);s=e}));return a};a.join=function(e){return e.map((function(e,t){return t==0?e:e.replace(/^\s+/,"")})).join("")};a.postProcess=function(e,t){if(!e||t.oneChangePerToken)return e;var n=null;var i=null;var a=null;e.forEach((function(e){if(e.added)i=e;else if(e.removed)a=e;else{(i||a)&&dedupeWhitespaceInChangeObjects(n,a,i,e);n=e;i=null;a=null}}));(i||a)&&dedupeWhitespaceInChangeObjects(n,a,i,null);return e};function diffWords(e,t,n){return(n===null||n===void 0?void 0:n.ignoreWhitespace)==null||n.ignoreWhitespace?a.diff(e,t,n):diffWordsWithSpace(e,t,n)}function dedupeWhitespaceInChangeObjects(e,t,n,i){if(t&&n){var a=t.value.match(/^\s*/)[0];var s=t.value.match(/\s*$/)[0];var c=n.value.match(/^\s*/)[0];var l=n.value.match(/\s*$/)[0];if(e){var u=longestCommonPrefix(a,c);e.value=replaceSuffix(e.value,c,u);t.value=removePrefix(t.value,u);n.value=removePrefix(n.value,u)}if(i){var p=longestCommonSuffix(s,l);i.value=replacePrefix(i.value,l,p);t.value=removeSuffix(t.value,p);n.value=removeSuffix(n.value,p)}}else if(n){e&&(n.value=n.value.replace(/^\s*/,""));i&&(i.value=i.value.replace(/^\s*/,""))}else if(e&&i){var h=i.value.match(/^\s*/)[0],d=t.value.match(/^\s*/)[0],m=t.value.match(/\s*$/)[0];var y=longestCommonPrefix(h,d);t.value=removePrefix(t.value,y);var g=longestCommonSuffix(removePrefix(h,y),m);t.value=removeSuffix(t.value,g);i.value=replacePrefix(i.value,h,g);e.value=replaceSuffix(e.value,h,h.slice(0,h.length-g.length))}else if(i){var v=i.value.match(/^\s*/)[0];var b=t.value.match(/\s*$/)[0];var w=maximumOverlap(b,v);t.value=removeSuffix(t.value,w)}else if(e){var x=e.value.match(/\s*$/)[0];var k=t.value.match(/^\s*/)[0];var j=maximumOverlap(x,k);t.value=removePrefix(t.value,j)}}var s=new Diff;s.tokenize=function(e){var t=new RegExp("(\\r?\\n)|[".concat(n,"]+|[^\\S\\n\\r]+|[^").concat(n,"]"),"ug");return e.match(t)||[]};function diffWordsWithSpace(e,t,n){return s.diff(e,t,n)}function generateOptions(e,t){if(typeof e==="function")t.callback=e;else if(e)for(var n in e)e.hasOwnProperty(n)&&(t[n]=e[n]);return t}var c=new Diff;c.tokenize=function(e,t){t.stripTrailingCr&&(e=e.replace(/\r\n/g,"\n"));var n=[],i=e.split(/(\n|\r\n)/);i[i.length-1]||i.pop();for(var a=0;a<i.length;a++){var s=i[a];a%2&&!t.newlineIsToken?n[n.length-1]+=s:n.push(s)}return n};c.equals=function(e,t,n){if(n.ignoreWhitespace){n.newlineIsToken&&e.includes("\n")||(e=e.trim());n.newlineIsToken&&t.includes("\n")||(t=t.trim())}else if(n.ignoreNewlineAtEof&&!n.newlineIsToken){e.endsWith("\n")&&(e=e.slice(0,-1));t.endsWith("\n")&&(t=t.slice(0,-1))}return Diff.prototype.equals.call(this,e,t,n)};function diffLines(e,t,n){return c.diff(e,t,n)}function diffTrimmedLines(e,t,n){var i=generateOptions(n,{ignoreWhitespace:true});return c.diff(e,t,i)}var l=new Diff;l.tokenize=function(e){return e.split(/(\S.+?[.!?])(?=\s+|$)/)};function diffSentences(e,t,n){return l.diff(e,t,n)}var u=new Diff;u.tokenize=function(e){return e.split(/([{}:;,]|\s+)/)};function diffCss(e,t,n){return u.diff(e,t,n)}function ownKeys(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);t&&(i=i.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,i)}return n}function _objectSpread2(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?ownKeys(Object(n),!0).forEach((function(t){_defineProperty(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):ownKeys(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function _toPrimitive(e,t){if("object"!=typeof e||!e)return e;var n=e[Symbol.toPrimitive];if(void 0!==n){var i=n.call(e,t||"default");if("object"!=typeof i)return i;throw new TypeError("@@toPrimitive must return a primitive value.")}return("string"===t?String:Number)(e)}function _toPropertyKey(e){var t=_toPrimitive(e,"string");return"symbol"==typeof t?t:t+""}function _typeof(e){return _typeof="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(e){return typeof e}:function(e){return e&&"function"==typeof Symbol&&e.constructor===Symbol&&e!==Symbol.prototype?"symbol":typeof e},_typeof(e)}function _defineProperty(e,t,n){t=_toPropertyKey(t);t in e?Object.defineProperty(e,t,{value:n,enumerable:true,configurable:true,writable:true}):e[t]=n;return e}function _toConsumableArray(e){return _arrayWithoutHoles(e)||_iterableToArray(e)||_unsupportedIterableToArray(e)||_nonIterableSpread()}function _arrayWithoutHoles(e){if(Array.isArray(e))return _arrayLikeToArray(e)}function _iterableToArray(e){if(typeof Symbol!=="undefined"&&e[Symbol.iterator]!=null||e["@@iterator"]!=null)return Array.from(e)}function _unsupportedIterableToArray(e,t){if(e){if(typeof e==="string")return _arrayLikeToArray(e,t);var n=Object.prototype.toString.call(e).slice(8,-1);n==="Object"&&e.constructor&&(n=e.constructor.name);return n==="Map"||n==="Set"?Array.from(e):n==="Arguments"||/^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)?_arrayLikeToArray(e,t):void 0}}function _arrayLikeToArray(e,t){(t==null||t>e.length)&&(t=e.length);for(var n=0,i=new Array(t);n<t;n++)i[n]=e[n];return i}function _nonIterableSpread(){throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")}var p=new Diff;p.useLongestToken=true;p.tokenize=c.tokenize;p.castInput=function(e,t){var n=t.undefinedReplacement,i=t.stringifyReplacer,a=i===void 0?function(e,t){return typeof t==="undefined"?n:t}:i;return typeof e==="string"?e:JSON.stringify(canonicalize(e,null,null,a),a,"  ")};p.equals=function(e,t,n){return Diff.prototype.equals.call(p,e.replace(/,([\r\n])/g,"$1"),t.replace(/,([\r\n])/g,"$1"),n)};function diffJson(e,t,n){return p.diff(e,t,n)}function canonicalize(e,t,n,i,a){t=t||[];n=n||[];i&&(e=i(a,e));var s;for(s=0;s<t.length;s+=1)if(t[s]===e)return n[s];var c;if("[object Array]"===Object.prototype.toString.call(e)){t.push(e);c=new Array(e.length);n.push(c);for(s=0;s<e.length;s+=1)c[s]=canonicalize(e[s],t,n,i,a);t.pop();n.pop();return c}e&&e.toJSON&&(e=e.toJSON());if(_typeof(e)==="object"&&e!==null){t.push(e);c={};n.push(c);var l,u=[];for(l in e)Object.prototype.hasOwnProperty.call(e,l)&&u.push(l);u.sort();for(s=0;s<u.length;s+=1){l=u[s];c[l]=canonicalize(e[l],t,n,i,l)}t.pop();n.pop()}else c=e;return c}var h=new Diff;h.tokenize=function(e){return e.slice()};h.join=h.removeEmpty=function(e){return e};function diffArrays(e,t,n){return h.diff(e,t,n)}function unixToWin(e){return Array.isArray(e)?e.map(unixToWin):_objectSpread2(_objectSpread2({},e),{},{hunks:e.hunks.map((function(e){return _objectSpread2(_objectSpread2({},e),{},{lines:e.lines.map((function(t,n){var i;return t.startsWith("\\")||t.endsWith("\r")||(i=e.lines[n+1])!==null&&i!==void 0&&i.startsWith("\\")?t:t+"\r"}))})}))})}function winToUnix(e){return Array.isArray(e)?e.map(winToUnix):_objectSpread2(_objectSpread2({},e),{},{hunks:e.hunks.map((function(e){return _objectSpread2(_objectSpread2({},e),{},{lines:e.lines.map((function(e){return e.endsWith("\r")?e.substring(0,e.length-1):e}))})}))})}function isUnix(e){Array.isArray(e)||(e=[e]);return!e.some((function(e){return e.hunks.some((function(e){return e.lines.some((function(e){return!e.startsWith("\\")&&e.endsWith("\r")}))}))}))}function isWin(e){Array.isArray(e)||(e=[e]);return e.some((function(e){return e.hunks.some((function(e){return e.lines.some((function(e){return e.endsWith("\r")}))}))}))&&e.every((function(e){return e.hunks.every((function(e){return e.lines.every((function(t,n){var i;return t.startsWith("\\")||t.endsWith("\r")||((i=e.lines[n+1])===null||i===void 0?void 0:i.startsWith("\\"))}))}))}))}function parsePatch(e){var t=e.split(/\n/),n=[],i=0;function parseIndex(){var e={};n.push(e);while(i<t.length){var a=t[i];if(/^(\-\-\-|\+\+\+|@@)\s/.test(a))break;var s=/^(?:Index:|diff(?: -r \w+)+)\s+(.+?)\s*$/.exec(a);s&&(e.index=s[1]);i++}parseFileHeader(e);parseFileHeader(e);e.hunks=[];while(i<t.length){var c=t[i];if(/^(Index:\s|diff\s|\-\-\-\s|\+\+\+\s|===================================================================)/.test(c))break;if(/^@@/.test(c))e.hunks.push(parseHunk());else{if(c)throw new Error("Unknown line "+(i+1)+" "+JSON.stringify(c));i++}}}function parseFileHeader(e){var n=/^(---|\+\+\+)\s+(.*)\r?$/.exec(t[i]);if(n){var a=n[1]==="---"?"old":"new";var s=n[2].split("\t",2);var c=s[0].replace(/\\\\/g,"\\");/^".*"$/.test(c)&&(c=c.substr(1,c.length-2));e[a+"FileName"]=c;e[a+"Header"]=(s[1]||"").trim();i++}}function parseHunk(){var e=i,n=t[i++],a=n.split(/@@ -(\d+)(?:,(\d+))? \+(\d+)(?:,(\d+))? @@/);var s={oldStart:+a[1],oldLines:typeof a[2]==="undefined"?1:+a[2],newStart:+a[3],newLines:typeof a[4]==="undefined"?1:+a[4],lines:[]};s.oldLines===0&&(s.oldStart+=1);s.newLines===0&&(s.newStart+=1);var c=0,l=0;for(;i<t.length&&(l<s.oldLines||c<s.newLines||(u=t[i])!==null&&u!==void 0&&u.startsWith("\\"));i++){var u;var p=t[i].length==0&&i!=t.length-1?" ":t[i][0];if(p!=="+"&&p!=="-"&&p!==" "&&p!=="\\")throw new Error("Hunk at line ".concat(e+1," contained invalid line ").concat(t[i]));s.lines.push(t[i]);if(p==="+")c++;else if(p==="-")l++;else if(p===" "){c++;l++}}c||s.newLines!==1||(s.newLines=0);l||s.oldLines!==1||(s.oldLines=0);if(c!==s.newLines)throw new Error("Added line count did not match for hunk at line "+(e+1));if(l!==s.oldLines)throw new Error("Removed line count did not match for hunk at line "+(e+1));return s}while(i<t.length)parseIndex();return n}function distanceIterator(e,t,n){var i=true,a=false,s=false,c=1;return function iterator(){if(i&&!s){a?c++:i=false;if(e+c<=n)return e+c;s=true}if(!a){s||(i=true);if(t<=e-c)return e-c++;a=true;return iterator()}}}function applyPatch(e,t){var n=arguments.length>2&&arguments[2]!==void 0?arguments[2]:{};typeof t==="string"&&(t=parsePatch(t));if(Array.isArray(t)){if(t.length>1)throw new Error("applyPatch only works with a single input.");t=t[0]}(n.autoConvertLineEndings||n.autoConvertLineEndings==null)&&(hasOnlyWinLineEndings(e)&&isUnix(t)?t=unixToWin(t):hasOnlyUnixLineEndings(e)&&isWin(t)&&(t=winToUnix(t)));var i=e.split("\n"),a=t.hunks,s=n.compareLine||function(e,t,n,i){return t===i},c=n.fuzzFactor||0,l=0;if(c<0||!Number.isInteger(c))throw new Error("fuzzFactor must be a non-negative integer");if(!a.length)return e;var u="",p=false,h=false;for(var d=0;d<a[a.length-1].lines.length;d++){var m=a[a.length-1].lines[d];m[0]=="\\"&&(u[0]=="+"?p=true:u[0]=="-"&&(h=true));u=m}if(p){if(h){if(!c&&i[i.length-1]=="")return false}else if(i[i.length-1]=="")i.pop();else if(!c)return false}else if(h)if(i[i.length-1]!="")i.push("");else if(!c)return false;function applyHunk(e,t,n){var a=arguments.length>3&&arguments[3]!==void 0?arguments[3]:0;var c=!(arguments.length>4&&arguments[4]!==void 0)||arguments[4];var l=arguments.length>5&&arguments[5]!==void 0?arguments[5]:[];var u=arguments.length>6&&arguments[6]!==void 0?arguments[6]:0;var p=0;var h=false;for(;a<e.length;a++){var d=e[a],m=d.length>0?d[0]:" ",y=d.length>0?d.substr(1):d;if(m==="-"){if(!s(t+1,i[t],m,y)){if(!n||i[t]==null)return null;l[u]=i[t];return applyHunk(e,t+1,n-1,a,false,l,u+1)}t++;p=0}if(m==="+"){if(!c)return null;l[u]=y;u++;p=0;h=true}if(m===" "){p++;l[u]=i[t];if(!s(t+1,i[t],m,y))return h||!n?null:i[t]&&(applyHunk(e,t+1,n-1,a+1,false,l,u+1)||applyHunk(e,t+1,n-1,a,false,l,u+1))||applyHunk(e,t,n-1,a+1,false,l,u);u++;c=true;h=false;t++}}u-=p;t-=p;l.length=u;return{patchedLines:l,oldLineLastI:t-1}}var y=[];var g=0;for(var v=0;v<a.length;v++){var b=a[v];var w=void 0;var x=i.length-b.oldLines+c;var k=void 0;for(var j=0;j<=c;j++){k=b.oldStart+g-1;var C=distanceIterator(k,l,x);for(;k!==void 0;k=C()){w=applyHunk(b.lines,k,j);if(w)break}if(w)break}if(!w)return false;for(var T=l;T<k;T++)y.push(i[T]);for(var A=0;A<w.patchedLines.length;A++){var S=w.patchedLines[A];y.push(S)}l=w.oldLineLastI+1;g=k+1-b.oldStart}for(var O=l;O<i.length;O++)y.push(i[O]);return y.join("\n")}function applyPatches(e,t){typeof e==="string"&&(e=parsePatch(e));var n=0;function processIndex(){var i=e[n++];if(!i)return t.complete();t.loadFile(i,(function(e,n){if(e)return t.complete(e);var a=applyPatch(n,i,t);t.patched(i,a,(function(e){if(e)return t.complete(e);processIndex()}))}))}processIndex()}function structuredPatch(e,t,n,i,a,s,c){c||(c={});typeof c==="function"&&(c={callback:c});typeof c.context==="undefined"&&(c.context=4);if(c.newlineIsToken)throw new Error("newlineIsToken may not be used with patch-generation functions, only with diffing functions");if(!c.callback)return diffLinesResultToPatch(diffLines(n,i,c));var l=c,u=l.callback;diffLines(n,i,_objectSpread2(_objectSpread2({},c),{},{callback:function callback(e){var t=diffLinesResultToPatch(e);u(t)}}));function diffLinesResultToPatch(n){if(n){n.push({value:"",lines:[]});var i=[];var l=0,u=0,p=[],h=1,d=1;var m=function _loop(){var e=n[y],t=e.lines||splitLines(e.value);e.lines=t;if(e.added||e.removed){var a;if(!l){var s=n[y-1];l=h;u=d;if(s){p=c.context>0?contextLines(s.lines.slice(-c.context)):[];l-=p.length;u-=p.length}}(a=p).push.apply(a,_toConsumableArray(t.map((function(t){return(e.added?"+":"-")+t}))));e.added?d+=t.length:h+=t.length}else{if(l)if(t.length<=c.context*2&&y<n.length-2){var m;(m=p).push.apply(m,_toConsumableArray(contextLines(t)))}else{var g;var v=Math.min(t.length,c.context);(g=p).push.apply(g,_toConsumableArray(contextLines(t.slice(0,v))));var b={oldStart:l,oldLines:h-l+v,newStart:u,newLines:d-u+v,lines:p};i.push(b);l=0;u=0;p=[]}h+=t.length;d+=t.length}};for(var y=0;y<n.length;y++)m();for(var g=0,v=i;g<v.length;g++){var b=v[g];for(var w=0;w<b.lines.length;w++)if(b.lines[w].endsWith("\n"))b.lines[w]=b.lines[w].slice(0,-1);else{b.lines.splice(w+1,0,"\\ No newline at end of file");w++}}return{oldFileName:e,newFileName:t,oldHeader:a,newHeader:s,hunks:i}}function contextLines(e){return e.map((function(e){return" "+e}))}}}function formatPatch(e){if(Array.isArray(e))return e.map(formatPatch).join("\n");var t=[];e.oldFileName==e.newFileName&&t.push("Index: "+e.oldFileName);t.push("===================================================================");t.push("--- "+e.oldFileName+(typeof e.oldHeader==="undefined"?"":"\t"+e.oldHeader));t.push("+++ "+e.newFileName+(typeof e.newHeader==="undefined"?"":"\t"+e.newHeader));for(var n=0;n<e.hunks.length;n++){var i=e.hunks[n];i.oldLines===0&&(i.oldStart-=1);i.newLines===0&&(i.newStart-=1);t.push("@@ -"+i.oldStart+","+i.oldLines+" +"+i.newStart+","+i.newLines+" @@");t.push.apply(t,i.lines)}return t.join("\n")+"\n"}function createTwoFilesPatch(e,t,n,i,a,s,c){var l;typeof c==="function"&&(c={callback:c});if((l=c)===null||l===void 0||!l.callback){var u=structuredPatch(e,t,n,i,a,s,c);if(!u)return;return formatPatch(u)}var p=c,h=p.callback;structuredPatch(e,t,n,i,a,s,_objectSpread2(_objectSpread2({},c),{},{callback:function callback(e){e?h(formatPatch(e)):h()}}))}function createPatch(e,t,n,i,a,s){return createTwoFilesPatch(e,e,t,n,i,a,s)}function splitLines(e){var t=e.endsWith("\n");var n=e.split("\n").map((function(e){return e+"\n"}));t?n.pop():n.push(n.pop().slice(0,-1));return n}function arrayEqual(e,t){return e.length===t.length&&arrayStartsWith(e,t)}function arrayStartsWith(e,t){if(t.length>e.length)return false;for(var n=0;n<t.length;n++)if(t[n]!==e[n])return false;return true}function calcLineCount(e){var t=calcOldNewLineCount(e.lines),n=t.oldLines,i=t.newLines;n!==void 0?e.oldLines=n:delete e.oldLines;i!==void 0?e.newLines=i:delete e.newLines}function merge(e,t,n){e=loadPatch(e,n);t=loadPatch(t,n);var i={};(e.index||t.index)&&(i.index=e.index||t.index);if(e.newFileName||t.newFileName)if(fileNameChanged(e))if(fileNameChanged(t)){i.oldFileName=selectField(i,e.oldFileName,t.oldFileName);i.newFileName=selectField(i,e.newFileName,t.newFileName);i.oldHeader=selectField(i,e.oldHeader,t.oldHeader);i.newHeader=selectField(i,e.newHeader,t.newHeader)}else{i.oldFileName=e.oldFileName;i.newFileName=e.newFileName;i.oldHeader=e.oldHeader;i.newHeader=e.newHeader}else{i.oldFileName=t.oldFileName||e.oldFileName;i.newFileName=t.newFileName||e.newFileName;i.oldHeader=t.oldHeader||e.oldHeader;i.newHeader=t.newHeader||e.newHeader}i.hunks=[];var a=0,s=0,c=0,l=0;while(a<e.hunks.length||s<t.hunks.length){var u=e.hunks[a]||{oldStart:Infinity},p=t.hunks[s]||{oldStart:Infinity};if(hunkBefore(u,p)){i.hunks.push(cloneHunk(u,c));a++;l+=u.newLines-u.oldLines}else if(hunkBefore(p,u)){i.hunks.push(cloneHunk(p,l));s++;c+=p.newLines-p.oldLines}else{var h={oldStart:Math.min(u.oldStart,p.oldStart),oldLines:0,newStart:Math.min(u.newStart+c,p.oldStart+l),newLines:0,lines:[]};mergeLines(h,u.oldStart,u.lines,p.oldStart,p.lines);s++;a++;i.hunks.push(h)}}return i}function loadPatch(e,t){if(typeof e==="string"){if(/^@@/m.test(e)||/^Index:/m.test(e))return parsePatch(e)[0];if(!t)throw new Error("Must provide a base reference or pass in a patch");return structuredPatch(void 0,void 0,t,e)}return e}function fileNameChanged(e){return e.newFileName&&e.newFileName!==e.oldFileName}function selectField(e,t,n){if(t===n)return t;e.conflict=true;return{mine:t,theirs:n}}function hunkBefore(e,t){return e.oldStart<t.oldStart&&e.oldStart+e.oldLines<t.oldStart}function cloneHunk(e,t){return{oldStart:e.oldStart,oldLines:e.oldLines,newStart:e.newStart+t,newLines:e.newLines,lines:e.lines}}function mergeLines(e,t,n,i,a){var s={offset:t,lines:n,index:0},c={offset:i,lines:a,index:0};insertLeading(e,s,c);insertLeading(e,c,s);while(s.index<s.lines.length&&c.index<c.lines.length){var l=s.lines[s.index],u=c.lines[c.index];if(l[0]!=="-"&&l[0]!=="+"||u[0]!=="-"&&u[0]!=="+")if(l[0]==="+"&&u[0]===" "){var p;(p=e.lines).push.apply(p,_toConsumableArray(collectChange(s)))}else if(u[0]==="+"&&l[0]===" "){var h;(h=e.lines).push.apply(h,_toConsumableArray(collectChange(c)))}else if(l[0]==="-"&&u[0]===" ")removal(e,s,c);else if(u[0]==="-"&&l[0]===" ")removal(e,c,s,true);else if(l===u){e.lines.push(l);s.index++;c.index++}else conflict(e,collectChange(s),collectChange(c));else mutualChange(e,s,c)}insertTrailing(e,s);insertTrailing(e,c);calcLineCount(e)}function mutualChange(e,t,n){var i=collectChange(t),a=collectChange(n);if(allRemoves(i)&&allRemoves(a)){if(arrayStartsWith(i,a)&&skipRemoveSuperset(n,i,i.length-a.length)){var s;(s=e.lines).push.apply(s,_toConsumableArray(i));return}if(arrayStartsWith(a,i)&&skipRemoveSuperset(t,a,a.length-i.length)){var c;(c=e.lines).push.apply(c,_toConsumableArray(a));return}}else if(arrayEqual(i,a)){var l;(l=e.lines).push.apply(l,_toConsumableArray(i));return}conflict(e,i,a)}function removal(e,t,n,i){var a=collectChange(t),s=collectContext(n,a);if(s.merged){var c;(c=e.lines).push.apply(c,_toConsumableArray(s.merged))}else conflict(e,i?s:a,i?a:s)}function conflict(e,t,n){e.conflict=true;e.lines.push({conflict:true,mine:t,theirs:n})}function insertLeading(e,t,n){while(t.offset<n.offset&&t.index<t.lines.length){var i=t.lines[t.index++];e.lines.push(i);t.offset++}}function insertTrailing(e,t){while(t.index<t.lines.length){var n=t.lines[t.index++];e.lines.push(n)}}function collectChange(e){var t=[],n=e.lines[e.index][0];while(e.index<e.lines.length){var i=e.lines[e.index];n==="-"&&i[0]==="+"&&(n="+");if(n!==i[0])break;t.push(i);e.index++}return t}function collectContext(e,t){var n=[],i=[],a=0,s=false,c=false;while(a<t.length&&e.index<e.lines.length){var l=e.lines[e.index],u=t[a];if(u[0]==="+")break;s=s||l[0]!==" ";i.push(u);a++;if(l[0]==="+"){c=true;while(l[0]==="+"){n.push(l);l=e.lines[++e.index]}}if(u.substr(1)===l.substr(1)){n.push(l);e.index++}else c=true}(t[a]||"")[0]==="+"&&s&&(c=true);if(c)return n;while(a<t.length)i.push(t[a++]);return{merged:i,changes:n}}function allRemoves(e){return e.reduce((function(e,t){return e&&t[0]==="-"}),true)}function skipRemoveSuperset(e,t,n){for(var i=0;i<n;i++){var a=t[t.length-n+i].substr(1);if(e.lines[e.index+i]!==" "+a)return false}e.index+=n;return true}function calcOldNewLineCount(e){var t=0;var n=0;e.forEach((function(e){if(typeof e!=="string"){var i=calcOldNewLineCount(e.mine);var a=calcOldNewLineCount(e.theirs);t!==void 0&&(i.oldLines===a.oldLines?t+=i.oldLines:t=void 0);n!==void 0&&(i.newLines===a.newLines?n+=i.newLines:n=void 0)}else{n===void 0||e[0]!=="+"&&e[0]!==" "||n++;t===void 0||e[0]!=="-"&&e[0]!==" "||t++}}));return{oldLines:t,newLines:n}}function reversePatch(e){return Array.isArray(e)?e.map(reversePatch).reverse():_objectSpread2(_objectSpread2({},e),{},{oldFileName:e.newFileName,oldHeader:e.newHeader,newFileName:e.oldFileName,newHeader:e.oldHeader,hunks:e.hunks.map((function(e){return{oldLines:e.newLines,oldStart:e.newStart,newLines:e.oldLines,newStart:e.oldStart,lines:e.lines.map((function(e){return e.startsWith("-")?"+".concat(e.slice(1)):e.startsWith("+")?"-".concat(e.slice(1)):e}))}}))})}function convertChangesToDMP(e){var t,n,i=[];for(var a=0;a<e.length;a++){t=e[a];n=t.added?1:t.removed?-1:0;i.push([n,t.value])}return i}function convertChangesToXML(e){var t=[];for(var n=0;n<e.length;n++){var i=e[n];i.added?t.push("<ins>"):i.removed&&t.push("<del>");t.push(escapeHTML(i.value));i.added?t.push("</ins>"):i.removed&&t.push("</del>")}return t.join("")}function escapeHTML(e){var t=e;t=t.replace(/&/g,"&amp;");t=t.replace(/</g,"&lt;");t=t.replace(/>/g,"&gt;");t=t.replace(/"/g,"&quot;");return t}e.Diff=Diff;e.applyPatch=applyPatch;e.applyPatches=applyPatches;e.canonicalize=canonicalize;e.convertChangesToDMP=convertChangesToDMP;e.convertChangesToXML=convertChangesToXML;e.createPatch=createPatch;e.createTwoFilesPatch=createTwoFilesPatch;e.diffArrays=diffArrays;e.diffChars=diffChars;e.diffCss=diffCss;e.diffJson=diffJson;e.diffLines=diffLines;e.diffSentences=diffSentences;e.diffTrimmedLines=diffTrimmedLines;e.diffWords=diffWords;e.diffWordsWithSpace=diffWordsWithSpace;e.formatPatch=formatPatch;e.merge=merge;e.parsePatch=parsePatch;e.reversePatch=reversePatch;e.structuredPatch=structuredPatch}))},{}],93:[function(e,t,n){var i="Expected a function";var a="__lodash_hash_undefined__";var s=1/0;var c="[object Function]",l="[object GeneratorFunction]",u="[object Symbol]";var p=/\.|\[(?:[^[\]]*|(["'])(?:(?!\1)[^\\]|\\.)*?\1)\]/,h=/^\w*$/,d=/^\./,m=/[^.[\]]+|\[(?:(-?\d+(?:\.\d+)?)|(["'])((?:(?!\2)[^\\]|\\.)*?)\2)\]|(?=(?:\.|\[\])(?:\.|\[\]|$))/g;var y=/[\\^$.*+?()[\]{}|]/g;var g=/\\(\\)?/g;var v=/^\[object .+?Constructor\]$/;var b=typeof global=="object"&&global&&global.Object===Object&&global;var w=typeof self=="object"&&self&&self.Object===Object&&self;var x=b||w||Function("return this")();
/**
 * Gets the value at `key` of `object`.
 *
 * @private
 * @param {Object} [object] The object to query.
 * @param {string} key The key of the property to get.
 * @returns {*} Returns the property value.
 */function getValue(e,t){return e==null?void 0:e[t]}
/**
 * Checks if `value` is a host object in IE < 9.
 *
 * @private
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is a host object, else `false`.
 */function isHostObject(e){var t=false;if(e!=null&&typeof e.toString!="function")try{t=!!(e+"")}catch(e){}return t}var k=Array.prototype,j=Function.prototype,C=Object.prototype;var T=x["__core-js_shared__"];var A=function(){var e=/[^.]+$/.exec(T&&T.keys&&T.keys.IE_PROTO||"");return e?"Symbol(src)_1."+e:""}();var S=j.toString;var O=C.hasOwnProperty;var E=C.toString;var P=RegExp("^"+S.call(O).replace(y,"\\$&").replace(/hasOwnProperty|(function).*?(?=\\\()| for .+?(?=\\\])/g,"$1.*?")+"$");var M=x.Symbol,I=k.splice;var L=getNative(x,"Map"),$=getNative(Object,"create");var F=M?M.prototype:void 0,N=F?F.toString:void 0;
/**
 * Creates a hash object.
 *
 * @private
 * @constructor
 * @param {Array} [entries] The key-value pairs to cache.
 */function Hash(e){var t=-1,n=e?e.length:0;this.clear();while(++t<n){var i=e[t];this.set(i[0],i[1])}}function hashClear(){this.__data__=$?$(null):{}}
/**
 * Removes `key` and its value from the hash.
 *
 * @private
 * @name delete
 * @memberOf Hash
 * @param {Object} hash The hash to modify.
 * @param {string} key The key of the value to remove.
 * @returns {boolean} Returns `true` if the entry was removed, else `false`.
 */function hashDelete(e){return this.has(e)&&delete this.__data__[e]}
/**
 * Gets the hash value for `key`.
 *
 * @private
 * @name get
 * @memberOf Hash
 * @param {string} key The key of the value to get.
 * @returns {*} Returns the entry value.
 */function hashGet(e){var t=this.__data__;if($){var n=t[e];return n===a?void 0:n}return O.call(t,e)?t[e]:void 0}
/**
 * Checks if a hash value for `key` exists.
 *
 * @private
 * @name has
 * @memberOf Hash
 * @param {string} key The key of the entry to check.
 * @returns {boolean} Returns `true` if an entry for `key` exists, else `false`.
 */function hashHas(e){var t=this.__data__;return $?t[e]!==void 0:O.call(t,e)}
/**
 * Sets the hash `key` to `value`.
 *
 * @private
 * @name set
 * @memberOf Hash
 * @param {string} key The key of the value to set.
 * @param {*} value The value to set.
 * @returns {Object} Returns the hash instance.
 */function hashSet(e,t){var n=this.__data__;n[e]=$&&t===void 0?a:t;return this}Hash.prototype.clear=hashClear;Hash.prototype.delete=hashDelete;Hash.prototype.get=hashGet;Hash.prototype.has=hashHas;Hash.prototype.set=hashSet;
/**
 * Creates an list cache object.
 *
 * @private
 * @constructor
 * @param {Array} [entries] The key-value pairs to cache.
 */function ListCache(e){var t=-1,n=e?e.length:0;this.clear();while(++t<n){var i=e[t];this.set(i[0],i[1])}}function listCacheClear(){this.__data__=[]}
/**
 * Removes `key` and its value from the list cache.
 *
 * @private
 * @name delete
 * @memberOf ListCache
 * @param {string} key The key of the value to remove.
 * @returns {boolean} Returns `true` if the entry was removed, else `false`.
 */function listCacheDelete(e){var t=this.__data__,n=assocIndexOf(t,e);if(n<0)return false;var i=t.length-1;n==i?t.pop():I.call(t,n,1);return true}
/**
 * Gets the list cache value for `key`.
 *
 * @private
 * @name get
 * @memberOf ListCache
 * @param {string} key The key of the value to get.
 * @returns {*} Returns the entry value.
 */function listCacheGet(e){var t=this.__data__,n=assocIndexOf(t,e);return n<0?void 0:t[n][1]}
/**
 * Checks if a list cache value for `key` exists.
 *
 * @private
 * @name has
 * @memberOf ListCache
 * @param {string} key The key of the entry to check.
 * @returns {boolean} Returns `true` if an entry for `key` exists, else `false`.
 */function listCacheHas(e){return assocIndexOf(this.__data__,e)>-1}
/**
 * Sets the list cache `key` to `value`.
 *
 * @private
 * @name set
 * @memberOf ListCache
 * @param {string} key The key of the value to set.
 * @param {*} value The value to set.
 * @returns {Object} Returns the list cache instance.
 */function listCacheSet(e,t){var n=this.__data__,i=assocIndexOf(n,e);i<0?n.push([e,t]):n[i][1]=t;return this}ListCache.prototype.clear=listCacheClear;ListCache.prototype.delete=listCacheDelete;ListCache.prototype.get=listCacheGet;ListCache.prototype.has=listCacheHas;ListCache.prototype.set=listCacheSet;
/**
 * Creates a map cache object to store key-value pairs.
 *
 * @private
 * @constructor
 * @param {Array} [entries] The key-value pairs to cache.
 */function MapCache(e){var t=-1,n=e?e.length:0;this.clear();while(++t<n){var i=e[t];this.set(i[0],i[1])}}function mapCacheClear(){this.__data__={hash:new Hash,map:new(L||ListCache),string:new Hash}}
/**
 * Removes `key` and its value from the map.
 *
 * @private
 * @name delete
 * @memberOf MapCache
 * @param {string} key The key of the value to remove.
 * @returns {boolean} Returns `true` if the entry was removed, else `false`.
 */function mapCacheDelete(e){return getMapData(this,e).delete(e)}
/**
 * Gets the map value for `key`.
 *
 * @private
 * @name get
 * @memberOf MapCache
 * @param {string} key The key of the value to get.
 * @returns {*} Returns the entry value.
 */function mapCacheGet(e){return getMapData(this,e).get(e)}
/**
 * Checks if a map value for `key` exists.
 *
 * @private
 * @name has
 * @memberOf MapCache
 * @param {string} key The key of the entry to check.
 * @returns {boolean} Returns `true` if an entry for `key` exists, else `false`.
 */function mapCacheHas(e){return getMapData(this,e).has(e)}
/**
 * Sets the map `key` to `value`.
 *
 * @private
 * @name set
 * @memberOf MapCache
 * @param {string} key The key of the value to set.
 * @param {*} value The value to set.
 * @returns {Object} Returns the map cache instance.
 */function mapCacheSet(e,t){getMapData(this,e).set(e,t);return this}MapCache.prototype.clear=mapCacheClear;MapCache.prototype.delete=mapCacheDelete;MapCache.prototype.get=mapCacheGet;MapCache.prototype.has=mapCacheHas;MapCache.prototype.set=mapCacheSet;
/**
 * Gets the index at which the `key` is found in `array` of key-value pairs.
 *
 * @private
 * @param {Array} array The array to inspect.
 * @param {*} key The key to search for.
 * @returns {number} Returns the index of the matched value, else `-1`.
 */function assocIndexOf(e,t){var n=e.length;while(n--)if(eq(e[n][0],t))return n;return-1}
/**
 * The base implementation of `_.get` without support for default values.
 *
 * @private
 * @param {Object} object The object to query.
 * @param {Array|string} path The path of the property to get.
 * @returns {*} Returns the resolved value.
 */function baseGet(e,t){t=isKey(t,e)?[t]:castPath(t);var n=0,i=t.length;while(e!=null&&n<i)e=e[toKey(t[n++])];return n&&n==i?e:void 0}
/**
 * The base implementation of `_.isNative` without bad shim checks.
 *
 * @private
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is a native function,
 *  else `false`.
 */function baseIsNative(e){if(!isObject(e)||isMasked(e))return false;var t=isFunction(e)||isHostObject(e)?P:v;return t.test(toSource(e))}
/**
 * The base implementation of `_.toString` which doesn't convert nullish
 * values to empty strings.
 *
 * @private
 * @param {*} value The value to process.
 * @returns {string} Returns the string.
 */function baseToString(e){if(typeof e=="string")return e;if(isSymbol(e))return N?N.call(e):"";var t=e+"";return t=="0"&&1/e==-s?"-0":t}
/**
 * Casts `value` to a path array if it's not one.
 *
 * @private
 * @param {*} value The value to inspect.
 * @returns {Array} Returns the cast property path array.
 */function castPath(e){return W(e)?e:D(e)}
/**
 * Gets the data for `map`.
 *
 * @private
 * @param {Object} map The map to query.
 * @param {string} key The reference key.
 * @returns {*} Returns the map data.
 */function getMapData(e,t){var n=e.__data__;return isKeyable(t)?n[typeof t=="string"?"string":"hash"]:n.map}
/**
 * Gets the native function at `key` of `object`.
 *
 * @private
 * @param {Object} object The object to query.
 * @param {string} key The key of the method to get.
 * @returns {*} Returns the function if it's native, else `undefined`.
 */function getNative(e,t){var n=getValue(e,t);return baseIsNative(n)?n:void 0}
/**
 * Checks if `value` is a property name and not a property path.
 *
 * @private
 * @param {*} value The value to check.
 * @param {Object} [object] The object to query keys on.
 * @returns {boolean} Returns `true` if `value` is a property name, else `false`.
 */function isKey(e,t){if(W(e))return false;var n=typeof e;return!(n!="number"&&n!="symbol"&&n!="boolean"&&e!=null&&!isSymbol(e))||(h.test(e)||!p.test(e)||t!=null&&e in Object(t))}
/**
 * Checks if `value` is suitable for use as unique object key.
 *
 * @private
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is suitable, else `false`.
 */function isKeyable(e){var t=typeof e;return t=="string"||t=="number"||t=="symbol"||t=="boolean"?e!=="__proto__":e===null}
/**
 * Checks if `func` has its source masked.
 *
 * @private
 * @param {Function} func The function to check.
 * @returns {boolean} Returns `true` if `func` is masked, else `false`.
 */function isMasked(e){return!!A&&A in e}
/**
 * Converts `string` to a property path array.
 *
 * @private
 * @param {string} string The string to convert.
 * @returns {Array} Returns the property path array.
 */var D=memoize((function(e){e=toString(e);var t=[];d.test(e)&&t.push("");e.replace(m,(function(e,n,i,a){t.push(i?a.replace(g,"$1"):n||e)}));return t}));
/**
 * Converts `value` to a string key if it's not a string or symbol.
 *
 * @private
 * @param {*} value The value to inspect.
 * @returns {string|symbol} Returns the key.
 */function toKey(e){if(typeof e=="string"||isSymbol(e))return e;var t=e+"";return t=="0"&&1/e==-s?"-0":t}
/**
 * Converts `func` to its source code.
 *
 * @private
 * @param {Function} func The function to process.
 * @returns {string} Returns the source code.
 */function toSource(e){if(e!=null){try{return S.call(e)}catch(e){}try{return e+""}catch(e){}}return""}
/**
 * Creates a function that memoizes the result of `func`. If `resolver` is
 * provided, it determines the cache key for storing the result based on the
 * arguments provided to the memoized function. By default, the first argument
 * provided to the memoized function is used as the map cache key. The `func`
 * is invoked with the `this` binding of the memoized function.
 *
 * **Note:** The cache is exposed as the `cache` property on the memoized
 * function. Its creation may be customized by replacing the `_.memoize.Cache`
 * constructor with one whose instances implement the
 * [`Map`](http://ecma-international.org/ecma-262/7.0/#sec-properties-of-the-map-prototype-object)
 * method interface of `delete`, `get`, `has`, and `set`.
 *
 * @static
 * @memberOf _
 * @since 0.1.0
 * @category Function
 * @param {Function} func The function to have its output memoized.
 * @param {Function} [resolver] The function to resolve the cache key.
 * @returns {Function} Returns the new memoized function.
 * @example
 *
 * var object = { 'a': 1, 'b': 2 };
 * var other = { 'c': 3, 'd': 4 };
 *
 * var values = _.memoize(_.values);
 * values(object);
 * // => [1, 2]
 *
 * values(other);
 * // => [3, 4]
 *
 * object.a = 2;
 * values(object);
 * // => [1, 2]
 *
 * // Modify the result cache.
 * values.cache.set(object, ['a', 'b']);
 * values(object);
 * // => ['a', 'b']
 *
 * // Replace `_.memoize.Cache`.
 * _.memoize.Cache = WeakMap;
 */function memoize(e,t){if(typeof e!="function"||t&&typeof t!="function")throw new TypeError(i);var memoized=function(){var n=arguments,i=t?t.apply(this,n):n[0],a=memoized.cache;if(a.has(i))return a.get(i);var s=e.apply(this,n);memoized.cache=a.set(i,s);return s};memoized.cache=new(memoize.Cache||MapCache);return memoized}memoize.Cache=MapCache;
/**
 * Performs a
 * [`SameValueZero`](http://ecma-international.org/ecma-262/7.0/#sec-samevaluezero)
 * comparison between two values to determine if they are equivalent.
 *
 * @static
 * @memberOf _
 * @since 4.0.0
 * @category Lang
 * @param {*} value The value to compare.
 * @param {*} other The other value to compare.
 * @returns {boolean} Returns `true` if the values are equivalent, else `false`.
 * @example
 *
 * var object = { 'a': 1 };
 * var other = { 'a': 1 };
 *
 * _.eq(object, object);
 * // => true
 *
 * _.eq(object, other);
 * // => false
 *
 * _.eq('a', 'a');
 * // => true
 *
 * _.eq('a', Object('a'));
 * // => false
 *
 * _.eq(NaN, NaN);
 * // => true
 */function eq(e,t){return e===t||e!==e&&t!==t}
/**
 * Checks if `value` is classified as an `Array` object.
 *
 * @static
 * @memberOf _
 * @since 0.1.0
 * @category Lang
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is an array, else `false`.
 * @example
 *
 * _.isArray([1, 2, 3]);
 * // => true
 *
 * _.isArray(document.body.children);
 * // => false
 *
 * _.isArray('abc');
 * // => false
 *
 * _.isArray(_.noop);
 * // => false
 */var W=Array.isArray;
/**
 * Checks if `value` is classified as a `Function` object.
 *
 * @static
 * @memberOf _
 * @since 0.1.0
 * @category Lang
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is a function, else `false`.
 * @example
 *
 * _.isFunction(_);
 * // => true
 *
 * _.isFunction(/abc/);
 * // => false
 */function isFunction(e){var t=isObject(e)?E.call(e):"";return t==c||t==l}
/**
 * Checks if `value` is the
 * [language type](http://www.ecma-international.org/ecma-262/7.0/#sec-ecmascript-language-types)
 * of `Object`. (e.g. arrays, functions, objects, regexes, `new Number(0)`, and `new String('')`)
 *
 * @static
 * @memberOf _
 * @since 0.1.0
 * @category Lang
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is an object, else `false`.
 * @example
 *
 * _.isObject({});
 * // => true
 *
 * _.isObject([1, 2, 3]);
 * // => true
 *
 * _.isObject(_.noop);
 * // => true
 *
 * _.isObject(null);
 * // => false
 */function isObject(e){var t=typeof e;return!!e&&(t=="object"||t=="function")}
/**
 * Checks if `value` is object-like. A value is object-like if it's not `null`
 * and has a `typeof` result of "object".
 *
 * @static
 * @memberOf _
 * @since 4.0.0
 * @category Lang
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is object-like, else `false`.
 * @example
 *
 * _.isObjectLike({});
 * // => true
 *
 * _.isObjectLike([1, 2, 3]);
 * // => true
 *
 * _.isObjectLike(_.noop);
 * // => false
 *
 * _.isObjectLike(null);
 * // => false
 */function isObjectLike(e){return!!e&&typeof e=="object"}
/**
 * Checks if `value` is classified as a `Symbol` primitive or object.
 *
 * @static
 * @memberOf _
 * @since 4.0.0
 * @category Lang
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is a symbol, else `false`.
 * @example
 *
 * _.isSymbol(Symbol.iterator);
 * // => true
 *
 * _.isSymbol('abc');
 * // => false
 */function isSymbol(e){return typeof e=="symbol"||isObjectLike(e)&&E.call(e)==u}
/**
 * Converts `value` to a string. An empty string is returned for `null`
 * and `undefined` values. The sign of `-0` is preserved.
 *
 * @static
 * @memberOf _
 * @since 4.0.0
 * @category Lang
 * @param {*} value The value to process.
 * @returns {string} Returns the string.
 * @example
 *
 * _.toString(null);
 * // => ''
 *
 * _.toString(-0);
 * // => '-0'
 *
 * _.toString([1, 2, 3]);
 * // => '1,2,3'
 */function toString(e){return e==null?"":baseToString(e)}
/**
 * Gets the value at `path` of `object`. If the resolved value is
 * `undefined`, the `defaultValue` is returned in its place.
 *
 * @static
 * @memberOf _
 * @since 3.7.0
 * @category Object
 * @param {Object} object The object to query.
 * @param {Array|string} path The path of the property to get.
 * @param {*} [defaultValue] The value returned for `undefined` resolved values.
 * @returns {*} Returns the resolved value.
 * @example
 *
 * var object = { 'a': [{ 'b': { 'c': 3 } }] };
 *
 * _.get(object, 'a[0].b.c');
 * // => 3
 *
 * _.get(object, ['a', '0', 'b', 'c']);
 * // => 3
 *
 * _.get(object, 'a.b.c', 'default');
 * // => 'default'
 */function get(e,t,n){var i=e==null?void 0:baseGet(e,t);return i===void 0?n:i}t.exports=get},{}],94:[function(e,t,n){t.exports={stdout:false,stderr:false}},{}],95:[function(e,t,n){(function(e,i){typeof n==="object"&&typeof t!=="undefined"?t.exports=i():typeof define==="function"&&define.amd?define(i):e.typeDetect=i()})(this,(function(){var e=typeof Promise==="function";var t=typeof self==="object"?self:global;var n=typeof Symbol!=="undefined";var i=typeof Map!=="undefined";var a=typeof Set!=="undefined";var s=typeof WeakMap!=="undefined";var c=typeof WeakSet!=="undefined";var l=typeof DataView!=="undefined";var u=n&&typeof Symbol.iterator!=="undefined";var p=n&&typeof Symbol.toStringTag!=="undefined";var h=a&&typeof Set.prototype.entries==="function";var d=i&&typeof Map.prototype.entries==="function";var m=h&&Object.getPrototypeOf((new Set).entries());var y=d&&Object.getPrototypeOf((new Map).entries());var g=u&&typeof Array.prototype[Symbol.iterator]==="function";var v=g&&Object.getPrototypeOf([][Symbol.iterator]());var b=u&&typeof String.prototype[Symbol.iterator]==="function";var w=b&&Object.getPrototypeOf(""[Symbol.iterator]());var x=8;var k=-1;
/**
 * ### typeOf (obj)
 *
 * Uses `Object.prototype.toString` to determine the type of an object,
 * normalising behaviour across engine versions & well optimised.
 *
 * @param {Mixed} object
 * @return {String} object type
 * @api public
 */function typeDetect(n){var u=typeof n;if(u!=="object")return u;if(n===null)return"null";if(n===t)return"global";if(Array.isArray(n)&&(p===false||!(Symbol.toStringTag in n)))return"Array";if(typeof window==="object"&&window!==null){if(typeof window.location==="object"&&n===window.location)return"Location";if(typeof window.document==="object"&&n===window.document)return"Document";if(typeof window.navigator==="object"){if(typeof window.navigator.mimeTypes==="object"&&n===window.navigator.mimeTypes)return"MimeTypeArray";if(typeof window.navigator.plugins==="object"&&n===window.navigator.plugins)return"PluginArray"}if((typeof window.HTMLElement==="function"||typeof window.HTMLElement==="object")&&n instanceof window.HTMLElement){if(n.tagName==="BLOCKQUOTE")return"HTMLQuoteElement";if(n.tagName==="TD")return"HTMLTableDataCellElement";if(n.tagName==="TH")return"HTMLTableHeaderCellElement"}}var h=p&&n[Symbol.toStringTag];if(typeof h==="string")return h;var d=Object.getPrototypeOf(n);return d===RegExp.prototype?"RegExp":d===Date.prototype?"Date":e&&d===Promise.prototype?"Promise":a&&d===Set.prototype?"Set":i&&d===Map.prototype?"Map":c&&d===WeakSet.prototype?"WeakSet":s&&d===WeakMap.prototype?"WeakMap":l&&d===DataView.prototype?"DataView":i&&d===y?"Map Iterator":a&&d===m?"Set Iterator":g&&d===v?"Array Iterator":b&&d===w?"String Iterator":d===null?"Object":Object.prototype.toString.call(n).slice(x,k)}return typeDetect}))},{}]},{},[2]);var t=e;const n=e.leakThreshold;const i=e.assert;const a=e.getFakes;const s=e.createStubInstance;const c=e.inject;const l=e.mock;const u=e.reset;const p=e.resetBehavior;const h=e.resetHistory;const d=e.restore;const m=e.restoreContext;const y=e.replace;const g=e.define;const v=e.replaceGetter;const b=e.replaceSetter;const w=e.spy;const x=e.stub;const k=e.fake;const j=e.useFakeTimers;const C=e.verify;const T=e.verifyAndRestore;const A=e.createSandbox;const S=e.match;const O=e.restoreObject;const E=e.expectation;const P=e.timers;const M=e.addBehavior;const I=e.promise;export{M as addBehavior,i as assert,A as createSandbox,s as createStubInstance,t as default,g as define,E as expectation,k as fake,a as getFakes,c as inject,n as leakThreshold,S as match,l as mock,I as promise,y as replace,v as replaceGetter,b as replaceSetter,u as reset,p as resetBehavior,h as resetHistory,d as restore,m as restoreContext,O as restoreObject,w as spy,x as stub,P as timers,j as useFakeTimers,C as verify,T as verifyAndRestore};

