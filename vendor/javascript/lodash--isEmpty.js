// lodash/isEmpty@4.17.23 downloaded from https://ga.jspm.io/npm:lodash@4.17.23/isEmpty.js

import{_ as r}from"./_/D4kZSuhp.js";import t from"./_getTag.js";import i from"./isArguments.js";import o from"./isArray.js";import s from"./isArrayLike.js";import e from"./isBuffer.js";import{_ as m}from"./_/D13tfVQC.js";import p from"./isTypedArray.js";import"./_/Dh8BfxAr.js";import"./_/slH5hUxU.js";import"./_/CX3pl0wT.js";import"./isFunction.js";import"./_/BvE8bFHC.js";import"./_/Dn0SV0nH.js";import"./isObject.js";import"./_/LlMKPN53.js";import"./_/Cryr7UAc.js";import"./_/wnzyZZ7q.js";import"./isObjectLike.js";import"./isLength.js";import"./stubFalse.js";import"./_/CnuXciZb.js";import"./_/BBlDpEEY.js";var j={};var f=r,a=t,n=i,u=o,_=s,l=e,c=m,v=p;var y="[object Map]",g="[object Set]";var b=Object.prototype;var h=b.hasOwnProperty;
/**
 * Checks if `value` is an empty object, collection, map, or set.
 *
 * Objects are considered empty if they have no own enumerable string keyed
 * properties.
 *
 * Array-like values such as `arguments` objects, arrays, buffers, strings, or
 * jQuery-like collections are considered empty if they have a `length` of `0`.
 * Similarly, maps and sets are considered empty if they have a `size` of `0`.
 *
 * @static
 * @memberOf _
 * @since 0.1.0
 * @category Lang
 * @param {*} value The value to check.
 * @returns {boolean} Returns `true` if `value` is empty, else `false`.
 * @example
 *
 * _.isEmpty(null);
 * // => true
 *
 * _.isEmpty(true);
 * // => true
 *
 * _.isEmpty(1);
 * // => true
 *
 * _.isEmpty([1, 2, 3]);
 * // => false
 *
 * _.isEmpty({ 'a': 1 });
 * // => false
 */function A(r){if(r==null)return true;if(_(r)&&(u(r)||typeof r=="string"||typeof r.splice=="function"||l(r)||v(r)||n(r)))return!r.length;var t=a(r);if(t==y||t==g)return!r.size;if(c(r))return!f(r).length;for(var i in r)if(h.call(r,i))return false;return true}j=A;var O=j;export{O as default};

