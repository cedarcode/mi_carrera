// lodash/has@4.17.23 downloaded from https://ga.jspm.io/npm:lodash@4.17.23/has.js

import{_ as r}from"./_/DMIYD6lT.js";import"./_/C6UayejR.js";import"./isArray.js";import"./isSymbol.js";import"./_/BvE8bFHC.js";import"./_/Dn0SV0nH.js";import"./isObjectLike.js";import"./_stringToPath.js";import"./memoize.js";import"./_/zyyNK3QO.js";import"./_/slH5hUxU.js";import"./_/CX3pl0wT.js";import"./isFunction.js";import"./isObject.js";import"./eq.js";import"./_/LlMKPN53.js";import"./toString.js";import"./_/vyAkOenX.js";import"./_arrayMap.js";import"./isArguments.js";import"./_isIndex.js";import"./isLength.js";import"./_toKey.js";var t={};var i=Object.prototype;var o=i.hasOwnProperty;
/**
 * The base implementation of `_.has` without support for deep paths.
 *
 * @private
 * @param {Object} [object] The object to query.
 * @param {Array|string} key The key to check.
 * @returns {boolean} Returns `true` if `key` exists, else `false`.
 */function s(r,t){return r!=null&&o.call(r,t)}t=s;var m=t;var p={};var j=m,a=r;
/**
 * Checks if `path` is a direct property of `object`.
 *
 * @static
 * @since 0.1.0
 * @memberOf _
 * @category Object
 * @param {Object} object The object to query.
 * @param {Array|string} path The path to check.
 * @returns {boolean} Returns `true` if `path` exists, else `false`.
 * @example
 *
 * var object = { 'a': { 'b': 2 } };
 * var other = _.create({ 'a': _.create({ 'b': 2 }) });
 *
 * _.has(object, 'a');
 * // => true
 *
 * _.has(object, 'a.b');
 * // => true
 *
 * _.has(object, ['a', 'b']);
 * // => true
 *
 * _.has(other, 'a');
 * // => false
 */function e(r,t){return r!=null&&a(r,t,j)}p=e;var n=p;export{n as default};

