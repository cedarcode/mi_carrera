// lodash/forEach@4.17.23 downloaded from https://ga.jspm.io/npm:lodash@4.17.23/forEach.js

import r from"./_arrayEach.js";import{_ as s}from"./_/DQZtRPbT.js";import{_ as i}from"./_/DCoPuGFh.js";import t from"./isArray.js";import"./_baseForOwn.js";import"./_/Ddyi9JOE.js";import"./_/CzhaiE9x.js";import"./keys.js";import"./_/jOZaAajY.js";import"./_/VmqDG5Et.js";import"./isArguments.js";import"./_/BvE8bFHC.js";import"./_/Dn0SV0nH.js";import"./isObjectLike.js";import"./isBuffer.js";import"./stubFalse.js";import"./_isIndex.js";import"./isTypedArray.js";import"./isLength.js";import"./_/CnuXciZb.js";import"./_/BBlDpEEY.js";import"./_/D4kZSuhp.js";import"./_/D13tfVQC.js";import"./_/Dh8BfxAr.js";import"./isArrayLike.js";import"./isFunction.js";import"./isObject.js";import"./_/CINdQ0h5.js";import"./identity.js";var o={};var m=r,j=s,p=i,_=t;
/**
 * Iterates over elements of `collection` and invokes `iteratee` for each element.
 * The iteratee is invoked with three arguments: (value, index|key, collection).
 * Iteratee functions may exit iteration early by explicitly returning `false`.
 *
 * **Note:** As with other "Collections" methods, objects with a "length"
 * property are iterated like arrays. To avoid this behavior use `_.forIn`
 * or `_.forOwn` for object iteration.
 *
 * @static
 * @memberOf _
 * @since 0.1.0
 * @alias each
 * @category Collection
 * @param {Array|Object} collection The collection to iterate over.
 * @param {Function} [iteratee=_.identity] The function invoked per iteration.
 * @returns {Array|Object} Returns `collection`.
 * @see _.forEachRight
 * @example
 *
 * _.forEach([1, 2], function(value) {
 *   console.log(value);
 * });
 * // => Logs `1` then `2`.
 *
 * _.forEach({ 'a': 1, 'b': 2 }, function(value, key) {
 *   console.log(key);
 * });
 * // => Logs 'a' then 'b' (iteration order is not guaranteed).
 */function a(r,s){var i=_(r)?m:j;return i(r,p(s))}o=a;var e=o;export{e as default};

