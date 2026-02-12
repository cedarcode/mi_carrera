// lodash/defaults@4.17.23 downloaded from https://ga.jspm.io/npm:lodash@4.17.23/defaults.js

import r from"./_baseRest.js";import t from"./eq.js";import{_ as s}from"./_/CDN6PQyr.js";import i from"./keysIn.js";import"./identity.js";import"./_overRest.js";import"./_/BvalCKaw.js";import"./_/CnrLO_5Q.js";import"./constant.js";import"./_/D284kTNg.js";import"./_/slH5hUxU.js";import"./_/CX3pl0wT.js";import"./isFunction.js";import"./_/BvE8bFHC.js";import"./_/Dn0SV0nH.js";import"./isObject.js";import"./isArrayLike.js";import"./isLength.js";import"./_isIndex.js";import"./_/jOZaAajY.js";import"./_/VmqDG5Et.js";import"./isArguments.js";import"./isObjectLike.js";import"./isArray.js";import"./isBuffer.js";import"./stubFalse.js";import"./isTypedArray.js";import"./_/CnuXciZb.js";import"./_/BBlDpEEY.js";import"./_/D13tfVQC.js";var o={};var m=r,j=t,p=s,e=i;var a=Object.prototype;var v=a.hasOwnProperty;
/**
 * Assigns own and inherited enumerable string keyed properties of source
 * objects to the destination object for all destination properties that
 * resolve to `undefined`. Source objects are applied from left to right.
 * Once a property is set, additional values of the same property are ignored.
 *
 * **Note:** This method mutates `object`.
 *
 * @static
 * @since 0.1.0
 * @memberOf _
 * @category Object
 * @param {Object} object The destination object.
 * @param {...Object} [sources] The source objects.
 * @returns {Object} Returns `object`.
 * @see _.defaultsDeep
 * @example
 *
 * _.defaults({ 'a': 1 }, { 'b': 2 }, { 'a': 3 });
 * // => { 'a': 1, 'b': 2 }
 */var _=m((function(r,t){r=Object(r);var s=-1;var i=t.length;var o=i>2?t[2]:void 0;o&&p(t[0],t[1],o)&&(i=1);while(++s<i){var m=t[s];var _=e(m);var n=-1;var l=_.length;while(++n<l){var c=_[n];var f=r[c];(f===void 0||j(f,a[c])&&!v.call(r,c))&&(r[c]=m[c])}}return r}));o=_;var n=o;export{n as default};

