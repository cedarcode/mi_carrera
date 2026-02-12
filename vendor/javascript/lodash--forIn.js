// lodash/forIn@4.17.23 downloaded from https://ga.jspm.io/npm:lodash@4.17.23/forIn.js

import{_ as r}from"./_/Ddyi9JOE.js";import{_ as s}from"./_/DCoPuGFh.js";import i from"./keysIn.js";import"./_/CzhaiE9x.js";import"./identity.js";import"./_/jOZaAajY.js";import"./_/VmqDG5Et.js";import"./isArguments.js";import"./_/BvE8bFHC.js";import"./_/Dn0SV0nH.js";import"./isObjectLike.js";import"./isArray.js";import"./isBuffer.js";import"./stubFalse.js";import"./_isIndex.js";import"./isTypedArray.js";import"./isLength.js";import"./_/CnuXciZb.js";import"./_/BBlDpEEY.js";import"./isObject.js";import"./_/D13tfVQC.js";import"./isArrayLike.js";import"./isFunction.js";var t={};var o=r,m=s,j=i;
/**
 * Iterates over own and inherited enumerable string keyed properties of an
 * object and invokes `iteratee` for each property. The iteratee is invoked
 * with three arguments: (value, key, object). Iteratee functions may exit
 * iteration early by explicitly returning `false`.
 *
 * @static
 * @memberOf _
 * @since 0.3.0
 * @category Object
 * @param {Object} object The object to iterate over.
 * @param {Function} [iteratee=_.identity] The function invoked per iteration.
 * @returns {Object} Returns `object`.
 * @see _.forInRight
 * @example
 *
 * function Foo() {
 *   this.a = 1;
 *   this.b = 2;
 * }
 *
 * Foo.prototype.c = 3;
 *
 * _.forIn(new Foo, function(value, key) {
 *   console.log(key);
 * });
 * // => Logs 'a', 'b', then 'c' (iteration order is not guaranteed).
 */function p(r,s){return r==null?r:o(r,m(s),j)}t=p;var e=t;export{e as default};

